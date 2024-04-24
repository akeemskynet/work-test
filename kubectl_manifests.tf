resource "kubectl_manifest" "karpenter_provisioner" {
  force_new = true
  yaml_body = <<YAML
apiVersion: karpenter.sh/v1alpha5
kind: Provisioner
metadata:
  name: karpenter
namespace: karpenter
spec:
  kubeletConfiguration:
    containerRuntime: "containerd"  #Currently set to dockerd, but containerd only works with bottlerocket images
  requirements:
    - key: karpenter.sh/capacity-type
      operator: In
      values: ["on-demand"]
  limits:
    resources:
      cpu: "${var.cpu_limits}"
      memory: "${var.memory_limits}"
  instanceProfile: ${aws_iam_instance_profile.karpenter.name}
  providerRef:                                # optional, recommended to use instead of `provider`
    name: "${module.eks.cluster_id}-karpenter-node-template"
  ttlSecondsAfterEmpty: 60
  ttlSecondsUntilExpired: 1296000 #Currently set to 15 days (60 * 60 * 24 * 15)
YAML
  depends_on = [
    helm_release.karpenter
  ]
}

resource "kubectl_manifest" "karpenter_node_template" {
  force_new = true
  yaml_body = <<YAML
apiVersion: karpenter.k8s.aws/v1alpha1
kind: AWSNodeTemplate
metadata:
  name: "${module.eks.cluster_id}-karpenter-node-template"
spec:
  amiFamily: "${var.ami_family}"
  subnetSelector:                             # required
    aws-ids: ${join(",", "${var.managed_nodes_subnet_ids}")}
  securityGroupSelector:                      # required, when not using launchTemplate
    aws-ids: "${aws_security_group.eks_security_group.id},${module.eks.cluster_primary_security_group_id},${module.eks.node_security_group_id}"
  amiSelector:
    aws-ids: "${var.karpenter_ami_id}"
  blockDeviceMappings:
    - deviceName: /dev/xvda
      ebs:
        volumeSize: ${var.karpenter_node_disk_size}
        volumeType: ${var.karpenter_node_disk_type}
        deleteOnTermination: true
  userData: |
    MIME-Version: 1.0
    Content-Type: multipart/mixed; boundary="BOUNDARY"

    --BOUNDARY
    Content-Type: text/x-shellscript; charset="us-ascii"

    #!/bin/bash
    mkdir -p /home/ec2-user/.ssh
    touch /home/ec2-user/.ssh/authorized_keys
    echo "${var.break_glass_key}" > /home/ec2-user/.ssh/authorized_keys
    chmod 600 /home/ec2-user/.ssh/authorized_keys
    chmod 700 /home/ec2-user/.ssh
    chown -R ec2-user /home/ec2-user/
    --BOUNDARY--
  tags:
    ${jsonencode(var.karpenter_tags)}

YAML
  depends_on = [
    helm_release.karpenter,
    kubectl_manifest.karpenter_provisioner
  ]
}

resource "kubectl_manifest" "secretsmanager_secretstore" {
  force_new = true
  for_each  = var.enable_secrets_manager == true ? var.secrets_manager_secret_stores : {}
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: ${each.key}
  namespace: ${each.value.secretsmanager_secretstore_namespace}
spec:
  retrySettings:
    maxRetries: ${each.value.secretsmanager_secretstore_max_retries}
    retryInterval: ${each.value.secretsmanager_secretstore_retry_interval}
  provider:
    # (1): AWS Secrets Manager
    # aws configures this store to sync secrets using AWS Secret Manager provider
    aws:
      service: SecretsManager
      region: ${each.value.secretsmanager_secretstore_region}
      auth:
        jwt:
          serviceAccountRef:
            name: ${each.value.external_secrets_operator_sa}
YAML
  depends_on = [
    helm_release.external_secrets_operator,
    module.external_secrets_operator_irsa
  ]
}

