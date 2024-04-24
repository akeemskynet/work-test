resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "https://charts.karpenter.sh/"
  chart      = "karpenter"
  version    = var.karpenter_helm_version

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter_irsa.iam_role_arn
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "clusterEndpoint"
    value = module.eks.cluster_endpoint
  }

  set {
    name  = "aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }

  depends_on = [
    module.eks,
    module.karpenter_irsa,
    aws_iam_instance_profile.karpenter
  ]
}


# AWS LoadBalancer Controller: https://github.com/aws/eks-charts/tree/master/stable/aws-load-balancer-controller
resource "helm_release" "aws_load_balancer_controller" {
  namespace        = "kube-system"
  create_namespace = false

  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.loadbalancer_helm_version

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.this["loadbalancer_sa"].metadata[0].name
  }

  set {
    name  = "default-tags"
    value = var.load_balancer_tags
  }

  depends_on = [
    module.eks,
    module.loadbalancer_irsa
  ]
}


# AWS EFS Controller: https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html
resource "helm_release" "aws_elastic_filesystem_driver" {
  namespace        = "kube-system"
  create_namespace = false

  name       = "aws-elastic-filesystem-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  version    = var.efs_helm_version

  set {
    name  = "controller.serviceAccount.create"
    value = false
  }

  set {
    name  = "app.kubernetes.io/managed-by"
    value = "Helm"
  }

  set {
    name  = "meta.helm.sh/release-name"
    value = "aws-elastic-filesystem-driver"
  }

  set {
    name  = "meta.helm.sh/release-namespace"
    value = "kube-system"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.efs_irsa.iam_role_arn
  }
  depends_on = [
    module.eks,
    module.efs_irsa
  ]
}


# External Secrets Operator: https://external-secrets.io/v0.7.1/introduction/getting-started/
resource "helm_release" "external_secrets_operator" {
  namespace        = "external-secrets"
  create_namespace = true

  name       = "external-secrets"
  repository = "https://charts.external-secrets.io"
  chart      = "external-secrets"
  version    = var.external_secrets_operator_helm_version

  set {
    name  = "installCRDs"
    value = true
  }

  depends_on = [
    module.eks,
    kubernetes_namespace.this,
    module.external_secrets_operator_irsa,
  ]
}

# KEDA: https://keda.sh/   
resource "helm_release" "keda-release" {
  namespace        = "keda"
  create_namespace = false

  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  version    = var.keda_helm_version

  set {
    name  = "serviceAccount.create"
    value = false
  }

  set {
    name  = "app.kubernetes.io/managed-by"
    value = "Helm"
  }

  set {
    name  = "meta.helm.sh/release-name"
    value = "keda"
  }

  set {
    name  = "meta.helm.sh/release-namespace"
    value = "keda"
  }

  set {
    name  = "operator.name"
    value = kubernetes_service_account.this["keda_sa"].metadata[0].name
  }

  set {
    name  = "serviceAccount.name"
    value = kubernetes_service_account.this["keda_sa"].metadata[0].name
  }

  set {
    name  = "podIdentity.aws.irsa.enabled"
    value = true
  }

  set {
    name  = "podIdentity.aws.irsa.roleArn"
    value = module.keda_irsa.iam_role_arn
  }

  depends_on = [
    module.eks,
    kubernetes_namespace.this
  ]
}

resource "helm_release" "filebeat" {
  count            = var.enable_filebeat ? 1 : 0
  namespace        = "elastic"
  create_namespace = false

  name       = "filebeat"
  repository = "https://helm.elastic.co"
  chart      = "filebeat"
  version    = var.filebeat_version

  values = [
    "${file("${path.module}/templates/filebeat.yaml")}"
  ]

  depends_on = [
    module.eks,
    kubernetes_namespace.this,
    kubectl_manifest.local_secretsmanager_secretstore
  ]
}

resource "helm_release" "metricbeat" {
  count            = var.enable_metricbeat ? 1 : 0
  namespace        = "elastic"
  create_namespace = false

  name       = "metricbeat"
  repository = "https://helm.elastic.co"
  chart      = "metricbeat"
  version    = var.metricbeat_version

  values = [
    "${file("${path.module}/templates/metricbeat.yaml")}"
  ]
  depends_on = [
    module.eks,
    kubernetes_namespace.this,
    kubectl_manifest.local_secretsmanager_secretstore
  ]
}

resource "helm_release" "kube_state_metrics" {
  namespace        = "kube-system"
  create_namespace = false
  chart            = "kube-state-metrics"
  repository       = "https://prometheus-community.github.io/helm-charts"
  name             = "prometheus-community"
  version          = var.kube_state_metrics_version

  depends_on = [
    module.eks
  ]
}


resource "helm_release" "kubecost" {
  count            = var.enable_kubecost ? 1 : 0
  namespace        = "kubecost"
  create_namespace = true

  name       = "kubecost"
  repository = "https://kubecost.github.io/cost-analyzer/"
  chart      = "cost-analyzer"
  version    = var.kubecost_version

  set {
    name  = "ingress.enabled"
    value = true
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/scheme"
    value = "internal"
  }

  set {
    name  = "ingress.annotations.alb\\.ingress\\.kubernetes\\.io/target-type"
    value = "ip"
  }

  set {
    name  = "ingress.annotations.kubernetes\\.io/ingress\\.class"
    value = "alb"
  }

  set {
    name  = "ingress.hosts"
    value = "{*.elb.amazonaws.com}"
  }

  set {
    name  = "persistentVolume.storageClass"
    value = kubernetes_storage_class.gp3.metadata[0].name
  }

  depends_on = [
    module.eks,
    module.ebs_csi_irsa
  ]
}
