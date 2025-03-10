resource "k8s_core_v1_config_map" "this" {
  data = {
    "fluent-bit.conf" = <<-EOF
      [SERVICE]
        Flush         1
        Log_Level     info
        Daemon        off
        Parsers_File  parsers.conf
        HTTP_Server   On
        HTTP_Listen   0.0.0.0
        HTTP_Port     2020

      @INCLUDE input-kubernetes.conf
      @INCLUDE filter-kubernetes.conf
      @INCLUDE output-elasticsearch.conf
      EOF

    "input-kubernetes.conf" = <<-EOF
      [INPUT]
        Name              tail
        Tag               kube.*
        Path              /var/log/containers/*.log
        Parser            docker
        DB                /var/log/flb_kube.db
        Mem_Buf_Limit     5MB
        Skip_Long_Lines   On
        Refresh_Interval  10
      EOF

    "output-elasticsearch.conf" = <<-EOF
      [OUTPUT]
        Name            es
        Match           *
        Host            $${FLUENT_ELASTICSEARCH_HOST}
        Port            $${FLUENT_ELASTICSEARCH_PORT}
        Logstash_Format On
        Retry_Limit     False
      EOF

    "parsers.conf" = <<-EOF
      [PARSER]
        Name   apache
        Format regex
        Regex  ^(?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] \"(?<method>\S+)(?: +(?<path>[^\\"]*?)(?: +\S*)?)?\" (?<code>[^ ]*) (?<size>[^ ]*)(?: \"(?<referer>[^\\"]*)\" \"(?<agent>[^\\"]*)\")?$
        Time_Key time
        Time_Format %d/%b/%Y:%H:%M:%S %z

      [PARSER]
        Name   apache2
        Format regex
        Regex  ^(?<host>[^ ]*) [^ ]* (?<user>[^ ]*) \[(?<time>[^\]]*)\] \"(?<method>\S+)(?: +(?<path>[^ ]*) +\S*)?\" (?<code>[^ ]*) (?<size>[^ ]*)(?: \"(?<referer>[^\\"]*)\" \"(?<agent>[^\\"]*)\")?$
        Time_Key time
        Time_Format %d/%b/%Y:%H:%M:%S %z

      [PARSER]
        Name   apache_error
        Format regex
        Regex  ^\[[^ ]* (?<time>[^\]]*)\] \[(?<level>[^\]]*)\](?: \[pid (?<pid>[^\]]*)\])?( \[client (?<client>[^\]]*)\])? (?<message>.*)$

      [PARSER]
        Name   nginx
        Format regex
        Regex ^(?<remote>[^ ]*) (?<host>[^ ]*) (?<user>[^ ]*) \[(?<time>[^\]]*)\] \"(?<method>\S+)(?: +(?<path>[^\\"]*?)(?: +\S*)?)?\" (?<code>[^ ]*) (?<size>[^ ]*)(?: \"(?<referer>[^\\"]*)\" \"(?<agent>[^\\"]*)\")?$
        Time_Key time
        Time_Format %d/%b/%Y:%H:%M:%S %z

      [PARSER]
        Name        json
        Format      json
        Time_Key    time
        Time_Format %d/%b/%Y:%H:%M:%S %z

      [PARSER]
        Name        docker
        Format      json
        Time_Key    time
        Time_Format %Y-%m-%dT%H:%M:%S.%L
        Time_Keep   On
        # Command      |  Decoder | Field | Optional Action
        # =============|==================|=================
        Decode_Field_As   escaped    log

      [PARSER]
        Name        syslog
        Format      regex
        Regex       ^\<(?<pri>[0-9]+)\>(?<time>[^ ]* {1,2}[^ ]* [^ ]*) (?<host>[^ ]*) (?<ident>[a-zA-Z0-9_\/\.\-]*)(?:\[(?<pid>[0-9]+)\])?(?:[^\:]*\:)? *(?<message>.*)$
        Time_Key    time
        Time_Format %b %d %H:%M:%S
      EOF

    "filter-kubernetes.conf" = <<-EOF
      [FILTER]
        Name                kubernetes
        Match               kube.*
        Kube_URL            https://kubernetes.default.svc.cluster.local:443
        Merge_Log           On
        K8S-Logging.Parser  On
      EOF
  }

  metadata {
    name      = var.name
    namespace = var.namespace
    labels    = local.labels
  }
}
