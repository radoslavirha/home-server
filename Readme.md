# Home server

Using

- [Helm](https://helm.sh/docs/intro/install/) v3
- [Flannel](https://mvallim.github.io/kubernetes-under-the-hood/documentation/kube-flannel.html)
- [Traefik](https://doc.traefik.io/traefik/setup/kubernetes/#prerequisites)
  - Managed by Argo CD
- [Rancher Local Path Provisioner](https://github.com/rancher/local-path-provisioner/tree/master/deploy/chart/local-path-provisioner)
  - clone into `local-path-provisioner`
  - `helm upgrade --install local-path-storage local-path-provisioner/local-path-provisioner/deploy/chart/local-path-provisioner --create-namespace --namespace local-path-storage --values local-path-provisioner/values.yaml`
  - `helm uninstall local-path-storage --namespace local-path-storage`
- [InfluxDB 2](https://github.com/influxdata/helm-charts)
  - `helm upgrade --install influx influxdata/influxdb2 --namespace monitoring --values helm-values/influxdb.yaml`
  - service is called `influxdb`
  - `helm uninstall influx -n monitoring`
- [Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/)
  - `helm upgrade --install grafana grafana/grafana --namespace monitoring --values helm-values/grafana.yaml`
  - `helm uninstall grafana -n monitoring`
- [Argo CD](https://artifacthub.io/packages/helm/argo-cd-oci/argo-cd)
  - `helm upgrade --install argocd argo/argo-cd --namespace argocd --values helm-values/argocd.yaml`
  - `helm uninstall argocd -n argocd`
