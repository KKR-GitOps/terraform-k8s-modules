locals {
  input_env = merge(
    var.env_file != null ? {for tuple in regexall("(\\w+)=(.+)", file(var.env_file)) : tuple[0] => tuple[1]} : {},
    var.env_map,
  )
  computed_env = [for k, v in local.input_env : { name = k, value = v }]
}

locals {
  parameters = {
    name      = var.name
    namespace = var.namespace
    replicas  = var.replicas
    ports     = var.ports

    annotations = merge(
      var.annotations,
      var.configmap != null ? {
        config_checksum = md5(join("", keys(var.configmap.data), values(var.configmap.data)))
      } : {},
    )

    enable_service_links        = false

    containers = [
      {
        name    = var.name
        image   = var.image
        command = var.command
        args    = [
          "--store=tikv",
          "--path=${var.pd}",
        ]

        env = concat([
          {
            name = "POD_NAME"
            value_from = {
              field_ref = {
                field_path = "metadata.name"
              }
            }
          },
          {
            name = "POD_IP"
            value_from = {
              field_ref = {
                field_path = "status.podIP"
              }
            }
          },
        ], var.env, local.computed_env)

        env_from = var.env_from

        resources = var.resources

        volume_mounts = concat(
          var.pvc != null ? [
            {
              name       = "data"
              mount_path = var.mount_path
            },
          ] : [],
          var.configmap != null ? [
          for k, v in var.configmap.data :
          {
            name       = "config"
            mount_path = "/config/${var.name}/${k}"
            sub_path   = k
          }
          ] : [],
          [], //hack: without this, sub_path above stops working
        )
      },
      {
        name = "mysql"
        image = "mysql"
        command = ["sleep", "infinity"]
      },
    ]

    init_containers = var.pvc != null ? [
      {
        name  = "init"
        image = var.image

        command = [
          "sh",
          "-cx",
          "chown 1000 ${var.mount_path}"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = var.mount_path
          },
        ]
      }
    ] : []

    affinity = {
      pod_anti_affinity = {
        required_during_scheduling_ignored_during_execution = [
          {
            label_selector = {
              match_expressions = [
                {
                  key      = "name"
                  operator = "In"
                  values   = [var.name]
                }
              ]
            }
            topology_key = "kubernetes.io/hostname"
          }
        ]
      }
    }

    node_selector        = var.node_selector
    service_account_name = var.service_account_name

    volumes = concat(
      var.pvc != null ? [
        {
          name = "data"

          persistent_volume_claim = {
            claim_name = var.pvc
          }
        }
      ] : [],
      var.configmap != null ? [
      {
        name = "config"

        config_map = {
          name = var.configmap.metadata[0].name
        }
      }
    ] : [],
    )
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}