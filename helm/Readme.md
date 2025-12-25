# Helm charts

## IoT applications

### Interactive map feeder

Deploy to sandbox environment

```sh
helm upgrade interactive-map-feeder-sandbox iot-applications \
    --values iot-applications/environments/interactive-map-feeder.yaml \
    --values iot-applications/environments/sandbox/interactive-map-feeder.yaml \
    --values iot-applications/environments/sandbox/variables.yaml \
    --values iot-applications/environments/sandbox/secrets.yaml \
    --namespace sandbox \
    --install \
    --atomic \
    --cleanup-on-fail \
    --timeout 2m
```

Uninstall from sandbox environment

```sh
helm uninstall interactive-map-feeder-sandbox \
    --namespace sandbox
```

Deploy to production environment

```sh
helm upgrade interactive-map-feeder-production iot-applications \
    --values iot-applications/environments/interactive-map-feeder.yaml \
    --values iot-applications/environments/production/interactive-map-feeder.yaml \
    --values iot-applications/environments/production/variables.yaml \
    --values iot-applications/environments/production/secrets.yaml \
    --namespace production \
    --install \
    --atomic \
    --cleanup-on-fail \
    --timeout 2m
```

Uninstall from production environment

```sh
helm uninstall interactive-map-feeder-production \
    --namespace production
```
