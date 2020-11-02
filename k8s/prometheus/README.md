# Prometheus

## Installation dependencies

```bash
GO111MODULE="on" go get github.com/jsonnet-bundler/jsonnet-bundler/cmd/jb
jb install github.com/prometheus-operator/kube-prometheus/jsonnet/kube-prometheus@release-0.6
```

## Install Kube Prometheus

```
make generate-in-docker
make install
```

## Bug

if node exporter crash on osx you can remove line 24 and 44 on manifest/node-exporter-daemonset.yaml  

```yaml
    - --path.rootfs=/host/root
``` 

```yaml
        - mountPath: /host/root
           mountPropagation: HostToContainer
           name: root
           readOnly: true
``` 
