resource "kubernetes_storage_class" "gp3" {
  metadata {
    name = "gp3-sc"
    # annotations = {
    #   "storageclass.kubernetes.io/is-default-class" : true,
    # }
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy      = "Delete"
  parameters = {
    "type" : "gp3"
    "csi.storage.k8s.io/fstype" : "xfs"
  }
  volume_binding_mode = "WaitForFirstConsumer"

  depends_on = [
    module.eks
  ]

}
