resource "k8s_networking_istio_io_v1alpha3_destination_rule" "istio_telemetry" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio-telemetry"
    namespace = var.namespace
  }
  spec = <<-JSON
    {
      "host": "istio-telemetry.${var.namespace}.svc.cluster.local",
      "trafficPolicy": {
        "connectionPool": {
          "http": {
            "http2MaxRequests": 10000,
            "maxRequestsPerConnection": 10000
          }
        },
        "portLevelSettings": [
          {
            "port": {
              "number": 15004
            },
            "tls": {
              "mode": "ISTIO_MUTUAL"
            }
          },
          {
            "port": {
              "number": 9091
            },
            "tls": {
              "mode": "DISABLE"
            }
          }
        ]
      }
    }
    JSON
}