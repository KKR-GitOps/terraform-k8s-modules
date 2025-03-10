resource "k8s_apiextensions_k8s_io_v1_custom_resource_definition" "clustertriggerauthentications_keda_sh" {
  metadata {
    annotations = {
      "controller-gen.kubebuilder.io/version" = "v0.14.0"
    }
    labels = {
      "app.kubernetes.io/part-of" = "keda-operator"
      "app.kubernetes.io/version" = "2.14.0"
    }
    name = "clustertriggerauthentications.keda.sh"
  }
  spec {
    group = "keda.sh"
    names {
      kind      = "ClusterTriggerAuthentication"
      list_kind = "ClusterTriggerAuthenticationList"
      plural    = "clustertriggerauthentications"
      short_names = [
        "cta",
        "clustertriggerauth",
      ]
      singular = "clustertriggerauthentication"
    }
    scope = "Cluster"

    versions {

      additional_printer_columns {
        json_path = ".spec.podIdentity.provider"
        name      = "PodIdentity"
        type      = "string"
      }
      additional_printer_columns {
        json_path = ".spec.secretTargetRef[*].name"
        name      = "Secret"
        type      = "string"
      }
      additional_printer_columns {
        json_path = ".spec.env[*].name"
        name      = "Env"
        type      = "string"
      }
      additional_printer_columns {
        json_path = ".spec.hashiCorpVault.address"
        name      = "VaultAddress"
        type      = "string"
      }
      additional_printer_columns {
        json_path = ".status.scaledobjects"
        name      = "ScaledObjects"
        priority  = 1
        type      = "string"
      }
      additional_printer_columns {
        json_path = ".status.scaledjobs"
        name      = "ScaledJobs"
        priority  = 1
        type      = "string"
      }
      name = "v1alpha1"
      schema {
        open_apiv3_schema = <<-JSON
          {
            "description": "ClusterTriggerAuthentication defines how a trigger can authenticate globally",
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
                "description": "TriggerAuthenticationSpec defines the various ways to authenticate",
                "properties": {
                  "awsSecretManager": {
                    "description": "AwsSecretManager is used to authenticate using AwsSecretManager",
                    "properties": {
                      "credentials": {
                        "properties": {
                          "accessKey": {
                            "properties": {
                              "valueFrom": {
                                "properties": {
                                  "secretKeyRef": {
                                    "properties": {
                                      "key": {
                                        "type": "string"
                                      },
                                      "name": {
                                        "type": "string"
                                      }
                                    },
                                    "required": [
                                      "key",
                                      "name"
                                    ],
                                    "type": "object"
                                  }
                                },
                                "required": [
                                  "secretKeyRef"
                                ],
                                "type": "object"
                              }
                            },
                            "required": [
                              "valueFrom"
                            ],
                            "type": "object"
                          },
                          "accessSecretKey": {
                            "properties": {
                              "valueFrom": {
                                "properties": {
                                  "secretKeyRef": {
                                    "properties": {
                                      "key": {
                                        "type": "string"
                                      },
                                      "name": {
                                        "type": "string"
                                      }
                                    },
                                    "required": [
                                      "key",
                                      "name"
                                    ],
                                    "type": "object"
                                  }
                                },
                                "required": [
                                  "secretKeyRef"
                                ],
                                "type": "object"
                              }
                            },
                            "required": [
                              "valueFrom"
                            ],
                            "type": "object"
                          },
                          "accessToken": {
                            "properties": {
                              "valueFrom": {
                                "properties": {
                                  "secretKeyRef": {
                                    "properties": {
                                      "key": {
                                        "type": "string"
                                      },
                                      "name": {
                                        "type": "string"
                                      }
                                    },
                                    "required": [
                                      "key",
                                      "name"
                                    ],
                                    "type": "object"
                                  }
                                },
                                "required": [
                                  "secretKeyRef"
                                ],
                                "type": "object"
                              }
                            },
                            "required": [
                              "valueFrom"
                            ],
                            "type": "object"
                          }
                        },
                        "required": [
                          "accessKey",
                          "accessSecretKey"
                        ],
                        "type": "object"
                      },
                      "podIdentity": {
                        "description": "AuthPodIdentity allows users to select the platform native identity\nmechanism",
                        "properties": {
                          "identityAuthorityHost": {
                            "description": "Set identityAuthorityHost to override the default Azure authority host. If this is set, then the IdentityTenantID must also be set",
                            "type": "string"
                          },
                          "identityId": {
                            "type": "string"
                          },
                          "identityOwner": {
                            "description": "IdentityOwner configures which identity has to be used during auto discovery, keda or the scaled workload. Mutually exclusive with roleArn",
                            "enum": [
                              "keda",
                              "workload"
                            ],
                            "type": "string"
                          },
                          "identityTenantId": {
                            "description": "Set identityTenantId to override the default Azure tenant id. If this is set, then the IdentityID must also be set",
                            "type": "string"
                          },
                          "provider": {
                            "description": "PodIdentityProvider contains the list of providers",
                            "enum": [
                              "azure",
                              "azure-workload",
                              "gcp",
                              "aws",
                              "aws-eks",
                              "aws-kiam",
                              "none"
                            ],
                            "type": "string"
                          },
                          "roleArn": {
                            "description": "RoleArn sets the AWS RoleArn to be used. Mutually exclusive with IdentityOwner",
                            "type": "string"
                          }
                        },
                        "required": [
                          "provider"
                        ],
                        "type": "object"
                      },
                      "region": {
                        "type": "string"
                      },
                      "secrets": {
                        "items": {
                          "properties": {
                            "name": {
                              "type": "string"
                            },
                            "parameter": {
                              "type": "string"
                            },
                            "versionId": {
                              "type": "string"
                            },
                            "versionStage": {
                              "type": "string"
                            }
                          },
                          "required": [
                            "name",
                            "parameter"
                          ],
                          "type": "object"
                        },
                        "type": "array"
                      }
                    },
                    "required": [
                      "secrets"
                    ],
                    "type": "object"
                  },
                  "azureKeyVault": {
                    "description": "AzureKeyVault is used to authenticate using Azure Key Vault",
                    "properties": {
                      "cloud": {
                        "properties": {
                          "activeDirectoryEndpoint": {
                            "type": "string"
                          },
                          "keyVaultResourceURL": {
                            "type": "string"
                          },
                          "type": {
                            "type": "string"
                          }
                        },
                        "required": [
                          "type"
                        ],
                        "type": "object"
                      },
                      "credentials": {
                        "properties": {
                          "clientId": {
                            "type": "string"
                          },
                          "clientSecret": {
                            "properties": {
                              "valueFrom": {
                                "properties": {
                                  "secretKeyRef": {
                                    "properties": {
                                      "key": {
                                        "type": "string"
                                      },
                                      "name": {
                                        "type": "string"
                                      }
                                    },
                                    "required": [
                                      "key",
                                      "name"
                                    ],
                                    "type": "object"
                                  }
                                },
                                "required": [
                                  "secretKeyRef"
                                ],
                                "type": "object"
                              }
                            },
                            "required": [
                              "valueFrom"
                            ],
                            "type": "object"
                          },
                          "tenantId": {
                            "type": "string"
                          }
                        },
                        "required": [
                          "clientId",
                          "clientSecret",
                          "tenantId"
                        ],
                        "type": "object"
                      },
                      "podIdentity": {
                        "description": "AuthPodIdentity allows users to select the platform native identity\nmechanism",
                        "properties": {
                          "identityAuthorityHost": {
                            "description": "Set identityAuthorityHost to override the default Azure authority host. If this is set, then the IdentityTenantID must also be set",
                            "type": "string"
                          },
                          "identityId": {
                            "type": "string"
                          },
                          "identityOwner": {
                            "description": "IdentityOwner configures which identity has to be used during auto discovery, keda or the scaled workload. Mutually exclusive with roleArn",
                            "enum": [
                              "keda",
                              "workload"
                            ],
                            "type": "string"
                          },
                          "identityTenantId": {
                            "description": "Set identityTenantId to override the default Azure tenant id. If this is set, then the IdentityID must also be set",
                            "type": "string"
                          },
                          "provider": {
                            "description": "PodIdentityProvider contains the list of providers",
                            "enum": [
                              "azure",
                              "azure-workload",
                              "gcp",
                              "aws",
                              "aws-eks",
                              "aws-kiam",
                              "none"
                            ],
                            "type": "string"
                          },
                          "roleArn": {
                            "description": "RoleArn sets the AWS RoleArn to be used. Mutually exclusive with IdentityOwner",
                            "type": "string"
                          }
                        },
                        "required": [
                          "provider"
                        ],
                        "type": "object"
                      },
                      "secrets": {
                        "items": {
                          "properties": {
                            "name": {
                              "type": "string"
                            },
                            "parameter": {
                              "type": "string"
                            },
                            "version": {
                              "type": "string"
                            }
                          },
                          "required": [
                            "name",
                            "parameter"
                          ],
                          "type": "object"
                        },
                        "type": "array"
                      },
                      "vaultUri": {
                        "type": "string"
                      }
                    },
                    "required": [
                      "secrets",
                      "vaultUri"
                    ],
                    "type": "object"
                  },
                  "configMapTargetRef": {
                    "items": {
                      "description": "AuthConfigMapTargetRef is used to authenticate using a reference to a config map",
                      "properties": {
                        "key": {
                          "type": "string"
                        },
                        "name": {
                          "type": "string"
                        },
                        "parameter": {
                          "type": "string"
                        }
                      },
                      "required": [
                        "key",
                        "name",
                        "parameter"
                      ],
                      "type": "object"
                    },
                    "type": "array"
                  },
                  "env": {
                    "items": {
                      "description": "AuthEnvironment is used to authenticate using environment variables\nin the destination ScaleTarget spec",
                      "properties": {
                        "containerName": {
                          "type": "string"
                        },
                        "name": {
                          "type": "string"
                        },
                        "parameter": {
                          "type": "string"
                        }
                      },
                      "required": [
                        "name",
                        "parameter"
                      ],
                      "type": "object"
                    },
                    "type": "array"
                  },
                  "gcpSecretManager": {
                    "properties": {
                      "credentials": {
                        "properties": {
                          "clientSecret": {
                            "properties": {
                              "valueFrom": {
                                "properties": {
                                  "secretKeyRef": {
                                    "properties": {
                                      "key": {
                                        "type": "string"
                                      },
                                      "name": {
                                        "type": "string"
                                      }
                                    },
                                    "required": [
                                      "key",
                                      "name"
                                    ],
                                    "type": "object"
                                  }
                                },
                                "required": [
                                  "secretKeyRef"
                                ],
                                "type": "object"
                              }
                            },
                            "required": [
                              "valueFrom"
                            ],
                            "type": "object"
                          }
                        },
                        "required": [
                          "clientSecret"
                        ],
                        "type": "object"
                      },
                      "podIdentity": {
                        "description": "AuthPodIdentity allows users to select the platform native identity\nmechanism",
                        "properties": {
                          "identityAuthorityHost": {
                            "description": "Set identityAuthorityHost to override the default Azure authority host. If this is set, then the IdentityTenantID must also be set",
                            "type": "string"
                          },
                          "identityId": {
                            "type": "string"
                          },
                          "identityOwner": {
                            "description": "IdentityOwner configures which identity has to be used during auto discovery, keda or the scaled workload. Mutually exclusive with roleArn",
                            "enum": [
                              "keda",
                              "workload"
                            ],
                            "type": "string"
                          },
                          "identityTenantId": {
                            "description": "Set identityTenantId to override the default Azure tenant id. If this is set, then the IdentityID must also be set",
                            "type": "string"
                          },
                          "provider": {
                            "description": "PodIdentityProvider contains the list of providers",
                            "enum": [
                              "azure",
                              "azure-workload",
                              "gcp",
                              "aws",
                              "aws-eks",
                              "aws-kiam",
                              "none"
                            ],
                            "type": "string"
                          },
                          "roleArn": {
                            "description": "RoleArn sets the AWS RoleArn to be used. Mutually exclusive with IdentityOwner",
                            "type": "string"
                          }
                        },
                        "required": [
                          "provider"
                        ],
                        "type": "object"
                      },
                      "secrets": {
                        "items": {
                          "properties": {
                            "id": {
                              "type": "string"
                            },
                            "parameter": {
                              "type": "string"
                            },
                            "version": {
                              "type": "string"
                            }
                          },
                          "required": [
                            "id",
                            "parameter"
                          ],
                          "type": "object"
                        },
                        "type": "array"
                      }
                    },
                    "required": [
                      "secrets"
                    ],
                    "type": "object"
                  },
                  "hashiCorpVault": {
                    "description": "HashiCorpVault is used to authenticate using Hashicorp Vault",
                    "properties": {
                      "address": {
                        "type": "string"
                      },
                      "authentication": {
                        "description": "VaultAuthentication contains the list of Hashicorp Vault authentication methods",
                        "type": "string"
                      },
                      "credential": {
                        "description": "Credential defines the Hashicorp Vault credentials depending on the authentication method",
                        "properties": {
                          "serviceAccount": {
                            "type": "string"
                          },
                          "token": {
                            "type": "string"
                          }
                        },
                        "type": "object"
                      },
                      "mount": {
                        "type": "string"
                      },
                      "namespace": {
                        "type": "string"
                      },
                      "role": {
                        "type": "string"
                      },
                      "secrets": {
                        "items": {
                          "description": "VaultSecret defines the mapping between the path of the secret in Vault to the parameter",
                          "properties": {
                            "key": {
                              "type": "string"
                            },
                            "parameter": {
                              "type": "string"
                            },
                            "path": {
                              "type": "string"
                            },
                            "pkiData": {
                              "properties": {
                                "altNames": {
                                  "type": "string"
                                },
                                "commonName": {
                                  "type": "string"
                                },
                                "format": {
                                  "type": "string"
                                },
                                "ipSans": {
                                  "type": "string"
                                },
                                "otherSans": {
                                  "type": "string"
                                },
                                "ttl": {
                                  "type": "string"
                                },
                                "uriSans": {
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "type": {
                              "description": "VaultSecretType defines the type of vault secret",
                              "type": "string"
                            }
                          },
                          "required": [
                            "key",
                            "parameter",
                            "path"
                          ],
                          "type": "object"
                        },
                        "type": "array"
                      }
                    },
                    "required": [
                      "address",
                      "authentication",
                      "secrets"
                    ],
                    "type": "object"
                  },
                  "podIdentity": {
                    "description": "AuthPodIdentity allows users to select the platform native identity\nmechanism",
                    "properties": {
                      "identityAuthorityHost": {
                        "description": "Set identityAuthorityHost to override the default Azure authority host. If this is set, then the IdentityTenantID must also be set",
                        "type": "string"
                      },
                      "identityId": {
                        "type": "string"
                      },
                      "identityOwner": {
                        "description": "IdentityOwner configures which identity has to be used during auto discovery, keda or the scaled workload. Mutually exclusive with roleArn",
                        "enum": [
                          "keda",
                          "workload"
                        ],
                        "type": "string"
                      },
                      "identityTenantId": {
                        "description": "Set identityTenantId to override the default Azure tenant id. If this is set, then the IdentityID must also be set",
                        "type": "string"
                      },
                      "provider": {
                        "description": "PodIdentityProvider contains the list of providers",
                        "enum": [
                          "azure",
                          "azure-workload",
                          "gcp",
                          "aws",
                          "aws-eks",
                          "aws-kiam",
                          "none"
                        ],
                        "type": "string"
                      },
                      "roleArn": {
                        "description": "RoleArn sets the AWS RoleArn to be used. Mutually exclusive with IdentityOwner",
                        "type": "string"
                      }
                    },
                    "required": [
                      "provider"
                    ],
                    "type": "object"
                  },
                  "secretTargetRef": {
                    "items": {
                      "description": "AuthSecretTargetRef is used to authenticate using a reference to a secret",
                      "properties": {
                        "key": {
                          "type": "string"
                        },
                        "name": {
                          "type": "string"
                        },
                        "parameter": {
                          "type": "string"
                        }
                      },
                      "required": [
                        "key",
                        "name",
                        "parameter"
                      ],
                      "type": "object"
                    },
                    "type": "array"
                  }
                },
                "type": "object"
              },
              "status": {
                "description": "TriggerAuthenticationStatus defines the observed state of TriggerAuthentication",
                "properties": {
                  "scaledjobs": {
                    "type": "string"
                  },
                  "scaledobjects": {
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