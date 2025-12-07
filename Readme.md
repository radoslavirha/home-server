# Home server

Using
- [Helm](https://helm.sh/docs/intro/install/)
- [Flannel](https://mvallim.github.io/kubernetes-under-the-hood/documentation/kube-flannel.html)
- [Traefik](https://doc.traefik.io/traefik/setup/kubernetes/#prerequisites)
    - install Helm charts
    - `helm install traefik traefik/traefik --namespace traefik --values traefik.yaml`