resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "destinationrules_networking_istio_io" {
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
    name = "destinationrules.networking.istio.io"
  }
  spec {

    additional_printer_columns {
      json_path   = ".spec.host"
      description = "The name of a service from the service registry"
      name        = "Host"
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
      kind      = "DestinationRule"
      list_kind = "DestinationRuleList"
      plural    = "destinationrules"
      short_names = [
        "dr",
      ]
      singular = "destinationrule"
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
              "description": "Configuration affecting load balancing, outlier detection, etc. See more details at: https://istio.io/docs/reference/config/networking/destination-rule.html",
              "properties": {
                "exportTo": {
                  "description": "A list of namespaces to which this destination rule is exported.",
                  "items": {
                    "format": "string",
                    "type": "string"
                  },
                  "type": "array"
                },
                "host": {
                  "description": "The name of a service from the service registry.",
                  "format": "string",
                  "type": "string"
                },
                "subsets": {
                  "items": {
                    "properties": {
                      "labels": {
                        "additionalProperties": {
                          "format": "string",
                          "type": "string"
                        },
                        "type": "object"
                      },
                      "name": {
                        "description": "Name of the subset.",
                        "format": "string",
                        "type": "string"
                      },
                      "trafficPolicy": {
                        "description": "Traffic policies that apply to this subset.",
                        "properties": {
                          "connectionPool": {
                            "properties": {
                              "http": {
                                "description": "HTTP connection pool settings.",
                                "properties": {
                                  "h2UpgradePolicy": {
                                    "description": "Specify if http1.1 connection should be upgraded to http2 for the associated destination.",
                                    "enum": [
                                      "DEFAULT",
                                      "DO_NOT_UPGRADE",
                                      "UPGRADE"
                                    ],
                                    "type": "string"
                                  },
                                  "http1MaxPendingRequests": {
                                    "description": "Maximum number of pending HTTP requests to a destination.",
                                    "format": "int32",
                                    "type": "integer"
                                  },
                                  "http2MaxRequests": {
                                    "description": "Maximum number of requests to a backend.",
                                    "format": "int32",
                                    "type": "integer"
                                  },
                                  "idleTimeout": {
                                    "description": "The idle timeout for upstream connection pool connections.",
                                    "type": "string"
                                  },
                                  "maxRequestsPerConnection": {
                                    "description": "Maximum number of requests per connection to a backend.",
                                    "format": "int32",
                                    "type": "integer"
                                  },
                                  "maxRetries": {
                                    "format": "int32",
                                    "type": "integer"
                                  }
                                },
                                "type": "object"
                              },
                              "tcp": {
                                "description": "Settings common to both HTTP and TCP upstream connections.",
                                "properties": {
                                  "connectTimeout": {
                                    "description": "TCP connection timeout.",
                                    "type": "string"
                                  },
                                  "maxConnections": {
                                    "description": "Maximum number of HTTP1 /TCP connections to a destination host.",
                                    "format": "int32",
                                    "type": "integer"
                                  },
                                  "tcpKeepalive": {
                                    "description": "If set then set SO_KEEPALIVE on the socket to enable TCP Keepalives.",
                                    "properties": {
                                      "interval": {
                                        "description": "The time duration between keep-alive probes.",
                                        "type": "string"
                                      },
                                      "probes": {
                                        "type": "integer"
                                      },
                                      "time": {
                                        "type": "string"
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
                          "loadBalancer": {
                            "description": "Settings controlling the load balancer algorithms.",
                            "oneOf": [
                              {
                                "not": {
                                  "anyOf": [
                                    {
                                      "required": [
                                        "simple"
                                      ]
                                    },
                                    {
                                      "properties": {
                                        "consistentHash": {
                                          "oneOf": [
                                            {
                                              "not": {
                                                "anyOf": [
                                                  {
                                                    "required": [
                                                      "httpHeaderName"
                                                    ]
                                                  },
                                                  {
                                                    "required": [
                                                      "httpCookie"
                                                    ]
                                                  },
                                                  {
                                                    "required": [
                                                      "useSourceIp"
                                                    ]
                                                  }
                                                ]
                                              }
                                            },
                                            {
                                              "required": [
                                                "httpHeaderName"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "httpCookie"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "useSourceIp"
                                              ]
                                            }
                                          ]
                                        }
                                      },
                                      "required": [
                                        "consistentHash"
                                      ]
                                    }
                                  ]
                                }
                              },
                              {
                                "required": [
                                  "simple"
                                ]
                              },
                              {
                                "properties": {
                                  "consistentHash": {
                                    "oneOf": [
                                      {
                                        "not": {
                                          "anyOf": [
                                            {
                                              "required": [
                                                "httpHeaderName"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "httpCookie"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "useSourceIp"
                                              ]
                                            }
                                          ]
                                        }
                                      },
                                      {
                                        "required": [
                                          "httpHeaderName"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "httpCookie"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "useSourceIp"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                "required": [
                                  "consistentHash"
                                ]
                              }
                            ],
                            "properties": {
                              "consistentHash": {
                                "properties": {
                                  "httpCookie": {
                                    "description": "Hash based on HTTP cookie.",
                                    "properties": {
                                      "name": {
                                        "description": "Name of the cookie.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "path": {
                                        "description": "Path to set for the cookie.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "ttl": {
                                        "description": "Lifetime of the cookie.",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "httpHeaderName": {
                                    "description": "Hash based on a specific HTTP header.",
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "minimumRingSize": {
                                    "type": "integer"
                                  },
                                  "useSourceIp": {
                                    "description": "Hash based on the source IP address.",
                                    "type": "boolean"
                                  }
                                },
                                "type": "object"
                              },
                              "localityLbSetting": {
                                "properties": {
                                  "distribute": {
                                    "description": "Optional: only one of distribute or failover can be set.",
                                    "items": {
                                      "properties": {
                                        "from": {
                                          "description": "Originating locality, '/' separated, e.g.",
                                          "format": "string",
                                          "type": "string"
                                        },
                                        "to": {
                                          "additionalProperties": {
                                            "type": "integer"
                                          },
                                          "description": "Map of upstream localities to traffic distribution weights.",
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "type": "array"
                                  },
                                  "enabled": {
                                    "description": "enable locality load balancing, this is DestinationRule-level and will override mesh wide settings in entirety.",
                                    "type": "boolean"
                                  },
                                  "failover": {
                                    "description": "Optional: only failover or distribute can be set.",
                                    "items": {
                                      "properties": {
                                        "from": {
                                          "description": "Originating region.",
                                          "format": "string",
                                          "type": "string"
                                        },
                                        "to": {
                                          "format": "string",
                                          "type": "string"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "type": "array"
                                  }
                                },
                                "type": "object"
                              },
                              "simple": {
                                "enum": [
                                  "ROUND_ROBIN",
                                  "LEAST_CONN",
                                  "RANDOM",
                                  "PASSTHROUGH"
                                ],
                                "type": "string"
                              }
                            },
                            "type": "object"
                          },
                          "outlierDetection": {
                            "properties": {
                              "baseEjectionTime": {
                                "description": "Minimum ejection duration.",
                                "type": "string"
                              },
                              "consecutive5xxErrors": {
                                "description": "Number of 5xx errors before a host is ejected from the connection pool.",
                                "type": "integer"
                              },
                              "consecutiveErrors": {
                                "format": "int32",
                                "type": "integer"
                              },
                              "consecutiveGatewayErrors": {
                                "description": "Number of gateway errors before a host is ejected from the connection pool.",
                                "type": "integer"
                              },
                              "interval": {
                                "description": "Time interval between ejection sweep analysis.",
                                "type": "string"
                              },
                              "maxEjectionPercent": {
                                "format": "int32",
                                "type": "integer"
                              },
                              "minHealthPercent": {
                                "format": "int32",
                                "type": "integer"
                              }
                            },
                            "type": "object"
                          },
                          "portLevelSettings": {
                            "description": "Traffic policies specific to individual ports.",
                            "items": {
                              "properties": {
                                "connectionPool": {
                                  "properties": {
                                    "http": {
                                      "description": "HTTP connection pool settings.",
                                      "properties": {
                                        "h2UpgradePolicy": {
                                          "description": "Specify if http1.1 connection should be upgraded to http2 for the associated destination.",
                                          "enum": [
                                            "DEFAULT",
                                            "DO_NOT_UPGRADE",
                                            "UPGRADE"
                                          ],
                                          "type": "string"
                                        },
                                        "http1MaxPendingRequests": {
                                          "description": "Maximum number of pending HTTP requests to a destination.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "http2MaxRequests": {
                                          "description": "Maximum number of requests to a backend.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "idleTimeout": {
                                          "description": "The idle timeout for upstream connection pool connections.",
                                          "type": "string"
                                        },
                                        "maxRequestsPerConnection": {
                                          "description": "Maximum number of requests per connection to a backend.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "maxRetries": {
                                          "format": "int32",
                                          "type": "integer"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "tcp": {
                                      "description": "Settings common to both HTTP and TCP upstream connections.",
                                      "properties": {
                                        "connectTimeout": {
                                          "description": "TCP connection timeout.",
                                          "type": "string"
                                        },
                                        "maxConnections": {
                                          "description": "Maximum number of HTTP1 /TCP connections to a destination host.",
                                          "format": "int32",
                                          "type": "integer"
                                        },
                                        "tcpKeepalive": {
                                          "description": "If set then set SO_KEEPALIVE on the socket to enable TCP Keepalives.",
                                          "properties": {
                                            "interval": {
                                              "description": "The time duration between keep-alive probes.",
                                              "type": "string"
                                            },
                                            "probes": {
                                              "type": "integer"
                                            },
                                            "time": {
                                              "type": "string"
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
                                "loadBalancer": {
                                  "description": "Settings controlling the load balancer algorithms.",
                                  "oneOf": [
                                    {
                                      "not": {
                                        "anyOf": [
                                          {
                                            "required": [
                                              "simple"
                                            ]
                                          },
                                          {
                                            "properties": {
                                              "consistentHash": {
                                                "oneOf": [
                                                  {
                                                    "not": {
                                                      "anyOf": [
                                                        {
                                                          "required": [
                                                            "httpHeaderName"
                                                          ]
                                                        },
                                                        {
                                                          "required": [
                                                            "httpCookie"
                                                          ]
                                                        },
                                                        {
                                                          "required": [
                                                            "useSourceIp"
                                                          ]
                                                        }
                                                      ]
                                                    }
                                                  },
                                                  {
                                                    "required": [
                                                      "httpHeaderName"
                                                    ]
                                                  },
                                                  {
                                                    "required": [
                                                      "httpCookie"
                                                    ]
                                                  },
                                                  {
                                                    "required": [
                                                      "useSourceIp"
                                                    ]
                                                  }
                                                ]
                                              }
                                            },
                                            "required": [
                                              "consistentHash"
                                            ]
                                          }
                                        ]
                                      }
                                    },
                                    {
                                      "required": [
                                        "simple"
                                      ]
                                    },
                                    {
                                      "properties": {
                                        "consistentHash": {
                                          "oneOf": [
                                            {
                                              "not": {
                                                "anyOf": [
                                                  {
                                                    "required": [
                                                      "httpHeaderName"
                                                    ]
                                                  },
                                                  {
                                                    "required": [
                                                      "httpCookie"
                                                    ]
                                                  },
                                                  {
                                                    "required": [
                                                      "useSourceIp"
                                                    ]
                                                  }
                                                ]
                                              }
                                            },
                                            {
                                              "required": [
                                                "httpHeaderName"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "httpCookie"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "useSourceIp"
                                              ]
                                            }
                                          ]
                                        }
                                      },
                                      "required": [
                                        "consistentHash"
                                      ]
                                    }
                                  ],
                                  "properties": {
                                    "consistentHash": {
                                      "properties": {
                                        "httpCookie": {
                                          "description": "Hash based on HTTP cookie.",
                                          "properties": {
                                            "name": {
                                              "description": "Name of the cookie.",
                                              "format": "string",
                                              "type": "string"
                                            },
                                            "path": {
                                              "description": "Path to set for the cookie.",
                                              "format": "string",
                                              "type": "string"
                                            },
                                            "ttl": {
                                              "description": "Lifetime of the cookie.",
                                              "type": "string"
                                            }
                                          },
                                          "type": "object"
                                        },
                                        "httpHeaderName": {
                                          "description": "Hash based on a specific HTTP header.",
                                          "format": "string",
                                          "type": "string"
                                        },
                                        "minimumRingSize": {
                                          "type": "integer"
                                        },
                                        "useSourceIp": {
                                          "description": "Hash based on the source IP address.",
                                          "type": "boolean"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "localityLbSetting": {
                                      "properties": {
                                        "distribute": {
                                          "description": "Optional: only one of distribute or failover can be set.",
                                          "items": {
                                            "properties": {
                                              "from": {
                                                "description": "Originating locality, '/' separated, e.g.",
                                                "format": "string",
                                                "type": "string"
                                              },
                                              "to": {
                                                "additionalProperties": {
                                                  "type": "integer"
                                                },
                                                "description": "Map of upstream localities to traffic distribution weights.",
                                                "type": "object"
                                              }
                                            },
                                            "type": "object"
                                          },
                                          "type": "array"
                                        },
                                        "enabled": {
                                          "description": "enable locality load balancing, this is DestinationRule-level and will override mesh wide settings in entirety.",
                                          "type": "boolean"
                                        },
                                        "failover": {
                                          "description": "Optional: only failover or distribute can be set.",
                                          "items": {
                                            "properties": {
                                              "from": {
                                                "description": "Originating region.",
                                                "format": "string",
                                                "type": "string"
                                              },
                                              "to": {
                                                "format": "string",
                                                "type": "string"
                                              }
                                            },
                                            "type": "object"
                                          },
                                          "type": "array"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "simple": {
                                      "enum": [
                                        "ROUND_ROBIN",
                                        "LEAST_CONN",
                                        "RANDOM",
                                        "PASSTHROUGH"
                                      ],
                                      "type": "string"
                                    }
                                  },
                                  "type": "object"
                                },
                                "outlierDetection": {
                                  "properties": {
                                    "baseEjectionTime": {
                                      "description": "Minimum ejection duration.",
                                      "type": "string"
                                    },
                                    "consecutive5xxErrors": {
                                      "description": "Number of 5xx errors before a host is ejected from the connection pool.",
                                      "type": "integer"
                                    },
                                    "consecutiveErrors": {
                                      "format": "int32",
                                      "type": "integer"
                                    },
                                    "consecutiveGatewayErrors": {
                                      "description": "Number of gateway errors before a host is ejected from the connection pool.",
                                      "type": "integer"
                                    },
                                    "interval": {
                                      "description": "Time interval between ejection sweep analysis.",
                                      "type": "string"
                                    },
                                    "maxEjectionPercent": {
                                      "format": "int32",
                                      "type": "integer"
                                    },
                                    "minHealthPercent": {
                                      "format": "int32",
                                      "type": "integer"
                                    }
                                  },
                                  "type": "object"
                                },
                                "port": {
                                  "properties": {
                                    "number": {
                                      "type": "integer"
                                    }
                                  },
                                  "type": "object"
                                },
                                "tls": {
                                  "description": "TLS related settings for connections to the upstream service.",
                                  "properties": {
                                    "caCertificates": {
                                      "format": "string",
                                      "type": "string"
                                    },
                                    "clientCertificate": {
                                      "description": "REQUIRED if mode is `MUTUAL`.",
                                      "format": "string",
                                      "type": "string"
                                    },
                                    "mode": {
                                      "enum": [
                                        "DISABLE",
                                        "SIMPLE",
                                        "MUTUAL",
                                        "ISTIO_MUTUAL"
                                      ],
                                      "type": "string"
                                    },
                                    "privateKey": {
                                      "description": "REQUIRED if mode is `MUTUAL`.",
                                      "format": "string",
                                      "type": "string"
                                    },
                                    "sni": {
                                      "description": "SNI string to present to the server during TLS handshake.",
                                      "format": "string",
                                      "type": "string"
                                    },
                                    "subjectAltNames": {
                                      "items": {
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "type": "array"
                                    }
                                  },
                                  "type": "object"
                                }
                              },
                              "type": "object"
                            },
                            "type": "array"
                          },
                          "tls": {
                            "description": "TLS related settings for connections to the upstream service.",
                            "properties": {
                              "caCertificates": {
                                "format": "string",
                                "type": "string"
                              },
                              "clientCertificate": {
                                "description": "REQUIRED if mode is `MUTUAL`.",
                                "format": "string",
                                "type": "string"
                              },
                              "mode": {
                                "enum": [
                                  "DISABLE",
                                  "SIMPLE",
                                  "MUTUAL",
                                  "ISTIO_MUTUAL"
                                ],
                                "type": "string"
                              },
                              "privateKey": {
                                "description": "REQUIRED if mode is `MUTUAL`.",
                                "format": "string",
                                "type": "string"
                              },
                              "sni": {
                                "description": "SNI string to present to the server during TLS handshake.",
                                "format": "string",
                                "type": "string"
                              },
                              "subjectAltNames": {
                                "items": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "type": "array"
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
                  "type": "array"
                },
                "trafficPolicy": {
                  "properties": {
                    "connectionPool": {
                      "properties": {
                        "http": {
                          "description": "HTTP connection pool settings.",
                          "properties": {
                            "h2UpgradePolicy": {
                              "description": "Specify if http1.1 connection should be upgraded to http2 for the associated destination.",
                              "enum": [
                                "DEFAULT",
                                "DO_NOT_UPGRADE",
                                "UPGRADE"
                              ],
                              "type": "string"
                            },
                            "http1MaxPendingRequests": {
                              "description": "Maximum number of pending HTTP requests to a destination.",
                              "format": "int32",
                              "type": "integer"
                            },
                            "http2MaxRequests": {
                              "description": "Maximum number of requests to a backend.",
                              "format": "int32",
                              "type": "integer"
                            },
                            "idleTimeout": {
                              "description": "The idle timeout for upstream connection pool connections.",
                              "type": "string"
                            },
                            "maxRequestsPerConnection": {
                              "description": "Maximum number of requests per connection to a backend.",
                              "format": "int32",
                              "type": "integer"
                            },
                            "maxRetries": {
                              "format": "int32",
                              "type": "integer"
                            }
                          },
                          "type": "object"
                        },
                        "tcp": {
                          "description": "Settings common to both HTTP and TCP upstream connections.",
                          "properties": {
                            "connectTimeout": {
                              "description": "TCP connection timeout.",
                              "type": "string"
                            },
                            "maxConnections": {
                              "description": "Maximum number of HTTP1 /TCP connections to a destination host.",
                              "format": "int32",
                              "type": "integer"
                            },
                            "tcpKeepalive": {
                              "description": "If set then set SO_KEEPALIVE on the socket to enable TCP Keepalives.",
                              "properties": {
                                "interval": {
                                  "description": "The time duration between keep-alive probes.",
                                  "type": "string"
                                },
                                "probes": {
                                  "type": "integer"
                                },
                                "time": {
                                  "type": "string"
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
                    "loadBalancer": {
                      "description": "Settings controlling the load balancer algorithms.",
                      "oneOf": [
                        {
                          "not": {
                            "anyOf": [
                              {
                                "required": [
                                  "simple"
                                ]
                              },
                              {
                                "properties": {
                                  "consistentHash": {
                                    "oneOf": [
                                      {
                                        "not": {
                                          "anyOf": [
                                            {
                                              "required": [
                                                "httpHeaderName"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "httpCookie"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "useSourceIp"
                                              ]
                                            }
                                          ]
                                        }
                                      },
                                      {
                                        "required": [
                                          "httpHeaderName"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "httpCookie"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "useSourceIp"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                "required": [
                                  "consistentHash"
                                ]
                              }
                            ]
                          }
                        },
                        {
                          "required": [
                            "simple"
                          ]
                        },
                        {
                          "properties": {
                            "consistentHash": {
                              "oneOf": [
                                {
                                  "not": {
                                    "anyOf": [
                                      {
                                        "required": [
                                          "httpHeaderName"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "httpCookie"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "useSourceIp"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                {
                                  "required": [
                                    "httpHeaderName"
                                  ]
                                },
                                {
                                  "required": [
                                    "httpCookie"
                                  ]
                                },
                                {
                                  "required": [
                                    "useSourceIp"
                                  ]
                                }
                              ]
                            }
                          },
                          "required": [
                            "consistentHash"
                          ]
                        }
                      ],
                      "properties": {
                        "consistentHash": {
                          "properties": {
                            "httpCookie": {
                              "description": "Hash based on HTTP cookie.",
                              "properties": {
                                "name": {
                                  "description": "Name of the cookie.",
                                  "format": "string",
                                  "type": "string"
                                },
                                "path": {
                                  "description": "Path to set for the cookie.",
                                  "format": "string",
                                  "type": "string"
                                },
                                "ttl": {
                                  "description": "Lifetime of the cookie.",
                                  "type": "string"
                                }
                              },
                              "type": "object"
                            },
                            "httpHeaderName": {
                              "description": "Hash based on a specific HTTP header.",
                              "format": "string",
                              "type": "string"
                            },
                            "minimumRingSize": {
                              "type": "integer"
                            },
                            "useSourceIp": {
                              "description": "Hash based on the source IP address.",
                              "type": "boolean"
                            }
                          },
                          "type": "object"
                        },
                        "localityLbSetting": {
                          "properties": {
                            "distribute": {
                              "description": "Optional: only one of distribute or failover can be set.",
                              "items": {
                                "properties": {
                                  "from": {
                                    "description": "Originating locality, '/' separated, e.g.",
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "to": {
                                    "additionalProperties": {
                                      "type": "integer"
                                    },
                                    "description": "Map of upstream localities to traffic distribution weights.",
                                    "type": "object"
                                  }
                                },
                                "type": "object"
                              },
                              "type": "array"
                            },
                            "enabled": {
                              "description": "enable locality load balancing, this is DestinationRule-level and will override mesh wide settings in entirety.",
                              "type": "boolean"
                            },
                            "failover": {
                              "description": "Optional: only failover or distribute can be set.",
                              "items": {
                                "properties": {
                                  "from": {
                                    "description": "Originating region.",
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "to": {
                                    "format": "string",
                                    "type": "string"
                                  }
                                },
                                "type": "object"
                              },
                              "type": "array"
                            }
                          },
                          "type": "object"
                        },
                        "simple": {
                          "enum": [
                            "ROUND_ROBIN",
                            "LEAST_CONN",
                            "RANDOM",
                            "PASSTHROUGH"
                          ],
                          "type": "string"
                        }
                      },
                      "type": "object"
                    },
                    "outlierDetection": {
                      "properties": {
                        "baseEjectionTime": {
                          "description": "Minimum ejection duration.",
                          "type": "string"
                        },
                        "consecutive5xxErrors": {
                          "description": "Number of 5xx errors before a host is ejected from the connection pool.",
                          "type": "integer"
                        },
                        "consecutiveErrors": {
                          "format": "int32",
                          "type": "integer"
                        },
                        "consecutiveGatewayErrors": {
                          "description": "Number of gateway errors before a host is ejected from the connection pool.",
                          "type": "integer"
                        },
                        "interval": {
                          "description": "Time interval between ejection sweep analysis.",
                          "type": "string"
                        },
                        "maxEjectionPercent": {
                          "format": "int32",
                          "type": "integer"
                        },
                        "minHealthPercent": {
                          "format": "int32",
                          "type": "integer"
                        }
                      },
                      "type": "object"
                    },
                    "portLevelSettings": {
                      "description": "Traffic policies specific to individual ports.",
                      "items": {
                        "properties": {
                          "connectionPool": {
                            "properties": {
                              "http": {
                                "description": "HTTP connection pool settings.",
                                "properties": {
                                  "h2UpgradePolicy": {
                                    "description": "Specify if http1.1 connection should be upgraded to http2 for the associated destination.",
                                    "enum": [
                                      "DEFAULT",
                                      "DO_NOT_UPGRADE",
                                      "UPGRADE"
                                    ],
                                    "type": "string"
                                  },
                                  "http1MaxPendingRequests": {
                                    "description": "Maximum number of pending HTTP requests to a destination.",
                                    "format": "int32",
                                    "type": "integer"
                                  },
                                  "http2MaxRequests": {
                                    "description": "Maximum number of requests to a backend.",
                                    "format": "int32",
                                    "type": "integer"
                                  },
                                  "idleTimeout": {
                                    "description": "The idle timeout for upstream connection pool connections.",
                                    "type": "string"
                                  },
                                  "maxRequestsPerConnection": {
                                    "description": "Maximum number of requests per connection to a backend.",
                                    "format": "int32",
                                    "type": "integer"
                                  },
                                  "maxRetries": {
                                    "format": "int32",
                                    "type": "integer"
                                  }
                                },
                                "type": "object"
                              },
                              "tcp": {
                                "description": "Settings common to both HTTP and TCP upstream connections.",
                                "properties": {
                                  "connectTimeout": {
                                    "description": "TCP connection timeout.",
                                    "type": "string"
                                  },
                                  "maxConnections": {
                                    "description": "Maximum number of HTTP1 /TCP connections to a destination host.",
                                    "format": "int32",
                                    "type": "integer"
                                  },
                                  "tcpKeepalive": {
                                    "description": "If set then set SO_KEEPALIVE on the socket to enable TCP Keepalives.",
                                    "properties": {
                                      "interval": {
                                        "description": "The time duration between keep-alive probes.",
                                        "type": "string"
                                      },
                                      "probes": {
                                        "type": "integer"
                                      },
                                      "time": {
                                        "type": "string"
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
                          "loadBalancer": {
                            "description": "Settings controlling the load balancer algorithms.",
                            "oneOf": [
                              {
                                "not": {
                                  "anyOf": [
                                    {
                                      "required": [
                                        "simple"
                                      ]
                                    },
                                    {
                                      "properties": {
                                        "consistentHash": {
                                          "oneOf": [
                                            {
                                              "not": {
                                                "anyOf": [
                                                  {
                                                    "required": [
                                                      "httpHeaderName"
                                                    ]
                                                  },
                                                  {
                                                    "required": [
                                                      "httpCookie"
                                                    ]
                                                  },
                                                  {
                                                    "required": [
                                                      "useSourceIp"
                                                    ]
                                                  }
                                                ]
                                              }
                                            },
                                            {
                                              "required": [
                                                "httpHeaderName"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "httpCookie"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "useSourceIp"
                                              ]
                                            }
                                          ]
                                        }
                                      },
                                      "required": [
                                        "consistentHash"
                                      ]
                                    }
                                  ]
                                }
                              },
                              {
                                "required": [
                                  "simple"
                                ]
                              },
                              {
                                "properties": {
                                  "consistentHash": {
                                    "oneOf": [
                                      {
                                        "not": {
                                          "anyOf": [
                                            {
                                              "required": [
                                                "httpHeaderName"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "httpCookie"
                                              ]
                                            },
                                            {
                                              "required": [
                                                "useSourceIp"
                                              ]
                                            }
                                          ]
                                        }
                                      },
                                      {
                                        "required": [
                                          "httpHeaderName"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "httpCookie"
                                        ]
                                      },
                                      {
                                        "required": [
                                          "useSourceIp"
                                        ]
                                      }
                                    ]
                                  }
                                },
                                "required": [
                                  "consistentHash"
                                ]
                              }
                            ],
                            "properties": {
                              "consistentHash": {
                                "properties": {
                                  "httpCookie": {
                                    "description": "Hash based on HTTP cookie.",
                                    "properties": {
                                      "name": {
                                        "description": "Name of the cookie.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "path": {
                                        "description": "Path to set for the cookie.",
                                        "format": "string",
                                        "type": "string"
                                      },
                                      "ttl": {
                                        "description": "Lifetime of the cookie.",
                                        "type": "string"
                                      }
                                    },
                                    "type": "object"
                                  },
                                  "httpHeaderName": {
                                    "description": "Hash based on a specific HTTP header.",
                                    "format": "string",
                                    "type": "string"
                                  },
                                  "minimumRingSize": {
                                    "type": "integer"
                                  },
                                  "useSourceIp": {
                                    "description": "Hash based on the source IP address.",
                                    "type": "boolean"
                                  }
                                },
                                "type": "object"
                              },
                              "localityLbSetting": {
                                "properties": {
                                  "distribute": {
                                    "description": "Optional: only one of distribute or failover can be set.",
                                    "items": {
                                      "properties": {
                                        "from": {
                                          "description": "Originating locality, '/' separated, e.g.",
                                          "format": "string",
                                          "type": "string"
                                        },
                                        "to": {
                                          "additionalProperties": {
                                            "type": "integer"
                                          },
                                          "description": "Map of upstream localities to traffic distribution weights.",
                                          "type": "object"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "type": "array"
                                  },
                                  "enabled": {
                                    "description": "enable locality load balancing, this is DestinationRule-level and will override mesh wide settings in entirety.",
                                    "type": "boolean"
                                  },
                                  "failover": {
                                    "description": "Optional: only failover or distribute can be set.",
                                    "items": {
                                      "properties": {
                                        "from": {
                                          "description": "Originating region.",
                                          "format": "string",
                                          "type": "string"
                                        },
                                        "to": {
                                          "format": "string",
                                          "type": "string"
                                        }
                                      },
                                      "type": "object"
                                    },
                                    "type": "array"
                                  }
                                },
                                "type": "object"
                              },
                              "simple": {
                                "enum": [
                                  "ROUND_ROBIN",
                                  "LEAST_CONN",
                                  "RANDOM",
                                  "PASSTHROUGH"
                                ],
                                "type": "string"
                              }
                            },
                            "type": "object"
                          },
                          "outlierDetection": {
                            "properties": {
                              "baseEjectionTime": {
                                "description": "Minimum ejection duration.",
                                "type": "string"
                              },
                              "consecutive5xxErrors": {
                                "description": "Number of 5xx errors before a host is ejected from the connection pool.",
                                "type": "integer"
                              },
                              "consecutiveErrors": {
                                "format": "int32",
                                "type": "integer"
                              },
                              "consecutiveGatewayErrors": {
                                "description": "Number of gateway errors before a host is ejected from the connection pool.",
                                "type": "integer"
                              },
                              "interval": {
                                "description": "Time interval between ejection sweep analysis.",
                                "type": "string"
                              },
                              "maxEjectionPercent": {
                                "format": "int32",
                                "type": "integer"
                              },
                              "minHealthPercent": {
                                "format": "int32",
                                "type": "integer"
                              }
                            },
                            "type": "object"
                          },
                          "port": {
                            "properties": {
                              "number": {
                                "type": "integer"
                              }
                            },
                            "type": "object"
                          },
                          "tls": {
                            "description": "TLS related settings for connections to the upstream service.",
                            "properties": {
                              "caCertificates": {
                                "format": "string",
                                "type": "string"
                              },
                              "clientCertificate": {
                                "description": "REQUIRED if mode is `MUTUAL`.",
                                "format": "string",
                                "type": "string"
                              },
                              "mode": {
                                "enum": [
                                  "DISABLE",
                                  "SIMPLE",
                                  "MUTUAL",
                                  "ISTIO_MUTUAL"
                                ],
                                "type": "string"
                              },
                              "privateKey": {
                                "description": "REQUIRED if mode is `MUTUAL`.",
                                "format": "string",
                                "type": "string"
                              },
                              "sni": {
                                "description": "SNI string to present to the server during TLS handshake.",
                                "format": "string",
                                "type": "string"
                              },
                              "subjectAltNames": {
                                "items": {
                                  "format": "string",
                                  "type": "string"
                                },
                                "type": "array"
                              }
                            },
                            "type": "object"
                          }
                        },
                        "type": "object"
                      },
                      "type": "array"
                    },
                    "tls": {
                      "description": "TLS related settings for connections to the upstream service.",
                      "properties": {
                        "caCertificates": {
                          "format": "string",
                          "type": "string"
                        },
                        "clientCertificate": {
                          "description": "REQUIRED if mode is `MUTUAL`.",
                          "format": "string",
                          "type": "string"
                        },
                        "mode": {
                          "enum": [
                            "DISABLE",
                            "SIMPLE",
                            "MUTUAL",
                            "ISTIO_MUTUAL"
                          ],
                          "type": "string"
                        },
                        "privateKey": {
                          "description": "REQUIRED if mode is `MUTUAL`.",
                          "format": "string",
                          "type": "string"
                        },
                        "sni": {
                          "description": "SNI string to present to the server during TLS handshake.",
                          "format": "string",
                          "type": "string"
                        },
                        "subjectAltNames": {
                          "items": {
                            "format": "string",
                            "type": "string"
                          },
                          "type": "array"
                        }
                      },
                      "type": "object"
                    }
                  },
                  "type": "object"
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