resource "kubectl_manifest" "local_secretsmanager_secretstore" {
  force_new = true
  for_each  = local.secrets_internal_manager_secret_stores
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: ${each.key}
  namespace: ${each.value.secretsmanager_secretstore_namespace}
spec:
  retrySettings:
    maxRetries: ${each.value.secretsmanager_secretstore_max_retries}
    retryInterval: ${each.value.secretsmanager_secretstore_retry_interval}
  provider:
    # (1): AWS Secrets Manager
    # aws configures this store to sync secrets using AWS Secret Manager provider
    aws:
      service: SecretsManager
      region: ${each.value.secretsmanager_secretstore_region}
      auth:
        jwt:
          serviceAccountRef:
            name: ${each.value.external_secrets_operator_sa}
YAML
  depends_on = [
    helm_release.external_secrets_operator,
    module.external_secrets_operator_irsa
  ]
}

resource "kubectl_manifest" "secretsmanager_external_secrets" {
  force_new = true
  for_each  = var.enable_secrets_manager == true ? var.secretsmanager_external_secrets_names : {}
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: ${each.key}
  namespace: ${each.value.secretsmanager_secretstore_namespace}
spec:
  refreshInterval: ${each.value.secretsmanager_external_secrets_refresh_interval}
  secretStoreRef:
    name: ${each.value.secretsmanager_secretstore_name}
    kind: SecretStore
  target:
    name: ${each.value.kubernetes_secretsmanager_secret_name}
    creationPolicy: Owner
  dataFrom:
  - extract:
      key: ${each.value.secretsmanager_secret_key}
YAML
  depends_on = [
    helm_release.external_secrets_operator,
    module.external_secrets_operator_irsa
  ]
}

resource "kubectl_manifest" "local_secretsmanager_external_secrets" {
  force_new = true
  for_each  = local.secretsmanager_internal_external_secrets_names
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: ${each.key}
  namespace: ${each.value.secretsmanager_secretstore_namespace}
spec:
  refreshInterval: ${each.value.secretsmanager_external_secrets_refresh_interval}
  secretStoreRef:
    name: ${each.value.secretsmanager_secretstore_name}
    kind: SecretStore
  target:
    name: ${each.value.kubernetes_secretsmanager_secret_name}
    creationPolicy: Owner
  dataFrom:
  - extract:
      key: ${each.value.secretsmanager_secret_key}
YAML
  depends_on = [
    helm_release.external_secrets_operator,
    module.external_secrets_operator_irsa
  ]
}

#SSM
resource "kubectl_manifest" "ssm_parameter_secretstore" {
  force_new = true
  for_each  = var.enable_ssm_parameter == true ? var.ssm_secrets_secret_stores : {}
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: ${each.key}
  namespace: ${each.value.ssm_parameter_secretstore_namespace}
spec:
  retrySettings:
    maxRetries: ${each.value.ssm_parameter_secretstore_max_retries}
    retryInterval: ${each.value.ssm_parameter_secretstore_retry_interval}

  provider:
    # (1): AWS ParameterStore
    # aws configures this store to sync secrets using AWS Secret Manager provider
    aws:
      service: ParameterStore
      region: ${each.value.ssm_parameter_secretstore_region}
      auth:
        jwt:
          serviceAccountRef:
            name: ${each.value.external_secrets_operator_sa}
YAML
  depends_on = [
    helm_release.external_secrets_operator,
    module.external_secrets_operator_irsa
  ]
}

resource "kubectl_manifest" "local_ssm_parameter_secretstore" {
  force_new = true
  for_each  = local.ssm_internal_secrets_secret_stores
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: ${each.key}
  namespace: ${each.value.ssm_parameter_secretstore_namespace}
spec:
  retrySettings:
    maxRetries: ${each.value.ssm_parameter_secretstore_max_retries}
    retryInterval: ${each.value.ssm_parameter_secretstore_retry_interval}

  provider:
    # (1): AWS ParameterStore
    # aws configures this store to sync secrets using AWS Secret Manager provider
    aws:
      service: ParameterStore
      region: ${each.value.ssm_parameter_secretstore_region}
      auth:
        jwt:
          serviceAccountRef:
            name: ${each.value.external_secrets_operator_sa}
YAML
  depends_on = [
    helm_release.external_secrets_operator,
    module.external_secrets_operator_irsa
  ]
}


