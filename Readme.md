# Home server

Using
- [Helm](https://helm.sh/docs/intro/install/)
- [Flannel](https://mvallim.github.io/kubernetes-under-the-hood/documentation/kube-flannel.html)
- [Traefik](https://doc.traefik.io/traefik/setup/kubernetes/#prerequisites)
    - `helm upgrade --install traefik traefik/traefik --namespace traefik --values traefik.yaml`
    - `helm uninstall traefik -n traefik`
- [Rancher Local Path Provisioner](https://github.com/rancher/local-path-provisioner)
- [InfluxDB 2](https://github.com/influxdata/helm-charts)
    - `helm upgrade --install influx influxdata/influxdb2 --namespace monitoring --values influx/values.yaml`
    - service is called `influxdb`
    - `helm uninstall influx -n monitoring`
- [Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/)
    - `helm upgrade --install grafana grafana/grafana --namespace monitoring --values grafana/values.yaml`
    - `helm uninstall grafana -n monitoring`