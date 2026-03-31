# Home Server

Kubernetes-based home server infrastructure with GitOps deployment management.

## Technology Stack

### Core Infrastructure
| Component | Purpose | Docs | Status |
|-----------|---------|------|--------|
| [Helm](https://helm.sh/docs/intro/install/) | Package management | v3 | Manual |
| [Cilium](https://docs.cilium.io/) | Container networking (eBPF, kube-proxy replacement, Hubble) | [Bootstrap](#cilium) | Manual |
| [Local Path Provisioner](https://github.com/rancher/local-path-provisioner) | Storage provisioning (pre-Longhorn) | [Setup](#local-path-provisioner) | Manual |

### GitOps & Deployment
| Component | Purpose | Docs | Status |
|-----------|---------|------|--------|
| [Argo CD](https://artifacthub.io/packages/helm/argo-cd-oci/argo-cd) | GitOps deployment | [Setup](#argo-cd) | Manual |
| [Argo Rollouts](https://artifacthub.io/packages/helm/argo/argo-rollouts) | Advanced deployment strategies | [Install](#argo-rollouts) | Auto (ArgoCD) |
| [Sealed Secrets](https://artifacthub.io/packages/helm/bitnami-labs/sealed-secrets) | Secret encryption | - | Auto (ArgoCD) |
| [Headlamp](https://artifacthub.io/packages/helm/headlamp/headlamp) | Kubernetes web UI | - | Auto (ArgoCD) |

### Ingress & Networking
| Component | Purpose | Docs | Status |
|-----------|---------|------|--------|
| [Traefik](https://artifacthub.io/packages/helm/traefik/traefik) | Ingress controller & reverse proxy | [Install](#traefik) | Auto (ArgoCD) |
| [external-dns](https://artifacthub.io/packages/helm/external-dns/external-dns) | Automatic DNS provisioning in UniFi via HTTPRoute discovery | - | Auto (ArgoCD) |

### Databases
| Component | Purpose | Status |
|-----------|---------|--------|
| [MongoDB](https://artifacthub.io/packages/helm/bitnami/mongodb) | Document database | Auto (ArgoCD) |
| [InfluxDB 2](https://artifacthub.io/packages/helm/influxdata/influxdb2) | Time series database | Auto (ArgoCD) |

### Monitoring & Observability
| Component | Purpose | Status |
|-----------|---------|--------|
| [kube-prometheus-stack](https://artifacthub.io/packages/helm/prometheus-community/kube-prometheus-stack) | Prometheus + Grafana + AlertManager | Auto (ArgoCD) |
| [Loki](https://artifacthub.io/packages/helm/grafana-community/loki) | Log aggregation | Auto (ArgoCD) |
| [Tempo](https://artifacthub.io/packages/helm/grafana-community/tempo) | Distributed tracing | Auto (ArgoCD) |
| [OpenTelemetry Collector](https://artifacthub.io/packages/helm/opentelemetry-helm/opentelemetry-collector) | Telemetry collection & export | Auto (ArgoCD) |

### Message Queue & IoT
| Component | Purpose | Status |
|-----------|---------|--------|
| [EMQX](https://artifacthub.io/packages/helm/emqx-operator/emqx) | MQTT broker | Auto (ArgoCD) |
| [Telegraf](https://artifacthub.io/packages/helm/influxdata/telegraf) | MQTT ingestion — accepts IoT data over MQTT and writes to InfluxDB | Auto (ArgoCD) |

## Applications

### IoT Miniservers
Custom IoT and integration services deployed on the cluster.

| Service | Purpose | Status |
|---------|---------|--------|
|[Interactive Map Feeder](https://github.com/radoslavirha/iot-miniservers/tree/main/apis/interactive-map-feeder) | Data Feeder for LaskaKit interactive map of Czech republic | Auto (ArgoCD) |
|[MIoT Bridge](https://github.com/radoslavirha/iot-miniservers/tree/main/apis/miot-bridge) | Loxone <-> MIoT (Xiaomi) devices bridge on local network | Auto (ArgoCD) |

## Installation & Setup

### Cilium
```bash
# Add repo if not already done
helm repo add cilium https://helm.cilium.io
helm repo update

# Install Cilium into kube-system with values from this repo
helm install cilium cilium/cilium \
  --version 1.19.2 \
  --namespace kube-system \
  --values helm-values/cilium.yaml
```

### Local Path Provisioner
```bash
# Clone into local-path-provisioner directory
git clone https://github.com/rancher/local-path-provisioner.git local-path-provisioner

# Install
helm upgrade --install local-path-storage local-path-provisioner/deploy/chart/local-path-provisioner \
  --create-namespace --namespace local-path-storage \
  --values local-path-provisioner/values.yaml

# Uninstall
helm uninstall local-path-storage --namespace local-path-storage
```

### Argo CD
```bash
# Install
helm upgrade --install argocd argo/argo-cd --namespace argocd \
  --values helm-values/argocd.yaml

# Uninstall
helm uninstall argocd -n argocd
```

### Argo Rollouts
- Requires [kubectl plugin](https://argo-rollouts.readthedocs.io/en/stable/installation/#kubectl-plugin-installation)
