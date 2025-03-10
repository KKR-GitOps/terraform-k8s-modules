resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "scaledobjects_keda_sh" {
  metadata {
    annotations = {
      "controller-gen.kubebuilder.io/version" = "v0.14.0"
    }
    labels = {
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "scaledobjects.keda.sh"
  }
  spec {
    group = "keda.sh"
    names {
      kind      = "ScaledObject"
      list_kind = "ScaledObjectList"
      plural    = "scaledobjects"
      short_names = [
        "so",
      ]
      singular = "scaledobject"
    }
    scope = "Namespaced"

    versions {

      additional_printer_columns {
        json_path = ".status.scaleTargetKind"
        name      = "ScaleTargetKind"
        type      = "string"
      }
      additional_printer_columns {
        json_path = ".spec.scaleTargetRef.name"
        name      = "ScaleTargetName"
        type      = "string"
      }
      additional_printer_columns {
        json_path = ".spec.minReplicaCount"
        name      = "Min"
        type      = "integer"
      }
      additional_printer_columns {
        json_path = ".spec.maxReplicaCount"
        name      = "Max"
        type      = "integer"
      }
      additional_printer_columns {
        json_path = ".spec.triggers[*].type"
        name      = "Triggers"
        type      = "string"
      }
      additional_printer_columns {
        json_path = ".spec.triggers[*].authenticationRef.name"
        name      = "Authentication"
        type      = "string"
      }
      additional_printer_columns {
        json_path = <<-EOF
          .status.conditions[?(@.type=="Ready")].status
          EOF
        name      = "Ready"
        type      = "string"
      }
      additional_printer_columns {
        json_path = <<-EOF
          .status.conditions[?(@.type=="Active")].status
          EOF
        name      = "Active"
        type      = "string"
      }
      additional_printer_columns {
        json_path = <<-EOF
          .status.conditions[?(@.type=="Fallback")].status
          EOF
        name      = "Fallback"
        type      = "string"
      }
      additional_printer_columns {
        json_path = <<-EOF
          .status.conditions[?(@.type=="Paused")].status
          EOF
        name      = "Paused"
        type      = "string"
      }
      additional_printer_columns {
        json_path = ".metadata.creationTimestamp"
        name      = "Age"
        type      = "date"
      }
      name = "v1alpha1"
      schema {
        open_apiv3_schema = <<-JSON
          {
            "description": "ScaledObject is a specification for a ScaledObject resource",
            "properties": {
              "apiVersion": {
                "description": "APIVersion defines the versioned schema of this representation of an object.\nServers should convert recognized schemas to the latest internal value, and\nmay reject unrecognized values.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#resources",
                "type": "string"
              },
              "kind": {
                "description": "Kind is a string value representing the REST resource this object represents.\nServers may infer this from the endpoint the client submits requests to.\nCannot be updated.\nIn CamelCase.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#types-kinds",
                "type": "string"
              },
              "metadata": {
                "type": "object"
              },
              "spec": {
                "description": "ScaledObjectSpec is the spec for a ScaledObject resource",
                "properties": {
                  "advanced": {
                    "description": "AdvancedConfig specifies advance scaling options",
                    "properties": {
                      "horizontalPodAutoscalerConfig": {
                        "description": "HorizontalPodAutoscalerConfig specifies horizontal scale config",
                        "properties": {
                          "behavior": {
                            "description": "HorizontalPodAutoscalerBehavior configures the scaling behavior of the target\nin both Up and Down directions (scaleUp and scaleDown fields respectively).",
                            "properties": {
                              "scaleDown": {
                                "description": "scaleDown is scaling policy for scaling Down.\nIf not set, the default value is to allow to scale down to minReplicas pods, with a\n300 second stabilization window (i.e., the highest recommendation for\nthe last 300sec is used).",
                                "properties": {
                                  "policies": {
                                    "description": "policies is a list of potential scaling polices which can be used during scaling.\nAt least one policy must be specified, otherwise the HPAScalingRules will be discarded as invalid",
                                    "items": {
                                      "description": "HPAScalingPolicy is a single policy which must hold true for a specified past interval.",
                                      "properties": {
                                        "periodSeconds": {
                                          "description": "periodSeconds specifies the window of time for which the policy should hold true.\nPeriodSeconds must be greater than zero and less than or equal to 1800 (30 min).",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "type": {
                                          "description": "type is used to specify the scaling policy.",
                                          "type": "string"
                                        },
                                        "value": {
                                          "description": "value contains the amount of change which is permitted by the policy.\nIt must be greater than zero",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "required": [
                                        "periodSeconds",
                                        "type",
                                        "value"
                                      ],
                                      "type": "object"
                                    },
                                    "type": "array",
                                    "x-kubernetes-list-type": "atomic"
                                  },
                                  "selectPolicy": {
                                    "description": "selectPolicy is used to specify which policy should be used.\nIf not set, the default value Max is used.",
                                    "type": "string"
                                  },
                                  "stabilizationWindowSeconds": {
                                    "description": "stabilizationWindowSeconds is the number of seconds for which past recommendations should be\nconsidered while scaling up or scaling down.\nStabilizationWindowSeconds must be greater than or equal to zero and less than or equal to 3600 (one hour).\nIf not set, use the default values:\n- For scale up: 0 (i.e. no stabilization is done).\n- For scale down: 300 (i.e. the stabilization window is 300 seconds long).",
                                    "format": "int32",
                                    "maximum": 3600,
                                    "minimum": 0,
                                    "type": "integer"
                                  }
                                },
                                "type": "object"
                              },
                              "scaleUp": {
                                "description": "scaleUp is scaling policy for scaling Up.\nIf not set, the default value is the higher of:\n  * increase no more than 4 pods per 60 seconds\n  * double the number of pods per 60 seconds\nNo stabilization is used.",
                                "properties": {
                                  "policies": {
                                    "description": "policies is a list of potential scaling polices which can be used during scaling.\nAt least one policy must be specified, otherwise the HPAScalingRules will be discarded as invalid",
                                    "items": {
                                      "description": "HPAScalingPolicy is a single policy which must hold true for a specified past interval.",
                                      "properties": {
                                        "periodSeconds": {
                                          "description": "periodSeconds specifies the window of time for which the policy should hold true.\nPeriodSeconds must be greater than zero and less than or equal to 1800 (30 min).",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "type": {
                                          "description": "type is used to specify the scaling policy.",
                                          "type": "string"
                                        },
                                        "value": {
                                          "description": "value contains the amount of change which is permitted by the policy.\nIt must be greater than zero",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "required": [
                                        "periodSeconds",
                                        "type",
                                        "value"
                                      ],
                                      "type": "object"
                                    },
                                    "type": "array",
                                    "x-kubernetes-list-type": "atomic"
                                  },
                                  "selectPolicy": {
                                    "description": "selectPolicy is used to specify which policy should be used.\nIf not set, the default value Max is used.",
                                    "type": "string"
                                  },
                                  "stabilizationWindowSeconds": {
                                    "description": "stabilizationWindowSeconds is the number of seconds for which past recommendations should be\nconsidered while scaling up or scaling down.\nStabilizationWindowSeconds must be greater than or equal to zero and less than or equal to 3600 (one hour).\nIf not set, use the default values:\n- For scale up: 0 (i.e. no stabilization is done).\n- For scale down: 300 (i.e. the stabilization window is 300 seconds long).",
                                    "format": "int32",
                                    "maximum": 3600,
                                    "minimum": 0,
                                    "type": "integer"
                                  }
                                },
                                "type": "object"
                              }
                            },
                            "type": "object"
                          },
                          "name": {
                            "type": "string"
                          }
                        },
                        "type": "object"
                      },
                      "restoreToOriginalReplicaCount": {
                        "type": "boolean"
                      },
                      "scalingModifiers": {
                        "description": "ScalingModifiers describes advanced scaling logic options like formula",
                        "properties": {
                          "activationTarget": {
                            "type": "string"
                          },
                          "formula": {
                            "type": "string"
                          },
                          "metricType": {
                            "description": "MetricTargetType specifies the type of metric being targeted, and should be either\n\"Value\", \"AverageValue\", or \"Utilization\"",
                            "type": "string"
                          },
                          "target": {
                            "type": "string"
                          }
                        },
                        "type": "object"
                      }
                    },
                    "type": "object"
                  },
                  "cooldownPeriod": {
                    "format": "int32",
                    "type": "integer"
                  },
                  "fallback": {
                    "description": "Fallback is the spec for fallback options",
                    "properties": {
                      "failureThreshold": {
                        "format": "int32",
                        "type": "integer"
                      },
                      "replicas": {
                        "format": "int32",
                        "type": "integer"
                      }
                    },
                    "required": [
                      "failureThreshold",
                      "replicas"
                    ],
                    "type": "object"
                  },
                  "idleReplicaCount": {
                    "format": "int32",
                    "type": "integer"
                  },
                  "initialCooldownPeriod": {
                    "format": "int32",
                    "type": "integer"
                  },
                  "maxReplicaCount": {
                    "format": "int32",
                    "type": "integer"
                  },
                  "minReplicaCount": {
                    "format": "int32",
                    "type": "integer"
                  },
                  "pollingInterval": {
                    "format": "int32",
                    "type": "integer"
                  },
                  "scaleTargetRef": {
                    "description": "ScaleTarget holds the reference to the scale target Object",
                    "properties": {
                      "apiVersion": {
                        "type": "string"
                      },
                      "envSourceContainerName": {
                        "type": "string"
                      },
                      "kind": {
                        "type": "string"
                      },
                      "name": {
                        "type": "string"
                      }
                    },
                    "required": [
                      "name"
                    ],
                    "type": "object"
                  },
                  "triggers": {
                    "items": {
                      "description": "ScaleTriggers reference the scaler that will be used",
                      "properties": {
                        "authenticationRef": {
                          "description": "AuthenticationRef points to the TriggerAuthentication or ClusterTriggerAuthentication object that\nis used to authenticate the scaler with the environment",
                          "properties": {
                            "kind": {
                              "description": "Kind of the resource being referred to. Defaults to TriggerAuthentication.",
                              "type": "string"
                            },
                            "name": {
                              "type": "string"
                            }
                          },
                          "required": [
                            "name"
                          ],
                          "type": "object"
                        },
                        "metadata": {
                          "additionalProperties": {
                            "type": "string"
                          },
                          "type": "object"
                        },
                        "metricType": {
                          "description": "MetricTargetType specifies the type of metric being targeted, and should be either\n\"Value\", \"AverageValue\", or \"Utilization\"",
                          "type": "string"
                        },
                        "name": {
                          "type": "string"
                        },
                        "type": {
                          "type": "string"
                        },
                        "useCachedMetrics": {
                          "type": "boolean"
                        }
                      },
                      "required": [
                        "metadata",
                        "type"
                      ],
                      "type": "object"
                    },
                    "type": "array"
                  }
                },
                "required": [
                  "scaleTargetRef",
                  "triggers"
                ],
                "type": "object"
              },
              "status": {
                "description": "ScaledObjectStatus is the status for a ScaledObject resource",
                "properties": {
                  "compositeScalerName": {
                    "type": "string"
                  },
                  "conditions": {
                    "description": "Conditions an array representation to store multiple Conditions",
                    "items": {
                      "description": "Condition to store the condition state",
                      "properties": {
                        "message": {
                          "description": "A human readable message indicating details about the transition.",
                          "type": "string"
                        },
                        "reason": {
                          "description": "The reason for the condition's last transition.",
                          "type": "string"
                        },
                        "status": {
                          "description": "Status of the condition, one of True, False, Unknown.",
                          "type": "string"
                        },
                        "type": {
                          "description": "Type of condition",
                          "type": "string"
                        }
                      },
                      "required": [
                        "status",
                        "type"
                      ],
                      "type": "object"
                    },
                    "type": "array"
                  },
                  "externalMetricNames": {
                    "items": {
                      "type": "string"
                    },
                    "type": "array"
                  },
                  "health": {
                    "additionalProperties": {
                      "description": "HealthStatus is the status for a ScaledObject's health",
                      "properties": {
                        "numberOfFailures": {
                          "format": "int32",
                          "type": "integer"
                        },
                        "status": {
                          "description": "HealthStatusType is an indication of whether the health status is happy or failing",
                          "type": "string"
                        }
                      },
                      "type": "object"
                    },
                    "type": "object"
                  },
                  "hpaName": {
                    "type": "string"
                  },
                  "lastActiveTime": {
                    "format": "date-time",
                    "type": "string"
                  },
                  "originalReplicaCount": {
                    "format": "int32",
                    "type": "integer"
                  },
                  "pausedReplicaCount": {
                    "format": "int32",
                    "type": "integer"
                  },
                  "resourceMetricNames": {
                    "items": {
                      "type": "string"
                    },
                    "type": "array"
                  },
                  "scaleTargetGVKR": {
                    "description": "GroupVersionKindResource provides unified structure for schema.GroupVersionKind and Resource",
                    "properties": {
                      "group": {
                        "type": "string"
                      },
                      "kind": {
                        "type": "string"
                      },
                      "resource": {
                        "type": "string"
                      },
                      "version": {
                        "type": "string"
                      }
                    },
                    "required": [
                      "group",
                      "kind",
                      "resource",
                      "version"
                    ],
                    "type": "object"
                  },
                  "scaleTargetKind": {
                    "type": "string"
                  }
                },
                "type": "object"
              }
            },
            "required": [
              "spec"
            ],
            "type": "object"
          }
          JSON
      }
      served  = true
      storage = true
      subresources {
        status = { "" = "" }
      }
    }
  }
}