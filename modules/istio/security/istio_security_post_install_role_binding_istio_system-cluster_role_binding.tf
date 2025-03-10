resource "k8s_rbac_authorization_k8s_io_v1_cluster_role_binding" "istio_security_post_install_role_binding_istio_system" {
  metadata {
    labels = {
      "app"      = "security"
      "chart"    = "security"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "istio-security-post-install-role-binding-istio-system"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "istio-security-post-install-istio-system"
  }

  subjects {
    kind      = "ServiceAccount"
    name      = "istio-security-post-install-account"
    namespace = var.namespace
  }
}