locals {
  parameters = {
    name                 = var.name
    namespace            = var.namespace
    annotations          = var.annotations
    replicas             = 1
    ports                = var.ports
    enable_service_links = false

    node_selector = {
      role = "green"
    }

    containers = [
      {
        name  = "jenkins"
        image = var.image
        image_pull_policy = "Always"

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
            name = "REQUESTS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "requests.memory"
                divisor  = "1Mi"
              }
            }
          },
          {
            name = "LIMITS_MEMORY"
            value_from = {
              resource_field_ref = {
                resource = "limits.memory"
                divisor  = "1Mi"
              }
            }
          },
          {
            name  = "GIT_CONFIG_GLOBAL"
            value = "/var/jenkins_home/.gitconfig"
          },
          {
            name  = "JAVA_OPTS"
            value = <<-EOF
            -Xmx$(REQUESTS_MEMORY)m
            -Dhudson.slaves.NodeProvisioner.initialDelay=0
            -Dhudson.slaves.NodeProvisioner.MARGIN=50
            -Dhudson.slaves.NodeProvisioner.MARGIN0=0.85
            -Dhudson.model.DirectoryBrowserSupport.CSP="default-src 'self' 'unsafe-inline'; img-src 'self' 'unsafe-inline' data:; style-src 'self' 'unsafe-inline'; child-src 'self' 'unsafe-inline'; frame-src 'self' 'unsafe-inline'; font-src 'self' data:;"
            -Djenkins.install.runSetupWizard=false
            -Dorg.apache.commons.jelly.tags.fmt.timeZone=${var.timezone}
            EOF
          }
        ], var.env)

        resources = var.resources

        # security_context = {
        #   privileged = true
        #   run_asuser = 0  # Run as root like in the debug pod
        #   # run_asuser = 50000
        # }

        startup_probe = {
          initial_delay_seconds = 120
          period_seconds        = 10
          failure_threshold     = 3

          http_get = {
            path = "/login"
            port = 8080
          }
        }

        liveness_probe = {
          initial_delay_seconds = 120
          period_seconds        = 10
          failure_threshold     = 3

          http_get = {
            path = "/login"
            port = 8080
          }
        }

        readiness_probe = {
          initial_delay_seconds = 30
          period_seconds        = 10
          failure_threshold     = 3

          http_get = {
            path = "/login"
            port = 8080
          }
        }

        volume_mounts = concat([
          {
            name       = "data"
            mount_path = "/var/jenkins_home"
          },
          {
            name       = "casc-configs"
            mount_path = "/var/jenkins_home/casc_configs"
          },
        ], var.enable_plugins_tmpfs ? [
          {
            name       = "plugins-tmpfs"
            mount_path = "/var/jenkins_home/plugins"
          },
        ] : [])
      }
    ]


    # EKS Permission Notes:
    # - In EKS with EFS, files often show as owned by UID 50000 regardless of container user
    # - 'chown' operations typically fail due to EKS security policies, even as root
    # - Instead of fighting this behavior, we simply skip this step
    # - Files are owned by UID 50000, so we run Jenkins as UID 50000 to match
    # - For EFS volumes, this user ID mapping is handled by Kubernetes automatically

    init_containers = [
      {
        name  = "init"
        image = var.image
        command = [
          "sh",
          "-cx",
          "export GIT_CONFIG_GLOBAL=/var/jenkins_home/.gitconfig && git config --global --add safe.directory '*' && ls -la /var/jenkins_home/.gitconfig && cat /var/jenkins_home/.gitconfig"
        ]

        security_context = {
          run_asuser = "0"
        }

        volume_mounts = [
          {
            name       = "data"
            mount_path = "/var/jenkins_home"
          },
        ]
      }
    ]

    security_context = {
      # fsgroup = 0  # Match the success case from debug pod
      fsgroup = 50000
      run_asuser = 1000
      # fsgroup = 1000
    }

    service_account_name = module.rbac.service_account.metadata[0].name

    strategy = {
      type = "Recreate"
    }

    volumes = concat([
      {
        name = "data"
        persistent_volume_claim = {
          claim_name = var.pvc_name
        }
      },
      {
        name = "casc-configs"
        config_map = {
          name = var.casc_config_map_name
        }
      },
    ], var.enable_plugins_tmpfs ? [
      {
        name = "plugins-tmpfs"
        empty_dir = {
          medium = "Memory"
        }
      },
    ] : [])
  }
}

module "deployment-service" {
  source     = "../../../archetypes/deployment-service"
  parameters = merge(local.parameters, var.overrides)
}
