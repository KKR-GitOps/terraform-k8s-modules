variable "name" {}

variable "namespace" {}

variable "image" {
  default = "vdaas/vald-manager-index:latest"
}

variable "replicas" {
  default = 1
}

variable "ports" {
  default = [
    {
      name = "grpc"
      port = 8081
    },
    {
      name = "readiness"
      port = 3001
    },
    {
      name = "pprof"
      port = 6060
    },
  ]
}

variable "command" {
  default = null
}
variable "args" {
  default = []
}

variable "env" {
  default = []
}
variable "env_map" {
  default = {}
}
variable "env_file" {
  default = null
}
variable "env_from" {
  default = []
}

variable "annotations" {
  default = {}
}

variable "node_selector" {
  default = {}
}

variable "resources" {
  default = {
    requests = {
      cpu    = "250m"
      memory = "64Mi"
    }
  }
}

variable "service_account_name" {
  default = null
}

variable "overrides" {
  default = {}
}

variable "configmap" {
  default = null
}

variable "pvc" {
  default = null
}

variable "mount_path" {
  default = "/data"
  description = "pvc mount path"
}

