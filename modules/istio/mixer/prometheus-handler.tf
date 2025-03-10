resource "k8s_config_istio_io_v1alpha2_handler" "prometheus" {
  metadata {
    labels = {
      "app"      = "mixer"
      "chart"    = "mixer"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "prometheus"
    namespace = var.namespace
  }
  spec = <<-JSON
    {
      "compiledAdapter": "prometheus",
      "params": {
        "metrics": [
          {
            "instance_name": "requestcount.instance.${var.namespace}",
            "kind": "COUNTER",
            "label_names": [
              "reporter",
              "source_app",
              "source_principal",
              "source_workload",
              "source_workload_namespace",
              "source_version",
              "destination_app",
              "destination_principal",
              "destination_workload",
              "destination_workload_namespace",
              "destination_version",
              "destination_service",
              "destination_service_name",
              "destination_service_namespace",
              "request_protocol",
              "response_code",
              "grpc_response_status",
              "response_flags",
              "connection_security_policy"
            ],
            "name": "requests_total"
          },
          {
            "buckets": {
              "explicit_buckets": {
                "bounds": [
                  0.005,
                  0.01,
                  0.025,
                  0.05,
                  0.1,
                  0.25,
                  0.5,
                  1,
                  2.5,
                  5,
                  10
                ]
              }
            },
            "instance_name": "requestduration.instance.${var.namespace}",
            "kind": "DISTRIBUTION",
            "label_names": [
              "reporter",
              "source_app",
              "source_principal",
              "source_workload",
              "source_workload_namespace",
              "source_version",
              "destination_app",
              "destination_principal",
              "destination_workload",
              "destination_workload_namespace",
              "destination_version",
              "destination_service",
              "destination_service_name",
              "destination_service_namespace",
              "request_protocol",
              "response_code",
              "grpc_response_status",
              "response_flags",
              "connection_security_policy"
            ],
            "name": "request_duration_seconds"
          },
          {
            "buckets": {
              "exponentialBuckets": {
                "growthFactor": 10,
                "numFiniteBuckets": 8,
                "scale": 1
              }
            },
            "instance_name": "requestsize.instance.${var.namespace}",
            "kind": "DISTRIBUTION",
            "label_names": [
              "reporter",
              "source_app",
              "source_principal",
              "source_workload",
              "source_workload_namespace",
              "source_version",
              "destination_app",
              "destination_principal",
              "destination_workload",
              "destination_workload_namespace",
              "destination_version",
              "destination_service",
              "destination_service_name",
              "destination_service_namespace",
              "request_protocol",
              "response_code",
              "grpc_response_status",
              "response_flags",
              "connection_security_policy"
            ],
            "name": "request_bytes"
          },
          {
            "buckets": {
              "exponentialBuckets": {
                "growthFactor": 10,
                "numFiniteBuckets": 8,
                "scale": 1
              }
            },
            "instance_name": "responsesize.instance.${var.namespace}",
            "kind": "DISTRIBUTION",
            "label_names": [
              "reporter",
              "source_app",
              "source_principal",
              "source_workload",
              "source_workload_namespace",
              "source_version",
              "destination_app",
              "destination_principal",
              "destination_workload",
              "destination_workload_namespace",
              "destination_version",
              "destination_service",
              "destination_service_name",
              "destination_service_namespace",
              "request_protocol",
              "response_code",
              "grpc_response_status",
              "response_flags",
              "connection_security_policy"
            ],
            "name": "response_bytes"
          },
          {
            "instance_name": "tcpbytesent.instance.${var.namespace}",
            "kind": "COUNTER",
            "label_names": [
              "reporter",
              "source_app",
              "source_principal",
              "source_workload",
              "source_workload_namespace",
              "source_version",
              "destination_app",
              "destination_principal",
              "destination_workload",
              "destination_workload_namespace",
              "destination_version",
              "destination_service",
              "destination_service_name",
              "destination_service_namespace",
              "connection_security_policy",
              "response_flags"
            ],
            "name": "tcp_sent_bytes_total"
          },
          {
            "instance_name": "tcpbytereceived.instance.${var.namespace}",
            "kind": "COUNTER",
            "label_names": [
              "reporter",
              "source_app",
              "source_principal",
              "source_workload",
              "source_workload_namespace",
              "source_version",
              "destination_app",
              "destination_principal",
              "destination_workload",
              "destination_workload_namespace",
              "destination_version",
              "destination_service",
              "destination_service_name",
              "destination_service_namespace",
              "connection_security_policy",
              "response_flags"
            ],
            "name": "tcp_received_bytes_total"
          },
          {
            "instance_name": "tcpconnectionsopened.instance.${var.namespace}",
            "kind": "COUNTER",
            "label_names": [
              "reporter",
              "source_app",
              "source_principal",
              "source_workload",
              "source_workload_namespace",
              "source_version",
              "destination_app",
              "destination_principal",
              "destination_workload",
              "destination_workload_namespace",
              "destination_version",
              "destination_service",
              "destination_service_name",
              "destination_service_namespace",
              "connection_security_policy",
              "response_flags"
            ],
            "name": "tcp_connections_opened_total"
          },
          {
            "instance_name": "tcpconnectionsclosed.instance.${var.namespace}",
            "kind": "COUNTER",
            "label_names": [
              "reporter",
              "source_app",
              "source_principal",
              "source_workload",
              "source_workload_namespace",
              "source_version",
              "destination_app",
              "destination_principal",
              "destination_workload",
              "destination_workload_namespace",
              "destination_version",
              "destination_service",
              "destination_service_name",
              "destination_service_namespace",
              "connection_security_policy",
              "response_flags"
            ],
            "name": "tcp_connections_closed_total"
          }
        ],
        "metricsExpirationPolicy": {
          "metricsExpiryDuration": "10m"
        }
      }
    }
    JSON
}