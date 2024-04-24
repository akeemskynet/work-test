resource "kubernetes_cluster_role_binding" "nccf-readonly" {
  metadata {
    name = "nccf-readonly"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }
  subject {
    kind      = "Group"
    name      = "nccf-readonly"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [
    module.eks
  ]
}

resource "kubernetes_cluster_role" "nccf-developers" {
  metadata {
    name = "nccf-developers"
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "pods/log", "pods/attach", "pods/exec", "pods/proxy", "pods/status"]
    verbs      = ["get", "watch", "list", "delete", "create", "update", "patch"]
  }
  rule {
    api_groups = ["storage.k8s.io"]
    resources  = ["storageclasses"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group (will need to change to get/list when modifying for better security)
    resources  = ["configmaps"]
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["events"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["replicationcontrollers/scale"]
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["replicationcontrollers"]
    verbs      = ["get", "list", "watch", "create", "delete", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["namespaces/status"]
    verbs      = ["get", "list", "create", "update", "delete", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["namespaces"]
    verbs      = ["get", "list", "create", "update", "delete", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["services"]
    verbs      = ["get", "list", "create", "update", "delete", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["services/status"]
    verbs      = ["get", "list", "create", "update", "delete", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["persistentvolumes"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["persistentvolumeclaims"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["nodes"]
    verbs      = ["get", "list", "watch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["serviceaccounts"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["apps"] # "" indicates the core API group
    resources  = ["daemonsets"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["apps"] # "" indicates the core API group
    resources  = ["deployments/scale"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["apps"] # "" indicates the core API group
    resources  = ["deployments"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["apps"] # "" indicates the core API group
    resources  = ["replicasets/scale"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["apps"] # "" indicates the core API group
    resources  = ["replicasets"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["apps"] # "" indicates the core API group
    resources  = ["statefulsets"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["apps"] # "" indicates the core API group
    resources  = ["statefulsets/scale"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["batch"] # "" indicates the core API group
    resources  = ["cronjobs"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["batch"] # "" indicates the core API group
    resources  = ["cronjobs/status"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["batch"] # "" indicates the core API group
    resources  = ["jobs"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["batch"] # "" indicates the core API group
    resources  = ["jobs/status"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["networking.k8s.io"] # "" indicates the core API group
    resources  = ["ingressclasses"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["networking.k8s.io"] # "" indicates the core API group
    resources  = ["ingresses"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["networking.k8s.io"] # "" indicates the core API group
    resources  = ["ingresses/status"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = ["rbac.authorization.k8s.io"] # "" indicates the core API group
    resources  = ["clusterroles"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["rbac.authorization.k8s.io"] # "" indicates the core API group
    resources  = ["roles"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["rbac.authorization.k8s.io"] # "" indicates the core API group
    resources  = ["clusterrolebindings"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["storage.k8s.io"] # "" indicates the core API group
    resources  = ["volumeattachments"]
    verbs      = ["get", "list", "create", "delete", "update", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group
    resources  = ["tokenreviews"]
    verbs      = ["get", "list"]
  }
  rule {
    api_groups = ["autoscaling"] # "" indicates the core API group
    resources  = ["horizontalpodautoscalers"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["coordination.k8s.io"] # "" indicates the core API group
    resources  = ["leases"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["storage.k8s.io"] # "" indicates the core API group
    resources  = ["csidrivers"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["storage.k8s.io"] # "" indicates the core API group
    resources  = ["csinodes"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["elbv2.k8s.aws"] # "" indicates the core API group
    resources  = ["targetgroupbindings"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["keda.sh"] # "" indicates the core API group
    resources  = ["scaledobjects"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["keda.sh"] # "" indicates the core API group
    resources  = ["scaledjobs"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["keda.sh"] # "" indicates the core API group
    resources  = ["triggerauthentications"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["keda.sh"] # "" indicates the core API group
    resources  = ["clustertriggerauthentications"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["elasticsearch.k8s.elastic.co"] # "" indicates the core API group
    resources  = ["elasticsearches"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = ["beat.k8s.elastic.co"] # "" indicates the core API group
    resources  = ["beats"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  rule {
    api_groups = [""] # "" indicates the core API group (will need to change to get/list when modifying for better security)
    resources  = ["secrets"]
    verbs      = ["get", "list", "create", "delete", "watch", "update", "patch"]
  }
  depends_on = [
    module.eks
  ]
}

resource "kubernetes_cluster_role_binding" "nccf-developers" {
  metadata {
    name = "nccf-developers"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "nccf-developers"
  }
  subject {
    kind      = "Group"
    name      = "nccf-developers"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [
    module.eks
  ]
}
