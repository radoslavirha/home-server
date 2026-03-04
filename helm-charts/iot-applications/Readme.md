# IoT applications Helm chart

Environment-agnostic chart. No environment-specific files live here.
All values (image tags, replicas, config content, variables) are in `helm-values/iot/`.

## Values structure

```
helm-values/iot/
  {app}.yaml                    ← shared: image, resources, labels, services, ingress, templates.file/path
  {env}/
    {app}.yaml                  ← env-specific: replicas, templates.content (jinja2 config body)
    variables.yaml              ← VAR_* values injected into jinja2 at runtime
```

## Applications configuration

See `values.yaml` for full schema with comments.

Example minimal app:

```yaml
apps:
  my-app:
    image:
      repository: my-repo/my-app
      tag: 1.0.0
    labels:
      component: api
      partOf: iot
    services:
      http:
        enabled: true
        protocol: TCP
        port: 80
        targetPort: 4000
    ingress:
      enabled: true
      serviceRef: http
```

deploys to: `{{ SUBDOMAIN if defined }}.{{ component }}.{{ VAR_PUBLIC_DOMAIN }}/{{ partOf }}/{{ app-name }}`

Services are named: `{component}-{partOf}-{app}-{serviceName}` (e.g. `api-iot-my-app-http`).

## Jinja2 config templates

Containers can have files mounted at startup via a jinja2 init container. Config template content is defined as a multiline string in env-specific values files — **no files inside the chart**.

A `checksum/config` annotation on the pod template ensures pods restart automatically whenever config content changes.

```yaml
# helm-values/iot/production/my-app.yaml
apps:
  my-app:
    templates:
      config:
        content: |
          {
            "url": "{{ VAR_PROTOCOL }}://{{ COMPONENT }}.{{ VAR_PUBLIC_DOMAIN }}/..."
          }
```

### Injected variables

All `VAR_*` and `SECRET_*` keys from values files are passed as env vars to the jinja2 init container.

#### Automatically injected

| Variable | Source |
|---|---|
| `APPLICATION` | `apps[name]` |
| `CONTAINER_PORT` | `apps[name].ingress.serviceRef` → `services[ref].targetPort` |
| `COMPONENT` | `apps[name].labels.component` |
| `APPLICATION_GROUP` | `apps[name].labels.partOf` |
| `NAMESPACE` | Helm `$.Release.Namespace` |

## Argo Rollouts

Set `rollout.enabled: true` with `rollout.strategy: canary` or `rollout.strategy: blueGreen` to emit a Rollout instead of a Deployment. See `values.yaml` for full schema including service pair references.
