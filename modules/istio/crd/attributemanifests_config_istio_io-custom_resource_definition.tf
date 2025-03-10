resource "k8s_apiextensions_k8s_io_v1beta1_custom_resource_definition" "attributemanifests_config_istio_io" {
  metadata {
    annotations = {
      "helm.sh/resource-policy" = "keep"
    }
    labels = {
      "app"      = "mixer"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "istio"    = "core"
      "package"  = "istio.io.mixer"
      "release"  = "istio"
    }
    name = "attributemanifests.config.istio.io"
  }
  spec {
    group = "config.istio.io"
    names {
      categories = [
        "istio-io",
        "policy-istio-io",
      ]
      kind      = "attributemanifest"
      list_kind = "attributemanifestList"
      plural    = "attributemanifests"
      singular  = "attributemanifest"
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
              "description": "Describes the rules used to configure Mixer's policy and telemetry features. See more details at: https://istio.io/docs/reference/config/policy-and-telemetry/istio.policy.v1beta1.html",
              "properties": {
                "attributes": {
                  "additionalProperties": {
                    "properties": {
                      "description": {
                        "description": "A human-readable description of the attribute's purpose.",
                        "format": "string",
                        "type": "string"
                      },
                      "valueType": {
                        "description": "The type of data carried by this attribute.",
                        "enum": [
                          "VALUE_TYPE_UNSPECIFIED",
                          "STRING",
                          "INT64",
                          "DOUBLE",
                          "BOOL",
                          "TIMESTAMP",
                          "IP_ADDRESS",
                          "EMAIL_ADDRESS",
                          "URI",
                          "DNS_NAME",
                          "DURATION",
                          "STRING_MAP"
                        ],
                        "type": "string"
                      }
                    },
                    "type": "object"
                  },
                  "description": "The set of attributes this Istio component will be responsible for producing at runtime.",
                  "type": "object"
                },
                "name": {
                  "description": "Name of the component producing these attributes.",
                  "format": "string",
                  "type": "string"
                },
                "revision": {
                  "description": "The revision of this document.",
                  "format": "string",
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

    versions {
      name    = "v1alpha2"
      served  = true
      storage = true
    }
  }
}