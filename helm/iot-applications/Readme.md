# IoT applications Helm chart

## Applications configuration

In the root, there must be `apps` dictionary with applications defined as key: value pairs. Key is important here, it is currently used to generate path to application within `applicationGroup`:

```yaml
apps:
    my-app:
        component: api
        applicationGroup: iot
```

deploys app to `{{ SUBDOMAIN if defined }}.{{ apps.my-app.component }}.{{ PUBLIC_DOMAIN }}/{{ apps.my-app.applicationGroup }}/{{ my-app }}`

Then you should define properties

- `replicas` - how many replicas to deploy
- `image`
  - `repository` container registry URL to image
  - `tag` image tag
- `labels`
  - `component` defines global application type like `api`, `ui`, `database`
  - `partOf` defines group of applications
- `service`
  - `targetPort` where k8s should expect app to be running inside container. Ideal scenario is to use `CONTAINER_PORT` variable inside application template to ensure expected port and actual port in container are the same.
- `ingress`
  - `enabled` tells if ingress should be enabled

Property `jinja2.templates` is dictionary of templates we want to mount into the container. `path` is path inside container where substituted template should be mounted, `file` is filename and `template` refers to template location.

## Jinja2

All the containers have possibility to mount any file which will be substituted from template (not Helm chart templates!). Does not distinguish any extensions, basically any plain text file Jinja2 can substitude with variables. If you app consumes JSON, you must prepare template to be valid JSON after substitution (quotes,...).

Templates can be found in `environments/{ ENV }/config` folder.

### Injected variables

All variables prefixed with `VAR_` or `SECRET_` found in `.yaml` files are injected into templating engine and can be used in templates.

#### Automatically created and injected variables

Some variables are automatically created and injected from application definition. It allows prettier app definition. In theory allows also deploying apps of different components with single file (UI + API + DB)

`APPLICATION` is created from `apps[name]`.
`CONTAINER_PORT` is created from `apps[name].service.targetPort`
`COMPONENT` is created from `apps[name].labels.component`
`APPLICATION_GROUP` is created from `apps[name].labels.partOf`
`NAMESPACE` is created from Helm `$.Release.Namespace`

### Usage in template

URL to application can be defined as:
`{{ VAR_PROTOCOL }}://{{ VAR_SUBDOMAIN }}.{{ COMPONENT }}.{{ VAR_PUBLIC_DOMAIN }}/{{ APPLICATION_GROUP }}/{{ APPLICATION }}`
