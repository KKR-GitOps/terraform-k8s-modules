resource "k8s_core_v1_config_map" "istio" {
  data = {
    "mesh"         = <<-EOF
      # Set the following variable to true to disable policy checks by Mixer.
      # Note that metrics will still be reported to Mixer.
      disablePolicyChecks: false
      
      disableMixerHttpReports: false
      # reportBatchMaxEntries is the number of requests that are batched before telemetry data is sent to the mixer server
      reportBatchMaxEntries: 100
      # reportBatchMaxTime is the max waiting time before the telemetry data of a request is sent to the mixer server
      reportBatchMaxTime: 1s
      
      # Set enableTracing to false to disable request tracing.
      enableTracing: true
      
      # Set accessLogFile to empty string to disable access log.
      accessLogFile: "/dev/stdout"
      
      # If accessLogEncoding is TEXT, value will be used directly as the log format
      # example: "[%START_TIME%] %REQ(:METHOD)% %REQ(X-ENVOY-ORIGINAL-PATH?:PATH)% %PROTOCOL%\n"
      # If AccessLogEncoding is JSON, value will be parsed as map[string]string
      # example: '{"start_time": "%START_TIME%", "req_method": "%REQ(:METHOD)%"}'
      # Leave empty to use default log format
      accessLogFormat: ""
      
      # Set accessLogEncoding to JSON or TEXT to configure sidecar access log
      accessLogEncoding: 'TEXT'
      
      enableEnvoyAccessLogService: false
      mixerCheckServer: istio-policy.${var.namespace}.svc.cluster.local:9091
      mixerReportServer: istio-telemetry.${var.namespace}.svc.cluster.local:9091
      # policyCheckFailOpen allows traffic in cases when the mixer policy service cannot be reached.
      # Default is false which means the traffic is denied when the client is unable to connect to Mixer.
      policyCheckFailOpen: false
      # Let Pilot give ingresses the public IP of the Istio ingressgateway
      ingressService: istio-ingressgateway
      
      # Default connect timeout for dynamic clusters generated by Pilot and returned via XDS
      connectTimeout: 10s
      
      # Automatic protocol detection uses a set of heuristics to
      # determine whether the connection is using TLS or not (on the
      # server side), as well as the application protocol being used
      # (e.g., http vs tcp). These heuristics rely on the client sending
      # the first bits of data. For server first protocols like MySQL,
      # MongoDB, etc., Envoy will timeout on the protocol detection after
      # the specified period, defaulting to non mTLS plain TCP
      # traffic. Set this field to tweak the period that Envoy will wait
      # for the client to send the first bits of data. (MUST BE >=1ms)
      protocolDetectionTimeout: 100ms
      
      # DNS refresh rate for Envoy clusters of type STRICT_DNS
      dnsRefreshRate: 300s
      
      # Unix Domain Socket through which envoy communicates with NodeAgent SDS to get
      # key/cert for mTLS. Use secret-mount files instead of SDS if set to empty.
      sdsUdsPath: ""
      
      # The trust domain corresponds to the trust root of a system.
      # Refer to https://github.com/spiffe/spiffe/blob/master/standards/SPIFFE-ID.md#21-trust-domain
      trustDomain: ""
      
      #  The trust domain aliases represent the aliases of trust_domain.
      #  For example, if we have
      #  trustDomain: td1
      #  trustDomainAliases: [“td2”, "td3"]
      #  Any service with the identity "td1/ns/foo/sa/a-service-account", "td2/ns/foo/sa/a-service-account",
      #  or "td3/ns/foo/sa/a-service-account" will be treated the same in the Istio mesh.
      trustDomainAliases:
      
      # If true, automatically configure client side mTLS settings to match the corresponding service's
      # server side mTLS authentication policy, when destination rule for that service does not specify
      # TLS settings.
      enableAutoMtls: true
      
      # Set the default behavior of the sidecar for handling outbound traffic from the application:
      # ALLOW_ANY - outbound traffic to unknown destinations will be allowed, in case there are no
      #   services or ServiceEntries for the destination port
      # REGISTRY_ONLY - restrict outbound traffic to services defined in the service registry as well
      #   as those defined through ServiceEntries
      outboundTrafficPolicy:
        mode: ALLOW_ANY
      localityLbSetting:
        enabled: true
      # The namespace to treat as the administrative root namespace for istio
      # configuration.
      rootNamespace: ${var.namespace}
      
      # Configures DNS certificates provisioned through Chiron linked into Pilot.
      certificates:
        []
      configSources:
      - address: istio-galley.${var.namespace}.svc:9901
      
      defaultConfig:
        #
        # TCP connection timeout between Envoy & the application, and between Envoys.  Used for static clusters
        # defined in Envoy's configuration file
        connectTimeout: 10s
        #
        ### ADVANCED SETTINGS #############
        # Where should envoy's configuration be stored in the istio-proxy container
        configPath: "/etc/istio/proxy"
        binaryPath: "/usr/local/bin/envoy"
        # The pseudo service name used for Envoy.
        serviceCluster: istio-proxy
        # These settings that determine how long an old Envoy
        # process should be kept alive after an occasional reload.
        drainDuration: 45s
        parentShutdownDuration: 1m0s
        #
        # The mode used to redirect inbound connections to Envoy. This setting
        # has no effect on outbound traffic: iptables REDIRECT is always used for
        # outbound connections.
        # If "REDIRECT", use iptables REDIRECT to NAT and redirect to Envoy.
        # The "REDIRECT" mode loses source addresses during redirection.
        # If "TPROXY", use iptables TPROXY to redirect to Envoy.
        # The "TPROXY" mode preserves both the source and destination IP
        # addresses and ports, so that they can be used for advanced filtering
        # and manipulation.
        # The "TPROXY" mode also configures the sidecar to run with the
        # CAP_NET_ADMIN capability, which is required to use TPROXY.
        #interceptionMode: REDIRECT
        #
        # Port where Envoy listens (on local host) for admin commands
        # You can exec into the istio-proxy container in a pod and
        # curl the admin port (curl http://localhost:15000/) to obtain
        # diagnostic information from Envoy. See
        # https://lyft.github.io/envoy/docs/operations/admin.html
        # for more details
        proxyAdminPort: 15000
        #
        # Set concurrency to a specific number to control the number of Proxy worker threads.
        # If set to 0 (default), then start worker thread for each CPU thread/core.
        concurrency: 2
        #
        tracing:
          zipkin:
            # Address of the Zipkin collector
            address: zipkin.${var.namespace}:9411
        #
        # Mutual TLS authentication between sidecars and istio control plane.
        controlPlaneAuthPolicy: NONE
        #
        # Address where istio Pilot service is running
        discoveryAddress: istio-pilot.${var.namespace}:15010
      EOF
    "meshNetworks" = "networks: {}"
  }
  metadata {
    labels = {
      "app"      = "istio"
      "chart"    = "istio"
      "heritage" = "Tiller"
      "release"  = "istio"
    }
    name      = "istio"
    namespace = var.namespace
  }
}