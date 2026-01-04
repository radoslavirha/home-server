# Home server

Using

- [Helm](https://helm.sh/docs/intro/install/) v3
- [Flannel](https://mvallim.github.io/kubernetes-under-the-hood/documentation/kube-flannel.html)
- [Rancher Local Path Provisioner](https://github.com/rancher/local-path-provisioner/tree/master/deploy/chart/local-path-provisioner)
  - clone into `local-path-provisioner`
  - `helm upgrade --install local-path-storage local-path-provisioner/local-path-provisioner/deploy/chart/local-path-provisioner --create-namespace --namespace local-path-storage --values local-path-provisioner/values.yaml`
  - `helm uninstall local-path-storage --namespace local-path-storage`
- [Argo CD](https://artifacthub.io/packages/helm/argo-cd-oci/argo-cd)
  - `helm upgrade --install argocd argo/argo-cd --namespace argocd --values helm-values/argocd.yaml`
  - `helm uninstall argocd -n argocd`
- [Argo Rollouts](https://artifacthub.io/packages/helm/argo/argo-rollouts)
  - Managed by Argo CD
  - [Kubectl plugin](https://argo-rollouts.readthedocs.io/en/stable/installation/#kubectl-plugin-installation)
- [Traefik](https://artifacthub.io/packages/helm/traefik/traefik)
  - Managed by Argo CD
  - Needs [Gateway API](https://doc.traefik.io/traefik/reference/install-configuration/providers/kubernetes/kubernetes-gateway/)
- [InfluxDB 2](https://artifacthub.io/packages/helm/influxdata/influxdb2)
  - Managed by Argo CD
- [Grafana](https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/)
  - Managed by Argo CD
- [Kubernetes Dashboard](https://artifacthub.io/packages/helm/k8s-dashboard/kubernetes-dashboard)
  - Managed by Argo CD