resource "kubectl_manifest" "ssm_parameter_external_secrets" {
  force_new = true
  for_each  = var.enable_ssm_parameter == true ? var.ssm_parameter_external_secrets_names : {}
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: ${each.key}
  namespace: ${each.value.ssm_parameter_secretstore_namespace}
spec:
  refreshInterval: ${each.value.ssm_parameter_secretstore_refresh_interval}
  secretStoreRef:
    name: ${each.value.ssm_parameter_secretstore_name}
    kind: SecretStore
  target:
    name: ${each.value.ssm_parameter_kubernetes_secret_name}
    creationPolicy: Owner
  data:
    - secretKey: ${each.value.ssm_parameter_secret_key_reference}
      remoteRef:
        key: ${each.value.ssm_parameter_secret_key_name}
YAML
  depends_on = [
    helm_release.external_secrets_operator,
    module.external_secrets_operator_irsa
  ]
}

resource "kubectl_manifest" "local_ssm_parameter_external_secrets" {
  force_new = true
  for_each  = local.ssm_internal_parameter_external_secrets_names
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: ${each.key}
  namespace: ${each.value.ssm_parameter_secretstore_namespace}
spec:
  refreshInterval: ${each.value.ssm_parameter_secretstore_refresh_interval}
  secretStoreRef:
    name: ${each.value.ssm_parameter_secretstore_name}
    kind: SecretStore
  target:
    name: ${each.value.ssm_parameter_kubernetes_secret_name}
    creationPolicy: Owner
  data:
    - secretKey: ${each.value.ssm_parameter_secret_key_reference}
      remoteRef:
        key: ${each.value.ssm_parameter_secret_key_name}
YAML
  depends_on = [
    helm_release.external_secrets_operator,
    module.external_secrets_operator_irsa
  ]
}

resource "kubectl_manifest" "queue_keda_scaled_object" {
  force_new = true
  for_each  = var.enable_keda_queue_scaled_objects == true ? var.keda_queue_scaled_objects : {}
  yaml_body = <<YAML
apiVersion: keda.sh/v1alpha1
kind: ScaledObject
metadata:
  name: "${each.key}-scaledobject"
  namespace: "${each.value.namespace}"
spec:
  scaleTargetRef:
    name:  "${each.key}"
  minReplicaCount: ${each.value.scaled_object_queue_triggers_min_count}
  maxReplicaCount: ${each.value.scaled_object_queue_triggers_max_count}
  triggers:
    - type: aws-sqs-queue
      authenticationRef:
        name: ${each.value.keda_auth_trigger_name}
      metadata: 
        queueURL: ${each.value.keda_scaled_object_queue_url}
        queueLength: "${each.value.keda_scaled_object_queue_length}"
        awsRegion: "${each.value.keda_scaled_object_queue_aws_region}"
        identityOwner: operator
YAML
  depends_on = [
    helm_release.keda-release
  ]
}


resource "kubectl_manifest" "keda_auth_trigger" {
  for_each  = var.enable_keda_queue_scaled_objects == true ? var.keda_auth_triggers : {}
  force_new = true
  yaml_body = <<YAML
apiVersion: keda.sh/v1alpha1
kind: TriggerAuthentication
metadata:
  name: "${each.key}"
  namespace: "${each.value.namespace}"
spec:
  podIdentity:
    provider: aws-eks
YAML
  depends_on = [
    helm_release.keda-release
  ]
}

## External secret for CA cert chain for elasticsearch.  Resource configuration has different
## syntax to support a plaintext secret vs json used for other secrets.  That's why this is a separate resource definition
resource "kubectl_manifest" "elasticsearch_ca_certs_external_secret" {
  count     = var.enable_secrets_manager == true && var.elastic_ca_certs_secret_name != null && (var.enable_filebeat || var.enable_metricbeat) ? 1 : 0
  yaml_body = <<YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: ca-certs
  namespace: elastic
spec:
  refreshInterval: 1h
  secretStoreRef:
    name: elastic-creds
    kind: SecretStore
  target:
    name: elasticsearch-master-certs
    creationPolicy: Owner
  data:
  - secretKey: ca.crt
    remoteRef:
      key: ${data.aws_secretsmanager_secret.elasticsearch_cert_chain[0].arn}
YAML
  depends_on = [
    module.external_secrets_operator_irsa
  ]
}
