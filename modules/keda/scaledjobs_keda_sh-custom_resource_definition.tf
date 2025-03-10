resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "scaledjobs_keda_sh" {
  metadata {
    annotations = {
      "controller-gen.kubebuilder.io/version" = "v0.14.0"
    }
    labels = {
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "scaledjobs.keda.sh"
  }
  spec {
    group = "keda.sh"
    names {
      kind      = "ScaledJob"
      list_kind = "ScaledJobList"
      plural    = "scaledjobs"
      short_names = [
        "sj",
      ]
      singular = "scaledjob"
    }
    scope = "Namespaced"

    versions {

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
            "description": "ScaledJob is the Schema for the scaledjobs API",
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
                "description": "ScaledJobSpec defines the desired state of ScaledJob",
                "properties": {
                  "envSourceContainerName": {
                    "type": "string"
                  },
                  "failedJobsHistoryLimit": {
                    "format": "int32",
                    "type": "integer"
                  },
                  "jobTargetRef": {
                    "description": "JobSpec describes how the job execution will look like.",
                    "properties": {
                      "activeDeadlineSeconds": {
                        "description": "Specifies the duration in seconds relative to the startTime that the job\nmay be continuously active before the system tries to terminate it; value\nmust be positive integer. If a Job is suspended (at creation or through an\nupdate), this timer will effectively be stopped and reset when the Job is\nresumed again.",
                        "format": "int64",
                        "type": "integer"
                      },
                      "backoffLimit": {
                        "description": "Specifies the number of retries before marking this job failed.\nDefaults to 6",
                        "format": "int32",
                        "type": "integer"
                      },
                      "backoffLimitPerIndex": {
                        "description": "Specifies the limit for the number of retries within an\nindex before marking this index as failed. When enabled the number of\nfailures per index is kept in the pod's\nbatch.kubernetes.io/job-index-failure-count annotation. It can only\nbe set when Job's completionMode=Indexed, and the Pod's restart\npolicy is Never. The field is immutable.\nThis field is alpha-level. It can be used when the `JobBackoffLimitPerIndex`\nfeature gate is enabled (disabled by default).",
                        "format": "int32",
                        "type": "integer"
                      },
                      "completionMode": {
                        "description": "completionMode specifies how Pod completions are tracked. It can be\n`NonIndexed` (default) or `Indexed`.\n\n\n`NonIndexed` means that the Job is considered complete when there have\nbeen .spec.completions successfully completed Pods. Each Pod completion is\nhomologous to each other.\n\n\n`Indexed` means that the Pods of a\nJob get an associated completion index from 0 to (.spec.completions - 1),\navailable in the annotation batch.kubernetes.io/job-completion-index.\nThe Job is considered complete when there is one successfully completed Pod\nfor each index.\nWhen value is `Indexed`, .spec.completions must be specified and\n`.spec.parallelism` must be less than or equal to 10^5.\nIn addition, The Pod name takes the form\n`$(job-name)-$(index)-$(random-string)`,\nthe Pod hostname takes the form `$(job-name)-$(index)`.\n\n\nMore completion modes can be added in the future.\nIf the Job controller observes a mode that it doesn't recognize, which\nis possible during upgrades due to version skew, the controller\nskips updates for the Job.",
                        "type": "string"
                      },
                      "completions": {
                        "description": "Specifies the desired number of successfully finished pods the\njob should be run with.  Setting to null means that the success of any\npod signals the success of all pods, and allows parallelism to have any positive\nvalue.  Setting to 1 means that parallelism is limited to 1 and the success of that\npod signals the success of the job.\nMore info: https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/",
                        "format": "int32",
                        "type": "integer"
                      },
                      "manualSelector": {
                        "description": "manualSelector controls generation of pod labels and pod selectors.\nLeave `manualSelector` unset unless you are certain what you are doing.\nWhen false or unset, the system pick labels unique to this job\nand appends those labels to the pod template.  When true,\nthe user is responsible for picking unique labels and specifying\nthe selector.  Failure to pick a unique label may cause this\nand other jobs to not function correctly.  However, You may see\n`manualSelector=true` in jobs that were created with the old `extensions/v1beta1`\nAPI.\nMore info: https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/#specifying-your-own-pod-selector",
                        "type": "boolean"
                      },
                      "maxFailedIndexes": {
                        "description": "Specifies the maximal number of failed indexes before marking the Job as\nfailed, when backoffLimitPerIndex is set. Once the number of failed\nindexes exceeds this number the entire Job is marked as Failed and its\nexecution is terminated. When left as null the job continues execution of\nall of its indexes and is marked with the `Complete` Job condition.\nIt can only be specified when backoffLimitPerIndex is set.\nIt can be null or up to completions. It is required and must be\nless than or equal to 10^4 when is completions greater than 10^5.\nThis field is alpha-level. It can be used when the `JobBackoffLimitPerIndex`\nfeature gate is enabled (disabled by default).",
                        "format": "int32",
                        "type": "integer"
                      },
                      "parallelism": {
                        "description": "Specifies the maximum desired number of pods the job should\nrun at any given time. The actual number of pods running in steady state will\nbe less than this number when ((.spec.completions - .status.successful) \u003c .spec.parallelism),\ni.e. when the work left to do is less than max parallelism.\nMore info: https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/",
                        "format": "int32",
                        "type": "integer"
                      },
                      "podFailurePolicy": {
                        "description": "Specifies the policy of handling failed pods. In particular, it allows to\nspecify the set of actions and conditions which need to be\nsatisfied to take the associated action.\nIf empty, the default behaviour applies - the counter of failed pods,\nrepresented by the jobs's .status.failed field, is incremented and it is\nchecked against the backoffLimit. This field cannot be used in combination\nwith restartPolicy=OnFailure.\n\n\nThis field is beta-level. It can be used when the `JobPodFailurePolicy`\nfeature gate is enabled (enabled by default).",
                        "properties": {
                          "rules": {
                            "description": "A list of pod failure policy rules. The rules are evaluated in order.\nOnce a rule matches a Pod failure, the remaining of the rules are ignored.\nWhen no rule matches the Pod failure, the default handling applies - the\ncounter of pod failures is incremented and it is checked against\nthe backoffLimit. At most 20 elements are allowed.",
                            "items": {
                              "description": "PodFailurePolicyRule describes how a pod failure is handled when the requirements are met.\nOne of onExitCodes and onPodConditions, but not both, can be used in each rule.",
                              "properties": {
                                "action": {
                                  "description": "Specifies the action taken on a pod failure when the requirements are satisfied.\nPossible values are:\n\n\n- FailJob: indicates that the pod's job is marked as Failed and all\n  running pods are terminated.\n- FailIndex: indicates that the pod's index is marked as Failed and will\n  not be restarted.\n  This value is alpha-level. It can be used when the\n  `JobBackoffLimitPerIndex` feature gate is enabled (disabled by default).\n- Ignore: indicates that the counter towards the .backoffLimit is not\n  incremented and a replacement pod is created.\n- Count: indicates that the pod is handled in the default way - the\n  counter towards the .backoffLimit is incremented.\nAdditional values are considered to be added in the future. Clients should\nreact to an unknown action by skipping the rule.",
                                  "type": "string"
                                },
                                "onExitCodes": {
                                  "description": "Represents the requirement on the container exit codes.",
                                  "properties": {
                                    "containerName": {
                                      "description": "Restricts the check for exit codes to the container with the\nspecified name. When null, the rule applies to all containers.\nWhen specified, it should match one the container or initContainer\nnames in the pod template.",
                                      "type": "string"
                                    },
                                    "operator": {
                                      "description": "Represents the relationship between the container exit code(s) and the\nspecified values. Containers completed with success (exit code 0) are\nexcluded from the requirement check. Possible values are:\n\n\n- In: the requirement is satisfied if at least one container exit code\n  (might be multiple if there are multiple containers not restricted\n  by the 'containerName' field) is in the set of specified values.\n- NotIn: the requirement is satisfied if at least one container exit code\n  (might be multiple if there are multiple containers not restricted\n  by the 'containerName' field) is not in the set of specified values.\nAdditional values are considered to be added in the future. Clients should\nreact to an unknown operator by assuming the requirement is not satisfied.",
                                      "type": "string"
                                    },
                                    "values": {
                                      "description": "Specifies the set of values. Each returned container exit code (might be\nmultiple in case of multiple containers) is checked against this set of\nvalues with respect to the operator. The list of values must be ordered\nand must not contain duplicates. Value '0' cannot be used for the In operator.\nAt least one element is required. At most 255 elements are allowed.",
                                      "items": {
                                        "format": "int32",
                                        "type": "integer"
                                      },
                                      "type": "array",
                                      "x-kubernetes-list-type": "set"
                                    }
                                  },
                                  "required": [
                                    "operator",
                                    "values"
                                  ],
                                  "type": "object"
                                },
                                "onPodConditions": {
                                  "description": "Represents the requirement on the pod conditions. The requirement is represented\nas a list of pod condition patterns. The requirement is satisfied if at\nleast one pattern matches an actual pod condition. At most 20 elements are allowed.",
                                  "items": {
                                    "description": "PodFailurePolicyOnPodConditionsPattern describes a pattern for matching\nan actual pod condition type.",
                                    "properties": {
                                      "status": {
                                        "description": "Specifies the required Pod condition status. To match a pod condition\nit is required that the specified status equals the pod condition status.\nDefaults to True.",
                                        "type": "string"
                                      },
                                      "type": {
                                        "description": "Specifies the required Pod condition type. To match a pod condition\nit is required that specified type equals the pod condition type.",
                                        "type": "string"
                                      }
                                    },
                                    "required": [
                                      "status",
                                      "type"
                                    ],
                                    "type": "object"
                                  },
                                  "type": "array",
                                  "x-kubernetes-list-type": "atomic"
                                }
                              },
                              "required": [
                                "action"
                              ],
                              "type": "object"
                            },
                            "type": "array",
                            "x-kubernetes-list-type": "atomic"
                          }
                        },
                        "required": [
                          "rules"
                        ],
                        "type": "object"
                      },
                      "podReplacementPolicy": {
                        "description": "podReplacementPolicy specifies when to create replacement Pods.\nPossible values are:\n- TerminatingOrFailed means that we recreate pods\n  when they are terminating (has a metadata.deletionTimestamp) or failed.\n- Failed means to wait until a previously created Pod is fully terminated (has phase\n  Failed or Succeeded) before creating a replacement Pod.\n\n\nWhen using podFailurePolicy, Failed is the the only allowed value.\nTerminatingOrFailed and Failed are allowed values when podFailurePolicy is not in use.\nThis is an alpha field. Enable JobPodReplacementPolicy to be able to use this field.",
                        "type": "string"
                      },
                      "selector": {
                        "description": "A label query over pods that should match the pod count.\nNormally, the system sets this field for you.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/#label-selectors",
                        "properties": {
                          "matchExpressions": {
                            "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                            "items": {
                              "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                              "properties": {
                                "key": {
                                  "description": "key is the label key that the selector applies to.",
                                  "type": "string"
                                },
                                "operator": {
                                  "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                  "type": "string"
                                },
                                "values": {
                                  "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                  "items": {
                                    "type": "string"
                                  },
                                  "type": "array"
                                }
                              },
                              "required": [
                                "key",
                                "operator"
                              ],
                              "type": "object"
                            },
                            "type": "array"
                          },
                          "matchLabels": {
                            "additionalProperties": {
                              "type": "string"
                            },
                            "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                            "type": "object"
                          }
                        },
                        "type": "object",
                        "x-kubernetes-map-type": "atomic"
                      },
                      "suspend": {
                        "description": "suspend specifies whether the Job controller should create Pods or not. If\na Job is created with suspend set to true, no Pods are created by the Job\ncontroller. If a Job is suspended after creation (i.e. the flag goes from\nfalse to true), the Job controller will delete all active Pods associated\nwith this Job. Users must design their workload to gracefully handle this.\nSuspending a Job will reset the StartTime field of the Job, effectively\nresetting the ActiveDeadlineSeconds timer too. Defaults to false.",
                        "type": "boolean"
                      },
                      "template": {
                        "description": "Describes the pod that will be created when executing a job.\nThe only allowed template.spec.restartPolicy values are \"Never\" or \"OnFailure\".\nMore info: https://kubernetes.io/docs/concepts/workloads/controllers/jobs-run-to-completion/",
                        "properties": {
                          "metadata": {
                            "description": "Standard object's metadata.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#metadata",
                            "type": "object",
                            "x-kubernetes-preserve-unknown-fields": true
                          },
                          "spec": {
                            "description": "Specification of the desired behavior of the pod.\nMore info: https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md#spec-and-status",
                            "properties": {
                              "activeDeadlineSeconds": {
                                "description": "Optional duration in seconds the pod may be active on the node relative to\nStartTime before the system will actively try to mark it failed and kill associated containers.\nValue must be a positive integer.",
                                "format": "int64",
                                "type": "integer"
                              },
                              "affinity": {
                                "description": "If specified, the pod's scheduling constraints",
                                "properties": {
                                  "nodeAffinity": {
                                    "description": "Describes node affinity scheduling rules for the pod.",
                                    "properties": {
                                      "preferredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "The scheduler will prefer to schedule pods to nodes that satisfy\nthe affinity expressions specified by this field, but it may choose\na node that violates one or more of the expressions. The node that is\nmost preferred is the one with the greatest sum of weights, i.e.\nfor each node that meets all of the scheduling requirements (resource\nrequest, requiredDuringScheduling affinity expressions, etc.),\ncompute a sum by iterating through the elements of this field and adding\n\"weight\" to the sum if the node matches the corresponding matchExpressions; the\nnode(s) with the highest sum are the most preferred.",
                                        "items": {
                                          "description": "An empty preferred scheduling term matches all objects with implicit weight 0\n(i.e. it's a no-op). A null preferred scheduling term matches no objects (i.e. is also a no-op).",
                                          "properties": {
                                            "preference": {
                                              "description": "A node selector term, associated with the corresponding weight.",
                                              "properties": {
                                                "matchExpressions": {
                                                  "description": "A list of node selector requirements by node's labels.",
                                                  "items": {
                                                    "description": "A node selector requirement is a selector that contains values, a key, and an operator\nthat relates the key and values.",
                                                    "properties": {
                                                      "key": {
                                                        "description": "The label key that the selector applies to.",
                                                        "type": "string"
                                                      },
                                                      "operator": {
                                                        "description": "Represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.",
                                                        "type": "string"
                                                      },
                                                      "values": {
                                                        "description": "An array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. If the operator is Gt or Lt, the values\narray must have a single element, which will be interpreted as an integer.\nThis array is replaced during a strategic merge patch.",
                                                        "items": {
                                                          "type": "string"
                                                        },
                                                        "type": "array"
                                                      }
                                                    },
                                                    "required": [
                                                      "key",
                                                      "operator"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "matchFields": {
                                                  "description": "A list of node selector requirements by node's fields.",
                                                  "items": {
                                                    "description": "A node selector requirement is a selector that contains values, a key, and an operator\nthat relates the key and values.",
                                                    "properties": {
                                                      "key": {
                                                        "description": "The label key that the selector applies to.",
                                                        "type": "string"
                                                      },
                                                      "operator": {
                                                        "description": "Represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.",
                                                        "type": "string"
                                                      },
                                                      "values": {
                                                        "description": "An array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. If the operator is Gt or Lt, the values\narray must have a single element, which will be interpreted as an integer.\nThis array is replaced during a strategic merge patch.",
                                                        "items": {
                                                          "type": "string"
                                                        },
                                                        "type": "array"
                                                      }
                                                    },
                                                    "required": [
                                                      "key",
                                                      "operator"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                }
                                              },
                                              "type": "object",
                                              "x-kubernetes-map-type": "atomic"
                                            },
                                            "weight": {
                                              "description": "Weight associated with matching the corresponding nodeSelectorTerm, in the range 1-100.",
                                              "format": "int32",
                                              "type": "integer"
                                            }
                                          },
                                          "required": [
                                            "preference",
                                            "weight"
                                          ],
                                          "type": "object"
                                        },
                                        "type": "array"
                                      },
                                      "requiredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "If the affinity requirements specified by this field are not met at\nscheduling time, the pod will not be scheduled onto the node.\nIf the affinity requirements specified by this field cease to be met\nat some point during pod execution (e.g. due to an update), the system\nmay or may not try to eventually evict the pod from its node.",
                                        "properties": {
                                          "nodeSelectorTerms": {
                                            "description": "Required. A list of node selector terms. The terms are ORed.",
                                            "items": {
                                              "description": "A null or empty node selector term matches no objects. The requirements of\nthem are ANDed.\nThe TopologySelectorTerm type implements a subset of the NodeSelectorTerm.",
                                              "properties": {
                                                "matchExpressions": {
                                                  "description": "A list of node selector requirements by node's labels.",
                                                  "items": {
                                                    "description": "A node selector requirement is a selector that contains values, a key, and an operator\nthat relates the key and values.",
                                                    "properties": {
                                                      "key": {
                                                        "description": "The label key that the selector applies to.",
                                                        "type": "string"
                                                      },
                                                      "operator": {
                                                        "description": "Represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.",
                                                        "type": "string"
                                                      },
                                                      "values": {
                                                        "description": "An array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. If the operator is Gt or Lt, the values\narray must have a single element, which will be interpreted as an integer.\nThis array is replaced during a strategic merge patch.",
                                                        "items": {
                                                          "type": "string"
                                                        },
                                                        "type": "array"
                                                      }
                                                    },
                                                    "required": [
                                                      "key",
                                                      "operator"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "matchFields": {
                                                  "description": "A list of node selector requirements by node's fields.",
                                                  "items": {
                                                    "description": "A node selector requirement is a selector that contains values, a key, and an operator\nthat relates the key and values.",
                                                    "properties": {
                                                      "key": {
                                                        "description": "The label key that the selector applies to.",
                                                        "type": "string"
                                                      },
                                                      "operator": {
                                                        "description": "Represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists, DoesNotExist. Gt, and Lt.",
                                                        "type": "string"
                                                      },
                                                      "values": {
                                                        "description": "An array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. If the operator is Gt or Lt, the values\narray must have a single element, which will be interpreted as an integer.\nThis array is replaced during a strategic merge patch.",
                                                        "items": {
                                                          "type": "string"
                                                        },
                                                        "type": "array"
                                                      }
                                                    },
                                                    "required": [
                                                      "key",
                                                      "operator"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                }
                                              },
                                              "type": "object",
                                              "x-kubernetes-map-type": "atomic"
                                            },
                                            "type": "array"
                                          }
                                        },
                                        "required": [
                                          "nodeSelectorTerms"
                                        ],
                                        "type": "object",
                                        "x-kubernetes-map-type": "atomic"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "podAffinity": {
                                    "description": "Describes pod affinity scheduling rules (e.g. co-locate this pod in the same node, zone, etc. as some other pod(s)).",
                                    "properties": {
                                      "preferredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "The scheduler will prefer to schedule pods to nodes that satisfy\nthe affinity expressions specified by this field, but it may choose\na node that violates one or more of the expressions. The node that is\nmost preferred is the one with the greatest sum of weights, i.e.\nfor each node that meets all of the scheduling requirements (resource\nrequest, requiredDuringScheduling affinity expressions, etc.),\ncompute a sum by iterating through the elements of this field and adding\n\"weight\" to the sum if the node has pods which matches the corresponding podAffinityTerm; the\nnode(s) with the highest sum are the most preferred.",
                                        "items": {
                                          "description": "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)",
                                          "properties": {
                                            "podAffinityTerm": {
                                              "description": "Required. A pod affinity term, associated with the corresponding weight.",
                                              "properties": {
                                                "labelSelector": {
                                                  "description": "A label query over a set of resources, in this case pods.",
                                                  "properties": {
                                                    "matchExpressions": {
                                                      "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                                      "items": {
                                                        "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                                        "properties": {
                                                          "key": {
                                                            "description": "key is the label key that the selector applies to.",
                                                            "type": "string"
                                                          },
                                                          "operator": {
                                                            "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                            "type": "string"
                                                          },
                                                          "values": {
                                                            "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                            "items": {
                                                              "type": "string"
                                                            },
                                                            "type": "array"
                                                          }
                                                        },
                                                        "required": [
                                                          "key",
                                                          "operator"
                                                        ],
                                                        "type": "object"
                                                      },
                                                      "type": "array"
                                                    },
                                                    "matchLabels": {
                                                      "additionalProperties": {
                                                        "type": "string"
                                                      },
                                                      "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                                      "type": "object"
                                                    }
                                                  },
                                                  "type": "object",
                                                  "x-kubernetes-map-type": "atomic"
                                                },
                                                "namespaceSelector": {
                                                  "description": "A label query over the set of namespaces that the term applies to.\nThe term is applied to the union of the namespaces selected by this field\nand the ones listed in the namespaces field.\nnull selector and null or empty namespaces list means \"this pod's namespace\".\nAn empty selector ({}) matches all namespaces.",
                                                  "properties": {
                                                    "matchExpressions": {
                                                      "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                                      "items": {
                                                        "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                                        "properties": {
                                                          "key": {
                                                            "description": "key is the label key that the selector applies to.",
                                                            "type": "string"
                                                          },
                                                          "operator": {
                                                            "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                            "type": "string"
                                                          },
                                                          "values": {
                                                            "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                            "items": {
                                                              "type": "string"
                                                            },
                                                            "type": "array"
                                                          }
                                                        },
                                                        "required": [
                                                          "key",
                                                          "operator"
                                                        ],
                                                        "type": "object"
                                                      },
                                                      "type": "array"
                                                    },
                                                    "matchLabels": {
                                                      "additionalProperties": {
                                                        "type": "string"
                                                      },
                                                      "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                                      "type": "object"
                                                    }
                                                  },
                                                  "type": "object",
                                                  "x-kubernetes-map-type": "atomic"
                                                },
                                                "namespaces": {
                                                  "description": "namespaces specifies a static list of namespace names that the term applies to.\nThe term is applied to the union of the namespaces listed in this field\nand the ones selected by namespaceSelector.\nnull or empty namespaces list and null namespaceSelector means \"this pod's namespace\".",
                                                  "items": {
                                                    "type": "string"
                                                  },
                                                  "type": "array"
                                                },
                                                "topologyKey": {
                                                  "description": "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching\nthe labelSelector in the specified namespaces, where co-located is defined as running on a node\nwhose value of the label with key topologyKey matches that of any node on which any of the\nselected pods is running.\nEmpty topologyKey is not allowed.",
                                                  "type": "string"
                                                }
                                              },
                                              "required": [
                                                "topologyKey"
                                              ],
                                              "type": "object"
                                            },
                                            "weight": {
                                              "description": "weight associated with matching the corresponding podAffinityTerm,\nin the range 1-100.",
                                              "format": "int32",
                                              "type": "integer"
                                            }
                                          },
                                          "required": [
                                            "podAffinityTerm",
                                            "weight"
                                          ],
                                          "type": "object"
                                        },
                                        "type": "array"
                                      },
                                      "requiredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "If the affinity requirements specified by this field are not met at\nscheduling time, the pod will not be scheduled onto the node.\nIf the affinity requirements specified by this field cease to be met\nat some point during pod execution (e.g. due to a pod label update), the\nsystem may or may not try to eventually evict the pod from its node.\nWhen there are multiple elements, the lists of nodes corresponding to each\npodAffinityTerm are intersected, i.e. all terms must be satisfied.",
                                        "items": {
                                          "description": "Defines a set of pods (namely those matching the labelSelector\nrelative to the given namespace(s)) that this pod should be\nco-located (affinity) or not co-located (anti-affinity) with,\nwhere co-located is defined as running on a node whose value of\nthe label with key \u003ctopologyKey\u003e matches that of any node on which\na pod of the set of pods is running",
                                          "properties": {
                                            "labelSelector": {
                                              "description": "A label query over a set of resources, in this case pods.",
                                              "properties": {
                                                "matchExpressions": {
                                                  "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                                  "items": {
                                                    "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                                    "properties": {
                                                      "key": {
                                                        "description": "key is the label key that the selector applies to.",
                                                        "type": "string"
                                                      },
                                                      "operator": {
                                                        "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                        "type": "string"
                                                      },
                                                      "values": {
                                                        "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                        "items": {
                                                          "type": "string"
                                                        },
                                                        "type": "array"
                                                      }
                                                    },
                                                    "required": [
                                                      "key",
                                                      "operator"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "matchLabels": {
                                                  "additionalProperties": {
                                                    "type": "string"
                                                  },
                                                  "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                                  "type": "object"
                                                }
                                              },
                                              "type": "object",
                                              "x-kubernetes-map-type": "atomic"
                                            },
                                            "namespaceSelector": {
                                              "description": "A label query over the set of namespaces that the term applies to.\nThe term is applied to the union of the namespaces selected by this field\nand the ones listed in the namespaces field.\nnull selector and null or empty namespaces list means \"this pod's namespace\".\nAn empty selector ({}) matches all namespaces.",
                                              "properties": {
                                                "matchExpressions": {
                                                  "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                                  "items": {
                                                    "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                                    "properties": {
                                                      "key": {
                                                        "description": "key is the label key that the selector applies to.",
                                                        "type": "string"
                                                      },
                                                      "operator": {
                                                        "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                        "type": "string"
                                                      },
                                                      "values": {
                                                        "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                        "items": {
                                                          "type": "string"
                                                        },
                                                        "type": "array"
                                                      }
                                                    },
                                                    "required": [
                                                      "key",
                                                      "operator"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "matchLabels": {
                                                  "additionalProperties": {
                                                    "type": "string"
                                                  },
                                                  "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                                  "type": "object"
                                                }
                                              },
                                              "type": "object",
                                              "x-kubernetes-map-type": "atomic"
                                            },
                                            "namespaces": {
                                              "description": "namespaces specifies a static list of namespace names that the term applies to.\nThe term is applied to the union of the namespaces listed in this field\nand the ones selected by namespaceSelector.\nnull or empty namespaces list and null namespaceSelector means \"this pod's namespace\".",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            },
                                            "topologyKey": {
                                              "description": "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching\nthe labelSelector in the specified namespaces, where co-located is defined as running on a node\nwhose value of the label with key topologyKey matches that of any node on which any of the\nselected pods is running.\nEmpty topologyKey is not allowed.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "topologyKey"
                                          ],
                                          "type": "object"
                                        },
                                        "type": "array"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "podAntiAffinity": {
                                    "description": "Describes pod anti-affinity scheduling rules (e.g. avoid putting this pod in the same node, zone, etc. as some other pod(s)).",
                                    "properties": {
                                      "preferredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "The scheduler will prefer to schedule pods to nodes that satisfy\nthe anti-affinity expressions specified by this field, but it may choose\na node that violates one or more of the expressions. The node that is\nmost preferred is the one with the greatest sum of weights, i.e.\nfor each node that meets all of the scheduling requirements (resource\nrequest, requiredDuringScheduling anti-affinity expressions, etc.),\ncompute a sum by iterating through the elements of this field and adding\n\"weight\" to the sum if the node has pods which matches the corresponding podAffinityTerm; the\nnode(s) with the highest sum are the most preferred.",
                                        "items": {
                                          "description": "The weights of all of the matched WeightedPodAffinityTerm fields are added per-node to find the most preferred node(s)",
                                          "properties": {
                                            "podAffinityTerm": {
                                              "description": "Required. A pod affinity term, associated with the corresponding weight.",
                                              "properties": {
                                                "labelSelector": {
                                                  "description": "A label query over a set of resources, in this case pods.",
                                                  "properties": {
                                                    "matchExpressions": {
                                                      "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                                      "items": {
                                                        "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                                        "properties": {
                                                          "key": {
                                                            "description": "key is the label key that the selector applies to.",
                                                            "type": "string"
                                                          },
                                                          "operator": {
                                                            "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                            "type": "string"
                                                          },
                                                          "values": {
                                                            "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                            "items": {
                                                              "type": "string"
                                                            },
                                                            "type": "array"
                                                          }
                                                        },
                                                        "required": [
                                                          "key",
                                                          "operator"
                                                        ],
                                                        "type": "object"
                                                      },
                                                      "type": "array"
                                                    },
                                                    "matchLabels": {
                                                      "additionalProperties": {
                                                        "type": "string"
                                                      },
                                                      "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                                      "type": "object"
                                                    }
                                                  },
                                                  "type": "object",
                                                  "x-kubernetes-map-type": "atomic"
                                                },
                                                "namespaceSelector": {
                                                  "description": "A label query over the set of namespaces that the term applies to.\nThe term is applied to the union of the namespaces selected by this field\nand the ones listed in the namespaces field.\nnull selector and null or empty namespaces list means \"this pod's namespace\".\nAn empty selector ({}) matches all namespaces.",
                                                  "properties": {
                                                    "matchExpressions": {
                                                      "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                                      "items": {
                                                        "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                                        "properties": {
                                                          "key": {
                                                            "description": "key is the label key that the selector applies to.",
                                                            "type": "string"
                                                          },
                                                          "operator": {
                                                            "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                            "type": "string"
                                                          },
                                                          "values": {
                                                            "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                            "items": {
                                                              "type": "string"
                                                            },
                                                            "type": "array"
                                                          }
                                                        },
                                                        "required": [
                                                          "key",
                                                          "operator"
                                                        ],
                                                        "type": "object"
                                                      },
                                                      "type": "array"
                                                    },
                                                    "matchLabels": {
                                                      "additionalProperties": {
                                                        "type": "string"
                                                      },
                                                      "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                                      "type": "object"
                                                    }
                                                  },
                                                  "type": "object",
                                                  "x-kubernetes-map-type": "atomic"
                                                },
                                                "namespaces": {
                                                  "description": "namespaces specifies a static list of namespace names that the term applies to.\nThe term is applied to the union of the namespaces listed in this field\nand the ones selected by namespaceSelector.\nnull or empty namespaces list and null namespaceSelector means \"this pod's namespace\".",
                                                  "items": {
                                                    "type": "string"
                                                  },
                                                  "type": "array"
                                                },
                                                "topologyKey": {
                                                  "description": "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching\nthe labelSelector in the specified namespaces, where co-located is defined as running on a node\nwhose value of the label with key topologyKey matches that of any node on which any of the\nselected pods is running.\nEmpty topologyKey is not allowed.",
                                                  "type": "string"
                                                }
                                              },
                                              "required": [
                                                "topologyKey"
                                              ],
                                              "type": "object"
                                            },
                                            "weight": {
                                              "description": "weight associated with matching the corresponding podAffinityTerm,\nin the range 1-100.",
                                              "format": "int32",
                                              "type": "integer"
                                            }
                                          },
                                          "required": [
                                            "podAffinityTerm",
                                            "weight"
                                          ],
                                          "type": "object"
                                        },
                                        "type": "array"
                                      },
                                      "requiredDuringSchedulingIgnoredDuringExecution": {
                                        "description": "If the anti-affinity requirements specified by this field are not met at\nscheduling time, the pod will not be scheduled onto the node.\nIf the anti-affinity requirements specified by this field cease to be met\nat some point during pod execution (e.g. due to a pod label update), the\nsystem may or may not try to eventually evict the pod from its node.\nWhen there are multiple elements, the lists of nodes corresponding to each\npodAffinityTerm are intersected, i.e. all terms must be satisfied.",
                                        "items": {
                                          "description": "Defines a set of pods (namely those matching the labelSelector\nrelative to the given namespace(s)) that this pod should be\nco-located (affinity) or not co-located (anti-affinity) with,\nwhere co-located is defined as running on a node whose value of\nthe label with key \u003ctopologyKey\u003e matches that of any node on which\na pod of the set of pods is running",
                                          "properties": {
                                            "labelSelector": {
                                              "description": "A label query over a set of resources, in this case pods.",
                                              "properties": {
                                                "matchExpressions": {
                                                  "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                                  "items": {
                                                    "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                                    "properties": {
                                                      "key": {
                                                        "description": "key is the label key that the selector applies to.",
                                                        "type": "string"
                                                      },
                                                      "operator": {
                                                        "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                        "type": "string"
                                                      },
                                                      "values": {
                                                        "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                        "items": {
                                                          "type": "string"
                                                        },
                                                        "type": "array"
                                                      }
                                                    },
                                                    "required": [
                                                      "key",
                                                      "operator"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "matchLabels": {
                                                  "additionalProperties": {
                                                    "type": "string"
                                                  },
                                                  "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                                  "type": "object"
                                                }
                                              },
                                              "type": "object",
                                              "x-kubernetes-map-type": "atomic"
                                            },
                                            "namespaceSelector": {
                                              "description": "A label query over the set of namespaces that the term applies to.\nThe term is applied to the union of the namespaces selected by this field\nand the ones listed in the namespaces field.\nnull selector and null or empty namespaces list means \"this pod's namespace\".\nAn empty selector ({}) matches all namespaces.",
                                              "properties": {
                                                "matchExpressions": {
                                                  "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                                  "items": {
                                                    "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                                    "properties": {
                                                      "key": {
                                                        "description": "key is the label key that the selector applies to.",
                                                        "type": "string"
                                                      },
                                                      "operator": {
                                                        "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                        "type": "string"
                                                      },
                                                      "values": {
                                                        "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                        "items": {
                                                          "type": "string"
                                                        },
                                                        "type": "array"
                                                      }
                                                    },
                                                    "required": [
                                                      "key",
                                                      "operator"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "matchLabels": {
                                                  "additionalProperties": {
                                                    "type": "string"
                                                  },
                                                  "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                                  "type": "object"
                                                }
                                              },
                                              "type": "object",
                                              "x-kubernetes-map-type": "atomic"
                                            },
                                            "namespaces": {
                                              "description": "namespaces specifies a static list of namespace names that the term applies to.\nThe term is applied to the union of the namespaces listed in this field\nand the ones selected by namespaceSelector.\nnull or empty namespaces list and null namespaceSelector means \"this pod's namespace\".",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            },
                                            "topologyKey": {
                                              "description": "This pod should be co-located (affinity) or not co-located (anti-affinity) with the pods matching\nthe labelSelector in the specified namespaces, where co-located is defined as running on a node\nwhose value of the label with key topologyKey matches that of any node on which any of the\nselected pods is running.\nEmpty topologyKey is not allowed.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "topologyKey"
                                          ],
                                          "type": "object"
                                        },
                                        "type": "array"
                                      }
                                    },
                                    "type": "object"
                                  }
                                },
                                "type": "object"
                              },
                              "automountServiceAccountToken": {
                                "description": "AutomountServiceAccountToken indicates whether a service account token should be automatically mounted.",
                                "type": "boolean"
                              },
                              "containers": {
                                "description": "List of containers belonging to the pod.\nContainers cannot currently be added or removed.\nThere must be at least one container in a Pod.\nCannot be updated.",
                                "items": {
                                  "description": "A single application container that you want to run within a pod.",
                                  "properties": {
                                    "args": {
                                      "description": "Arguments to the entrypoint.\nThe container image's CMD is used if this is not provided.\nVariable references $(VAR_NAME) are expanded using the container's environment. If a variable\ncannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced\nto a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. \"$$(VAR_NAME)\" will\nproduce the string literal \"$(VAR_NAME)\". Escaped references will never be expanded, regardless\nof whether the variable exists or not. Cannot be updated.\nMore info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell",
                                      "items": {
                                        "type": "string"
                                      },
                                      "type": "array"
                                    },
                                    "command": {
                                      "description": "Entrypoint array. Not executed within a shell.\nThe container image's ENTRYPOINT is used if this is not provided.\nVariable references $(VAR_NAME) are expanded using the container's environment. If a variable\ncannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced\nto a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. \"$$(VAR_NAME)\" will\nproduce the string literal \"$(VAR_NAME)\". Escaped references will never be expanded, regardless\nof whether the variable exists or not. Cannot be updated.\nMore info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell",
                                      "items": {
                                        "type": "string"
                                      },
                                      "type": "array"
                                    },
                                    "env": {
                                      "description": "List of environment variables to set in the container.\nCannot be updated.",
                                      "items": {
                                        "description": "EnvVar represents an environment variable present in a Container.",
                                        "properties": {
                                          "name": {
                                            "description": "Name of the environment variable. Must be a C_IDENTIFIER.",
                                            "type": "string"
                                          },
                                          "value": {
                                            "description": "Variable references $(VAR_NAME) are expanded\nusing the previously defined environment variables in the container and\nany service environment variables. If a variable cannot be resolved,\nthe reference in the input string will be unchanged. Double $$ are reduced\nto a single $, which allows for escaping the $(VAR_NAME) syntax: i.e.\n\"$$(VAR_NAME)\" will produce the string literal \"$(VAR_NAME)\".\nEscaped references will never be expanded, regardless of whether the variable\nexists or not.\nDefaults to \"\".",
                                            "type": "string"
                                          },
                                          "valueFrom": {
                                            "description": "Source for the environment variable's value. Cannot be used if value is not empty.",
                                            "properties": {
                                              "configMapKeyRef": {
                                                "description": "Selects a key of a ConfigMap.",
                                                "properties": {
                                                  "key": {
                                                    "description": "The key to select.",
                                                    "type": "string"
                                                  },
                                                  "name": {
                                                    "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                    "type": "string"
                                                  },
                                                  "optional": {
                                                    "description": "Specify whether the ConfigMap or its key must be defined",
                                                    "type": "boolean"
                                                  }
                                                },
                                                "required": [
                                                  "key"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "fieldRef": {
                                                "description": "Selects a field of the pod: supports metadata.name, metadata.namespace, `metadata.labels['\u003cKEY\u003e']`, `metadata.annotations['\u003cKEY\u003e']`,\nspec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs.",
                                                "properties": {
                                                  "apiVersion": {
                                                    "description": "Version of the schema the FieldPath is written in terms of, defaults to \"v1\".",
                                                    "type": "string"
                                                  },
                                                  "fieldPath": {
                                                    "description": "Path of the field to select in the specified API version.",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "fieldPath"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "resourceFieldRef": {
                                                "description": "Selects a resource of the container: only resources limits and requests\n(limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported.",
                                                "properties": {
                                                  "containerName": {
                                                    "description": "Container name: required for volumes, optional for env vars",
                                                    "type": "string"
                                                  },
                                                  "divisor": {
                                                    "anyOf": [
                                                      {
                                                        "type": "integer"
                                                      },
                                                      {
                                                        "type": "string"
                                                      }
                                                    ],
                                                    "description": "Specifies the output format of the exposed resources, defaults to \"1\"",
                                                    "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                    "x-kubernetes-int-or-string": true
                                                  },
                                                  "resource": {
                                                    "description": "Required: resource to select",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "resource"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "secretKeyRef": {
                                                "description": "Selects a key of a secret in the pod's namespace",
                                                "properties": {
                                                  "key": {
                                                    "description": "The key of the secret to select from.  Must be a valid secret key.",
                                                    "type": "string"
                                                  },
                                                  "name": {
                                                    "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                    "type": "string"
                                                  },
                                                  "optional": {
                                                    "description": "Specify whether the Secret or its key must be defined",
                                                    "type": "boolean"
                                                  }
                                                },
                                                "required": [
                                                  "key"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              }
                                            },
                                            "type": "object"
                                          }
                                        },
                                        "required": [
                                          "name"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "envFrom": {
                                      "description": "List of sources to populate environment variables in the container.\nThe keys defined within a source must be a C_IDENTIFIER. All invalid keys\nwill be reported as an event when the container is starting. When a key exists in multiple\nsources, the value associated with the last source will take precedence.\nValues defined by an Env with a duplicate key will take precedence.\nCannot be updated.",
                                      "items": {
                                        "description": "EnvFromSource represents the source of a set of ConfigMaps",
                                        "properties": {
                                          "configMapRef": {
                                            "description": "The ConfigMap to select from",
                                            "properties": {
                                              "name": {
                                                "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                "type": "string"
                                              },
                                              "optional": {
                                                "description": "Specify whether the ConfigMap must be defined",
                                                "type": "boolean"
                                              }
                                            },
                                            "type": "object",
                                            "x-kubernetes-map-type": "atomic"
                                          },
                                          "prefix": {
                                            "description": "An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER.",
                                            "type": "string"
                                          },
                                          "secretRef": {
                                            "description": "The Secret to select from",
                                            "properties": {
                                              "name": {
                                                "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                "type": "string"
                                              },
                                              "optional": {
                                                "description": "Specify whether the Secret must be defined",
                                                "type": "boolean"
                                              }
                                            },
                                            "type": "object",
                                            "x-kubernetes-map-type": "atomic"
                                          }
                                        },
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "image": {
                                      "description": "Container image name.\nMore info: https://kubernetes.io/docs/concepts/containers/images\nThis field is optional to allow higher level config management to default or override\ncontainer images in workload controllers like Deployments and StatefulSets.",
                                      "type": "string"
                                    },
                                    "imagePullPolicy": {
                                      "description": "Image pull policy.\nOne of Always, Never, IfNotPresent.\nDefaults to Always if :latest tag is specified, or IfNotPresent otherwise.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/containers/images#updating-images",
                                      "type": "string"
                                    },
                                    "lifecycle": {
                                      "description": "Actions that the management system should take in response to container lifecycle events.\nCannot be updated.",
                                      "properties": {
                                        "postStart": {
                                          "description": "PostStart is called immediately after a container is created. If the handler fails,\nthe container is terminated and restarted according to its restart policy.\nOther management of the container blocks until the hook completes.\nMore info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks",
                                          "properties": {
                                            "exec": {
                                              "description": "Exec specifies the action to take.",
                                              "properties": {
                                                "command": {
                                                  "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                                  "items": {
                                                    "type": "string"
                                                  },
                                                  "type": "array"
                                                }
                                              },
                                              "type": "object"
                                            },
                                            "httpGet": {
                                              "description": "HTTPGet specifies the http request to perform.",
                                              "properties": {
                                                "host": {
                                                  "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                                  "type": "string"
                                                },
                                                "httpHeaders": {
                                                  "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                                  "items": {
                                                    "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                    "properties": {
                                                      "name": {
                                                        "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                        "type": "string"
                                                      },
                                                      "value": {
                                                        "description": "The header field value",
                                                        "type": "string"
                                                      }
                                                    },
                                                    "required": [
                                                      "name",
                                                      "value"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "path": {
                                                  "description": "Path to access on the HTTP server.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                  "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                                  "type": "string"
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            },
                                            "tcpSocket": {
                                              "description": "Deprecated. TCPSocket is NOT supported as a LifecycleHandler and kept\nfor the backward compatibility. There are no validation of this field and\nlifecycle hooks will fail in runtime when tcp handler is specified.",
                                              "properties": {
                                                "host": {
                                                  "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "preStop": {
                                          "description": "PreStop is called immediately before a container is terminated due to an\nAPI request or management event such as liveness/startup probe failure,\npreemption, resource contention, etc. The handler is not called if the\ncontainer crashes or exits. The Pod's termination grace period countdown begins before the\nPreStop hook is executed. Regardless of the outcome of the handler, the\ncontainer will eventually terminate within the Pod's termination grace\nperiod (unless delayed by finalizers). Other management of the container blocks until the hook completes\nor until the termination grace period is reached.\nMore info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks",
                                          "properties": {
                                            "exec": {
                                              "description": "Exec specifies the action to take.",
                                              "properties": {
                                                "command": {
                                                  "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                                  "items": {
                                                    "type": "string"
                                                  },
                                                  "type": "array"
                                                }
                                              },
                                              "type": "object"
                                            },
                                            "httpGet": {
                                              "description": "HTTPGet specifies the http request to perform.",
                                              "properties": {
                                                "host": {
                                                  "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                                  "type": "string"
                                                },
                                                "httpHeaders": {
                                                  "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                                  "items": {
                                                    "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                    "properties": {
                                                      "name": {
                                                        "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                        "type": "string"
                                                      },
                                                      "value": {
                                                        "description": "The header field value",
                                                        "type": "string"
                                                      }
                                                    },
                                                    "required": [
                                                      "name",
                                                      "value"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "path": {
                                                  "description": "Path to access on the HTTP server.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                  "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                                  "type": "string"
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            },
                                            "tcpSocket": {
                                              "description": "Deprecated. TCPSocket is NOT supported as a LifecycleHandler and kept\nfor the backward compatibility. There are no validation of this field and\nlifecycle hooks will fail in runtime when tcp handler is specified.",
                                              "properties": {
                                                "host": {
                                                  "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            }
                                          },
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "livenessProbe": {
                                      "description": "Periodic probe of container liveness.\nContainer will be restarted if the probe fails.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                      "properties": {
                                        "exec": {
                                          "description": "Exec specifies the action to take.",
                                          "properties": {
                                            "command": {
                                              "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "failureThreshold": {
                                          "description": "Minimum consecutive failures for the probe to be considered failed after having succeeded.\nDefaults to 3. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "grpc": {
                                          "description": "GRPC specifies an action involving a GRPC port.",
                                          "properties": {
                                            "port": {
                                              "description": "Port number of the gRPC service. Number must be in the range 1 to 65535.",
                                              "format": "int32",
                                              "type": "integer"
                                            },
                                            "service": {
                                              "description": "Service is the name of the service to place in the gRPC HealthCheckRequest\n(see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).\n\n\nIf this is not specified, the default behavior is defined by gRPC.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "httpGet": {
                                          "description": "HTTPGet specifies the http request to perform.",
                                          "properties": {
                                            "host": {
                                              "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                              "type": "string"
                                            },
                                            "httpHeaders": {
                                              "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                              "items": {
                                                "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                "properties": {
                                                  "name": {
                                                    "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                    "type": "string"
                                                  },
                                                  "value": {
                                                    "description": "The header field value",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "name",
                                                  "value"
                                                ],
                                                "type": "object"
                                              },
                                              "type": "array"
                                            },
                                            "path": {
                                              "description": "Path to access on the HTTP server.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                              "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                          "description": "Number of seconds after the container has started before liveness probes are initiated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "periodSeconds": {
                                          "description": "How often (in seconds) to perform the probe.\nDefault to 10 seconds. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "successThreshold": {
                                          "description": "Minimum consecutive successes for the probe to be considered successful after having failed.\nDefaults to 1. Must be 1 for liveness and startup. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpSocket": {
                                          "description": "TCPSocket specifies an action involving a TCP port.",
                                          "properties": {
                                            "host": {
                                              "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "terminationGracePeriodSeconds": {
                                          "description": "Optional duration in seconds the pod needs to terminate gracefully upon probe failure.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nIf this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this\nvalue overrides the value provided by the pod spec.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nThis is a beta field and requires enabling ProbeTerminationGracePeriod feature gate.\nMinimum value is 1. spec.terminationGracePeriodSeconds is used if unset.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "timeoutSeconds": {
                                          "description": "Number of seconds after which the probe times out.\nDefaults to 1 second. Minimum value is 1.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "name": {
                                      "description": "Name of the container specified as a DNS_LABEL.\nEach container in a pod must have a unique name (DNS_LABEL).\nCannot be updated.",
                                      "type": "string"
                                    },
                                    "ports": {
                                      "description": "List of ports to expose from the container. Not specifying a port here\nDOES NOT prevent that port from being exposed. Any port which is\nlistening on the default \"0.0.0.0\" address inside a container will be\naccessible from the network.\nModifying this array with strategic merge patch may corrupt the data.\nFor more information See https://github.com/kubernetes/kubernetes/issues/108255.\nCannot be updated.",
                                      "items": {
                                        "description": "ContainerPort represents a network port in a single container.",
                                        "properties": {
                                          "containerPort": {
                                            "description": "Number of port to expose on the pod's IP address.\nThis must be a valid port number, 0 \u003c x \u003c 65536.",
                                            "format": "int32",
                                            "type": "integer"
                                          },
                                          "hostIP": {
                                            "description": "What host IP to bind the external port to.",
                                            "type": "string"
                                          },
                                          "hostPort": {
                                            "description": "Number of port to expose on the host.\nIf specified, this must be a valid port number, 0 \u003c x \u003c 65536.\nIf HostNetwork is specified, this must match ContainerPort.\nMost containers do not need this.",
                                            "format": "int32",
                                            "type": "integer"
                                          },
                                          "name": {
                                            "description": "If specified, this must be an IANA_SVC_NAME and unique within the pod. Each\nnamed port in a pod must have a unique name. Name for the port that can be\nreferred to by services.",
                                            "type": "string"
                                          },
                                          "protocol": {
                                            "default": "TCP",
                                            "description": "Protocol for port. Must be UDP, TCP, or SCTP.\nDefaults to \"TCP\".",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "containerPort",
                                          "protocol"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array",
                                      "x-kubernetes-list-map-keys": [
                                        "containerPort",
                                        "protocol"
                                      ],
                                      "x-kubernetes-list-type": "map"
                                    },
                                    "readinessProbe": {
                                      "description": "Periodic probe of container service readiness.\nContainer will be removed from service endpoints if the probe fails.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                      "properties": {
                                        "exec": {
                                          "description": "Exec specifies the action to take.",
                                          "properties": {
                                            "command": {
                                              "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "failureThreshold": {
                                          "description": "Minimum consecutive failures for the probe to be considered failed after having succeeded.\nDefaults to 3. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "grpc": {
                                          "description": "GRPC specifies an action involving a GRPC port.",
                                          "properties": {
                                            "port": {
                                              "description": "Port number of the gRPC service. Number must be in the range 1 to 65535.",
                                              "format": "int32",
                                              "type": "integer"
                                            },
                                            "service": {
                                              "description": "Service is the name of the service to place in the gRPC HealthCheckRequest\n(see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).\n\n\nIf this is not specified, the default behavior is defined by gRPC.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "httpGet": {
                                          "description": "HTTPGet specifies the http request to perform.",
                                          "properties": {
                                            "host": {
                                              "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                              "type": "string"
                                            },
                                            "httpHeaders": {
                                              "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                              "items": {
                                                "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                "properties": {
                                                  "name": {
                                                    "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                    "type": "string"
                                                  },
                                                  "value": {
                                                    "description": "The header field value",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "name",
                                                  "value"
                                                ],
                                                "type": "object"
                                              },
                                              "type": "array"
                                            },
                                            "path": {
                                              "description": "Path to access on the HTTP server.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                              "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                          "description": "Number of seconds after the container has started before liveness probes are initiated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "periodSeconds": {
                                          "description": "How often (in seconds) to perform the probe.\nDefault to 10 seconds. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "successThreshold": {
                                          "description": "Minimum consecutive successes for the probe to be considered successful after having failed.\nDefaults to 1. Must be 1 for liveness and startup. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpSocket": {
                                          "description": "TCPSocket specifies an action involving a TCP port.",
                                          "properties": {
                                            "host": {
                                              "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "terminationGracePeriodSeconds": {
                                          "description": "Optional duration in seconds the pod needs to terminate gracefully upon probe failure.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nIf this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this\nvalue overrides the value provided by the pod spec.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nThis is a beta field and requires enabling ProbeTerminationGracePeriod feature gate.\nMinimum value is 1. spec.terminationGracePeriodSeconds is used if unset.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "timeoutSeconds": {
                                          "description": "Number of seconds after which the probe times out.\nDefaults to 1 second. Minimum value is 1.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "resizePolicy": {
                                      "description": "Resources resize policy for the container.",
                                      "items": {
                                        "description": "ContainerResizePolicy represents resource resize policy for the container.",
                                        "properties": {
                                          "resourceName": {
                                            "description": "Name of the resource to which this resource resize policy applies.\nSupported values: cpu, memory.",
                                            "type": "string"
                                          },
                                          "restartPolicy": {
                                            "description": "Restart policy to apply when specified resource is resized.\nIf not specified, it defaults to NotRequired.",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "resourceName",
                                          "restartPolicy"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array",
                                      "x-kubernetes-list-type": "atomic"
                                    },
                                    "resources": {
                                      "description": "Compute Resources required by this container.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                      "properties": {
                                        "claims": {
                                          "description": "Claims lists the names of resources, defined in spec.resourceClaims,\nthat are used by this container.\n\n\nThis is an alpha field and requires enabling the\nDynamicResourceAllocation feature gate.\n\n\nThis field is immutable. It can only be set for containers.",
                                          "items": {
                                            "description": "ResourceClaim references one entry in PodSpec.ResourceClaims.",
                                            "properties": {
                                              "name": {
                                                "description": "Name must match the name of one entry in pod.spec.resourceClaims of\nthe Pod where this field is used. It makes that resource available\ninside a container.",
                                                "type": "string"
                                              }
                                            },
                                            "required": [
                                              "name"
                                            ],
                                            "type": "object"
                                          },
                                          "type": "array",
                                          "x-kubernetes-list-map-keys": [
                                            "name"
                                          ],
                                          "x-kubernetes-list-type": "map"
                                        },
                                        "limits": {
                                          "additionalProperties": {
                                            "anyOf": [
                                              {
                                                "type": "integer"
                                              },
                                              {
                                                "type": "string"
                                              }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                          },
                                          "description": "Limits describes the maximum amount of compute resources allowed.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                          "type": "object"
                                        },
                                        "requests": {
                                          "additionalProperties": {
                                            "anyOf": [
                                              {
                                                "type": "integer"
                                              },
                                              {
                                                "type": "string"
                                              }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                          },
                                          "description": "Requests describes the minimum amount of compute resources required.\nIf Requests is omitted for a container, it defaults to Limits if that is explicitly specified,\notherwise to an implementation-defined value. Requests cannot exceed Limits.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "restartPolicy": {
                                      "description": "RestartPolicy defines the restart behavior of individual containers in a pod.\nThis field may only be set for init containers, and the only allowed value is \"Always\".\nFor non-init containers or when this field is not specified,\nthe restart behavior is defined by the Pod's restart policy and the container type.\nSetting the RestartPolicy as \"Always\" for the init container will have the following effect:\nthis init container will be continually restarted on\nexit until all regular containers have terminated. Once all regular\ncontainers have completed, all init containers with restartPolicy \"Always\"\nwill be shut down. This lifecycle differs from normal init containers and\nis often referred to as a \"sidecar\" container. Although this init\ncontainer still starts in the init container sequence, it does not wait\nfor the container to complete before proceeding to the next init\ncontainer. Instead, the next init container starts immediately after this\ninit container is started, or after any startupProbe has successfully\ncompleted.",
                                      "type": "string"
                                    },
                                    "securityContext": {
                                      "description": "SecurityContext defines the security options the container should be run with.\nIf set, the fields of SecurityContext override the equivalent fields of PodSecurityContext.\nMore info: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/",
                                      "properties": {
                                        "allowPrivilegeEscalation": {
                                          "description": "AllowPrivilegeEscalation controls whether a process can gain more\nprivileges than its parent process. This bool directly controls if\nthe no_new_privs flag will be set on the container process.\nAllowPrivilegeEscalation is true always when the container is:\n1) run as Privileged\n2) has CAP_SYS_ADMIN\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "boolean"
                                        },
                                        "capabilities": {
                                          "description": "The capabilities to add/drop when running containers.\nDefaults to the default set of capabilities granted by the container runtime.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "properties": {
                                            "add": {
                                              "description": "Added capabilities",
                                              "items": {
                                                "description": "Capability represent POSIX capabilities type",
                                                "type": "string"
                                              },
                                              "type": "array"
                                            },
                                            "drop": {
                                              "description": "Removed capabilities",
                                              "items": {
                                                "description": "Capability represent POSIX capabilities type",
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "privileged": {
                                          "description": "Run container in privileged mode.\nProcesses in privileged containers are essentially equivalent to root on the host.\nDefaults to false.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "boolean"
                                        },
                                        "procMount": {
                                          "description": "procMount denotes the type of proc mount to use for the containers.\nThe default is DefaultProcMount which uses the container runtime defaults for\nreadonly paths and masked paths.\nThis requires the ProcMountType feature flag to be enabled.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "string"
                                        },
                                        "readOnlyRootFilesystem": {
                                          "description": "Whether this container has a read-only root filesystem.\nDefault is false.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "boolean"
                                        },
                                        "runAsGroup": {
                                          "description": "The GID to run the entrypoint of the container process.\nUses runtime default if unset.\nMay also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "runAsNonRoot": {
                                          "description": "Indicates that the container must run as a non-root user.\nIf true, the Kubelet will validate the image at runtime to ensure that it\ndoes not run as UID 0 (root) and fail to start the container if it does.\nIf unset or false, no such validation will be performed.\nMay also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.",
                                          "type": "boolean"
                                        },
                                        "runAsUser": {
                                          "description": "The UID to run the entrypoint of the container process.\nDefaults to user specified in image metadata if unspecified.\nMay also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "seLinuxOptions": {
                                          "description": "The SELinux context to be applied to the container.\nIf unspecified, the container runtime will allocate a random SELinux context for each\ncontainer.  May also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "properties": {
                                            "level": {
                                              "description": "Level is SELinux level label that applies to the container.",
                                              "type": "string"
                                            },
                                            "role": {
                                              "description": "Role is a SELinux role label that applies to the container.",
                                              "type": "string"
                                            },
                                            "type": {
                                              "description": "Type is a SELinux type label that applies to the container.",
                                              "type": "string"
                                            },
                                            "user": {
                                              "description": "User is a SELinux user label that applies to the container.",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "seccompProfile": {
                                          "description": "The seccomp options to use by this container. If seccomp options are\nprovided at both the pod \u0026 container level, the container options\noverride the pod options.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "properties": {
                                            "localhostProfile": {
                                              "description": "localhostProfile indicates a profile defined in a file on the node should be used.\nThe profile must be preconfigured on the node to work.\nMust be a descending path, relative to the kubelet's configured seccomp profile location.\nMust be set if type is \"Localhost\". Must NOT be set for any other type.",
                                              "type": "string"
                                            },
                                            "type": {
                                              "description": "type indicates which kind of seccomp profile will be applied.\nValid options are:\n\n\nLocalhost - a profile defined in a file on the node should be used.\nRuntimeDefault - the container runtime default profile should be used.\nUnconfined - no profile should be applied.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "type"
                                          ],
                                          "type": "object"
                                        },
                                        "windowsOptions": {
                                          "description": "The Windows specific settings applied to all containers.\nIf unspecified, the options from the PodSecurityContext will be used.\nIf set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is linux.",
                                          "properties": {
                                            "gmsaCredentialSpec": {
                                              "description": "GMSACredentialSpec is where the GMSA admission webhook\n(https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the\nGMSA credential spec named by the GMSACredentialSpecName field.",
                                              "type": "string"
                                            },
                                            "gmsaCredentialSpecName": {
                                              "description": "GMSACredentialSpecName is the name of the GMSA credential spec to use.",
                                              "type": "string"
                                            },
                                            "hostProcess": {
                                              "description": "HostProcess determines if a container should be run as a 'Host Process' container.\nAll of a Pod's containers must have the same effective HostProcess value\n(it is not allowed to have a mix of HostProcess containers and non-HostProcess containers).\nIn addition, if HostProcess is true then HostNetwork must also be set to true.",
                                              "type": "boolean"
                                            },
                                            "runAsUserName": {
                                              "description": "The UserName in Windows to run the entrypoint of the container process.\nDefaults to the user specified in image metadata if unspecified.\nMay also be set in PodSecurityContext. If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "startupProbe": {
                                      "description": "StartupProbe indicates that the Pod has successfully initialized.\nIf specified, no other probes are executed until this completes successfully.\nIf this probe fails, the Pod will be restarted, just as if the livenessProbe failed.\nThis can be used to provide different probe parameters at the beginning of a Pod's lifecycle,\nwhen it might take a long time to load data or warm a cache, than during steady-state operation.\nThis cannot be updated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                      "properties": {
                                        "exec": {
                                          "description": "Exec specifies the action to take.",
                                          "properties": {
                                            "command": {
                                              "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "failureThreshold": {
                                          "description": "Minimum consecutive failures for the probe to be considered failed after having succeeded.\nDefaults to 3. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "grpc": {
                                          "description": "GRPC specifies an action involving a GRPC port.",
                                          "properties": {
                                            "port": {
                                              "description": "Port number of the gRPC service. Number must be in the range 1 to 65535.",
                                              "format": "int32",
                                              "type": "integer"
                                            },
                                            "service": {
                                              "description": "Service is the name of the service to place in the gRPC HealthCheckRequest\n(see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).\n\n\nIf this is not specified, the default behavior is defined by gRPC.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "httpGet": {
                                          "description": "HTTPGet specifies the http request to perform.",
                                          "properties": {
                                            "host": {
                                              "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                              "type": "string"
                                            },
                                            "httpHeaders": {
                                              "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                              "items": {
                                                "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                "properties": {
                                                  "name": {
                                                    "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                    "type": "string"
                                                  },
                                                  "value": {
                                                    "description": "The header field value",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "name",
                                                  "value"
                                                ],
                                                "type": "object"
                                              },
                                              "type": "array"
                                            },
                                            "path": {
                                              "description": "Path to access on the HTTP server.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                              "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                          "description": "Number of seconds after the container has started before liveness probes are initiated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "periodSeconds": {
                                          "description": "How often (in seconds) to perform the probe.\nDefault to 10 seconds. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "successThreshold": {
                                          "description": "Minimum consecutive successes for the probe to be considered successful after having failed.\nDefaults to 1. Must be 1 for liveness and startup. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpSocket": {
                                          "description": "TCPSocket specifies an action involving a TCP port.",
                                          "properties": {
                                            "host": {
                                              "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "terminationGracePeriodSeconds": {
                                          "description": "Optional duration in seconds the pod needs to terminate gracefully upon probe failure.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nIf this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this\nvalue overrides the value provided by the pod spec.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nThis is a beta field and requires enabling ProbeTerminationGracePeriod feature gate.\nMinimum value is 1. spec.terminationGracePeriodSeconds is used if unset.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "timeoutSeconds": {
                                          "description": "Number of seconds after which the probe times out.\nDefaults to 1 second. Minimum value is 1.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "stdin": {
                                      "description": "Whether this container should allocate a buffer for stdin in the container runtime. If this\nis not set, reads from stdin in the container will always result in EOF.\nDefault is false.",
                                      "type": "boolean"
                                    },
                                    "stdinOnce": {
                                      "description": "Whether the container runtime should close the stdin channel after it has been opened by\na single attach. When stdin is true the stdin stream will remain open across multiple attach\nsessions. If stdinOnce is set to true, stdin is opened on container start, is empty until the\nfirst client attaches to stdin, and then remains open and accepts data until the client disconnects,\nat which time stdin is closed and remains closed until the container is restarted. If this\nflag is false, a container processes that reads from stdin will never receive an EOF.\nDefault is false",
                                      "type": "boolean"
                                    },
                                    "terminationMessagePath": {
                                      "description": "Optional: Path at which the file to which the container's termination message\nwill be written is mounted into the container's filesystem.\nMessage written is intended to be brief final status, such as an assertion failure message.\nWill be truncated by the node if greater than 4096 bytes. The total message length across\nall containers will be limited to 12kb.\nDefaults to /dev/termination-log.\nCannot be updated.",
                                      "type": "string"
                                    },
                                    "terminationMessagePolicy": {
                                      "description": "Indicate how the termination message should be populated. File will use the contents of\nterminationMessagePath to populate the container status message on both success and failure.\nFallbackToLogsOnError will use the last chunk of container log output if the termination\nmessage file is empty and the container exited with an error.\nThe log output is limited to 2048 bytes or 80 lines, whichever is smaller.\nDefaults to File.\nCannot be updated.",
                                      "type": "string"
                                    },
                                    "tty": {
                                      "description": "Whether this container should allocate a TTY for itself, also requires 'stdin' to be true.\nDefault is false.",
                                      "type": "boolean"
                                    },
                                    "volumeDevices": {
                                      "description": "volumeDevices is the list of block devices to be used by the container.",
                                      "items": {
                                        "description": "volumeDevice describes a mapping of a raw block device within a container.",
                                        "properties": {
                                          "devicePath": {
                                            "description": "devicePath is the path inside of the container that the device will be mapped to.",
                                            "type": "string"
                                          },
                                          "name": {
                                            "description": "name must match the name of a persistentVolumeClaim in the pod",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "devicePath",
                                          "name"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "volumeMounts": {
                                      "description": "Pod volumes to mount into the container's filesystem.\nCannot be updated.",
                                      "items": {
                                        "description": "VolumeMount describes a mounting of a Volume within a container.",
                                        "properties": {
                                          "mountPath": {
                                            "description": "Path within the container at which the volume should be mounted.  Must\nnot contain ':'.",
                                            "type": "string"
                                          },
                                          "mountPropagation": {
                                            "description": "mountPropagation determines how mounts are propagated from the host\nto container and the other way around.\nWhen not set, MountPropagationNone is used.\nThis field is beta in 1.10.",
                                            "type": "string"
                                          },
                                          "name": {
                                            "description": "This must match the Name of a Volume.",
                                            "type": "string"
                                          },
                                          "readOnly": {
                                            "description": "Mounted read-only if true, read-write otherwise (false or unspecified).\nDefaults to false.",
                                            "type": "boolean"
                                          },
                                          "subPath": {
                                            "description": "Path within the volume from which the container's volume should be mounted.\nDefaults to \"\" (volume's root).",
                                            "type": "string"
                                          },
                                          "subPathExpr": {
                                            "description": "Expanded path within the volume from which the container's volume should be mounted.\nBehaves similarly to SubPath but environment variable references $(VAR_NAME) are expanded using the container's environment.\nDefaults to \"\" (volume's root).\nSubPathExpr and SubPath are mutually exclusive.",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "mountPath",
                                          "name"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "workingDir": {
                                      "description": "Container's working directory.\nIf not specified, the container runtime's default will be used, which\nmight be configured in the container image.\nCannot be updated.",
                                      "type": "string"
                                    }
                                  },
                                  "required": [
                                    "name"
                                  ],
                                  "type": "object"
                                },
                                "type": "array"
                              },
                              "dnsConfig": {
                                "description": "Specifies the DNS parameters of a pod.\nParameters specified here will be merged to the generated DNS\nconfiguration based on DNSPolicy.",
                                "properties": {
                                  "nameservers": {
                                    "description": "A list of DNS name server IP addresses.\nThis will be appended to the base nameservers generated from DNSPolicy.\nDuplicated nameservers will be removed.",
                                    "items": {
                                      "type": "string"
                                    },
                                    "type": "array"
                                  },
                                  "options": {
                                    "description": "A list of DNS resolver options.\nThis will be merged with the base options generated from DNSPolicy.\nDuplicated entries will be removed. Resolution options given in Options\nwill override those that appear in the base DNSPolicy.",
                                    "items": {
                                      "description": "PodDNSConfigOption defines DNS resolver options of a pod.",
                                      "properties": {
                                        "name": {
                                          "description": "Required.",
                                          "type": "string"
                                        },
                                        "value": {
                                          "type": "string"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "type": "array"
                                  },
                                  "searches": {
                                    "description": "A list of DNS search domains for host-name lookup.\nThis will be appended to the base search paths generated from DNSPolicy.\nDuplicated search paths will be removed.",
                                    "items": {
                                      "type": "string"
                                    },
                                    "type": "array"
                                  }
                                },
                                "type": "object"
                              },
                              "dnsPolicy": {
                                "description": "Set DNS policy for the pod.\nDefaults to \"ClusterFirst\".\nValid values are 'ClusterFirstWithHostNet', 'ClusterFirst', 'Default' or 'None'.\nDNS parameters given in DNSConfig will be merged with the policy selected with DNSPolicy.\nTo have DNS options set along with hostNetwork, you have to specify DNS policy\nexplicitly to 'ClusterFirstWithHostNet'.",
                                "type": "string"
                              },
                              "enableServiceLinks": {
                                "description": "EnableServiceLinks indicates whether information about services should be injected into pod's\nenvironment variables, matching the syntax of Docker links.\nOptional: Defaults to true.",
                                "type": "boolean"
                              },
                              "ephemeralContainers": {
                                "description": "List of ephemeral containers run in this pod. Ephemeral containers may be run in an existing\npod to perform user-initiated actions such as debugging. This list cannot be specified when\ncreating a pod, and it cannot be modified by updating the pod spec. In order to add an\nephemeral container to an existing pod, use the pod's ephemeralcontainers subresource.",
                                "items": {
                                  "description": "An EphemeralContainer is a temporary container that you may add to an existing Pod for\nuser-initiated activities such as debugging. Ephemeral containers have no resource or\nscheduling guarantees, and they will not be restarted when they exit or when a Pod is\nremoved or restarted. The kubelet may evict a Pod if an ephemeral container causes the\nPod to exceed its resource allocation.\n\n\nTo add an ephemeral container, use the ephemeralcontainers subresource of an existing\nPod. Ephemeral containers may not be removed or restarted.",
                                  "properties": {
                                    "args": {
                                      "description": "Arguments to the entrypoint.\nThe image's CMD is used if this is not provided.\nVariable references $(VAR_NAME) are expanded using the container's environment. If a variable\ncannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced\nto a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. \"$$(VAR_NAME)\" will\nproduce the string literal \"$(VAR_NAME)\". Escaped references will never be expanded, regardless\nof whether the variable exists or not. Cannot be updated.\nMore info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell",
                                      "items": {
                                        "type": "string"
                                      },
                                      "type": "array"
                                    },
                                    "command": {
                                      "description": "Entrypoint array. Not executed within a shell.\nThe image's ENTRYPOINT is used if this is not provided.\nVariable references $(VAR_NAME) are expanded using the container's environment. If a variable\ncannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced\nto a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. \"$$(VAR_NAME)\" will\nproduce the string literal \"$(VAR_NAME)\". Escaped references will never be expanded, regardless\nof whether the variable exists or not. Cannot be updated.\nMore info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell",
                                      "items": {
                                        "type": "string"
                                      },
                                      "type": "array"
                                    },
                                    "env": {
                                      "description": "List of environment variables to set in the container.\nCannot be updated.",
                                      "items": {
                                        "description": "EnvVar represents an environment variable present in a Container.",
                                        "properties": {
                                          "name": {
                                            "description": "Name of the environment variable. Must be a C_IDENTIFIER.",
                                            "type": "string"
                                          },
                                          "value": {
                                            "description": "Variable references $(VAR_NAME) are expanded\nusing the previously defined environment variables in the container and\nany service environment variables. If a variable cannot be resolved,\nthe reference in the input string will be unchanged. Double $$ are reduced\nto a single $, which allows for escaping the $(VAR_NAME) syntax: i.e.\n\"$$(VAR_NAME)\" will produce the string literal \"$(VAR_NAME)\".\nEscaped references will never be expanded, regardless of whether the variable\nexists or not.\nDefaults to \"\".",
                                            "type": "string"
                                          },
                                          "valueFrom": {
                                            "description": "Source for the environment variable's value. Cannot be used if value is not empty.",
                                            "properties": {
                                              "configMapKeyRef": {
                                                "description": "Selects a key of a ConfigMap.",
                                                "properties": {
                                                  "key": {
                                                    "description": "The key to select.",
                                                    "type": "string"
                                                  },
                                                  "name": {
                                                    "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                    "type": "string"
                                                  },
                                                  "optional": {
                                                    "description": "Specify whether the ConfigMap or its key must be defined",
                                                    "type": "boolean"
                                                  }
                                                },
                                                "required": [
                                                  "key"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "fieldRef": {
                                                "description": "Selects a field of the pod: supports metadata.name, metadata.namespace, `metadata.labels['\u003cKEY\u003e']`, `metadata.annotations['\u003cKEY\u003e']`,\nspec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs.",
                                                "properties": {
                                                  "apiVersion": {
                                                    "description": "Version of the schema the FieldPath is written in terms of, defaults to \"v1\".",
                                                    "type": "string"
                                                  },
                                                  "fieldPath": {
                                                    "description": "Path of the field to select in the specified API version.",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "fieldPath"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "resourceFieldRef": {
                                                "description": "Selects a resource of the container: only resources limits and requests\n(limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported.",
                                                "properties": {
                                                  "containerName": {
                                                    "description": "Container name: required for volumes, optional for env vars",
                                                    "type": "string"
                                                  },
                                                  "divisor": {
                                                    "anyOf": [
                                                      {
                                                        "type": "integer"
                                                      },
                                                      {
                                                        "type": "string"
                                                      }
                                                    ],
                                                    "description": "Specifies the output format of the exposed resources, defaults to \"1\"",
                                                    "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                    "x-kubernetes-int-or-string": true
                                                  },
                                                  "resource": {
                                                    "description": "Required: resource to select",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "resource"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "secretKeyRef": {
                                                "description": "Selects a key of a secret in the pod's namespace",
                                                "properties": {
                                                  "key": {
                                                    "description": "The key of the secret to select from.  Must be a valid secret key.",
                                                    "type": "string"
                                                  },
                                                  "name": {
                                                    "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                    "type": "string"
                                                  },
                                                  "optional": {
                                                    "description": "Specify whether the Secret or its key must be defined",
                                                    "type": "boolean"
                                                  }
                                                },
                                                "required": [
                                                  "key"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              }
                                            },
                                            "type": "object"
                                          }
                                        },
                                        "required": [
                                          "name"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "envFrom": {
                                      "description": "List of sources to populate environment variables in the container.\nThe keys defined within a source must be a C_IDENTIFIER. All invalid keys\nwill be reported as an event when the container is starting. When a key exists in multiple\nsources, the value associated with the last source will take precedence.\nValues defined by an Env with a duplicate key will take precedence.\nCannot be updated.",
                                      "items": {
                                        "description": "EnvFromSource represents the source of a set of ConfigMaps",
                                        "properties": {
                                          "configMapRef": {
                                            "description": "The ConfigMap to select from",
                                            "properties": {
                                              "name": {
                                                "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                "type": "string"
                                              },
                                              "optional": {
                                                "description": "Specify whether the ConfigMap must be defined",
                                                "type": "boolean"
                                              }
                                            },
                                            "type": "object",
                                            "x-kubernetes-map-type": "atomic"
                                          },
                                          "prefix": {
                                            "description": "An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER.",
                                            "type": "string"
                                          },
                                          "secretRef": {
                                            "description": "The Secret to select from",
                                            "properties": {
                                              "name": {
                                                "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                "type": "string"
                                              },
                                              "optional": {
                                                "description": "Specify whether the Secret must be defined",
                                                "type": "boolean"
                                              }
                                            },
                                            "type": "object",
                                            "x-kubernetes-map-type": "atomic"
                                          }
                                        },
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "image": {
                                      "description": "Container image name.\nMore info: https://kubernetes.io/docs/concepts/containers/images",
                                      "type": "string"
                                    },
                                    "imagePullPolicy": {
                                      "description": "Image pull policy.\nOne of Always, Never, IfNotPresent.\nDefaults to Always if :latest tag is specified, or IfNotPresent otherwise.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/containers/images#updating-images",
                                      "type": "string"
                                    },
                                    "lifecycle": {
                                      "description": "Lifecycle is not allowed for ephemeral containers.",
                                      "properties": {
                                        "postStart": {
                                          "description": "PostStart is called immediately after a container is created. If the handler fails,\nthe container is terminated and restarted according to its restart policy.\nOther management of the container blocks until the hook completes.\nMore info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks",
                                          "properties": {
                                            "exec": {
                                              "description": "Exec specifies the action to take.",
                                              "properties": {
                                                "command": {
                                                  "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                                  "items": {
                                                    "type": "string"
                                                  },
                                                  "type": "array"
                                                }
                                              },
                                              "type": "object"
                                            },
                                            "httpGet": {
                                              "description": "HTTPGet specifies the http request to perform.",
                                              "properties": {
                                                "host": {
                                                  "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                                  "type": "string"
                                                },
                                                "httpHeaders": {
                                                  "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                                  "items": {
                                                    "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                    "properties": {
                                                      "name": {
                                                        "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                        "type": "string"
                                                      },
                                                      "value": {
                                                        "description": "The header field value",
                                                        "type": "string"
                                                      }
                                                    },
                                                    "required": [
                                                      "name",
                                                      "value"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "path": {
                                                  "description": "Path to access on the HTTP server.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                  "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                                  "type": "string"
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            },
                                            "tcpSocket": {
                                              "description": "Deprecated. TCPSocket is NOT supported as a LifecycleHandler and kept\nfor the backward compatibility. There are no validation of this field and\nlifecycle hooks will fail in runtime when tcp handler is specified.",
                                              "properties": {
                                                "host": {
                                                  "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "preStop": {
                                          "description": "PreStop is called immediately before a container is terminated due to an\nAPI request or management event such as liveness/startup probe failure,\npreemption, resource contention, etc. The handler is not called if the\ncontainer crashes or exits. The Pod's termination grace period countdown begins before the\nPreStop hook is executed. Regardless of the outcome of the handler, the\ncontainer will eventually terminate within the Pod's termination grace\nperiod (unless delayed by finalizers). Other management of the container blocks until the hook completes\nor until the termination grace period is reached.\nMore info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks",
                                          "properties": {
                                            "exec": {
                                              "description": "Exec specifies the action to take.",
                                              "properties": {
                                                "command": {
                                                  "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                                  "items": {
                                                    "type": "string"
                                                  },
                                                  "type": "array"
                                                }
                                              },
                                              "type": "object"
                                            },
                                            "httpGet": {
                                              "description": "HTTPGet specifies the http request to perform.",
                                              "properties": {
                                                "host": {
                                                  "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                                  "type": "string"
                                                },
                                                "httpHeaders": {
                                                  "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                                  "items": {
                                                    "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                    "properties": {
                                                      "name": {
                                                        "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                        "type": "string"
                                                      },
                                                      "value": {
                                                        "description": "The header field value",
                                                        "type": "string"
                                                      }
                                                    },
                                                    "required": [
                                                      "name",
                                                      "value"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "path": {
                                                  "description": "Path to access on the HTTP server.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                  "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                                  "type": "string"
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            },
                                            "tcpSocket": {
                                              "description": "Deprecated. TCPSocket is NOT supported as a LifecycleHandler and kept\nfor the backward compatibility. There are no validation of this field and\nlifecycle hooks will fail in runtime when tcp handler is specified.",
                                              "properties": {
                                                "host": {
                                                  "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            }
                                          },
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "livenessProbe": {
                                      "description": "Probes are not allowed for ephemeral containers.",
                                      "properties": {
                                        "exec": {
                                          "description": "Exec specifies the action to take.",
                                          "properties": {
                                            "command": {
                                              "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "failureThreshold": {
                                          "description": "Minimum consecutive failures for the probe to be considered failed after having succeeded.\nDefaults to 3. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "grpc": {
                                          "description": "GRPC specifies an action involving a GRPC port.",
                                          "properties": {
                                            "port": {
                                              "description": "Port number of the gRPC service. Number must be in the range 1 to 65535.",
                                              "format": "int32",
                                              "type": "integer"
                                            },
                                            "service": {
                                              "description": "Service is the name of the service to place in the gRPC HealthCheckRequest\n(see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).\n\n\nIf this is not specified, the default behavior is defined by gRPC.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "httpGet": {
                                          "description": "HTTPGet specifies the http request to perform.",
                                          "properties": {
                                            "host": {
                                              "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                              "type": "string"
                                            },
                                            "httpHeaders": {
                                              "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                              "items": {
                                                "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                "properties": {
                                                  "name": {
                                                    "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                    "type": "string"
                                                  },
                                                  "value": {
                                                    "description": "The header field value",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "name",
                                                  "value"
                                                ],
                                                "type": "object"
                                              },
                                              "type": "array"
                                            },
                                            "path": {
                                              "description": "Path to access on the HTTP server.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                              "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                          "description": "Number of seconds after the container has started before liveness probes are initiated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "periodSeconds": {
                                          "description": "How often (in seconds) to perform the probe.\nDefault to 10 seconds. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "successThreshold": {
                                          "description": "Minimum consecutive successes for the probe to be considered successful after having failed.\nDefaults to 1. Must be 1 for liveness and startup. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpSocket": {
                                          "description": "TCPSocket specifies an action involving a TCP port.",
                                          "properties": {
                                            "host": {
                                              "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "terminationGracePeriodSeconds": {
                                          "description": "Optional duration in seconds the pod needs to terminate gracefully upon probe failure.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nIf this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this\nvalue overrides the value provided by the pod spec.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nThis is a beta field and requires enabling ProbeTerminationGracePeriod feature gate.\nMinimum value is 1. spec.terminationGracePeriodSeconds is used if unset.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "timeoutSeconds": {
                                          "description": "Number of seconds after which the probe times out.\nDefaults to 1 second. Minimum value is 1.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "name": {
                                      "description": "Name of the ephemeral container specified as a DNS_LABEL.\nThis name must be unique among all containers, init containers and ephemeral containers.",
                                      "type": "string"
                                    },
                                    "ports": {
                                      "description": "Ports are not allowed for ephemeral containers.",
                                      "items": {
                                        "description": "ContainerPort represents a network port in a single container.",
                                        "properties": {
                                          "containerPort": {
                                            "description": "Number of port to expose on the pod's IP address.\nThis must be a valid port number, 0 \u003c x \u003c 65536.",
                                            "format": "int32",
                                            "type": "integer"
                                          },
                                          "hostIP": {
                                            "description": "What host IP to bind the external port to.",
                                            "type": "string"
                                          },
                                          "hostPort": {
                                            "description": "Number of port to expose on the host.\nIf specified, this must be a valid port number, 0 \u003c x \u003c 65536.\nIf HostNetwork is specified, this must match ContainerPort.\nMost containers do not need this.",
                                            "format": "int32",
                                            "type": "integer"
                                          },
                                          "name": {
                                            "description": "If specified, this must be an IANA_SVC_NAME and unique within the pod. Each\nnamed port in a pod must have a unique name. Name for the port that can be\nreferred to by services.",
                                            "type": "string"
                                          },
                                          "protocol": {
                                            "default": "TCP",
                                            "description": "Protocol for port. Must be UDP, TCP, or SCTP.\nDefaults to \"TCP\".",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "containerPort",
                                          "protocol"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array",
                                      "x-kubernetes-list-map-keys": [
                                        "containerPort",
                                        "protocol"
                                      ],
                                      "x-kubernetes-list-type": "map"
                                    },
                                    "readinessProbe": {
                                      "description": "Probes are not allowed for ephemeral containers.",
                                      "properties": {
                                        "exec": {
                                          "description": "Exec specifies the action to take.",
                                          "properties": {
                                            "command": {
                                              "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "failureThreshold": {
                                          "description": "Minimum consecutive failures for the probe to be considered failed after having succeeded.\nDefaults to 3. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "grpc": {
                                          "description": "GRPC specifies an action involving a GRPC port.",
                                          "properties": {
                                            "port": {
                                              "description": "Port number of the gRPC service. Number must be in the range 1 to 65535.",
                                              "format": "int32",
                                              "type": "integer"
                                            },
                                            "service": {
                                              "description": "Service is the name of the service to place in the gRPC HealthCheckRequest\n(see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).\n\n\nIf this is not specified, the default behavior is defined by gRPC.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "httpGet": {
                                          "description": "HTTPGet specifies the http request to perform.",
                                          "properties": {
                                            "host": {
                                              "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                              "type": "string"
                                            },
                                            "httpHeaders": {
                                              "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                              "items": {
                                                "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                "properties": {
                                                  "name": {
                                                    "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                    "type": "string"
                                                  },
                                                  "value": {
                                                    "description": "The header field value",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "name",
                                                  "value"
                                                ],
                                                "type": "object"
                                              },
                                              "type": "array"
                                            },
                                            "path": {
                                              "description": "Path to access on the HTTP server.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                              "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                          "description": "Number of seconds after the container has started before liveness probes are initiated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "periodSeconds": {
                                          "description": "How often (in seconds) to perform the probe.\nDefault to 10 seconds. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "successThreshold": {
                                          "description": "Minimum consecutive successes for the probe to be considered successful after having failed.\nDefaults to 1. Must be 1 for liveness and startup. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpSocket": {
                                          "description": "TCPSocket specifies an action involving a TCP port.",
                                          "properties": {
                                            "host": {
                                              "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "terminationGracePeriodSeconds": {
                                          "description": "Optional duration in seconds the pod needs to terminate gracefully upon probe failure.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nIf this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this\nvalue overrides the value provided by the pod spec.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nThis is a beta field and requires enabling ProbeTerminationGracePeriod feature gate.\nMinimum value is 1. spec.terminationGracePeriodSeconds is used if unset.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "timeoutSeconds": {
                                          "description": "Number of seconds after which the probe times out.\nDefaults to 1 second. Minimum value is 1.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "resizePolicy": {
                                      "description": "Resources resize policy for the container.",
                                      "items": {
                                        "description": "ContainerResizePolicy represents resource resize policy for the container.",
                                        "properties": {
                                          "resourceName": {
                                            "description": "Name of the resource to which this resource resize policy applies.\nSupported values: cpu, memory.",
                                            "type": "string"
                                          },
                                          "restartPolicy": {
                                            "description": "Restart policy to apply when specified resource is resized.\nIf not specified, it defaults to NotRequired.",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "resourceName",
                                          "restartPolicy"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array",
                                      "x-kubernetes-list-type": "atomic"
                                    },
                                    "resources": {
                                      "description": "Resources are not allowed for ephemeral containers. Ephemeral containers use spare resources\nalready allocated to the pod.",
                                      "properties": {
                                        "claims": {
                                          "description": "Claims lists the names of resources, defined in spec.resourceClaims,\nthat are used by this container.\n\n\nThis is an alpha field and requires enabling the\nDynamicResourceAllocation feature gate.\n\n\nThis field is immutable. It can only be set for containers.",
                                          "items": {
                                            "description": "ResourceClaim references one entry in PodSpec.ResourceClaims.",
                                            "properties": {
                                              "name": {
                                                "description": "Name must match the name of one entry in pod.spec.resourceClaims of\nthe Pod where this field is used. It makes that resource available\ninside a container.",
                                                "type": "string"
                                              }
                                            },
                                            "required": [
                                              "name"
                                            ],
                                            "type": "object"
                                          },
                                          "type": "array",
                                          "x-kubernetes-list-map-keys": [
                                            "name"
                                          ],
                                          "x-kubernetes-list-type": "map"
                                        },
                                        "limits": {
                                          "additionalProperties": {
                                            "anyOf": [
                                              {
                                                "type": "integer"
                                              },
                                              {
                                                "type": "string"
                                              }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                          },
                                          "description": "Limits describes the maximum amount of compute resources allowed.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                          "type": "object"
                                        },
                                        "requests": {
                                          "additionalProperties": {
                                            "anyOf": [
                                              {
                                                "type": "integer"
                                              },
                                              {
                                                "type": "string"
                                              }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                          },
                                          "description": "Requests describes the minimum amount of compute resources required.\nIf Requests is omitted for a container, it defaults to Limits if that is explicitly specified,\notherwise to an implementation-defined value. Requests cannot exceed Limits.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "restartPolicy": {
                                      "description": "Restart policy for the container to manage the restart behavior of each\ncontainer within a pod.\nThis may only be set for init containers. You cannot set this field on\nephemeral containers.",
                                      "type": "string"
                                    },
                                    "securityContext": {
                                      "description": "Optional: SecurityContext defines the security options the ephemeral container should be run with.\nIf set, the fields of SecurityContext override the equivalent fields of PodSecurityContext.",
                                      "properties": {
                                        "allowPrivilegeEscalation": {
                                          "description": "AllowPrivilegeEscalation controls whether a process can gain more\nprivileges than its parent process. This bool directly controls if\nthe no_new_privs flag will be set on the container process.\nAllowPrivilegeEscalation is true always when the container is:\n1) run as Privileged\n2) has CAP_SYS_ADMIN\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "boolean"
                                        },
                                        "capabilities": {
                                          "description": "The capabilities to add/drop when running containers.\nDefaults to the default set of capabilities granted by the container runtime.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "properties": {
                                            "add": {
                                              "description": "Added capabilities",
                                              "items": {
                                                "description": "Capability represent POSIX capabilities type",
                                                "type": "string"
                                              },
                                              "type": "array"
                                            },
                                            "drop": {
                                              "description": "Removed capabilities",
                                              "items": {
                                                "description": "Capability represent POSIX capabilities type",
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "privileged": {
                                          "description": "Run container in privileged mode.\nProcesses in privileged containers are essentially equivalent to root on the host.\nDefaults to false.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "boolean"
                                        },
                                        "procMount": {
                                          "description": "procMount denotes the type of proc mount to use for the containers.\nThe default is DefaultProcMount which uses the container runtime defaults for\nreadonly paths and masked paths.\nThis requires the ProcMountType feature flag to be enabled.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "string"
                                        },
                                        "readOnlyRootFilesystem": {
                                          "description": "Whether this container has a read-only root filesystem.\nDefault is false.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "boolean"
                                        },
                                        "runAsGroup": {
                                          "description": "The GID to run the entrypoint of the container process.\nUses runtime default if unset.\nMay also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "runAsNonRoot": {
                                          "description": "Indicates that the container must run as a non-root user.\nIf true, the Kubelet will validate the image at runtime to ensure that it\ndoes not run as UID 0 (root) and fail to start the container if it does.\nIf unset or false, no such validation will be performed.\nMay also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.",
                                          "type": "boolean"
                                        },
                                        "runAsUser": {
                                          "description": "The UID to run the entrypoint of the container process.\nDefaults to user specified in image metadata if unspecified.\nMay also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "seLinuxOptions": {
                                          "description": "The SELinux context to be applied to the container.\nIf unspecified, the container runtime will allocate a random SELinux context for each\ncontainer.  May also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "properties": {
                                            "level": {
                                              "description": "Level is SELinux level label that applies to the container.",
                                              "type": "string"
                                            },
                                            "role": {
                                              "description": "Role is a SELinux role label that applies to the container.",
                                              "type": "string"
                                            },
                                            "type": {
                                              "description": "Type is a SELinux type label that applies to the container.",
                                              "type": "string"
                                            },
                                            "user": {
                                              "description": "User is a SELinux user label that applies to the container.",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "seccompProfile": {
                                          "description": "The seccomp options to use by this container. If seccomp options are\nprovided at both the pod \u0026 container level, the container options\noverride the pod options.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "properties": {
                                            "localhostProfile": {
                                              "description": "localhostProfile indicates a profile defined in a file on the node should be used.\nThe profile must be preconfigured on the node to work.\nMust be a descending path, relative to the kubelet's configured seccomp profile location.\nMust be set if type is \"Localhost\". Must NOT be set for any other type.",
                                              "type": "string"
                                            },
                                            "type": {
                                              "description": "type indicates which kind of seccomp profile will be applied.\nValid options are:\n\n\nLocalhost - a profile defined in a file on the node should be used.\nRuntimeDefault - the container runtime default profile should be used.\nUnconfined - no profile should be applied.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "type"
                                          ],
                                          "type": "object"
                                        },
                                        "windowsOptions": {
                                          "description": "The Windows specific settings applied to all containers.\nIf unspecified, the options from the PodSecurityContext will be used.\nIf set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is linux.",
                                          "properties": {
                                            "gmsaCredentialSpec": {
                                              "description": "GMSACredentialSpec is where the GMSA admission webhook\n(https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the\nGMSA credential spec named by the GMSACredentialSpecName field.",
                                              "type": "string"
                                            },
                                            "gmsaCredentialSpecName": {
                                              "description": "GMSACredentialSpecName is the name of the GMSA credential spec to use.",
                                              "type": "string"
                                            },
                                            "hostProcess": {
                                              "description": "HostProcess determines if a container should be run as a 'Host Process' container.\nAll of a Pod's containers must have the same effective HostProcess value\n(it is not allowed to have a mix of HostProcess containers and non-HostProcess containers).\nIn addition, if HostProcess is true then HostNetwork must also be set to true.",
                                              "type": "boolean"
                                            },
                                            "runAsUserName": {
                                              "description": "The UserName in Windows to run the entrypoint of the container process.\nDefaults to the user specified in image metadata if unspecified.\nMay also be set in PodSecurityContext. If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "startupProbe": {
                                      "description": "Probes are not allowed for ephemeral containers.",
                                      "properties": {
                                        "exec": {
                                          "description": "Exec specifies the action to take.",
                                          "properties": {
                                            "command": {
                                              "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "failureThreshold": {
                                          "description": "Minimum consecutive failures for the probe to be considered failed after having succeeded.\nDefaults to 3. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "grpc": {
                                          "description": "GRPC specifies an action involving a GRPC port.",
                                          "properties": {
                                            "port": {
                                              "description": "Port number of the gRPC service. Number must be in the range 1 to 65535.",
                                              "format": "int32",
                                              "type": "integer"
                                            },
                                            "service": {
                                              "description": "Service is the name of the service to place in the gRPC HealthCheckRequest\n(see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).\n\n\nIf this is not specified, the default behavior is defined by gRPC.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "httpGet": {
                                          "description": "HTTPGet specifies the http request to perform.",
                                          "properties": {
                                            "host": {
                                              "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                              "type": "string"
                                            },
                                            "httpHeaders": {
                                              "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                              "items": {
                                                "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                "properties": {
                                                  "name": {
                                                    "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                    "type": "string"
                                                  },
                                                  "value": {
                                                    "description": "The header field value",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "name",
                                                  "value"
                                                ],
                                                "type": "object"
                                              },
                                              "type": "array"
                                            },
                                            "path": {
                                              "description": "Path to access on the HTTP server.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                              "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                          "description": "Number of seconds after the container has started before liveness probes are initiated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "periodSeconds": {
                                          "description": "How often (in seconds) to perform the probe.\nDefault to 10 seconds. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "successThreshold": {
                                          "description": "Minimum consecutive successes for the probe to be considered successful after having failed.\nDefaults to 1. Must be 1 for liveness and startup. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpSocket": {
                                          "description": "TCPSocket specifies an action involving a TCP port.",
                                          "properties": {
                                            "host": {
                                              "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "terminationGracePeriodSeconds": {
                                          "description": "Optional duration in seconds the pod needs to terminate gracefully upon probe failure.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nIf this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this\nvalue overrides the value provided by the pod spec.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nThis is a beta field and requires enabling ProbeTerminationGracePeriod feature gate.\nMinimum value is 1. spec.terminationGracePeriodSeconds is used if unset.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "timeoutSeconds": {
                                          "description": "Number of seconds after which the probe times out.\nDefaults to 1 second. Minimum value is 1.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "stdin": {
                                      "description": "Whether this container should allocate a buffer for stdin in the container runtime. If this\nis not set, reads from stdin in the container will always result in EOF.\nDefault is false.",
                                      "type": "boolean"
                                    },
                                    "stdinOnce": {
                                      "description": "Whether the container runtime should close the stdin channel after it has been opened by\na single attach. When stdin is true the stdin stream will remain open across multiple attach\nsessions. If stdinOnce is set to true, stdin is opened on container start, is empty until the\nfirst client attaches to stdin, and then remains open and accepts data until the client disconnects,\nat which time stdin is closed and remains closed until the container is restarted. If this\nflag is false, a container processes that reads from stdin will never receive an EOF.\nDefault is false",
                                      "type": "boolean"
                                    },
                                    "targetContainerName": {
                                      "description": "If set, the name of the container from PodSpec that this ephemeral container targets.\nThe ephemeral container will be run in the namespaces (IPC, PID, etc) of this container.\nIf not set then the ephemeral container uses the namespaces configured in the Pod spec.\n\n\nThe container runtime must implement support for this feature. If the runtime does not\nsupport namespace targeting then the result of setting this field is undefined.",
                                      "type": "string"
                                    },
                                    "terminationMessagePath": {
                                      "description": "Optional: Path at which the file to which the container's termination message\nwill be written is mounted into the container's filesystem.\nMessage written is intended to be brief final status, such as an assertion failure message.\nWill be truncated by the node if greater than 4096 bytes. The total message length across\nall containers will be limited to 12kb.\nDefaults to /dev/termination-log.\nCannot be updated.",
                                      "type": "string"
                                    },
                                    "terminationMessagePolicy": {
                                      "description": "Indicate how the termination message should be populated. File will use the contents of\nterminationMessagePath to populate the container status message on both success and failure.\nFallbackToLogsOnError will use the last chunk of container log output if the termination\nmessage file is empty and the container exited with an error.\nThe log output is limited to 2048 bytes or 80 lines, whichever is smaller.\nDefaults to File.\nCannot be updated.",
                                      "type": "string"
                                    },
                                    "tty": {
                                      "description": "Whether this container should allocate a TTY for itself, also requires 'stdin' to be true.\nDefault is false.",
                                      "type": "boolean"
                                    },
                                    "volumeDevices": {
                                      "description": "volumeDevices is the list of block devices to be used by the container.",
                                      "items": {
                                        "description": "volumeDevice describes a mapping of a raw block device within a container.",
                                        "properties": {
                                          "devicePath": {
                                            "description": "devicePath is the path inside of the container that the device will be mapped to.",
                                            "type": "string"
                                          },
                                          "name": {
                                            "description": "name must match the name of a persistentVolumeClaim in the pod",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "devicePath",
                                          "name"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "volumeMounts": {
                                      "description": "Pod volumes to mount into the container's filesystem. Subpath mounts are not allowed for ephemeral containers.\nCannot be updated.",
                                      "items": {
                                        "description": "VolumeMount describes a mounting of a Volume within a container.",
                                        "properties": {
                                          "mountPath": {
                                            "description": "Path within the container at which the volume should be mounted.  Must\nnot contain ':'.",
                                            "type": "string"
                                          },
                                          "mountPropagation": {
                                            "description": "mountPropagation determines how mounts are propagated from the host\nto container and the other way around.\nWhen not set, MountPropagationNone is used.\nThis field is beta in 1.10.",
                                            "type": "string"
                                          },
                                          "name": {
                                            "description": "This must match the Name of a Volume.",
                                            "type": "string"
                                          },
                                          "readOnly": {
                                            "description": "Mounted read-only if true, read-write otherwise (false or unspecified).\nDefaults to false.",
                                            "type": "boolean"
                                          },
                                          "subPath": {
                                            "description": "Path within the volume from which the container's volume should be mounted.\nDefaults to \"\" (volume's root).",
                                            "type": "string"
                                          },
                                          "subPathExpr": {
                                            "description": "Expanded path within the volume from which the container's volume should be mounted.\nBehaves similarly to SubPath but environment variable references $(VAR_NAME) are expanded using the container's environment.\nDefaults to \"\" (volume's root).\nSubPathExpr and SubPath are mutually exclusive.",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "mountPath",
                                          "name"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "workingDir": {
                                      "description": "Container's working directory.\nIf not specified, the container runtime's default will be used, which\nmight be configured in the container image.\nCannot be updated.",
                                      "type": "string"
                                    }
                                  },
                                  "required": [
                                    "name"
                                  ],
                                  "type": "object"
                                },
                                "type": "array"
                              },
                              "hostAliases": {
                                "description": "HostAliases is an optional list of hosts and IPs that will be injected into the pod's hosts\nfile if specified. This is only valid for non-hostNetwork pods.",
                                "items": {
                                  "description": "HostAlias holds the mapping between IP and hostnames that will be injected as an entry in the\npod's hosts file.",
                                  "properties": {
                                    "hostnames": {
                                      "description": "Hostnames for the above IP address.",
                                      "items": {
                                        "type": "string"
                                      },
                                      "type": "array"
                                    },
                                    "ip": {
                                      "description": "IP address of the host file entry.",
                                      "type": "string"
                                    }
                                  },
                                  "type": "object"
                                },
                                "type": "array"
                              },
                              "hostIPC": {
                                "description": "Use the host's ipc namespace.\nOptional: Default to false.",
                                "type": "boolean"
                              },
                              "hostNetwork": {
                                "description": "Host networking requested for this pod. Use the host's network namespace.\nIf this option is set, the ports that will be used must be specified.\nDefault to false.",
                                "type": "boolean"
                              },
                              "hostPID": {
                                "description": "Use the host's pid namespace.\nOptional: Default to false.",
                                "type": "boolean"
                              },
                              "hostUsers": {
                                "description": "Use the host's user namespace.\nOptional: Default to true.\nIf set to true or not present, the pod will be run in the host user namespace, useful\nfor when the pod needs a feature only available to the host user namespace, such as\nloading a kernel module with CAP_SYS_MODULE.\nWhen set to false, a new userns is created for the pod. Setting false is useful for\nmitigating container breakout vulnerabilities even allowing users to run their\ncontainers as root without actually having root privileges on the host.\nThis field is alpha-level and is only honored by servers that enable the UserNamespacesSupport feature.",
                                "type": "boolean"
                              },
                              "hostname": {
                                "description": "Specifies the hostname of the Pod\nIf not specified, the pod's hostname will be set to a system-defined value.",
                                "type": "string"
                              },
                              "imagePullSecrets": {
                                "description": "ImagePullSecrets is an optional list of references to secrets in the same namespace to use for pulling any of the images used by this PodSpec.\nIf specified, these secrets will be passed to individual puller implementations for them to use.\nMore info: https://kubernetes.io/docs/concepts/containers/images#specifying-imagepullsecrets-on-a-pod",
                                "items": {
                                  "description": "LocalObjectReference contains enough information to let you locate the\nreferenced object inside the same namespace.",
                                  "properties": {
                                    "name": {
                                      "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                      "type": "string"
                                    }
                                  },
                                  "type": "object",
                                  "x-kubernetes-map-type": "atomic"
                                },
                                "type": "array"
                              },
                              "initContainers": {
                                "description": "List of initialization containers belonging to the pod.\nInit containers are executed in order prior to containers being started. If any\ninit container fails, the pod is considered to have failed and is handled according\nto its restartPolicy. The name for an init container or normal container must be\nunique among all containers.\nInit containers may not have Lifecycle actions, Readiness probes, Liveness probes, or Startup probes.\nThe resourceRequirements of an init container are taken into account during scheduling\nby finding the highest request/limit for each resource type, and then using the max of\nof that value or the sum of the normal containers. Limits are applied to init containers\nin a similar fashion.\nInit containers cannot currently be added or removed.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/init-containers/",
                                "items": {
                                  "description": "A single application container that you want to run within a pod.",
                                  "properties": {
                                    "args": {
                                      "description": "Arguments to the entrypoint.\nThe container image's CMD is used if this is not provided.\nVariable references $(VAR_NAME) are expanded using the container's environment. If a variable\ncannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced\nto a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. \"$$(VAR_NAME)\" will\nproduce the string literal \"$(VAR_NAME)\". Escaped references will never be expanded, regardless\nof whether the variable exists or not. Cannot be updated.\nMore info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell",
                                      "items": {
                                        "type": "string"
                                      },
                                      "type": "array"
                                    },
                                    "command": {
                                      "description": "Entrypoint array. Not executed within a shell.\nThe container image's ENTRYPOINT is used if this is not provided.\nVariable references $(VAR_NAME) are expanded using the container's environment. If a variable\ncannot be resolved, the reference in the input string will be unchanged. Double $$ are reduced\nto a single $, which allows for escaping the $(VAR_NAME) syntax: i.e. \"$$(VAR_NAME)\" will\nproduce the string literal \"$(VAR_NAME)\". Escaped references will never be expanded, regardless\nof whether the variable exists or not. Cannot be updated.\nMore info: https://kubernetes.io/docs/tasks/inject-data-application/define-command-argument-container/#running-a-command-in-a-shell",
                                      "items": {
                                        "type": "string"
                                      },
                                      "type": "array"
                                    },
                                    "env": {
                                      "description": "List of environment variables to set in the container.\nCannot be updated.",
                                      "items": {
                                        "description": "EnvVar represents an environment variable present in a Container.",
                                        "properties": {
                                          "name": {
                                            "description": "Name of the environment variable. Must be a C_IDENTIFIER.",
                                            "type": "string"
                                          },
                                          "value": {
                                            "description": "Variable references $(VAR_NAME) are expanded\nusing the previously defined environment variables in the container and\nany service environment variables. If a variable cannot be resolved,\nthe reference in the input string will be unchanged. Double $$ are reduced\nto a single $, which allows for escaping the $(VAR_NAME) syntax: i.e.\n\"$$(VAR_NAME)\" will produce the string literal \"$(VAR_NAME)\".\nEscaped references will never be expanded, regardless of whether the variable\nexists or not.\nDefaults to \"\".",
                                            "type": "string"
                                          },
                                          "valueFrom": {
                                            "description": "Source for the environment variable's value. Cannot be used if value is not empty.",
                                            "properties": {
                                              "configMapKeyRef": {
                                                "description": "Selects a key of a ConfigMap.",
                                                "properties": {
                                                  "key": {
                                                    "description": "The key to select.",
                                                    "type": "string"
                                                  },
                                                  "name": {
                                                    "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                    "type": "string"
                                                  },
                                                  "optional": {
                                                    "description": "Specify whether the ConfigMap or its key must be defined",
                                                    "type": "boolean"
                                                  }
                                                },
                                                "required": [
                                                  "key"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "fieldRef": {
                                                "description": "Selects a field of the pod: supports metadata.name, metadata.namespace, `metadata.labels['\u003cKEY\u003e']`, `metadata.annotations['\u003cKEY\u003e']`,\nspec.nodeName, spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs.",
                                                "properties": {
                                                  "apiVersion": {
                                                    "description": "Version of the schema the FieldPath is written in terms of, defaults to \"v1\".",
                                                    "type": "string"
                                                  },
                                                  "fieldPath": {
                                                    "description": "Path of the field to select in the specified API version.",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "fieldPath"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "resourceFieldRef": {
                                                "description": "Selects a resource of the container: only resources limits and requests\n(limits.cpu, limits.memory, limits.ephemeral-storage, requests.cpu, requests.memory and requests.ephemeral-storage) are currently supported.",
                                                "properties": {
                                                  "containerName": {
                                                    "description": "Container name: required for volumes, optional for env vars",
                                                    "type": "string"
                                                  },
                                                  "divisor": {
                                                    "anyOf": [
                                                      {
                                                        "type": "integer"
                                                      },
                                                      {
                                                        "type": "string"
                                                      }
                                                    ],
                                                    "description": "Specifies the output format of the exposed resources, defaults to \"1\"",
                                                    "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                    "x-kubernetes-int-or-string": true
                                                  },
                                                  "resource": {
                                                    "description": "Required: resource to select",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "resource"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "secretKeyRef": {
                                                "description": "Selects a key of a secret in the pod's namespace",
                                                "properties": {
                                                  "key": {
                                                    "description": "The key of the secret to select from.  Must be a valid secret key.",
                                                    "type": "string"
                                                  },
                                                  "name": {
                                                    "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                    "type": "string"
                                                  },
                                                  "optional": {
                                                    "description": "Specify whether the Secret or its key must be defined",
                                                    "type": "boolean"
                                                  }
                                                },
                                                "required": [
                                                  "key"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              }
                                            },
                                            "type": "object"
                                          }
                                        },
                                        "required": [
                                          "name"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "envFrom": {
                                      "description": "List of sources to populate environment variables in the container.\nThe keys defined within a source must be a C_IDENTIFIER. All invalid keys\nwill be reported as an event when the container is starting. When a key exists in multiple\nsources, the value associated with the last source will take precedence.\nValues defined by an Env with a duplicate key will take precedence.\nCannot be updated.",
                                      "items": {
                                        "description": "EnvFromSource represents the source of a set of ConfigMaps",
                                        "properties": {
                                          "configMapRef": {
                                            "description": "The ConfigMap to select from",
                                            "properties": {
                                              "name": {
                                                "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                "type": "string"
                                              },
                                              "optional": {
                                                "description": "Specify whether the ConfigMap must be defined",
                                                "type": "boolean"
                                              }
                                            },
                                            "type": "object",
                                            "x-kubernetes-map-type": "atomic"
                                          },
                                          "prefix": {
                                            "description": "An optional identifier to prepend to each key in the ConfigMap. Must be a C_IDENTIFIER.",
                                            "type": "string"
                                          },
                                          "secretRef": {
                                            "description": "The Secret to select from",
                                            "properties": {
                                              "name": {
                                                "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                "type": "string"
                                              },
                                              "optional": {
                                                "description": "Specify whether the Secret must be defined",
                                                "type": "boolean"
                                              }
                                            },
                                            "type": "object",
                                            "x-kubernetes-map-type": "atomic"
                                          }
                                        },
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "image": {
                                      "description": "Container image name.\nMore info: https://kubernetes.io/docs/concepts/containers/images\nThis field is optional to allow higher level config management to default or override\ncontainer images in workload controllers like Deployments and StatefulSets.",
                                      "type": "string"
                                    },
                                    "imagePullPolicy": {
                                      "description": "Image pull policy.\nOne of Always, Never, IfNotPresent.\nDefaults to Always if :latest tag is specified, or IfNotPresent otherwise.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/containers/images#updating-images",
                                      "type": "string"
                                    },
                                    "lifecycle": {
                                      "description": "Actions that the management system should take in response to container lifecycle events.\nCannot be updated.",
                                      "properties": {
                                        "postStart": {
                                          "description": "PostStart is called immediately after a container is created. If the handler fails,\nthe container is terminated and restarted according to its restart policy.\nOther management of the container blocks until the hook completes.\nMore info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks",
                                          "properties": {
                                            "exec": {
                                              "description": "Exec specifies the action to take.",
                                              "properties": {
                                                "command": {
                                                  "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                                  "items": {
                                                    "type": "string"
                                                  },
                                                  "type": "array"
                                                }
                                              },
                                              "type": "object"
                                            },
                                            "httpGet": {
                                              "description": "HTTPGet specifies the http request to perform.",
                                              "properties": {
                                                "host": {
                                                  "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                                  "type": "string"
                                                },
                                                "httpHeaders": {
                                                  "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                                  "items": {
                                                    "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                    "properties": {
                                                      "name": {
                                                        "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                        "type": "string"
                                                      },
                                                      "value": {
                                                        "description": "The header field value",
                                                        "type": "string"
                                                      }
                                                    },
                                                    "required": [
                                                      "name",
                                                      "value"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "path": {
                                                  "description": "Path to access on the HTTP server.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                  "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                                  "type": "string"
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            },
                                            "tcpSocket": {
                                              "description": "Deprecated. TCPSocket is NOT supported as a LifecycleHandler and kept\nfor the backward compatibility. There are no validation of this field and\nlifecycle hooks will fail in runtime when tcp handler is specified.",
                                              "properties": {
                                                "host": {
                                                  "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "preStop": {
                                          "description": "PreStop is called immediately before a container is terminated due to an\nAPI request or management event such as liveness/startup probe failure,\npreemption, resource contention, etc. The handler is not called if the\ncontainer crashes or exits. The Pod's termination grace period countdown begins before the\nPreStop hook is executed. Regardless of the outcome of the handler, the\ncontainer will eventually terminate within the Pod's termination grace\nperiod (unless delayed by finalizers). Other management of the container blocks until the hook completes\nor until the termination grace period is reached.\nMore info: https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/#container-hooks",
                                          "properties": {
                                            "exec": {
                                              "description": "Exec specifies the action to take.",
                                              "properties": {
                                                "command": {
                                                  "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                                  "items": {
                                                    "type": "string"
                                                  },
                                                  "type": "array"
                                                }
                                              },
                                              "type": "object"
                                            },
                                            "httpGet": {
                                              "description": "HTTPGet specifies the http request to perform.",
                                              "properties": {
                                                "host": {
                                                  "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                                  "type": "string"
                                                },
                                                "httpHeaders": {
                                                  "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                                  "items": {
                                                    "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                    "properties": {
                                                      "name": {
                                                        "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                        "type": "string"
                                                      },
                                                      "value": {
                                                        "description": "The header field value",
                                                        "type": "string"
                                                      }
                                                    },
                                                    "required": [
                                                      "name",
                                                      "value"
                                                    ],
                                                    "type": "object"
                                                  },
                                                  "type": "array"
                                                },
                                                "path": {
                                                  "description": "Path to access on the HTTP server.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                },
                                                "scheme": {
                                                  "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                                  "type": "string"
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            },
                                            "tcpSocket": {
                                              "description": "Deprecated. TCPSocket is NOT supported as a LifecycleHandler and kept\nfor the backward compatibility. There are no validation of this field and\nlifecycle hooks will fail in runtime when tcp handler is specified.",
                                              "properties": {
                                                "host": {
                                                  "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                                  "type": "string"
                                                },
                                                "port": {
                                                  "anyOf": [
                                                    {
                                                      "type": "integer"
                                                    },
                                                    {
                                                      "type": "string"
                                                    }
                                                  ],
                                                  "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                                  "x-kubernetes-int-or-string": true
                                                }
                                              },
                                              "required": [
                                                "port"
                                              ],
                                              "type": "object"
                                            }
                                          },
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "livenessProbe": {
                                      "description": "Periodic probe of container liveness.\nContainer will be restarted if the probe fails.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                      "properties": {
                                        "exec": {
                                          "description": "Exec specifies the action to take.",
                                          "properties": {
                                            "command": {
                                              "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "failureThreshold": {
                                          "description": "Minimum consecutive failures for the probe to be considered failed after having succeeded.\nDefaults to 3. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "grpc": {
                                          "description": "GRPC specifies an action involving a GRPC port.",
                                          "properties": {
                                            "port": {
                                              "description": "Port number of the gRPC service. Number must be in the range 1 to 65535.",
                                              "format": "int32",
                                              "type": "integer"
                                            },
                                            "service": {
                                              "description": "Service is the name of the service to place in the gRPC HealthCheckRequest\n(see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).\n\n\nIf this is not specified, the default behavior is defined by gRPC.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "httpGet": {
                                          "description": "HTTPGet specifies the http request to perform.",
                                          "properties": {
                                            "host": {
                                              "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                              "type": "string"
                                            },
                                            "httpHeaders": {
                                              "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                              "items": {
                                                "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                "properties": {
                                                  "name": {
                                                    "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                    "type": "string"
                                                  },
                                                  "value": {
                                                    "description": "The header field value",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "name",
                                                  "value"
                                                ],
                                                "type": "object"
                                              },
                                              "type": "array"
                                            },
                                            "path": {
                                              "description": "Path to access on the HTTP server.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                              "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                          "description": "Number of seconds after the container has started before liveness probes are initiated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "periodSeconds": {
                                          "description": "How often (in seconds) to perform the probe.\nDefault to 10 seconds. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "successThreshold": {
                                          "description": "Minimum consecutive successes for the probe to be considered successful after having failed.\nDefaults to 1. Must be 1 for liveness and startup. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpSocket": {
                                          "description": "TCPSocket specifies an action involving a TCP port.",
                                          "properties": {
                                            "host": {
                                              "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "terminationGracePeriodSeconds": {
                                          "description": "Optional duration in seconds the pod needs to terminate gracefully upon probe failure.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nIf this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this\nvalue overrides the value provided by the pod spec.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nThis is a beta field and requires enabling ProbeTerminationGracePeriod feature gate.\nMinimum value is 1. spec.terminationGracePeriodSeconds is used if unset.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "timeoutSeconds": {
                                          "description": "Number of seconds after which the probe times out.\nDefaults to 1 second. Minimum value is 1.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "name": {
                                      "description": "Name of the container specified as a DNS_LABEL.\nEach container in a pod must have a unique name (DNS_LABEL).\nCannot be updated.",
                                      "type": "string"
                                    },
                                    "ports": {
                                      "description": "List of ports to expose from the container. Not specifying a port here\nDOES NOT prevent that port from being exposed. Any port which is\nlistening on the default \"0.0.0.0\" address inside a container will be\naccessible from the network.\nModifying this array with strategic merge patch may corrupt the data.\nFor more information See https://github.com/kubernetes/kubernetes/issues/108255.\nCannot be updated.",
                                      "items": {
                                        "description": "ContainerPort represents a network port in a single container.",
                                        "properties": {
                                          "containerPort": {
                                            "description": "Number of port to expose on the pod's IP address.\nThis must be a valid port number, 0 \u003c x \u003c 65536.",
                                            "format": "int32",
                                            "type": "integer"
                                          },
                                          "hostIP": {
                                            "description": "What host IP to bind the external port to.",
                                            "type": "string"
                                          },
                                          "hostPort": {
                                            "description": "Number of port to expose on the host.\nIf specified, this must be a valid port number, 0 \u003c x \u003c 65536.\nIf HostNetwork is specified, this must match ContainerPort.\nMost containers do not need this.",
                                            "format": "int32",
                                            "type": "integer"
                                          },
                                          "name": {
                                            "description": "If specified, this must be an IANA_SVC_NAME and unique within the pod. Each\nnamed port in a pod must have a unique name. Name for the port that can be\nreferred to by services.",
                                            "type": "string"
                                          },
                                          "protocol": {
                                            "default": "TCP",
                                            "description": "Protocol for port. Must be UDP, TCP, or SCTP.\nDefaults to \"TCP\".",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "containerPort",
                                          "protocol"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array",
                                      "x-kubernetes-list-map-keys": [
                                        "containerPort",
                                        "protocol"
                                      ],
                                      "x-kubernetes-list-type": "map"
                                    },
                                    "readinessProbe": {
                                      "description": "Periodic probe of container service readiness.\nContainer will be removed from service endpoints if the probe fails.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                      "properties": {
                                        "exec": {
                                          "description": "Exec specifies the action to take.",
                                          "properties": {
                                            "command": {
                                              "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "failureThreshold": {
                                          "description": "Minimum consecutive failures for the probe to be considered failed after having succeeded.\nDefaults to 3. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "grpc": {
                                          "description": "GRPC specifies an action involving a GRPC port.",
                                          "properties": {
                                            "port": {
                                              "description": "Port number of the gRPC service. Number must be in the range 1 to 65535.",
                                              "format": "int32",
                                              "type": "integer"
                                            },
                                            "service": {
                                              "description": "Service is the name of the service to place in the gRPC HealthCheckRequest\n(see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).\n\n\nIf this is not specified, the default behavior is defined by gRPC.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "httpGet": {
                                          "description": "HTTPGet specifies the http request to perform.",
                                          "properties": {
                                            "host": {
                                              "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                              "type": "string"
                                            },
                                            "httpHeaders": {
                                              "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                              "items": {
                                                "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                "properties": {
                                                  "name": {
                                                    "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                    "type": "string"
                                                  },
                                                  "value": {
                                                    "description": "The header field value",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "name",
                                                  "value"
                                                ],
                                                "type": "object"
                                              },
                                              "type": "array"
                                            },
                                            "path": {
                                              "description": "Path to access on the HTTP server.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                              "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                          "description": "Number of seconds after the container has started before liveness probes are initiated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "periodSeconds": {
                                          "description": "How often (in seconds) to perform the probe.\nDefault to 10 seconds. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "successThreshold": {
                                          "description": "Minimum consecutive successes for the probe to be considered successful after having failed.\nDefaults to 1. Must be 1 for liveness and startup. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpSocket": {
                                          "description": "TCPSocket specifies an action involving a TCP port.",
                                          "properties": {
                                            "host": {
                                              "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "terminationGracePeriodSeconds": {
                                          "description": "Optional duration in seconds the pod needs to terminate gracefully upon probe failure.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nIf this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this\nvalue overrides the value provided by the pod spec.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nThis is a beta field and requires enabling ProbeTerminationGracePeriod feature gate.\nMinimum value is 1. spec.terminationGracePeriodSeconds is used if unset.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "timeoutSeconds": {
                                          "description": "Number of seconds after which the probe times out.\nDefaults to 1 second. Minimum value is 1.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "resizePolicy": {
                                      "description": "Resources resize policy for the container.",
                                      "items": {
                                        "description": "ContainerResizePolicy represents resource resize policy for the container.",
                                        "properties": {
                                          "resourceName": {
                                            "description": "Name of the resource to which this resource resize policy applies.\nSupported values: cpu, memory.",
                                            "type": "string"
                                          },
                                          "restartPolicy": {
                                            "description": "Restart policy to apply when specified resource is resized.\nIf not specified, it defaults to NotRequired.",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "resourceName",
                                          "restartPolicy"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array",
                                      "x-kubernetes-list-type": "atomic"
                                    },
                                    "resources": {
                                      "description": "Compute Resources required by this container.\nCannot be updated.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                      "properties": {
                                        "claims": {
                                          "description": "Claims lists the names of resources, defined in spec.resourceClaims,\nthat are used by this container.\n\n\nThis is an alpha field and requires enabling the\nDynamicResourceAllocation feature gate.\n\n\nThis field is immutable. It can only be set for containers.",
                                          "items": {
                                            "description": "ResourceClaim references one entry in PodSpec.ResourceClaims.",
                                            "properties": {
                                              "name": {
                                                "description": "Name must match the name of one entry in pod.spec.resourceClaims of\nthe Pod where this field is used. It makes that resource available\ninside a container.",
                                                "type": "string"
                                              }
                                            },
                                            "required": [
                                              "name"
                                            ],
                                            "type": "object"
                                          },
                                          "type": "array",
                                          "x-kubernetes-list-map-keys": [
                                            "name"
                                          ],
                                          "x-kubernetes-list-type": "map"
                                        },
                                        "limits": {
                                          "additionalProperties": {
                                            "anyOf": [
                                              {
                                                "type": "integer"
                                              },
                                              {
                                                "type": "string"
                                              }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                          },
                                          "description": "Limits describes the maximum amount of compute resources allowed.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                          "type": "object"
                                        },
                                        "requests": {
                                          "additionalProperties": {
                                            "anyOf": [
                                              {
                                                "type": "integer"
                                              },
                                              {
                                                "type": "string"
                                              }
                                            ],
                                            "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                            "x-kubernetes-int-or-string": true
                                          },
                                          "description": "Requests describes the minimum amount of compute resources required.\nIf Requests is omitted for a container, it defaults to Limits if that is explicitly specified,\notherwise to an implementation-defined value. Requests cannot exceed Limits.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "restartPolicy": {
                                      "description": "RestartPolicy defines the restart behavior of individual containers in a pod.\nThis field may only be set for init containers, and the only allowed value is \"Always\".\nFor non-init containers or when this field is not specified,\nthe restart behavior is defined by the Pod's restart policy and the container type.\nSetting the RestartPolicy as \"Always\" for the init container will have the following effect:\nthis init container will be continually restarted on\nexit until all regular containers have terminated. Once all regular\ncontainers have completed, all init containers with restartPolicy \"Always\"\nwill be shut down. This lifecycle differs from normal init containers and\nis often referred to as a \"sidecar\" container. Although this init\ncontainer still starts in the init container sequence, it does not wait\nfor the container to complete before proceeding to the next init\ncontainer. Instead, the next init container starts immediately after this\ninit container is started, or after any startupProbe has successfully\ncompleted.",
                                      "type": "string"
                                    },
                                    "securityContext": {
                                      "description": "SecurityContext defines the security options the container should be run with.\nIf set, the fields of SecurityContext override the equivalent fields of PodSecurityContext.\nMore info: https://kubernetes.io/docs/tasks/configure-pod-container/security-context/",
                                      "properties": {
                                        "allowPrivilegeEscalation": {
                                          "description": "AllowPrivilegeEscalation controls whether a process can gain more\nprivileges than its parent process. This bool directly controls if\nthe no_new_privs flag will be set on the container process.\nAllowPrivilegeEscalation is true always when the container is:\n1) run as Privileged\n2) has CAP_SYS_ADMIN\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "boolean"
                                        },
                                        "capabilities": {
                                          "description": "The capabilities to add/drop when running containers.\nDefaults to the default set of capabilities granted by the container runtime.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "properties": {
                                            "add": {
                                              "description": "Added capabilities",
                                              "items": {
                                                "description": "Capability represent POSIX capabilities type",
                                                "type": "string"
                                              },
                                              "type": "array"
                                            },
                                            "drop": {
                                              "description": "Removed capabilities",
                                              "items": {
                                                "description": "Capability represent POSIX capabilities type",
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "privileged": {
                                          "description": "Run container in privileged mode.\nProcesses in privileged containers are essentially equivalent to root on the host.\nDefaults to false.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "boolean"
                                        },
                                        "procMount": {
                                          "description": "procMount denotes the type of proc mount to use for the containers.\nThe default is DefaultProcMount which uses the container runtime defaults for\nreadonly paths and masked paths.\nThis requires the ProcMountType feature flag to be enabled.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "string"
                                        },
                                        "readOnlyRootFilesystem": {
                                          "description": "Whether this container has a read-only root filesystem.\nDefault is false.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "type": "boolean"
                                        },
                                        "runAsGroup": {
                                          "description": "The GID to run the entrypoint of the container process.\nUses runtime default if unset.\nMay also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "runAsNonRoot": {
                                          "description": "Indicates that the container must run as a non-root user.\nIf true, the Kubelet will validate the image at runtime to ensure that it\ndoes not run as UID 0 (root) and fail to start the container if it does.\nIf unset or false, no such validation will be performed.\nMay also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.",
                                          "type": "boolean"
                                        },
                                        "runAsUser": {
                                          "description": "The UID to run the entrypoint of the container process.\nDefaults to user specified in image metadata if unspecified.\nMay also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "seLinuxOptions": {
                                          "description": "The SELinux context to be applied to the container.\nIf unspecified, the container runtime will allocate a random SELinux context for each\ncontainer.  May also be set in PodSecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "properties": {
                                            "level": {
                                              "description": "Level is SELinux level label that applies to the container.",
                                              "type": "string"
                                            },
                                            "role": {
                                              "description": "Role is a SELinux role label that applies to the container.",
                                              "type": "string"
                                            },
                                            "type": {
                                              "description": "Type is a SELinux type label that applies to the container.",
                                              "type": "string"
                                            },
                                            "user": {
                                              "description": "User is a SELinux user label that applies to the container.",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "seccompProfile": {
                                          "description": "The seccomp options to use by this container. If seccomp options are\nprovided at both the pod \u0026 container level, the container options\noverride the pod options.\nNote that this field cannot be set when spec.os.name is windows.",
                                          "properties": {
                                            "localhostProfile": {
                                              "description": "localhostProfile indicates a profile defined in a file on the node should be used.\nThe profile must be preconfigured on the node to work.\nMust be a descending path, relative to the kubelet's configured seccomp profile location.\nMust be set if type is \"Localhost\". Must NOT be set for any other type.",
                                              "type": "string"
                                            },
                                            "type": {
                                              "description": "type indicates which kind of seccomp profile will be applied.\nValid options are:\n\n\nLocalhost - a profile defined in a file on the node should be used.\nRuntimeDefault - the container runtime default profile should be used.\nUnconfined - no profile should be applied.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "type"
                                          ],
                                          "type": "object"
                                        },
                                        "windowsOptions": {
                                          "description": "The Windows specific settings applied to all containers.\nIf unspecified, the options from the PodSecurityContext will be used.\nIf set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is linux.",
                                          "properties": {
                                            "gmsaCredentialSpec": {
                                              "description": "GMSACredentialSpec is where the GMSA admission webhook\n(https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the\nGMSA credential spec named by the GMSACredentialSpecName field.",
                                              "type": "string"
                                            },
                                            "gmsaCredentialSpecName": {
                                              "description": "GMSACredentialSpecName is the name of the GMSA credential spec to use.",
                                              "type": "string"
                                            },
                                            "hostProcess": {
                                              "description": "HostProcess determines if a container should be run as a 'Host Process' container.\nAll of a Pod's containers must have the same effective HostProcess value\n(it is not allowed to have a mix of HostProcess containers and non-HostProcess containers).\nIn addition, if HostProcess is true then HostNetwork must also be set to true.",
                                              "type": "boolean"
                                            },
                                            "runAsUserName": {
                                              "description": "The UserName in Windows to run the entrypoint of the container process.\nDefaults to the user specified in image metadata if unspecified.\nMay also be set in PodSecurityContext. If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "startupProbe": {
                                      "description": "StartupProbe indicates that the Pod has successfully initialized.\nIf specified, no other probes are executed until this completes successfully.\nIf this probe fails, the Pod will be restarted, just as if the livenessProbe failed.\nThis can be used to provide different probe parameters at the beginning of a Pod's lifecycle,\nwhen it might take a long time to load data or warm a cache, than during steady-state operation.\nThis cannot be updated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                      "properties": {
                                        "exec": {
                                          "description": "Exec specifies the action to take.",
                                          "properties": {
                                            "command": {
                                              "description": "Command is the command line to execute inside the container, the working directory for the\ncommand  is root ('/') in the container's filesystem. The command is simply exec'd, it is\nnot run inside a shell, so traditional shell instructions ('|', etc) won't work. To use\na shell, you need to explicitly call out to that shell.\nExit status of 0 is treated as live/healthy and non-zero is unhealthy.",
                                              "items": {
                                                "type": "string"
                                              },
                                              "type": "array"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "failureThreshold": {
                                          "description": "Minimum consecutive failures for the probe to be considered failed after having succeeded.\nDefaults to 3. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "grpc": {
                                          "description": "GRPC specifies an action involving a GRPC port.",
                                          "properties": {
                                            "port": {
                                              "description": "Port number of the gRPC service. Number must be in the range 1 to 65535.",
                                              "format": "int32",
                                              "type": "integer"
                                            },
                                            "service": {
                                              "description": "Service is the name of the service to place in the gRPC HealthCheckRequest\n(see https://github.com/grpc/grpc/blob/master/doc/health-checking.md).\n\n\nIf this is not specified, the default behavior is defined by gRPC.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "httpGet": {
                                          "description": "HTTPGet specifies the http request to perform.",
                                          "properties": {
                                            "host": {
                                              "description": "Host name to connect to, defaults to the pod IP. You probably want to set\n\"Host\" in httpHeaders instead.",
                                              "type": "string"
                                            },
                                            "httpHeaders": {
                                              "description": "Custom headers to set in the request. HTTP allows repeated headers.",
                                              "items": {
                                                "description": "HTTPHeader describes a custom header to be used in HTTP probes",
                                                "properties": {
                                                  "name": {
                                                    "description": "The header field name.\nThis will be canonicalized upon output, so case-variant names will be understood as the same header.",
                                                    "type": "string"
                                                  },
                                                  "value": {
                                                    "description": "The header field value",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "name",
                                                  "value"
                                                ],
                                                "type": "object"
                                              },
                                              "type": "array"
                                            },
                                            "path": {
                                              "description": "Path to access on the HTTP server.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Name or number of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            },
                                            "scheme": {
                                              "description": "Scheme to use for connecting to the host.\nDefaults to HTTP.",
                                              "type": "string"
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "initialDelaySeconds": {
                                          "description": "Number of seconds after the container has started before liveness probes are initiated.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "periodSeconds": {
                                          "description": "How often (in seconds) to perform the probe.\nDefault to 10 seconds. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "successThreshold": {
                                          "description": "Minimum consecutive successes for the probe to be considered successful after having failed.\nDefaults to 1. Must be 1 for liveness and startup. Minimum value is 1.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpSocket": {
                                          "description": "TCPSocket specifies an action involving a TCP port.",
                                          "properties": {
                                            "host": {
                                              "description": "Optional: Host name to connect to, defaults to the pod IP.",
                                              "type": "string"
                                            },
                                            "port": {
                                              "anyOf": [
                                                {
                                                  "type": "integer"
                                                },
                                                {
                                                  "type": "string"
                                                }
                                              ],
                                              "description": "Number or name of the port to access on the container.\nNumber must be in the range 1 to 65535.\nName must be an IANA_SVC_NAME.",
                                              "x-kubernetes-int-or-string": true
                                            }
                                          },
                                          "required": [
                                            "port"
                                          ],
                                          "type": "object"
                                        },
                                        "terminationGracePeriodSeconds": {
                                          "description": "Optional duration in seconds the pod needs to terminate gracefully upon probe failure.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nIf this value is nil, the pod's terminationGracePeriodSeconds will be used. Otherwise, this\nvalue overrides the value provided by the pod spec.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nThis is a beta field and requires enabling ProbeTerminationGracePeriod feature gate.\nMinimum value is 1. spec.terminationGracePeriodSeconds is used if unset.",
                                          "format": "int64",
                                          "type": "integer"
                                        },
                                        "timeoutSeconds": {
                                          "description": "Number of seconds after which the probe times out.\nDefaults to 1 second. Minimum value is 1.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle#container-probes",
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "stdin": {
                                      "description": "Whether this container should allocate a buffer for stdin in the container runtime. If this\nis not set, reads from stdin in the container will always result in EOF.\nDefault is false.",
                                      "type": "boolean"
                                    },
                                    "stdinOnce": {
                                      "description": "Whether the container runtime should close the stdin channel after it has been opened by\na single attach. When stdin is true the stdin stream will remain open across multiple attach\nsessions. If stdinOnce is set to true, stdin is opened on container start, is empty until the\nfirst client attaches to stdin, and then remains open and accepts data until the client disconnects,\nat which time stdin is closed and remains closed until the container is restarted. If this\nflag is false, a container processes that reads from stdin will never receive an EOF.\nDefault is false",
                                      "type": "boolean"
                                    },
                                    "terminationMessagePath": {
                                      "description": "Optional: Path at which the file to which the container's termination message\nwill be written is mounted into the container's filesystem.\nMessage written is intended to be brief final status, such as an assertion failure message.\nWill be truncated by the node if greater than 4096 bytes. The total message length across\nall containers will be limited to 12kb.\nDefaults to /dev/termination-log.\nCannot be updated.",
                                      "type": "string"
                                    },
                                    "terminationMessagePolicy": {
                                      "description": "Indicate how the termination message should be populated. File will use the contents of\nterminationMessagePath to populate the container status message on both success and failure.\nFallbackToLogsOnError will use the last chunk of container log output if the termination\nmessage file is empty and the container exited with an error.\nThe log output is limited to 2048 bytes or 80 lines, whichever is smaller.\nDefaults to File.\nCannot be updated.",
                                      "type": "string"
                                    },
                                    "tty": {
                                      "description": "Whether this container should allocate a TTY for itself, also requires 'stdin' to be true.\nDefault is false.",
                                      "type": "boolean"
                                    },
                                    "volumeDevices": {
                                      "description": "volumeDevices is the list of block devices to be used by the container.",
                                      "items": {
                                        "description": "volumeDevice describes a mapping of a raw block device within a container.",
                                        "properties": {
                                          "devicePath": {
                                            "description": "devicePath is the path inside of the container that the device will be mapped to.",
                                            "type": "string"
                                          },
                                          "name": {
                                            "description": "name must match the name of a persistentVolumeClaim in the pod",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "devicePath",
                                          "name"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "volumeMounts": {
                                      "description": "Pod volumes to mount into the container's filesystem.\nCannot be updated.",
                                      "items": {
                                        "description": "VolumeMount describes a mounting of a Volume within a container.",
                                        "properties": {
                                          "mountPath": {
                                            "description": "Path within the container at which the volume should be mounted.  Must\nnot contain ':'.",
                                            "type": "string"
                                          },
                                          "mountPropagation": {
                                            "description": "mountPropagation determines how mounts are propagated from the host\nto container and the other way around.\nWhen not set, MountPropagationNone is used.\nThis field is beta in 1.10.",
                                            "type": "string"
                                          },
                                          "name": {
                                            "description": "This must match the Name of a Volume.",
                                            "type": "string"
                                          },
                                          "readOnly": {
                                            "description": "Mounted read-only if true, read-write otherwise (false or unspecified).\nDefaults to false.",
                                            "type": "boolean"
                                          },
                                          "subPath": {
                                            "description": "Path within the volume from which the container's volume should be mounted.\nDefaults to \"\" (volume's root).",
                                            "type": "string"
                                          },
                                          "subPathExpr": {
                                            "description": "Expanded path within the volume from which the container's volume should be mounted.\nBehaves similarly to SubPath but environment variable references $(VAR_NAME) are expanded using the container's environment.\nDefaults to \"\" (volume's root).\nSubPathExpr and SubPath are mutually exclusive.",
                                            "type": "string"
                                          }
                                        },
                                        "required": [
                                          "mountPath",
                                          "name"
                                        ],
                                        "type": "object"
                                      },
                                      "type": "array"
                                    },
                                    "workingDir": {
                                      "description": "Container's working directory.\nIf not specified, the container runtime's default will be used, which\nmight be configured in the container image.\nCannot be updated.",
                                      "type": "string"
                                    }
                                  },
                                  "required": [
                                    "name"
                                  ],
                                  "type": "object"
                                },
                                "type": "array"
                              },
                              "nodeName": {
                                "description": "NodeName is a request to schedule this pod onto a specific node. If it is non-empty,\nthe scheduler simply schedules this pod onto that node, assuming that it fits resource\nrequirements.",
                                "type": "string"
                              },
                              "nodeSelector": {
                                "additionalProperties": {
                                  "type": "string"
                                },
                                "description": "NodeSelector is a selector which must be true for the pod to fit on a node.\nSelector which must match a node's labels for the pod to be scheduled on that node.\nMore info: https://kubernetes.io/docs/concepts/configuration/assign-pod-node/",
                                "type": "object",
                                "x-kubernetes-map-type": "atomic"
                              },
                              "os": {
                                "description": "Specifies the OS of the containers in the pod.\nSome pod and container fields are restricted if this is set.\n\n\nIf the OS field is set to linux, the following fields must be unset:\n-securityContext.windowsOptions\n\n\nIf the OS field is set to windows, following fields must be unset:\n- spec.hostPID\n- spec.hostIPC\n- spec.hostUsers\n- spec.securityContext.seLinuxOptions\n- spec.securityContext.seccompProfile\n- spec.securityContext.fsGroup\n- spec.securityContext.fsGroupChangePolicy\n- spec.securityContext.sysctls\n- spec.shareProcessNamespace\n- spec.securityContext.runAsUser\n- spec.securityContext.runAsGroup\n- spec.securityContext.supplementalGroups\n- spec.containers[*].securityContext.seLinuxOptions\n- spec.containers[*].securityContext.seccompProfile\n- spec.containers[*].securityContext.capabilities\n- spec.containers[*].securityContext.readOnlyRootFilesystem\n- spec.containers[*].securityContext.privileged\n- spec.containers[*].securityContext.allowPrivilegeEscalation\n- spec.containers[*].securityContext.procMount\n- spec.containers[*].securityContext.runAsUser\n- spec.containers[*].securityContext.runAsGroup",
                                "properties": {
                                  "name": {
                                    "description": "Name is the name of the operating system. The currently supported values are linux and windows.\nAdditional value may be defined in future and can be one of:\nhttps://github.com/opencontainers/runtime-spec/blob/master/config.md#platform-specific-configuration\nClients should expect to handle additional values and treat unrecognized values in this field as os: null",
                                    "type": "string"
                                  }
                                },
                                "required": [
                                  "name"
                                ],
                                "type": "object"
                              },
                              "overhead": {
                                "additionalProperties": {
                                  "anyOf": [
                                    {
                                      "type": "integer"
                                    },
                                    {
                                      "type": "string"
                                    }
                                  ],
                                  "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                  "x-kubernetes-int-or-string": true
                                },
                                "description": "Overhead represents the resource overhead associated with running a pod for a given RuntimeClass.\nThis field will be autopopulated at admission time by the RuntimeClass admission controller. If\nthe RuntimeClass admission controller is enabled, overhead must not be set in Pod create requests.\nThe RuntimeClass admission controller will reject Pod create requests which have the overhead already\nset. If RuntimeClass is configured and selected in the PodSpec, Overhead will be set to the value\ndefined in the corresponding RuntimeClass, otherwise it will remain unset and treated as zero.\nMore info: https://git.k8s.io/enhancements/keps/sig-node/688-pod-overhead/README.md",
                                "type": "object"
                              },
                              "preemptionPolicy": {
                                "description": "PreemptionPolicy is the Policy for preempting pods with lower priority.\nOne of Never, PreemptLowerPriority.\nDefaults to PreemptLowerPriority if unset.",
                                "type": "string"
                              },
                              "priority": {
                                "description": "The priority value. Various system components use this field to find the\npriority of the pod. When Priority Admission Controller is enabled, it\nprevents users from setting this field. The admission controller populates\nthis field from PriorityClassName.\nThe higher the value, the higher the priority.",
                                "format": "int32",
                                "type": "integer"
                              },
                              "priorityClassName": {
                                "description": "If specified, indicates the pod's priority. \"system-node-critical\" and\n\"system-cluster-critical\" are two special keywords which indicate the\nhighest priorities with the former being the highest priority. Any other\nname must be defined by creating a PriorityClass object with that name.\nIf not specified, the pod priority will be default or zero if there is no\ndefault.",
                                "type": "string"
                              },
                              "readinessGates": {
                                "description": "If specified, all readiness gates will be evaluated for pod readiness.\nA pod is ready when all its containers are ready AND\nall conditions specified in the readiness gates have status equal to \"True\"\nMore info: https://git.k8s.io/enhancements/keps/sig-network/580-pod-readiness-gates",
                                "items": {
                                  "description": "PodReadinessGate contains the reference to a pod condition",
                                  "properties": {
                                    "conditionType": {
                                      "description": "ConditionType refers to a condition in the pod's condition list with matching type.",
                                      "type": "string"
                                    }
                                  },
                                  "required": [
                                    "conditionType"
                                  ],
                                  "type": "object"
                                },
                                "type": "array"
                              },
                              "resourceClaims": {
                                "description": "ResourceClaims defines which ResourceClaims must be allocated\nand reserved before the Pod is allowed to start. The resources\nwill be made available to those containers which consume them\nby name.\n\n\nThis is an alpha field and requires enabling the\nDynamicResourceAllocation feature gate.\n\n\nThis field is immutable.",
                                "items": {
                                  "description": "PodResourceClaim references exactly one ResourceClaim through a ClaimSource.\nIt adds a name to it that uniquely identifies the ResourceClaim inside the Pod.\nContainers that need access to the ResourceClaim reference it with this name.",
                                  "properties": {
                                    "name": {
                                      "description": "Name uniquely identifies this resource claim inside the pod.\nThis must be a DNS_LABEL.",
                                      "type": "string"
                                    },
                                    "source": {
                                      "description": "Source describes where to find the ResourceClaim.",
                                      "properties": {
                                        "resourceClaimName": {
                                          "description": "ResourceClaimName is the name of a ResourceClaim object in the same\nnamespace as this pod.",
                                          "type": "string"
                                        },
                                        "resourceClaimTemplateName": {
                                          "description": "ResourceClaimTemplateName is the name of a ResourceClaimTemplate\nobject in the same namespace as this pod.\n\n\nThe template will be used to create a new ResourceClaim, which will\nbe bound to this pod. When this pod is deleted, the ResourceClaim\nwill also be deleted. The pod name and resource name, along with a\ngenerated component, will be used to form a unique name for the\nResourceClaim, which will be recorded in pod.status.resourceClaimStatuses.\n\n\nThis field is immutable and no changes will be made to the\ncorresponding ResourceClaim by the control plane after creating the\nResourceClaim.",
                                          "type": "string"
                                        }
                                      },
                                      "type": "object"
                                    }
                                  },
                                  "required": [
                                    "name"
                                  ],
                                  "type": "object"
                                },
                                "type": "array",
                                "x-kubernetes-list-map-keys": [
                                  "name"
                                ],
                                "x-kubernetes-list-type": "map"
                              },
                              "restartPolicy": {
                                "description": "Restart policy for all containers within the pod.\nOne of Always, OnFailure, Never. In some contexts, only a subset of those values may be permitted.\nDefault to Always.\nMore info: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/#restart-policy",
                                "type": "string"
                              },
                              "runtimeClassName": {
                                "description": "RuntimeClassName refers to a RuntimeClass object in the node.k8s.io group, which should be used\nto run this pod.  If no RuntimeClass resource matches the named class, the pod will not be run.\nIf unset or empty, the \"legacy\" RuntimeClass will be used, which is an implicit class with an\nempty definition that uses the default runtime handler.\nMore info: https://git.k8s.io/enhancements/keps/sig-node/585-runtime-class",
                                "type": "string"
                              },
                              "schedulerName": {
                                "description": "If specified, the pod will be dispatched by specified scheduler.\nIf not specified, the pod will be dispatched by default scheduler.",
                                "type": "string"
                              },
                              "schedulingGates": {
                                "description": "SchedulingGates is an opaque list of values that if specified will block scheduling the pod.\nIf schedulingGates is not empty, the pod will stay in the SchedulingGated state and the\nscheduler will not attempt to schedule the pod.\n\n\nSchedulingGates can only be set at pod creation time, and be removed only afterwards.\n\n\nThis is a beta feature enabled by the PodSchedulingReadiness feature gate.",
                                "items": {
                                  "description": "PodSchedulingGate is associated to a Pod to guard its scheduling.",
                                  "properties": {
                                    "name": {
                                      "description": "Name of the scheduling gate.\nEach scheduling gate must have a unique name field.",
                                      "type": "string"
                                    }
                                  },
                                  "required": [
                                    "name"
                                  ],
                                  "type": "object"
                                },
                                "type": "array",
                                "x-kubernetes-list-map-keys": [
                                  "name"
                                ],
                                "x-kubernetes-list-type": "map"
                              },
                              "securityContext": {
                                "description": "SecurityContext holds pod-level security attributes and common container settings.\nOptional: Defaults to empty.  See type description for default values of each field.",
                                "properties": {
                                  "fsGroup": {
                                    "description": "A special supplemental group that applies to all containers in a pod.\nSome volume types allow the Kubelet to change the ownership of that volume\nto be owned by the pod:\n\n\n1. The owning GID will be the FSGroup\n2. The setgid bit is set (new files created in the volume will be owned by FSGroup)\n3. The permission bits are OR'd with rw-rw----\n\n\nIf unset, the Kubelet will not modify the ownership and permissions of any volume.\nNote that this field cannot be set when spec.os.name is windows.",
                                    "format": "int64",
                                    "type": "integer"
                                  },
                                  "fsGroupChangePolicy": {
                                    "description": "fsGroupChangePolicy defines behavior of changing ownership and permission of the volume\nbefore being exposed inside Pod. This field will only apply to\nvolume types which support fsGroup based ownership(and permissions).\nIt will have no effect on ephemeral volume types such as: secret, configmaps\nand emptydir.\nValid values are \"OnRootMismatch\" and \"Always\". If not specified, \"Always\" is used.\nNote that this field cannot be set when spec.os.name is windows.",
                                    "type": "string"
                                  },
                                  "runAsGroup": {
                                    "description": "The GID to run the entrypoint of the container process.\nUses runtime default if unset.\nMay also be set in SecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence\nfor that container.\nNote that this field cannot be set when spec.os.name is windows.",
                                    "format": "int64",
                                    "type": "integer"
                                  },
                                  "runAsNonRoot": {
                                    "description": "Indicates that the container must run as a non-root user.\nIf true, the Kubelet will validate the image at runtime to ensure that it\ndoes not run as UID 0 (root) and fail to start the container if it does.\nIf unset or false, no such validation will be performed.\nMay also be set in SecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.",
                                    "type": "boolean"
                                  },
                                  "runAsUser": {
                                    "description": "The UID to run the entrypoint of the container process.\nDefaults to user specified in image metadata if unspecified.\nMay also be set in SecurityContext.  If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence\nfor that container.\nNote that this field cannot be set when spec.os.name is windows.",
                                    "format": "int64",
                                    "type": "integer"
                                  },
                                  "seLinuxOptions": {
                                    "description": "The SELinux context to be applied to all containers.\nIf unspecified, the container runtime will allocate a random SELinux context for each\ncontainer.  May also be set in SecurityContext.  If set in\nboth SecurityContext and PodSecurityContext, the value specified in SecurityContext\ntakes precedence for that container.\nNote that this field cannot be set when spec.os.name is windows.",
                                    "properties": {
                                      "level": {
                                        "description": "Level is SELinux level label that applies to the container.",
                                        "type": "string"
                                      },
                                      "role": {
                                        "description": "Role is a SELinux role label that applies to the container.",
                                        "type": "string"
                                      },
                                      "type": {
                                        "description": "Type is a SELinux type label that applies to the container.",
                                        "type": "string"
                                      },
                                      "user": {
                                        "description": "User is a SELinux user label that applies to the container.",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "seccompProfile": {
                                    "description": "The seccomp options to use by the containers in this pod.\nNote that this field cannot be set when spec.os.name is windows.",
                                    "properties": {
                                      "localhostProfile": {
                                        "description": "localhostProfile indicates a profile defined in a file on the node should be used.\nThe profile must be preconfigured on the node to work.\nMust be a descending path, relative to the kubelet's configured seccomp profile location.\nMust be set if type is \"Localhost\". Must NOT be set for any other type.",
                                        "type": "string"
                                      },
                                      "type": {
                                        "description": "type indicates which kind of seccomp profile will be applied.\nValid options are:\n\n\nLocalhost - a profile defined in a file on the node should be used.\nRuntimeDefault - the container runtime default profile should be used.\nUnconfined - no profile should be applied.",
                                        "type": "string"
                                      }
                                    },
                                    "required": [
                                      "type"
                                    ],
                                    "type": "object"
                                  },
                                  "supplementalGroups": {
                                    "description": "A list of groups applied to the first process run in each container, in addition\nto the container's primary GID, the fsGroup (if specified), and group memberships\ndefined in the container image for the uid of the container process. If unspecified,\nno additional groups are added to any container. Note that group memberships\ndefined in the container image for the uid of the container process are still effective,\neven if they are not included in this list.\nNote that this field cannot be set when spec.os.name is windows.",
                                    "items": {
                                      "format": "int64",
                                      "type": "integer"
                                    },
                                    "type": "array"
                                  },
                                  "sysctls": {
                                    "description": "Sysctls hold a list of namespaced sysctls used for the pod. Pods with unsupported\nsysctls (by the container runtime) might fail to launch.\nNote that this field cannot be set when spec.os.name is windows.",
                                    "items": {
                                      "description": "Sysctl defines a kernel parameter to be set",
                                      "properties": {
                                        "name": {
                                          "description": "Name of a property to set",
                                          "type": "string"
                                        },
                                        "value": {
                                          "description": "Value of a property to set",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "name",
                                        "value"
                                      ],
                                      "type": "object"
                                    },
                                    "type": "array"
                                  },
                                  "windowsOptions": {
                                    "description": "The Windows specific settings applied to all containers.\nIf unspecified, the options within a container's SecurityContext will be used.\nIf set in both SecurityContext and PodSecurityContext, the value specified in SecurityContext takes precedence.\nNote that this field cannot be set when spec.os.name is linux.",
                                    "properties": {
                                      "gmsaCredentialSpec": {
                                        "description": "GMSACredentialSpec is where the GMSA admission webhook\n(https://github.com/kubernetes-sigs/windows-gmsa) inlines the contents of the\nGMSA credential spec named by the GMSACredentialSpecName field.",
                                        "type": "string"
                                      },
                                      "gmsaCredentialSpecName": {
                                        "description": "GMSACredentialSpecName is the name of the GMSA credential spec to use.",
                                        "type": "string"
                                      },
                                      "hostProcess": {
                                        "description": "HostProcess determines if a container should be run as a 'Host Process' container.\nAll of a Pod's containers must have the same effective HostProcess value\n(it is not allowed to have a mix of HostProcess containers and non-HostProcess containers).\nIn addition, if HostProcess is true then HostNetwork must also be set to true.",
                                        "type": "boolean"
                                      },
                                      "runAsUserName": {
                                        "description": "The UserName in Windows to run the entrypoint of the container process.\nDefaults to the user specified in image metadata if unspecified.\nMay also be set in PodSecurityContext. If set in both SecurityContext and\nPodSecurityContext, the value specified in SecurityContext takes precedence.",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  }
                                },
                                "type": "object"
                              },
                              "serviceAccount": {
                                "description": "DeprecatedServiceAccount is a depreciated alias for ServiceAccountName.\nDeprecated: Use serviceAccountName instead.",
                                "type": "string"
                              },
                              "serviceAccountName": {
                                "description": "ServiceAccountName is the name of the ServiceAccount to use to run this pod.\nMore info: https://kubernetes.io/docs/tasks/configure-pod-container/configure-service-account/",
                                "type": "string"
                              },
                              "setHostnameAsFQDN": {
                                "description": "If true the pod's hostname will be configured as the pod's FQDN, rather than the leaf name (the default).\nIn Linux containers, this means setting the FQDN in the hostname field of the kernel (the nodename field of struct utsname).\nIn Windows containers, this means setting the registry value of hostname for the registry key HKEY_LOCAL_MACHINE\\\\SYSTEM\\\\CurrentControlSet\\\\Services\\\\Tcpip\\\\Parameters to FQDN.\nIf a pod does not have FQDN, this has no effect.\nDefault to false.",
                                "type": "boolean"
                              },
                              "shareProcessNamespace": {
                                "description": "Share a single process namespace between all of the containers in a pod.\nWhen this is set containers will be able to view and signal processes from other containers\nin the same pod, and the first process in each container will not be assigned PID 1.\nHostPID and ShareProcessNamespace cannot both be set.\nOptional: Default to false.",
                                "type": "boolean"
                              },
                              "subdomain": {
                                "description": "If specified, the fully qualified Pod hostname will be \"\u003chostname\u003e.\u003csubdomain\u003e.\u003cpod namespace\u003e.svc.\u003ccluster domain\u003e\".\nIf not specified, the pod will not have a domainname at all.",
                                "type": "string"
                              },
                              "terminationGracePeriodSeconds": {
                                "description": "Optional duration in seconds the pod needs to terminate gracefully. May be decreased in delete request.\nValue must be non-negative integer. The value zero indicates stop immediately via\nthe kill signal (no opportunity to shut down).\nIf this value is nil, the default grace period will be used instead.\nThe grace period is the duration in seconds after the processes running in the pod are sent\na termination signal and the time when the processes are forcibly halted with a kill signal.\nSet this value longer than the expected cleanup time for your process.\nDefaults to 30 seconds.",
                                "format": "int64",
                                "type": "integer"
                              },
                              "tolerations": {
                                "description": "If specified, the pod's tolerations.",
                                "items": {
                                  "description": "The pod this Toleration is attached to tolerates any taint that matches\nthe triple \u003ckey,value,effect\u003e using the matching operator \u003coperator\u003e.",
                                  "properties": {
                                    "effect": {
                                      "description": "Effect indicates the taint effect to match. Empty means match all taint effects.\nWhen specified, allowed values are NoSchedule, PreferNoSchedule and NoExecute.",
                                      "type": "string"
                                    },
                                    "key": {
                                      "description": "Key is the taint key that the toleration applies to. Empty means match all taint keys.\nIf the key is empty, operator must be Exists; this combination means to match all values and all keys.",
                                      "type": "string"
                                    },
                                    "operator": {
                                      "description": "Operator represents a key's relationship to the value.\nValid operators are Exists and Equal. Defaults to Equal.\nExists is equivalent to wildcard for value, so that a pod can\ntolerate all taints of a particular category.",
                                      "type": "string"
                                    },
                                    "tolerationSeconds": {
                                      "description": "TolerationSeconds represents the period of time the toleration (which must be\nof effect NoExecute, otherwise this field is ignored) tolerates the taint. By default,\nit is not set, which means tolerate the taint forever (do not evict). Zero and\nnegative values will be treated as 0 (evict immediately) by the system.",
                                      "format": "int64",
                                      "type": "integer"
                                    },
                                    "value": {
                                      "description": "Value is the taint value the toleration matches to.\nIf the operator is Exists, the value should be empty, otherwise just a regular string.",
                                      "type": "string"
                                    }
                                  },
                                  "type": "object"
                                },
                                "type": "array"
                              },
                              "topologySpreadConstraints": {
                                "description": "TopologySpreadConstraints describes how a group of pods ought to spread across topology\ndomains. Scheduler will schedule pods in a way which abides by the constraints.\nAll topologySpreadConstraints are ANDed.",
                                "items": {
                                  "description": "TopologySpreadConstraint specifies how to spread matching pods among the given topology.",
                                  "properties": {
                                    "labelSelector": {
                                      "description": "LabelSelector is used to find matching pods.\nPods that match this label selector are counted to determine the number of pods\nin their corresponding topology domain.",
                                      "properties": {
                                        "matchExpressions": {
                                          "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                          "items": {
                                            "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                            "properties": {
                                              "key": {
                                                "description": "key is the label key that the selector applies to.",
                                                "type": "string"
                                              },
                                              "operator": {
                                                "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                "type": "string"
                                              },
                                              "values": {
                                                "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                "items": {
                                                  "type": "string"
                                                },
                                                "type": "array"
                                              }
                                            },
                                            "required": [
                                              "key",
                                              "operator"
                                            ],
                                            "type": "object"
                                          },
                                          "type": "array"
                                        },
                                        "matchLabels": {
                                          "additionalProperties": {
                                            "type": "string"
                                          },
                                          "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                          "type": "object"
                                        }
                                      },
                                      "type": "object",
                                      "x-kubernetes-map-type": "atomic"
                                    },
                                    "matchLabelKeys": {
                                      "description": "MatchLabelKeys is a set of pod label keys to select the pods over which\nspreading will be calculated. The keys are used to lookup values from the\nincoming pod labels, those key-value labels are ANDed with labelSelector\nto select the group of existing pods over which spreading will be calculated\nfor the incoming pod. The same key is forbidden to exist in both MatchLabelKeys and LabelSelector.\nMatchLabelKeys cannot be set when LabelSelector isn't set.\nKeys that don't exist in the incoming pod labels will\nbe ignored. A null or empty list means only match against labelSelector.\n\n\nThis is a beta field and requires the MatchLabelKeysInPodTopologySpread feature gate to be enabled (enabled by default).",
                                      "items": {
                                        "type": "string"
                                      },
                                      "type": "array",
                                      "x-kubernetes-list-type": "atomic"
                                    },
                                    "maxSkew": {
                                      "description": "MaxSkew describes the degree to which pods may be unevenly distributed.\nWhen `whenUnsatisfiable=DoNotSchedule`, it is the maximum permitted difference\nbetween the number of matching pods in the target topology and the global minimum.\nThe global minimum is the minimum number of matching pods in an eligible domain\nor zero if the number of eligible domains is less than MinDomains.\nFor example, in a 3-zone cluster, MaxSkew is set to 1, and pods with the same\nlabelSelector spread as 2/2/1:\nIn this case, the global minimum is 1.\n| zone1 | zone2 | zone3 |\n|  P P  |  P P  |   P   |\n- if MaxSkew is 1, incoming pod can only be scheduled to zone3 to become 2/2/2;\nscheduling it onto zone1(zone2) would make the ActualSkew(3-1) on zone1(zone2)\nviolate MaxSkew(1).\n- if MaxSkew is 2, incoming pod can be scheduled onto any zone.\nWhen `whenUnsatisfiable=ScheduleAnyway`, it is used to give higher precedence\nto topologies that satisfy it.\nIt's a required field. Default value is 1 and 0 is not allowed.",
                                      "format": "int32",
                                      "type": "integer"
                                    },
                                    "minDomains": {
                                      "description": "MinDomains indicates a minimum number of eligible domains.\nWhen the number of eligible domains with matching topology keys is less than minDomains,\nPod Topology Spread treats \"global minimum\" as 0, and then the calculation of Skew is performed.\nAnd when the number of eligible domains with matching topology keys equals or greater than minDomains,\nthis value has no effect on scheduling.\nAs a result, when the number of eligible domains is less than minDomains,\nscheduler won't schedule more than maxSkew Pods to those domains.\nIf value is nil, the constraint behaves as if MinDomains is equal to 1.\nValid values are integers greater than 0.\nWhen value is not nil, WhenUnsatisfiable must be DoNotSchedule.\n\n\nFor example, in a 3-zone cluster, MaxSkew is set to 2, MinDomains is set to 5 and pods with the same\nlabelSelector spread as 2/2/2:\n| zone1 | zone2 | zone3 |\n|  P P  |  P P  |  P P  |\nThe number of domains is less than 5(MinDomains), so \"global minimum\" is treated as 0.\nIn this situation, new pod with the same labelSelector cannot be scheduled,\nbecause computed skew will be 3(3 - 0) if new Pod is scheduled to any of the three zones,\nit will violate MaxSkew.\n\n\nThis is a beta field and requires the MinDomainsInPodTopologySpread feature gate to be enabled (enabled by default).",
                                      "format": "int32",
                                      "type": "integer"
                                    },
                                    "nodeAffinityPolicy": {
                                      "description": "NodeAffinityPolicy indicates how we will treat Pod's nodeAffinity/nodeSelector\nwhen calculating pod topology spread skew. Options are:\n- Honor: only nodes matching nodeAffinity/nodeSelector are included in the calculations.\n- Ignore: nodeAffinity/nodeSelector are ignored. All nodes are included in the calculations.\n\n\nIf this value is nil, the behavior is equivalent to the Honor policy.\nThis is a beta-level feature default enabled by the NodeInclusionPolicyInPodTopologySpread feature flag.",
                                      "type": "string"
                                    },
                                    "nodeTaintsPolicy": {
                                      "description": "NodeTaintsPolicy indicates how we will treat node taints when calculating\npod topology spread skew. Options are:\n- Honor: nodes without taints, along with tainted nodes for which the incoming pod\nhas a toleration, are included.\n- Ignore: node taints are ignored. All nodes are included.\n\n\nIf this value is nil, the behavior is equivalent to the Ignore policy.\nThis is a beta-level feature default enabled by the NodeInclusionPolicyInPodTopologySpread feature flag.",
                                      "type": "string"
                                    },
                                    "topologyKey": {
                                      "description": "TopologyKey is the key of node labels. Nodes that have a label with this key\nand identical values are considered to be in the same topology.\nWe consider each \u003ckey, value\u003e as a \"bucket\", and try to put balanced number\nof pods into each bucket.\nWe define a domain as a particular instance of a topology.\nAlso, we define an eligible domain as a domain whose nodes meet the requirements of\nnodeAffinityPolicy and nodeTaintsPolicy.\ne.g. If TopologyKey is \"kubernetes.io/hostname\", each Node is a domain of that topology.\nAnd, if TopologyKey is \"topology.kubernetes.io/zone\", each zone is a domain of that topology.\nIt's a required field.",
                                      "type": "string"
                                    },
                                    "whenUnsatisfiable": {
                                      "description": "WhenUnsatisfiable indicates how to deal with a pod if it doesn't satisfy\nthe spread constraint.\n- DoNotSchedule (default) tells the scheduler not to schedule it.\n- ScheduleAnyway tells the scheduler to schedule the pod in any location,\n  but giving higher precedence to topologies that would help reduce the\n  skew.\nA constraint is considered \"Unsatisfiable\" for an incoming pod\nif and only if every possible node assignment for that pod would violate\n\"MaxSkew\" on some topology.\nFor example, in a 3-zone cluster, MaxSkew is set to 1, and pods with the same\nlabelSelector spread as 3/1/1:\n| zone1 | zone2 | zone3 |\n| P P P |   P   |   P   |\nIf WhenUnsatisfiable is set to DoNotSchedule, incoming pod can only be scheduled\nto zone2(zone3) to become 3/2/1(3/1/2) as ActualSkew(2-1) on zone2(zone3) satisfies\nMaxSkew(1). In other words, the cluster can still be imbalanced, but scheduler\nwon't make it *more* imbalanced.\nIt's a required field.",
                                      "type": "string"
                                    }
                                  },
                                  "required": [
                                    "maxSkew",
                                    "topologyKey",
                                    "whenUnsatisfiable"
                                  ],
                                  "type": "object"
                                },
                                "type": "array",
                                "x-kubernetes-list-map-keys": [
                                  "topologyKey",
                                  "whenUnsatisfiable"
                                ],
                                "x-kubernetes-list-type": "map"
                              },
                              "volumes": {
                                "description": "List of volumes that can be mounted by containers belonging to the pod.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes",
                                "items": {
                                  "description": "Volume represents a named volume in a pod that may be accessed by any container in the pod.",
                                  "properties": {
                                    "awsElasticBlockStore": {
                                      "description": "awsElasticBlockStore represents an AWS Disk resource that is attached to a\nkubelet's host machine and then exposed to the pod.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore",
                                      "properties": {
                                        "fsType": {
                                          "description": "fsType is the filesystem type of the volume that you want to mount.\nTip: Ensure that the filesystem type is supported by the host operating system.\nExamples: \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore\nTODO: how do we prevent errors in the filesystem from compromising the machine",
                                          "type": "string"
                                        },
                                        "partition": {
                                          "description": "partition is the partition in the volume that you want to mount.\nIf omitted, the default is to mount by volume name.\nExamples: For volume /dev/sda1, you specify the partition as \"1\".\nSimilarly, the volume partition for /dev/sda is \"0\" (or you can leave the property empty).",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "readOnly": {
                                          "description": "readOnly value true will force the readOnly setting in VolumeMounts.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore",
                                          "type": "boolean"
                                        },
                                        "volumeID": {
                                          "description": "volumeID is unique ID of the persistent disk resource in AWS (Amazon EBS volume).\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#awselasticblockstore",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "volumeID"
                                      ],
                                      "type": "object"
                                    },
                                    "azureDisk": {
                                      "description": "azureDisk represents an Azure Data Disk mount on the host and bind mount to the pod.",
                                      "properties": {
                                        "cachingMode": {
                                          "description": "cachingMode is the Host Caching mode: None, Read Only, Read Write.",
                                          "type": "string"
                                        },
                                        "diskName": {
                                          "description": "diskName is the Name of the data disk in the blob storage",
                                          "type": "string"
                                        },
                                        "diskURI": {
                                          "description": "diskURI is the URI of data disk in the blob storage",
                                          "type": "string"
                                        },
                                        "fsType": {
                                          "description": "fsType is Filesystem type to mount.\nMust be a filesystem type supported by the host operating system.\nEx. \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.",
                                          "type": "string"
                                        },
                                        "kind": {
                                          "description": "kind expected values are Shared: multiple blob disks per storage account  Dedicated: single blob disk per storage account  Managed: azure managed data disk (only in managed availability set). defaults to shared",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly Defaults to false (read/write). ReadOnly here will force\nthe ReadOnly setting in VolumeMounts.",
                                          "type": "boolean"
                                        }
                                      },
                                      "required": [
                                        "diskName",
                                        "diskURI"
                                      ],
                                      "type": "object"
                                    },
                                    "azureFile": {
                                      "description": "azureFile represents an Azure File Service mount on the host and bind mount to the pod.",
                                      "properties": {
                                        "readOnly": {
                                          "description": "readOnly defaults to false (read/write). ReadOnly here will force\nthe ReadOnly setting in VolumeMounts.",
                                          "type": "boolean"
                                        },
                                        "secretName": {
                                          "description": "secretName is the  name of secret that contains Azure Storage Account Name and Key",
                                          "type": "string"
                                        },
                                        "shareName": {
                                          "description": "shareName is the azure share Name",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "secretName",
                                        "shareName"
                                      ],
                                      "type": "object"
                                    },
                                    "cephfs": {
                                      "description": "cephFS represents a Ceph FS mount on the host that shares a pod's lifetime",
                                      "properties": {
                                        "monitors": {
                                          "description": "monitors is Required: Monitors is a collection of Ceph monitors\nMore info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it",
                                          "items": {
                                            "type": "string"
                                          },
                                          "type": "array"
                                        },
                                        "path": {
                                          "description": "path is Optional: Used as the mounted root, rather than the full Ceph tree, default is /",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly is Optional: Defaults to false (read/write). ReadOnly here will force\nthe ReadOnly setting in VolumeMounts.\nMore info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it",
                                          "type": "boolean"
                                        },
                                        "secretFile": {
                                          "description": "secretFile is Optional: SecretFile is the path to key ring for User, default is /etc/ceph/user.secret\nMore info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it",
                                          "type": "string"
                                        },
                                        "secretRef": {
                                          "description": "secretRef is Optional: SecretRef is reference to the authentication secret for User, default is empty.\nMore info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it",
                                          "properties": {
                                            "name": {
                                              "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object",
                                          "x-kubernetes-map-type": "atomic"
                                        },
                                        "user": {
                                          "description": "user is optional: User is the rados user name, default is admin\nMore info: https://examples.k8s.io/volumes/cephfs/README.md#how-to-use-it",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "monitors"
                                      ],
                                      "type": "object"
                                    },
                                    "cinder": {
                                      "description": "cinder represents a cinder volume attached and mounted on kubelets host machine.\nMore info: https://examples.k8s.io/mysql-cinder-pd/README.md",
                                      "properties": {
                                        "fsType": {
                                          "description": "fsType is the filesystem type to mount.\nMust be a filesystem type supported by the host operating system.\nExamples: \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.\nMore info: https://examples.k8s.io/mysql-cinder-pd/README.md",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly defaults to false (read/write). ReadOnly here will force\nthe ReadOnly setting in VolumeMounts.\nMore info: https://examples.k8s.io/mysql-cinder-pd/README.md",
                                          "type": "boolean"
                                        },
                                        "secretRef": {
                                          "description": "secretRef is optional: points to a secret object containing parameters used to connect\nto OpenStack.",
                                          "properties": {
                                            "name": {
                                              "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object",
                                          "x-kubernetes-map-type": "atomic"
                                        },
                                        "volumeID": {
                                          "description": "volumeID used to identify the volume in cinder.\nMore info: https://examples.k8s.io/mysql-cinder-pd/README.md",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "volumeID"
                                      ],
                                      "type": "object"
                                    },
                                    "configMap": {
                                      "description": "configMap represents a configMap that should populate this volume",
                                      "properties": {
                                        "defaultMode": {
                                          "description": "defaultMode is optional: mode bits used to set permissions on created files by default.\nMust be an octal value between 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values for mode bits.\nDefaults to 0644.\nDirectories within the path are not affected by this setting.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "items": {
                                          "description": "items if unspecified, each key-value pair in the Data field of the referenced\nConfigMap will be projected into the volume as a file whose name is the\nkey and content is the value. If specified, the listed keys will be\nprojected into the specified paths, and unlisted keys will not be\npresent. If a key is specified which is not present in the ConfigMap,\nthe volume setup will error unless it is marked optional. Paths must be\nrelative and may not contain the '..' path or start with '..'.",
                                          "items": {
                                            "description": "Maps a string key to a path within a volume.",
                                            "properties": {
                                              "key": {
                                                "description": "key is the key to project.",
                                                "type": "string"
                                              },
                                              "mode": {
                                                "description": "mode is Optional: mode bits used to set permissions on this file.\nMust be an octal value between 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values for mode bits.\nIf not specified, the volume defaultMode will be used.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                                "format": "int32",
                                                "type": "integer"
                                              },
                                              "path": {
                                                "description": "path is the relative path of the file to map the key to.\nMay not be an absolute path.\nMay not contain the path element '..'.\nMay not start with the string '..'.",
                                                "type": "string"
                                              }
                                            },
                                            "required": [
                                              "key",
                                              "path"
                                            ],
                                            "type": "object"
                                          },
                                          "type": "array"
                                        },
                                        "name": {
                                          "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                          "type": "string"
                                        },
                                        "optional": {
                                          "description": "optional specify whether the ConfigMap or its keys must be defined",
                                          "type": "boolean"
                                        }
                                      },
                                      "type": "object",
                                      "x-kubernetes-map-type": "atomic"
                                    },
                                    "csi": {
                                      "description": "csi (Container Storage Interface) represents ephemeral storage that is handled by certain external CSI drivers (Beta feature).",
                                      "properties": {
                                        "driver": {
                                          "description": "driver is the name of the CSI driver that handles this volume.\nConsult with your admin for the correct name as registered in the cluster.",
                                          "type": "string"
                                        },
                                        "fsType": {
                                          "description": "fsType to mount. Ex. \"ext4\", \"xfs\", \"ntfs\".\nIf not provided, the empty value is passed to the associated CSI driver\nwhich will determine the default filesystem to apply.",
                                          "type": "string"
                                        },
                                        "nodePublishSecretRef": {
                                          "description": "nodePublishSecretRef is a reference to the secret object containing\nsensitive information to pass to the CSI driver to complete the CSI\nNodePublishVolume and NodeUnpublishVolume calls.\nThis field is optional, and  may be empty if no secret is required. If the\nsecret object contains more than one secret, all secret references are passed.",
                                          "properties": {
                                            "name": {
                                              "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object",
                                          "x-kubernetes-map-type": "atomic"
                                        },
                                        "readOnly": {
                                          "description": "readOnly specifies a read-only configuration for the volume.\nDefaults to false (read/write).",
                                          "type": "boolean"
                                        },
                                        "volumeAttributes": {
                                          "additionalProperties": {
                                            "type": "string"
                                          },
                                          "description": "volumeAttributes stores driver-specific properties that are passed to the CSI\ndriver. Consult your driver's documentation for supported values.",
                                          "type": "object"
                                        }
                                      },
                                      "required": [
                                        "driver"
                                      ],
                                      "type": "object"
                                    },
                                    "downwardAPI": {
                                      "description": "downwardAPI represents downward API about the pod that should populate this volume",
                                      "properties": {
                                        "defaultMode": {
                                          "description": "Optional: mode bits to use on created files by default. Must be a\nOptional: mode bits used to set permissions on created files by default.\nMust be an octal value between 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values for mode bits.\nDefaults to 0644.\nDirectories within the path are not affected by this setting.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "items": {
                                          "description": "Items is a list of downward API volume file",
                                          "items": {
                                            "description": "DownwardAPIVolumeFile represents information to create the file containing the pod field",
                                            "properties": {
                                              "fieldRef": {
                                                "description": "Required: Selects a field of the pod: only annotations, labels, name and namespace are supported.",
                                                "properties": {
                                                  "apiVersion": {
                                                    "description": "Version of the schema the FieldPath is written in terms of, defaults to \"v1\".",
                                                    "type": "string"
                                                  },
                                                  "fieldPath": {
                                                    "description": "Path of the field to select in the specified API version.",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "fieldPath"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "mode": {
                                                "description": "Optional: mode bits used to set permissions on this file, must be an octal value\nbetween 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values for mode bits.\nIf not specified, the volume defaultMode will be used.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                                "format": "int32",
                                                "type": "integer"
                                              },
                                              "path": {
                                                "description": "Required: Path is  the relative path name of the file to be created. Must not be absolute or contain the '..' path. Must be utf-8 encoded. The first item of the relative path must not start with '..'",
                                                "type": "string"
                                              },
                                              "resourceFieldRef": {
                                                "description": "Selects a resource of the container: only resources limits and requests\n(limits.cpu, limits.memory, requests.cpu and requests.memory) are currently supported.",
                                                "properties": {
                                                  "containerName": {
                                                    "description": "Container name: required for volumes, optional for env vars",
                                                    "type": "string"
                                                  },
                                                  "divisor": {
                                                    "anyOf": [
                                                      {
                                                        "type": "integer"
                                                      },
                                                      {
                                                        "type": "string"
                                                      }
                                                    ],
                                                    "description": "Specifies the output format of the exposed resources, defaults to \"1\"",
                                                    "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                    "x-kubernetes-int-or-string": true
                                                  },
                                                  "resource": {
                                                    "description": "Required: resource to select",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "resource"
                                                ],
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              }
                                            },
                                            "required": [
                                              "path"
                                            ],
                                            "type": "object"
                                          },
                                          "type": "array"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "emptyDir": {
                                      "description": "emptyDir represents a temporary directory that shares a pod's lifetime.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir",
                                      "properties": {
                                        "medium": {
                                          "description": "medium represents what type of storage medium should back this directory.\nThe default is \"\" which means to use the node's default medium.\nMust be an empty string (default) or Memory.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir",
                                          "type": "string"
                                        },
                                        "sizeLimit": {
                                          "anyOf": [
                                            {
                                              "type": "integer"
                                            },
                                            {
                                              "type": "string"
                                            }
                                          ],
                                          "description": "sizeLimit is the total amount of local storage required for this EmptyDir volume.\nThe size limit is also applicable for memory medium.\nThe maximum usage on memory medium EmptyDir would be the minimum value between\nthe SizeLimit specified here and the sum of memory limits of all containers in a pod.\nThe default is nil which means that the limit is undefined.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#emptydir",
                                          "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                          "x-kubernetes-int-or-string": true
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "ephemeral": {
                                      "description": "ephemeral represents a volume that is handled by a cluster storage driver.\nThe volume's lifecycle is tied to the pod that defines it - it will be created before the pod starts,\nand deleted when the pod is removed.\n\n\nUse this if:\na) the volume is only needed while the pod runs,\nb) features of normal volumes like restoring from snapshot or capacity\n   tracking are needed,\nc) the storage driver is specified through a storage class, and\nd) the storage driver supports dynamic volume provisioning through\n   a PersistentVolumeClaim (see EphemeralVolumeSource for more\n   information on the connection between this volume type\n   and PersistentVolumeClaim).\n\n\nUse PersistentVolumeClaim or one of the vendor-specific\nAPIs for volumes that persist for longer than the lifecycle\nof an individual pod.\n\n\nUse CSI for light-weight local ephemeral volumes if the CSI driver is meant to\nbe used that way - see the documentation of the driver for\nmore information.\n\n\nA pod can use both types of ephemeral volumes and\npersistent volumes at the same time.",
                                      "properties": {
                                        "volumeClaimTemplate": {
                                          "description": "Will be used to create a stand-alone PVC to provision the volume.\nThe pod in which this EphemeralVolumeSource is embedded will be the\nowner of the PVC, i.e. the PVC will be deleted together with the\npod.  The name of the PVC will be `\u003cpod name\u003e-\u003cvolume name\u003e` where\n`\u003cvolume name\u003e` is the name from the `PodSpec.Volumes` array\nentry. Pod validation will reject the pod if the concatenated name\nis not valid for a PVC (for example, too long).\n\n\nAn existing PVC with that name that is not owned by the pod\nwill *not* be used for the pod to avoid using an unrelated\nvolume by mistake. Starting the pod is then blocked until\nthe unrelated PVC is removed. If such a pre-created PVC is\nmeant to be used by the pod, the PVC has to updated with an\nowner reference to the pod once the pod exists. Normally\nthis should not be necessary, but it may be useful when\nmanually reconstructing a broken cluster.\n\n\nThis field is read-only and no changes will be made by Kubernetes\nto the PVC after it has been created.\n\n\nRequired, must not be nil.",
                                          "properties": {
                                            "metadata": {
                                              "description": "May contain labels and annotations that will be copied into the PVC\nwhen creating it. No other fields are allowed and will be rejected during\nvalidation.",
                                              "type": "object"
                                            },
                                            "spec": {
                                              "description": "The specification for the PersistentVolumeClaim. The entire content is\ncopied unchanged into the PVC that gets created from this\ntemplate. The same fields as in a PersistentVolumeClaim\nare also valid here.",
                                              "properties": {
                                                "accessModes": {
                                                  "description": "accessModes contains the desired access modes the volume should have.\nMore info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#access-modes-1",
                                                  "items": {
                                                    "type": "string"
                                                  },
                                                  "type": "array"
                                                },
                                                "dataSource": {
                                                  "description": "dataSource field can be used to specify either:\n* An existing VolumeSnapshot object (snapshot.storage.k8s.io/VolumeSnapshot)\n* An existing PVC (PersistentVolumeClaim)\nIf the provisioner or an external controller can support the specified data source,\nit will create a new volume based on the contents of the specified data source.\nWhen the AnyVolumeDataSource feature gate is enabled, dataSource contents will be copied to dataSourceRef,\nand dataSourceRef contents will be copied to dataSource when dataSourceRef.namespace is not specified.\nIf the namespace is specified, then dataSourceRef will not be copied to dataSource.",
                                                  "properties": {
                                                    "apiGroup": {
                                                      "description": "APIGroup is the group for the resource being referenced.\nIf APIGroup is not specified, the specified Kind must be in the core API group.\nFor any other third-party types, APIGroup is required.",
                                                      "type": "string"
                                                    },
                                                    "kind": {
                                                      "description": "Kind is the type of resource being referenced",
                                                      "type": "string"
                                                    },
                                                    "name": {
                                                      "description": "Name is the name of resource being referenced",
                                                      "type": "string"
                                                    }
                                                  },
                                                  "required": [
                                                    "kind",
                                                    "name"
                                                  ],
                                                  "type": "object",
                                                  "x-kubernetes-map-type": "atomic"
                                                },
                                                "dataSourceRef": {
                                                  "description": "dataSourceRef specifies the object from which to populate the volume with data, if a non-empty\nvolume is desired. This may be any object from a non-empty API group (non\ncore object) or a PersistentVolumeClaim object.\nWhen this field is specified, volume binding will only succeed if the type of\nthe specified object matches some installed volume populator or dynamic\nprovisioner.\nThis field will replace the functionality of the dataSource field and as such\nif both fields are non-empty, they must have the same value. For backwards\ncompatibility, when namespace isn't specified in dataSourceRef,\nboth fields (dataSource and dataSourceRef) will be set to the same\nvalue automatically if one of them is empty and the other is non-empty.\nWhen namespace is specified in dataSourceRef,\ndataSource isn't set to the same value and must be empty.\nThere are three important differences between dataSource and dataSourceRef:\n* While dataSource only allows two specific types of objects, dataSourceRef\n  allows any non-core object, as well as PersistentVolumeClaim objects.\n* While dataSource ignores disallowed values (dropping them), dataSourceRef\n  preserves all values, and generates an error if a disallowed value is\n  specified.\n* While dataSource only allows local objects, dataSourceRef allows objects\n  in any namespaces.\n(Beta) Using this field requires the AnyVolumeDataSource feature gate to be enabled.\n(Alpha) Using the namespace field of dataSourceRef requires the CrossNamespaceVolumeDataSource feature gate to be enabled.",
                                                  "properties": {
                                                    "apiGroup": {
                                                      "description": "APIGroup is the group for the resource being referenced.\nIf APIGroup is not specified, the specified Kind must be in the core API group.\nFor any other third-party types, APIGroup is required.",
                                                      "type": "string"
                                                    },
                                                    "kind": {
                                                      "description": "Kind is the type of resource being referenced",
                                                      "type": "string"
                                                    },
                                                    "name": {
                                                      "description": "Name is the name of resource being referenced",
                                                      "type": "string"
                                                    },
                                                    "namespace": {
                                                      "description": "Namespace is the namespace of resource being referenced\nNote that when a namespace is specified, a gateway.networking.k8s.io/ReferenceGrant object is required in the referent namespace to allow that namespace's owner to accept the reference. See the ReferenceGrant documentation for details.\n(Alpha) This field requires the CrossNamespaceVolumeDataSource feature gate to be enabled.",
                                                      "type": "string"
                                                    }
                                                  },
                                                  "required": [
                                                    "kind",
                                                    "name"
                                                  ],
                                                  "type": "object"
                                                },
                                                "resources": {
                                                  "description": "resources represents the minimum resources the volume should have.\nIf RecoverVolumeExpansionFailure feature is enabled users are allowed to specify resource requirements\nthat are lower than previous value but must still be higher than capacity recorded in the\nstatus field of the claim.\nMore info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#resources",
                                                  "properties": {
                                                    "claims": {
                                                      "description": "Claims lists the names of resources, defined in spec.resourceClaims,\nthat are used by this container.\n\n\nThis is an alpha field and requires enabling the\nDynamicResourceAllocation feature gate.\n\n\nThis field is immutable. It can only be set for containers.",
                                                      "items": {
                                                        "description": "ResourceClaim references one entry in PodSpec.ResourceClaims.",
                                                        "properties": {
                                                          "name": {
                                                            "description": "Name must match the name of one entry in pod.spec.resourceClaims of\nthe Pod where this field is used. It makes that resource available\ninside a container.",
                                                            "type": "string"
                                                          }
                                                        },
                                                        "required": [
                                                          "name"
                                                        ],
                                                        "type": "object"
                                                      },
                                                      "type": "array",
                                                      "x-kubernetes-list-map-keys": [
                                                        "name"
                                                      ],
                                                      "x-kubernetes-list-type": "map"
                                                    },
                                                    "limits": {
                                                      "additionalProperties": {
                                                        "anyOf": [
                                                          {
                                                            "type": "integer"
                                                          },
                                                          {
                                                            "type": "string"
                                                          }
                                                        ],
                                                        "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                        "x-kubernetes-int-or-string": true
                                                      },
                                                      "description": "Limits describes the maximum amount of compute resources allowed.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                                      "type": "object"
                                                    },
                                                    "requests": {
                                                      "additionalProperties": {
                                                        "anyOf": [
                                                          {
                                                            "type": "integer"
                                                          },
                                                          {
                                                            "type": "string"
                                                          }
                                                        ],
                                                        "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                        "x-kubernetes-int-or-string": true
                                                      },
                                                      "description": "Requests describes the minimum amount of compute resources required.\nIf Requests is omitted for a container, it defaults to Limits if that is explicitly specified,\notherwise to an implementation-defined value. Requests cannot exceed Limits.\nMore info: https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/",
                                                      "type": "object"
                                                    }
                                                  },
                                                  "type": "object"
                                                },
                                                "selector": {
                                                  "description": "selector is a label query over volumes to consider for binding.",
                                                  "properties": {
                                                    "matchExpressions": {
                                                      "description": "matchExpressions is a list of label selector requirements. The requirements are ANDed.",
                                                      "items": {
                                                        "description": "A label selector requirement is a selector that contains values, a key, and an operator that\nrelates the key and values.",
                                                        "properties": {
                                                          "key": {
                                                            "description": "key is the label key that the selector applies to.",
                                                            "type": "string"
                                                          },
                                                          "operator": {
                                                            "description": "operator represents a key's relationship to a set of values.\nValid operators are In, NotIn, Exists and DoesNotExist.",
                                                            "type": "string"
                                                          },
                                                          "values": {
                                                            "description": "values is an array of string values. If the operator is In or NotIn,\nthe values array must be non-empty. If the operator is Exists or DoesNotExist,\nthe values array must be empty. This array is replaced during a strategic\nmerge patch.",
                                                            "items": {
                                                              "type": "string"
                                                            },
                                                            "type": "array"
                                                          }
                                                        },
                                                        "required": [
                                                          "key",
                                                          "operator"
                                                        ],
                                                        "type": "object"
                                                      },
                                                      "type": "array"
                                                    },
                                                    "matchLabels": {
                                                      "additionalProperties": {
                                                        "type": "string"
                                                      },
                                                      "description": "matchLabels is a map of {key,value} pairs. A single {key,value} in the matchLabels\nmap is equivalent to an element of matchExpressions, whose key field is \"key\", the\noperator is \"In\", and the values array contains only \"value\". The requirements are ANDed.",
                                                      "type": "object"
                                                    }
                                                  },
                                                  "type": "object",
                                                  "x-kubernetes-map-type": "atomic"
                                                },
                                                "storageClassName": {
                                                  "description": "storageClassName is the name of the StorageClass required by the claim.\nMore info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#class-1",
                                                  "type": "string"
                                                },
                                                "volumeMode": {
                                                  "description": "volumeMode defines what type of volume is required by the claim.\nValue of Filesystem is implied when not included in claim spec.",
                                                  "type": "string"
                                                },
                                                "volumeName": {
                                                  "description": "volumeName is the binding reference to the PersistentVolume backing this claim.",
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
                                      },
                                      "type": "object"
                                    },
                                    "fc": {
                                      "description": "fc represents a Fibre Channel resource that is attached to a kubelet's host machine and then exposed to the pod.",
                                      "properties": {
                                        "fsType": {
                                          "description": "fsType is the filesystem type to mount.\nMust be a filesystem type supported by the host operating system.\nEx. \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.\nTODO: how do we prevent errors in the filesystem from compromising the machine",
                                          "type": "string"
                                        },
                                        "lun": {
                                          "description": "lun is Optional: FC target lun number",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "readOnly": {
                                          "description": "readOnly is Optional: Defaults to false (read/write). ReadOnly here will force\nthe ReadOnly setting in VolumeMounts.",
                                          "type": "boolean"
                                        },
                                        "targetWWNs": {
                                          "description": "targetWWNs is Optional: FC target worldwide names (WWNs)",
                                          "items": {
                                            "type": "string"
                                          },
                                          "type": "array"
                                        },
                                        "wwids": {
                                          "description": "wwids Optional: FC volume world wide identifiers (wwids)\nEither wwids or combination of targetWWNs and lun must be set, but not both simultaneously.",
                                          "items": {
                                            "type": "string"
                                          },
                                          "type": "array"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "flexVolume": {
                                      "description": "flexVolume represents a generic volume resource that is\nprovisioned/attached using an exec based plugin.",
                                      "properties": {
                                        "driver": {
                                          "description": "driver is the name of the driver to use for this volume.",
                                          "type": "string"
                                        },
                                        "fsType": {
                                          "description": "fsType is the filesystem type to mount.\nMust be a filesystem type supported by the host operating system.\nEx. \"ext4\", \"xfs\", \"ntfs\". The default filesystem depends on FlexVolume script.",
                                          "type": "string"
                                        },
                                        "options": {
                                          "additionalProperties": {
                                            "type": "string"
                                          },
                                          "description": "options is Optional: this field holds extra command options if any.",
                                          "type": "object"
                                        },
                                        "readOnly": {
                                          "description": "readOnly is Optional: defaults to false (read/write). ReadOnly here will force\nthe ReadOnly setting in VolumeMounts.",
                                          "type": "boolean"
                                        },
                                        "secretRef": {
                                          "description": "secretRef is Optional: secretRef is reference to the secret object containing\nsensitive information to pass to the plugin scripts. This may be\nempty if no secret object is specified. If the secret object\ncontains more than one secret, all secrets are passed to the plugin\nscripts.",
                                          "properties": {
                                            "name": {
                                              "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object",
                                          "x-kubernetes-map-type": "atomic"
                                        }
                                      },
                                      "required": [
                                        "driver"
                                      ],
                                      "type": "object"
                                    },
                                    "flocker": {
                                      "description": "flocker represents a Flocker volume attached to a kubelet's host machine. This depends on the Flocker control service being running",
                                      "properties": {
                                        "datasetName": {
                                          "description": "datasetName is Name of the dataset stored as metadata -\u003e name on the dataset for Flocker\nshould be considered as deprecated",
                                          "type": "string"
                                        },
                                        "datasetUUID": {
                                          "description": "datasetUUID is the UUID of the dataset. This is unique identifier of a Flocker dataset",
                                          "type": "string"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "gcePersistentDisk": {
                                      "description": "gcePersistentDisk represents a GCE Disk resource that is attached to a\nkubelet's host machine and then exposed to the pod.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk",
                                      "properties": {
                                        "fsType": {
                                          "description": "fsType is filesystem type of the volume that you want to mount.\nTip: Ensure that the filesystem type is supported by the host operating system.\nExamples: \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk\nTODO: how do we prevent errors in the filesystem from compromising the machine",
                                          "type": "string"
                                        },
                                        "partition": {
                                          "description": "partition is the partition in the volume that you want to mount.\nIf omitted, the default is to mount by volume name.\nExamples: For volume /dev/sda1, you specify the partition as \"1\".\nSimilarly, the volume partition for /dev/sda is \"0\" (or you can leave the property empty).\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "pdName": {
                                          "description": "pdName is unique name of the PD resource in GCE. Used to identify the disk in GCE.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly here will force the ReadOnly setting in VolumeMounts.\nDefaults to false.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#gcepersistentdisk",
                                          "type": "boolean"
                                        }
                                      },
                                      "required": [
                                        "pdName"
                                      ],
                                      "type": "object"
                                    },
                                    "gitRepo": {
                                      "description": "gitRepo represents a git repository at a particular revision.\nDEPRECATED: GitRepo is deprecated. To provision a container with a git repo, mount an\nEmptyDir into an InitContainer that clones the repo using git, then mount the EmptyDir\ninto the Pod's container.",
                                      "properties": {
                                        "directory": {
                                          "description": "directory is the target directory name.\nMust not contain or start with '..'.  If '.' is supplied, the volume directory will be the\ngit repository.  Otherwise, if specified, the volume will contain the git repository in\nthe subdirectory with the given name.",
                                          "type": "string"
                                        },
                                        "repository": {
                                          "description": "repository is the URL",
                                          "type": "string"
                                        },
                                        "revision": {
                                          "description": "revision is the commit hash for the specified revision.",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "repository"
                                      ],
                                      "type": "object"
                                    },
                                    "glusterfs": {
                                      "description": "glusterfs represents a Glusterfs mount on the host that shares a pod's lifetime.\nMore info: https://examples.k8s.io/volumes/glusterfs/README.md",
                                      "properties": {
                                        "endpoints": {
                                          "description": "endpoints is the endpoint name that details Glusterfs topology.\nMore info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod",
                                          "type": "string"
                                        },
                                        "path": {
                                          "description": "path is the Glusterfs volume path.\nMore info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly here will force the Glusterfs volume to be mounted with read-only permissions.\nDefaults to false.\nMore info: https://examples.k8s.io/volumes/glusterfs/README.md#create-a-pod",
                                          "type": "boolean"
                                        }
                                      },
                                      "required": [
                                        "endpoints",
                                        "path"
                                      ],
                                      "type": "object"
                                    },
                                    "hostPath": {
                                      "description": "hostPath represents a pre-existing file or directory on the host\nmachine that is directly exposed to the container. This is generally\nused for system agents or other privileged things that are allowed\nto see the host machine. Most containers will NOT need this.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath\n---\nTODO(jonesdl) We need to restrict who can use host directory mounts and who can/can not\nmount host directories as read/write.",
                                      "properties": {
                                        "path": {
                                          "description": "path of the directory on the host.\nIf the path is a symlink, it will follow the link to the real path.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath",
                                          "type": "string"
                                        },
                                        "type": {
                                          "description": "type for HostPath Volume\nDefaults to \"\"\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#hostpath",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "path"
                                      ],
                                      "type": "object"
                                    },
                                    "iscsi": {
                                      "description": "iscsi represents an ISCSI Disk resource that is attached to a\nkubelet's host machine and then exposed to the pod.\nMore info: https://examples.k8s.io/volumes/iscsi/README.md",
                                      "properties": {
                                        "chapAuthDiscovery": {
                                          "description": "chapAuthDiscovery defines whether support iSCSI Discovery CHAP authentication",
                                          "type": "boolean"
                                        },
                                        "chapAuthSession": {
                                          "description": "chapAuthSession defines whether support iSCSI Session CHAP authentication",
                                          "type": "boolean"
                                        },
                                        "fsType": {
                                          "description": "fsType is the filesystem type of the volume that you want to mount.\nTip: Ensure that the filesystem type is supported by the host operating system.\nExamples: \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#iscsi\nTODO: how do we prevent errors in the filesystem from compromising the machine",
                                          "type": "string"
                                        },
                                        "initiatorName": {
                                          "description": "initiatorName is the custom iSCSI Initiator Name.\nIf initiatorName is specified with iscsiInterface simultaneously, new iSCSI interface\n\u003ctarget portal\u003e:\u003cvolume name\u003e will be created for the connection.",
                                          "type": "string"
                                        },
                                        "iqn": {
                                          "description": "iqn is the target iSCSI Qualified Name.",
                                          "type": "string"
                                        },
                                        "iscsiInterface": {
                                          "description": "iscsiInterface is the interface Name that uses an iSCSI transport.\nDefaults to 'default' (tcp).",
                                          "type": "string"
                                        },
                                        "lun": {
                                          "description": "lun represents iSCSI Target Lun number.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "portals": {
                                          "description": "portals is the iSCSI Target Portal List. The portal is either an IP or ip_addr:port if the port\nis other than default (typically TCP ports 860 and 3260).",
                                          "items": {
                                            "type": "string"
                                          },
                                          "type": "array"
                                        },
                                        "readOnly": {
                                          "description": "readOnly here will force the ReadOnly setting in VolumeMounts.\nDefaults to false.",
                                          "type": "boolean"
                                        },
                                        "secretRef": {
                                          "description": "secretRef is the CHAP Secret for iSCSI target and initiator authentication",
                                          "properties": {
                                            "name": {
                                              "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object",
                                          "x-kubernetes-map-type": "atomic"
                                        },
                                        "targetPortal": {
                                          "description": "targetPortal is iSCSI Target Portal. The Portal is either an IP or ip_addr:port if the port\nis other than default (typically TCP ports 860 and 3260).",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "iqn",
                                        "lun",
                                        "targetPortal"
                                      ],
                                      "type": "object"
                                    },
                                    "name": {
                                      "description": "name of the volume.\nMust be a DNS_LABEL and unique within the pod.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names",
                                      "type": "string"
                                    },
                                    "nfs": {
                                      "description": "nfs represents an NFS mount on the host that shares a pod's lifetime\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#nfs",
                                      "properties": {
                                        "path": {
                                          "description": "path that is exported by the NFS server.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#nfs",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly here will force the NFS export to be mounted with read-only permissions.\nDefaults to false.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#nfs",
                                          "type": "boolean"
                                        },
                                        "server": {
                                          "description": "server is the hostname or IP address of the NFS server.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#nfs",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "path",
                                        "server"
                                      ],
                                      "type": "object"
                                    },
                                    "persistentVolumeClaim": {
                                      "description": "persistentVolumeClaimVolumeSource represents a reference to a\nPersistentVolumeClaim in the same namespace.\nMore info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims",
                                      "properties": {
                                        "claimName": {
                                          "description": "claimName is the name of a PersistentVolumeClaim in the same namespace as the pod using this volume.\nMore info: https://kubernetes.io/docs/concepts/storage/persistent-volumes#persistentvolumeclaims",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly Will force the ReadOnly setting in VolumeMounts.\nDefault false.",
                                          "type": "boolean"
                                        }
                                      },
                                      "required": [
                                        "claimName"
                                      ],
                                      "type": "object"
                                    },
                                    "photonPersistentDisk": {
                                      "description": "photonPersistentDisk represents a PhotonController persistent disk attached and mounted on kubelets host machine",
                                      "properties": {
                                        "fsType": {
                                          "description": "fsType is the filesystem type to mount.\nMust be a filesystem type supported by the host operating system.\nEx. \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.",
                                          "type": "string"
                                        },
                                        "pdID": {
                                          "description": "pdID is the ID that identifies Photon Controller persistent disk",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "pdID"
                                      ],
                                      "type": "object"
                                    },
                                    "portworxVolume": {
                                      "description": "portworxVolume represents a portworx volume attached and mounted on kubelets host machine",
                                      "properties": {
                                        "fsType": {
                                          "description": "fSType represents the filesystem type to mount\nMust be a filesystem type supported by the host operating system.\nEx. \"ext4\", \"xfs\". Implicitly inferred to be \"ext4\" if unspecified.",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly defaults to false (read/write). ReadOnly here will force\nthe ReadOnly setting in VolumeMounts.",
                                          "type": "boolean"
                                        },
                                        "volumeID": {
                                          "description": "volumeID uniquely identifies a Portworx volume",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "volumeID"
                                      ],
                                      "type": "object"
                                    },
                                    "projected": {
                                      "description": "projected items for all in one resources secrets, configmaps, and downward API",
                                      "properties": {
                                        "defaultMode": {
                                          "description": "defaultMode are the mode bits used to set permissions on created files by default.\nMust be an octal value between 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values for mode bits.\nDirectories within the path are not affected by this setting.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "sources": {
                                          "description": "sources is the list of volume projections",
                                          "items": {
                                            "description": "Projection that may be projected along with other supported volume types",
                                            "properties": {
                                              "configMap": {
                                                "description": "configMap information about the configMap data to project",
                                                "properties": {
                                                  "items": {
                                                    "description": "items if unspecified, each key-value pair in the Data field of the referenced\nConfigMap will be projected into the volume as a file whose name is the\nkey and content is the value. If specified, the listed keys will be\nprojected into the specified paths, and unlisted keys will not be\npresent. If a key is specified which is not present in the ConfigMap,\nthe volume setup will error unless it is marked optional. Paths must be\nrelative and may not contain the '..' path or start with '..'.",
                                                    "items": {
                                                      "description": "Maps a string key to a path within a volume.",
                                                      "properties": {
                                                        "key": {
                                                          "description": "key is the key to project.",
                                                          "type": "string"
                                                        },
                                                        "mode": {
                                                          "description": "mode is Optional: mode bits used to set permissions on this file.\nMust be an octal value between 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values for mode bits.\nIf not specified, the volume defaultMode will be used.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                                          "format": "int32",
                                                          "type": "integer"
                                                        },
                                                        "path": {
                                                          "description": "path is the relative path of the file to map the key to.\nMay not be an absolute path.\nMay not contain the path element '..'.\nMay not start with the string '..'.",
                                                          "type": "string"
                                                        }
                                                      },
                                                      "required": [
                                                        "key",
                                                        "path"
                                                      ],
                                                      "type": "object"
                                                    },
                                                    "type": "array"
                                                  },
                                                  "name": {
                                                    "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                    "type": "string"
                                                  },
                                                  "optional": {
                                                    "description": "optional specify whether the ConfigMap or its keys must be defined",
                                                    "type": "boolean"
                                                  }
                                                },
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "downwardAPI": {
                                                "description": "downwardAPI information about the downwardAPI data to project",
                                                "properties": {
                                                  "items": {
                                                    "description": "Items is a list of DownwardAPIVolume file",
                                                    "items": {
                                                      "description": "DownwardAPIVolumeFile represents information to create the file containing the pod field",
                                                      "properties": {
                                                        "fieldRef": {
                                                          "description": "Required: Selects a field of the pod: only annotations, labels, name and namespace are supported.",
                                                          "properties": {
                                                            "apiVersion": {
                                                              "description": "Version of the schema the FieldPath is written in terms of, defaults to \"v1\".",
                                                              "type": "string"
                                                            },
                                                            "fieldPath": {
                                                              "description": "Path of the field to select in the specified API version.",
                                                              "type": "string"
                                                            }
                                                          },
                                                          "required": [
                                                            "fieldPath"
                                                          ],
                                                          "type": "object",
                                                          "x-kubernetes-map-type": "atomic"
                                                        },
                                                        "mode": {
                                                          "description": "Optional: mode bits used to set permissions on this file, must be an octal value\nbetween 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values for mode bits.\nIf not specified, the volume defaultMode will be used.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                                          "format": "int32",
                                                          "type": "integer"
                                                        },
                                                        "path": {
                                                          "description": "Required: Path is  the relative path name of the file to be created. Must not be absolute or contain the '..' path. Must be utf-8 encoded. The first item of the relative path must not start with '..'",
                                                          "type": "string"
                                                        },
                                                        "resourceFieldRef": {
                                                          "description": "Selects a resource of the container: only resources limits and requests\n(limits.cpu, limits.memory, requests.cpu and requests.memory) are currently supported.",
                                                          "properties": {
                                                            "containerName": {
                                                              "description": "Container name: required for volumes, optional for env vars",
                                                              "type": "string"
                                                            },
                                                            "divisor": {
                                                              "anyOf": [
                                                                {
                                                                  "type": "integer"
                                                                },
                                                                {
                                                                  "type": "string"
                                                                }
                                                              ],
                                                              "description": "Specifies the output format of the exposed resources, defaults to \"1\"",
                                                              "pattern": "^(\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))(([KMGTPE]i)|[numkMGTPE]|([eE](\\+|-)?(([0-9]+(\\.[0-9]*)?)|(\\.[0-9]+))))?$",
                                                              "x-kubernetes-int-or-string": true
                                                            },
                                                            "resource": {
                                                              "description": "Required: resource to select",
                                                              "type": "string"
                                                            }
                                                          },
                                                          "required": [
                                                            "resource"
                                                          ],
                                                          "type": "object",
                                                          "x-kubernetes-map-type": "atomic"
                                                        }
                                                      },
                                                      "required": [
                                                        "path"
                                                      ],
                                                      "type": "object"
                                                    },
                                                    "type": "array"
                                                  }
                                                },
                                                "type": "object"
                                              },
                                              "secret": {
                                                "description": "secret information about the secret data to project",
                                                "properties": {
                                                  "items": {
                                                    "description": "items if unspecified, each key-value pair in the Data field of the referenced\nSecret will be projected into the volume as a file whose name is the\nkey and content is the value. If specified, the listed keys will be\nprojected into the specified paths, and unlisted keys will not be\npresent. If a key is specified which is not present in the Secret,\nthe volume setup will error unless it is marked optional. Paths must be\nrelative and may not contain the '..' path or start with '..'.",
                                                    "items": {
                                                      "description": "Maps a string key to a path within a volume.",
                                                      "properties": {
                                                        "key": {
                                                          "description": "key is the key to project.",
                                                          "type": "string"
                                                        },
                                                        "mode": {
                                                          "description": "mode is Optional: mode bits used to set permissions on this file.\nMust be an octal value between 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values for mode bits.\nIf not specified, the volume defaultMode will be used.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                                          "format": "int32",
                                                          "type": "integer"
                                                        },
                                                        "path": {
                                                          "description": "path is the relative path of the file to map the key to.\nMay not be an absolute path.\nMay not contain the path element '..'.\nMay not start with the string '..'.",
                                                          "type": "string"
                                                        }
                                                      },
                                                      "required": [
                                                        "key",
                                                        "path"
                                                      ],
                                                      "type": "object"
                                                    },
                                                    "type": "array"
                                                  },
                                                  "name": {
                                                    "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                                    "type": "string"
                                                  },
                                                  "optional": {
                                                    "description": "optional field specify whether the Secret or its key must be defined",
                                                    "type": "boolean"
                                                  }
                                                },
                                                "type": "object",
                                                "x-kubernetes-map-type": "atomic"
                                              },
                                              "serviceAccountToken": {
                                                "description": "serviceAccountToken is information about the serviceAccountToken data to project",
                                                "properties": {
                                                  "audience": {
                                                    "description": "audience is the intended audience of the token. A recipient of a token\nmust identify itself with an identifier specified in the audience of the\ntoken, and otherwise should reject the token. The audience defaults to the\nidentifier of the apiserver.",
                                                    "type": "string"
                                                  },
                                                  "expirationSeconds": {
                                                    "description": "expirationSeconds is the requested duration of validity of the service\naccount token. As the token approaches expiration, the kubelet volume\nplugin will proactively rotate the service account token. The kubelet will\nstart trying to rotate the token if the token is older than 80 percent of\nits time to live or if the token is older than 24 hours.Defaults to 1 hour\nand must be at least 10 minutes.",
                                                    "format": "int64",
                                                    "type": "integer"
                                                  },
                                                  "path": {
                                                    "description": "path is the path relative to the mount point of the file to project the\ntoken into.",
                                                    "type": "string"
                                                  }
                                                },
                                                "required": [
                                                  "path"
                                                ],
                                                "type": "object"
                                              }
                                            },
                                            "type": "object"
                                          },
                                          "type": "array"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "quobyte": {
                                      "description": "quobyte represents a Quobyte mount on the host that shares a pod's lifetime",
                                      "properties": {
                                        "group": {
                                          "description": "group to map volume access to\nDefault is no group",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly here will force the Quobyte volume to be mounted with read-only permissions.\nDefaults to false.",
                                          "type": "boolean"
                                        },
                                        "registry": {
                                          "description": "registry represents a single or multiple Quobyte Registry services\nspecified as a string as host:port pair (multiple entries are separated with commas)\nwhich acts as the central registry for volumes",
                                          "type": "string"
                                        },
                                        "tenant": {
                                          "description": "tenant owning the given Quobyte volume in the Backend\nUsed with dynamically provisioned Quobyte volumes, value is set by the plugin",
                                          "type": "string"
                                        },
                                        "user": {
                                          "description": "user to map volume access to\nDefaults to serivceaccount user",
                                          "type": "string"
                                        },
                                        "volume": {
                                          "description": "volume is a string that references an already created Quobyte volume by name.",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "registry",
                                        "volume"
                                      ],
                                      "type": "object"
                                    },
                                    "rbd": {
                                      "description": "rbd represents a Rados Block Device mount on the host that shares a pod's lifetime.\nMore info: https://examples.k8s.io/volumes/rbd/README.md",
                                      "properties": {
                                        "fsType": {
                                          "description": "fsType is the filesystem type of the volume that you want to mount.\nTip: Ensure that the filesystem type is supported by the host operating system.\nExamples: \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#rbd\nTODO: how do we prevent errors in the filesystem from compromising the machine",
                                          "type": "string"
                                        },
                                        "image": {
                                          "description": "image is the rados image name.\nMore info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it",
                                          "type": "string"
                                        },
                                        "keyring": {
                                          "description": "keyring is the path to key ring for RBDUser.\nDefault is /etc/ceph/keyring.\nMore info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it",
                                          "type": "string"
                                        },
                                        "monitors": {
                                          "description": "monitors is a collection of Ceph monitors.\nMore info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it",
                                          "items": {
                                            "type": "string"
                                          },
                                          "type": "array"
                                        },
                                        "pool": {
                                          "description": "pool is the rados pool name.\nDefault is rbd.\nMore info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly here will force the ReadOnly setting in VolumeMounts.\nDefaults to false.\nMore info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it",
                                          "type": "boolean"
                                        },
                                        "secretRef": {
                                          "description": "secretRef is name of the authentication secret for RBDUser. If provided\noverrides keyring.\nDefault is nil.\nMore info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it",
                                          "properties": {
                                            "name": {
                                              "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object",
                                          "x-kubernetes-map-type": "atomic"
                                        },
                                        "user": {
                                          "description": "user is the rados user name.\nDefault is admin.\nMore info: https://examples.k8s.io/volumes/rbd/README.md#how-to-use-it",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "image",
                                        "monitors"
                                      ],
                                      "type": "object"
                                    },
                                    "scaleIO": {
                                      "description": "scaleIO represents a ScaleIO persistent volume attached and mounted on Kubernetes nodes.",
                                      "properties": {
                                        "fsType": {
                                          "description": "fsType is the filesystem type to mount.\nMust be a filesystem type supported by the host operating system.\nEx. \"ext4\", \"xfs\", \"ntfs\".\nDefault is \"xfs\".",
                                          "type": "string"
                                        },
                                        "gateway": {
                                          "description": "gateway is the host address of the ScaleIO API Gateway.",
                                          "type": "string"
                                        },
                                        "protectionDomain": {
                                          "description": "protectionDomain is the name of the ScaleIO Protection Domain for the configured storage.",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly Defaults to false (read/write). ReadOnly here will force\nthe ReadOnly setting in VolumeMounts.",
                                          "type": "boolean"
                                        },
                                        "secretRef": {
                                          "description": "secretRef references to the secret for ScaleIO user and other\nsensitive information. If this is not provided, Login operation will fail.",
                                          "properties": {
                                            "name": {
                                              "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object",
                                          "x-kubernetes-map-type": "atomic"
                                        },
                                        "sslEnabled": {
                                          "description": "sslEnabled Flag enable/disable SSL communication with Gateway, default false",
                                          "type": "boolean"
                                        },
                                        "storageMode": {
                                          "description": "storageMode indicates whether the storage for a volume should be ThickProvisioned or ThinProvisioned.\nDefault is ThinProvisioned.",
                                          "type": "string"
                                        },
                                        "storagePool": {
                                          "description": "storagePool is the ScaleIO Storage Pool associated with the protection domain.",
                                          "type": "string"
                                        },
                                        "system": {
                                          "description": "system is the name of the storage system as configured in ScaleIO.",
                                          "type": "string"
                                        },
                                        "volumeName": {
                                          "description": "volumeName is the name of a volume already created in the ScaleIO system\nthat is associated with this volume source.",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "gateway",
                                        "secretRef",
                                        "system"
                                      ],
                                      "type": "object"
                                    },
                                    "secret": {
                                      "description": "secret represents a secret that should populate this volume.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#secret",
                                      "properties": {
                                        "defaultMode": {
                                          "description": "defaultMode is Optional: mode bits used to set permissions on created files by default.\nMust be an octal value between 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values\nfor mode bits. Defaults to 0644.\nDirectories within the path are not affected by this setting.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "items": {
                                          "description": "items If unspecified, each key-value pair in the Data field of the referenced\nSecret will be projected into the volume as a file whose name is the\nkey and content is the value. If specified, the listed keys will be\nprojected into the specified paths, and unlisted keys will not be\npresent. If a key is specified which is not present in the Secret,\nthe volume setup will error unless it is marked optional. Paths must be\nrelative and may not contain the '..' path or start with '..'.",
                                          "items": {
                                            "description": "Maps a string key to a path within a volume.",
                                            "properties": {
                                              "key": {
                                                "description": "key is the key to project.",
                                                "type": "string"
                                              },
                                              "mode": {
                                                "description": "mode is Optional: mode bits used to set permissions on this file.\nMust be an octal value between 0000 and 0777 or a decimal value between 0 and 511.\nYAML accepts both octal and decimal values, JSON requires decimal values for mode bits.\nIf not specified, the volume defaultMode will be used.\nThis might be in conflict with other options that affect the file\nmode, like fsGroup, and the result can be other mode bits set.",
                                                "format": "int32",
                                                "type": "integer"
                                              },
                                              "path": {
                                                "description": "path is the relative path of the file to map the key to.\nMay not be an absolute path.\nMay not contain the path element '..'.\nMay not start with the string '..'.",
                                                "type": "string"
                                              }
                                            },
                                            "required": [
                                              "key",
                                              "path"
                                            ],
                                            "type": "object"
                                          },
                                          "type": "array"
                                        },
                                        "optional": {
                                          "description": "optional field specify whether the Secret or its keys must be defined",
                                          "type": "boolean"
                                        },
                                        "secretName": {
                                          "description": "secretName is the name of the secret in the pod's namespace to use.\nMore info: https://kubernetes.io/docs/concepts/storage/volumes#secret",
                                          "type": "string"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "storageos": {
                                      "description": "storageOS represents a StorageOS volume attached and mounted on Kubernetes nodes.",
                                      "properties": {
                                        "fsType": {
                                          "description": "fsType is the filesystem type to mount.\nMust be a filesystem type supported by the host operating system.\nEx. \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.",
                                          "type": "string"
                                        },
                                        "readOnly": {
                                          "description": "readOnly defaults to false (read/write). ReadOnly here will force\nthe ReadOnly setting in VolumeMounts.",
                                          "type": "boolean"
                                        },
                                        "secretRef": {
                                          "description": "secretRef specifies the secret to use for obtaining the StorageOS API\ncredentials.  If not specified, default values will be attempted.",
                                          "properties": {
                                            "name": {
                                              "description": "Name of the referent.\nMore info: https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#names\nTODO: Add other useful fields. apiVersion, kind, uid?",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object",
                                          "x-kubernetes-map-type": "atomic"
                                        },
                                        "volumeName": {
                                          "description": "volumeName is the human-readable name of the StorageOS volume.  Volume\nnames are only unique within a namespace.",
                                          "type": "string"
                                        },
                                        "volumeNamespace": {
                                          "description": "volumeNamespace specifies the scope of the volume within StorageOS.  If no\nnamespace is specified then the Pod's namespace will be used.  This allows the\nKubernetes name scoping to be mirrored within StorageOS for tighter integration.\nSet VolumeName to any name to override the default behaviour.\nSet to \"default\" if you are not using namespaces within StorageOS.\nNamespaces that do not pre-exist within StorageOS will be created.",
                                          "type": "string"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "vsphereVolume": {
                                      "description": "vsphereVolume represents a vSphere volume attached and mounted on kubelets host machine",
                                      "properties": {
                                        "fsType": {
                                          "description": "fsType is filesystem type to mount.\nMust be a filesystem type supported by the host operating system.\nEx. \"ext4\", \"xfs\", \"ntfs\". Implicitly inferred to be \"ext4\" if unspecified.",
                                          "type": "string"
                                        },
                                        "storagePolicyID": {
                                          "description": "storagePolicyID is the storage Policy Based Management (SPBM) profile ID associated with the StoragePolicyName.",
                                          "type": "string"
                                        },
                                        "storagePolicyName": {
                                          "description": "storagePolicyName is the storage Policy Based Management (SPBM) profile name.",
                                          "type": "string"
                                        },
                                        "volumePath": {
                                          "description": "volumePath is the path that identifies vSphere volume vmdk",
                                          "type": "string"
                                        }
                                      },
                                      "required": [
                                        "volumePath"
                                      ],
                                      "type": "object"
                                    }
                                  },
                                  "required": [
                                    "name"
                                  ],
                                  "type": "object"
                                },
                                "type": "array"
                              }
                            },
                            "required": [
                              "containers"
                            ],
                            "type": "object"
                          }
                        },
                        "type": "object"
                      },
                      "ttlSecondsAfterFinished": {
                        "description": "ttlSecondsAfterFinished limits the lifetime of a Job that has finished\nexecution (either Complete or Failed). If this field is set,\nttlSecondsAfterFinished after the Job finishes, it is eligible to be\nautomatically deleted. When the Job is being deleted, its lifecycle\nguarantees (e.g. finalizers) will be honored. If this field is unset,\nthe Job won't be automatically deleted. If this field is set to zero,\nthe Job becomes eligible to be deleted immediately after it finishes.",
                        "format": "int32",
                        "type": "integer"
                      }
                    },
                    "required": [
                      "template"
                    ],
                    "type": "object"
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
                  "rollout": {
                    "description": "Rollout defines the strategy for job rollouts",
                    "properties": {
                      "propagationPolicy": {
                        "type": "string"
                      },
                      "strategy": {
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "rolloutStrategy": {
                    "type": "string"
                  },
                  "scalingStrategy": {
                    "description": "ScalingStrategy defines the strategy of Scaling",
                    "properties": {
                      "customScalingQueueLengthDeduction": {
                        "format": "int32",
                        "type": "integer"
                      },
                      "customScalingRunningJobPercentage": {
                        "type": "string"
                      },
                      "multipleScalersCalculation": {
                        "type": "string"
                      },
                      "pendingPodConditions": {
                        "items": {
                          "type": "string"
                        },
                        "type": "array"
                      },
                      "strategy": {
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "successfulJobsHistoryLimit": {
                    "format": "int32",
                    "type": "integer"
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
                  "jobTargetRef",
                  "triggers"
                ],
                "type": "object"
              },
              "status": {
                "description": "ScaledJobStatus defines the observed state of ScaledJob",
                "properties": {
                  "Paused": {
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
                  "lastActiveTime": {
                    "format": "date-time",
                    "type": "string"
                  }
                },
                "type": "object"
              }
            },
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