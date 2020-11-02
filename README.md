# Projet php scaling with custom metrics on prometheus

# Installation

```
cd k8s/prometheus
make generate-in-docker
make install
cd ../../apps
skaffold dev
```

# Tools

https://github.com/GoogleContainerTools/skaffold
https://github.com/prometheus-operator/kube-prometheus
https://github.com/hipages/php-fpm_exporter
