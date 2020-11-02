local kp =
  (import 'kube-prometheus/kube-prometheus.libsonnet') +
  (import 'kube-prometheus/kube-prometheus-custom-metrics.libsonnet') + // allow custom metrics
  {
    _config+:: {
      namespace: 'default',

      prometheus+:: {
        namespaces+:: [], // Allow Adding additional namespaces to monitor
      },

      kubeStateMetrics+:: {
        collectors: '',  // empty string gets a default set
        scrapeInterval: '15s',
        scrapeTimeout: '15s',
        baseCPU: '100m',
        baseMemory: '150Mi',
      },

      grafana+:: {
        config: { // http://docs.grafana.org/installation/configuration/
          sections: {
            "auth.anonymous": {enabled: true},
          },
        },
      },

      prometheusAdapter+:: { // https://github.com/hipages/php-fpm_exporter rules
        config+: |||
          rules:
            - metricsQuery: 'round(sum (<<.Series>>{<<.LabelMatchers>>,state="Running"}) by (<<.GroupBy>>) / (sum (<<.Series>>{<<.LabelMatchers>>,state="Running"}) by (<<.GroupBy>>)  + sum (<<.Series>>{<<.LabelMatchers>>,state="Idle"}) by (<<.GroupBy>>) ) * 100)'
              name:
                as: "phpfpm_process_state_percentage"
                matches: "phpfpm_process_state"
              resources:
                overrides:
                  kubernetes_namespace:
                    resource: namespace
                  kubernetes_pod_name:
                    resource: pod
              seriesFilters: []
              seriesQuery: '{__name__="phpfpm_process_state"}'
        |||,
      },
    },
  };

{ ['setup/0namespace-' + name]: kp.kubePrometheus[name] for name in std.objectFields(kp.kubePrometheus) } +
{
  ['setup/prometheus-operator-' + name]: kp.prometheusOperator[name]
  for name in std.filter((function(name) name != 'serviceMonitor'), std.objectFields(kp.prometheusOperator))
} +
// serviceMonitor is separated so that it can be created after the CRDs are ready
{ 'prometheus-operator-serviceMonitor': kp.prometheusOperator.serviceMonitor } +
{ ['node-exporter-' + name]: kp.nodeExporter[name] for name in std.objectFields(kp.nodeExporter) } +
{ ['kube-state-metrics-' + name]: kp.kubeStateMetrics[name] for name in std.objectFields(kp.kubeStateMetrics) } +
{ ['alertmanager-' + name]: kp.alertmanager[name] for name in std.objectFields(kp.alertmanager) } +
{ ['prometheus-' + name]: kp.prometheus[name] for name in std.objectFields(kp.prometheus) } +
{ ['prometheus-adapter-' + name]: kp.prometheusAdapter[name] for name in std.objectFields(kp.prometheusAdapter) } +
{ ['grafana-' + name]: kp.grafana[name] for name in std.objectFields(kp.grafana) }
