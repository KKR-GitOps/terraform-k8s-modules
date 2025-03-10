resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "virtualservices_networking_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "istio-pilot"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name = "virtualservices.networking.istio.io"
  }
  spec {

    additional_printer_columns {
      json_path   = ".spec.gateways"
      description = "The names of gateways and sidecars that should apply these routes"
      name        = "Gateways"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".spec.hosts"
      description = "The destination hosts to which traffic is being sent"
      name        = "Hosts"
      type        = "string"
    }
    additional_printer_columns {
      json_path   = ".metadata.creationTimestamp"
      description = "CreationTimestamp is a timestamp representing the server time when this object was created. It is not guaranteed to be set in happens-before order across separate operations. Clients may not set this value. It is represented in RFC3339 form and is in UTC. Populated by the system. Read-only. Null for lists. More info: https://git.k8s.io/community/contributors/devel/api-conventions.md#metadata"
      name        = "Age"
      type        = "date"
    }
    group = "networking.istio.io"
    names {
      categories = [
        "istio-io",
        "networking-istio-io",
      ]
      kind      = "VirtualService"
      list_kind = "VirtualServiceList"
      plural    = "virtualservices"
      short_names = [
        "vs",
      ]
      singular = "virtualservice"
    }
    scope = "Namespaced"
    subresources {
      status = {
      }
    }
    validation {
      open_apiv3_schema = <<-JSON
        {
          "properties": {
            "spec": {
              "description": "Configuration affecting label/content routing, sni routing, etc. See more details at: https://istio.io/docs/reference/config/networking/virtual-service.html",
              "properties": {
                "exportTo": {
                  "description": "A list of namespaces to which this virtual service is exported.",
                  "items": {
                    "format": "string",
                    "type": "string"
                  },
                  "type": "array"
                },
                "gateways": {
                  "description": "The names of gateways and sidecars that should apply these routes.",
                  "items": {
                    "format": "string",
                    "type": "string"
                  },
                  "type": "array"
                },
                "hosts": {
                  "description": "The destination hosts to which traffic is being sent.",
                  "items": {
                    "format": "string",
                    "type": "string"
                  },
                  "type": "array"
                },
                "http": {
                  "description": "An ordered list of route rules for HTTP traffic.",
                  "items": {
                    "properties": {
                      "corsPolicy": {
                        "description": "Cross-Origin Resource Sharing policy (CORS).",
                        "properties": {
                          "allowCredentials": {
                            "type": "boolean"
                          },
                          "allowHeaders": {
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "allowMethods": {
                            "description": "List of HTTP methods allowed to access the resource.",
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "allowOrigin": {
                            "description": "The list of origins that are allowed to perform CORS requests.",
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "allowOrigins": {
                            "description": "String patterns that match allowed origins.",
                            "items": {
                              "oneOf": [
                                {
                                  "not": {
                                    "anyOf": [
                                      {
                                        "required": [
                                          "exact"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "prefix"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "regex"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                {
                                  "required": [
                                    "exact"
                                  ]
                                },
                                {
                                  "required": [
                                    "prefix"
                                  ]
                                },
                                {
                                  "required": [
                                    "regex"
                                  ]
                                }
                              ],
                              "properties": {
                                "exact": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "prefix": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "regex": {
                                  "format": "string",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "type": "array"
                          },
                          "exposeHeaders": {
                            "items": {
                              "format": "string",
                              "type": "string"
                            },
                            "type": "array"
                          },
                          "maxAge": {
                            "type": "string"
                          }
                        },
                        "type": "object"
                      },
                      "fault": {
                        "description": "Fault injection policy to apply on HTTP traffic at the client side.",
                        "properties": {
                          "abort": {
                            "oneOf": [
                              {
                                "not": {
                                  "anyOf": [
                                    {
                                      "required": [
                                        "httpStatus"
                                      ]
                                    },
                                    {
                                      "required": [
                                        "grpcStatus"
                                      ]
                                    },
                                    {
                                      "required": [
                                        "http2Error"
                                      ]
                                    }
                                  ]
                                }
                              },
                              {
                                "required": [
                                  "httpStatus"
                                ]
                              },
                              {
                                "required": [
                                  "grpcStatus"
                                ]
                              },
                              {
                                "required": [
                                  "http2Error"
                                ]
                              }
                            ],
                            "properties": {
                              "grpcStatus": {
                                "format": "string",
                                "type": "string"
                              },
                              "http2Error": {
                                "format": "string",
                                "type": "string"
                              },
                              "httpStatus": {
                                "description": "HTTP status code to use to abort the Http request.",
                                "format": "int32",
                                "type": "integer"
                              },
                              "percentage": {
                                "description": "Percentage of requests to be aborted with the error code provided.",
                                "properties": {
                                  "value": {
                                    "format": "double",
                                    "type": "number"
                                  }
                                },
                                "type": "object"
                              }
                            },
                            "type": "object"
                          },
                          "delay": {
                            "oneOf": [
                              {
                                "not": {
                                  "anyOf": [
                                    {
                                      "required": [
                                        "fixedDelay"
                                      ]
                                    },
                                    {
                                      "required": [
                                        "exponentialDelay"
                                      ]
                                    }
                                  ]
                                }
                              },
                              {
                                "required": [
                                  "fixedDelay"
                                ]
                              },
                              {
                                "required": [
                                  "exponentialDelay"
                                ]
                              }
                            ],
                            "properties": {
                              "exponentialDelay": {
                                "type": "string"
                              },
                              "fixedDelay": {
                                "description": "Add a fixed delay before forwarding the request.",
                                "type": "string"
                              },
                              "percent": {
                                "description": "Percentage of requests on which the delay will be injected (0-100).",
                                "format": "int32",
                                "type": "integer"
                              },
                              "percentage": {
                                "description": "Percentage of requests on which the delay will be injected.",
                                "properties": {
                                  "value": {
                                    "format": "double",
                                    "type": "number"
                                  }
                                },
                                "type": "object"
                              }
                            },
                            "type": "object"
                          }
                        },
                        "type": "object"
                      },
                      "headers": {
                        "properties": {
                          "request": {
                            "properties": {
                              "add": {
                                "additionalProperties": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "type": "object"
                              },
                              "remove": {
                                "items": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "type": "array"
                              },
                              "set": {
                                "additionalProperties": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "type": "object"
                              }
                            },
                            "type": "object"
                          },
                          "response": {
                            "properties": {
                              "add": {
                                "additionalProperties": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "type": "object"
                              },
                              "remove": {
                                "items": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "type": "array"
                              },
                              "set": {
                                "additionalProperties": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "type": "object"
                              }
                            },
                            "type": "object"
                          }
                        },
                        "type": "object"
                      },
                      "match": {
                        "items": {
                          "properties": {
                            "authority": {
                              "oneOf": [
                                {
                                  "not": {
                                    "anyOf": [
                                      {
                                        "required": [
                                          "exact"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "prefix"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "regex"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                {
                                  "required": [
                                    "exact"
                                  ]
                                },
                                {
                                  "required": [
                                    "prefix"
                                  ]
                                },
                                {
                                  "required": [
                                    "regex"
                                  ]
                                }
                              ],
                              "properties": {
                                "exact": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "prefix": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "regex": {
                                  "format": "string",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "gateways": {
                              "description": "Names of gateways where the rule should be applied.",
                              "items": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "array"
                            },
                            "headers": {
                              "additionalProperties": {
                                "oneOf": [
                                  {
                                    "not": {
                                      "anyOf": [
                                        {
                                          "required": [
                                            "exact"
                                          ]
                                        },
                                        {
                                          "required": [
                                            "prefix"
                                          ]
                                        },
                                        {
                                          "required": [
                                            "regex"
                                          ]
                                        }
                                      ]
                                    }
                                  },
                                  {
                                    "required": [
                                      "exact"
                                    ]
                                  },
                                  {
                                    "required": [
                                      "prefix"
                                    ]
                                  },
                                  {
                                    "required": [
                                      "regex"
                                    ]
                                  }
                                ],
                                "properties": {
                                  "exact": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "prefix": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "regex": {
                                    "format": "string",
                                    "type": "string"
                                  }
                                },
                                "type": "object"
                              },
                              "type": "object"
                            },
                            "ignoreUriCase": {
                              "description": "Flag to specify whether the URI matching should be case-insensitive.",
                              "type": "boolean"
                            },
                            "method": {
                              "oneOf": [
                                {
                                  "not": {
                                    "anyOf": [
                                      {
                                        "required": [
                                          "exact"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "prefix"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "regex"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                {
                                  "required": [
                                    "exact"
                                  ]
                                },
                                {
                                  "required": [
                                    "prefix"
                                  ]
                                },
                                {
                                  "required": [
                                    "regex"
                                  ]
                                }
                              ],
                              "properties": {
                                "exact": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "prefix": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "regex": {
                                  "format": "string",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "name": {
                              "description": "The name assigned to a match.",
                              "format": "string",
                              "type": "string"
                            },
                            "port": {
                              "description": "Specifies the ports on the host that is being addressed.",
                              "type": "integer"
                            },
                            "queryParams": {
                              "additionalProperties": {
                                "oneOf": [
                                  {
                                    "not": {
                                      "anyOf": [
                                        {
                                          "required": [
                                            "exact"
                                          ]
                                        },
                                        {
                                          "required": [
                                            "prefix"
                                          ]
                                        },
                                        {
                                          "required": [
                                            "regex"
                                          ]
                                        }
                                      ]
                                    }
                                  },
                                  {
                                    "required": [
                                      "exact"
                                    ]
                                  },
                                  {
                                    "required": [
                                      "prefix"
                                    ]
                                  },
                                  {
                                    "required": [
                                      "regex"
                                    ]
                                  }
                                ],
                                "properties": {
                                  "exact": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "prefix": {
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "regex": {
                                    "format": "string",
                                    "type": "string"
                                  }
                                },
                                "type": "object"
                              },
                              "description": "Query parameters for matching.",
                              "type": "object"
                            },
                            "scheme": {
                              "oneOf": [
                                {
                                  "not": {
                                    "anyOf": [
                                      {
                                        "required": [
                                          "exact"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "prefix"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "regex"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                {
                                  "required": [
                                    "exact"
                                  ]
                                },
                                {
                                  "required": [
                                    "prefix"
                                  ]
                                },
                                {
                                  "required": [
                                    "regex"
                                  ]
                                }
                              ],
                              "properties": {
                                "exact": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "prefix": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "regex": {
                                  "format": "string",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "sourceLabels": {
                              "additionalProperties": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "object"
                            },
                            "uri": {
                              "oneOf": [
                                {
                                  "not": {
                                    "anyOf": [
                                      {
                                        "required": [
                                          "exact"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "prefix"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "regex"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                {
                                  "required": [
                                    "exact"
                                  ]
                                },
                                {
                                  "required": [
                                    "prefix"
                                  ]
                                },
                                {
                                  "required": [
                                    "regex"
                                  ]
                                }
                              ],
                              "properties": {
                                "exact": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "prefix": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "regex": {
                                  "format": "string",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      },
                      "mirror": {
                        "properties": {
                          "host": {
                            "description": "The name of a service from the service registry.",
                            "format": "string",
                            "type": "string"
                          },
                          "port": {
                            "description": "Specifies the port on the host that is being addressed.",
                            "properties": {
                              "number": {
                                "type": "integer"
                              }
                            },
                            "type": "object"
                          },
                          "subset": {
                            "description": "The name of a subset within the service.",
                            "format": "string",
                            "type": "string"
                          }
                        },
                        "type": "object"
                      },
                      "mirrorPercent": {
                        "description": "Percentage of the traffic to be mirrored by the `mirror` field.",
                        "type": "integer"
                      },
                      "mirrorPercentage": {
                        "description": "Percentage of the traffic to be mirrored by the `mirror` field.",
                        "properties": {
                          "value": {
                            "format": "double",
                            "type": "number"
                          }
                        },
                        "type": "object"
                      },
                      "mirror_percent": {
                        "description": "Percentage of the traffic to be mirrored by the `mirror` field.",
                        "type": "integer"
                      },
                      "name": {
                        "description": "The name assigned to the route for debugging purposes.",
                        "format": "string",
                        "type": "string"
                      },
                      "redirect": {
                        "description": "A HTTP rule can either redirect or forward (default) traffic.",
                        "properties": {
                          "authority": {
                            "format": "string",
                            "type": "string"
                          },
                          "redirectCode": {
                            "type": "integer"
                          },
                          "uri": {
                            "format": "string",
                            "type": "string"
                          }
                        },
                        "type": "object"
                      },
                      "retries": {
                        "description": "Retry policy for HTTP requests.",
                        "properties": {
                          "attempts": {
                            "description": "Number of retries for a given request.",
                            "format": "int32",
                            "type": "integer"
                          },
                          "perTryTimeout": {
                            "description": "Timeout per retry attempt for a given request.",
                            "type": "string"
                          },
                          "retryOn": {
                            "description": "Specifies the conditions under which retry takes place.",
                            "format": "string",
                            "type": "string"
                          }
                        },
                        "type": "object"
                      },
                      "rewrite": {
                        "description": "Rewrite HTTP URIs and Authority headers.",
                        "properties": {
                          "authority": {
                            "description": "rewrite the Authority/Host header with this value.",
                            "format": "string",
                            "type": "string"
                          },
                          "uri": {
                            "format": "string",
                            "type": "string"
                          }
                        },
                        "type": "object"
                      },
                      "route": {
                        "description": "A HTTP rule can either redirect or forward (default) traffic.",
                        "items": {
                          "properties": {
                            "destination": {
                              "properties": {
                                "host": {
                                  "description": "The name of a service from the service registry.",
                                  "format": "string",
                                  "type": "string"
                                },
                                "port": {
                                  "description": "Specifies the port on the host that is being addressed.",
                                  "properties": {
                                    "number": {
                                      "type": "integer"
                                    }
                                  },
                                  "type": "object"
                                },
                                "subset": {
                                  "description": "The name of a subset within the service.",
                                  "format": "string",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "headers": {
                              "properties": {
                                "request": {
                                  "properties": {
                                    "add": {
                                      "additionalProperties": {
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "type": "object"
                                    },
                                    "remove": {
                                      "items": {
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "type": "array"
                                    },
                                    "set": {
                                      "additionalProperties": {
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "type": "object"
                                    }
                                  },
                                  "type": "object"
                                },
                                "response": {
                                  "properties": {
                                    "add": {
                                      "additionalProperties": {
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "type": "object"
                                    },
                                    "remove": {
                                      "items": {
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "type": "array"
                                    },
                                    "set": {
                                      "additionalProperties": {
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "type": "object"
                                    }
                                  },
                                  "type": "object"
                                }
                              },
                              "type": "object"
                            },
                            "weight": {
                              "format": "int32",
                              "type": "integer"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      },
                      "timeout": {
                        "description": "Timeout for HTTP requests.",
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "tcp": {
                  "description": "An ordered list of route rules for opaque TCP traffic.",
                  "items": {
                    "properties": {
                      "match": {
                        "items": {
                          "properties": {
                            "destinationSubnets": {
                              "description": "IPv4 or IPv6 ip addresses of destination with optional subnet.",
                              "items": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "array"
                            },
                            "gateways": {
                              "description": "Names of gateways where the rule should be applied.",
                              "items": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "array"
                            },
                            "port": {
                              "description": "Specifies the port on the host that is being addressed.",
                              "type": "integer"
                            },
                            "sourceLabels": {
                              "additionalProperties": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "object"
                            },
                            "sourceSubnet": {
                              "description": "IPv4 or IPv6 ip address of source with optional subnet.",
                              "format": "string",
                              "type": "string"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      },
                      "route": {
                        "description": "The destination to which the connection should be forwarded to.",
                        "items": {
                          "properties": {
                            "destination": {
                              "properties": {
                                "host": {
                                  "description": "The name of a service from the service registry.",
                                  "format": "string",
                                  "type": "string"
                                },
                                "port": {
                                  "description": "Specifies the port on the host that is being addressed.",
                                  "properties": {
                                    "number": {
                                      "type": "integer"
                                    }
                                  },
                                  "type": "object"
                                },
                                "subset": {
                                  "description": "The name of a subset within the service.",
                                  "format": "string",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "weight": {
                              "format": "int32",
                              "type": "integer"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                },
                "tls": {
                  "items": {
                    "properties": {
                      "match": {
                        "items": {
                          "properties": {
                            "destinationSubnets": {
                              "description": "IPv4 or IPv6 ip addresses of destination with optional subnet.",
                              "items": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "array"
                            },
                            "gateways": {
                              "description": "Names of gateways where the rule should be applied.",
                              "items": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "array"
                            },
                            "port": {
                              "description": "Specifies the port on the host that is being addressed.",
                              "type": "integer"
                            },
                            "sniHosts": {
                              "description": "SNI (server name indicator) to match on.",
                              "items": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "array"
                            },
                            "sourceLabels": {
                              "additionalProperties": {
                                "format": "string",
                                "type": "string"
                              },
                              "type": "object"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      },
                      "route": {
                        "description": "The destination to which the connection should be forwarded to.",
                        "items": {
                          "properties": {
                            "destination": {
                              "properties": {
                                "host": {
                                  "description": "The name of a service from the service registry.",
                                  "format": "string",
                                  "type": "string"
                                },
                                "port": {
                                  "description": "Specifies the port on the host that is being addressed.",
                                  "properties": {
                                    "number": {
                                      "type": "integer"
                                    }
                                  },
                                  "type": "object"
                                },
                                "subset": {
                                  "description": "The name of a subset within the service.",
                                  "format": "string",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "weight": {
                              "format": "int32",
                              "type": "integer"
                            }
                          },
                          "type": "object"
                        },
                        "type": "array"
                      }
                    },
                    "type": "object"
                  },
                  "type": "array"
                }
              },
              "type": "object"
            }
          },
          "type": "object"
        }
        JSON
    }

    versions {
      name    = "v1alpha3"
      served  = true
      storage = true
    }
    versions {
      name    = "v1beta1"
      served  = true
      storage = false
    }
  }
}