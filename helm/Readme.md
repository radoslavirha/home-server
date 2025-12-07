# Helm charts

## IoT applications

### Interactive map feeder

Deploy to sandbox environment

```sh
helm upgrade --install interactive-map-feeder-sandbox iot-applications -n sandbox -f iot-applications/environments/interactive-map-feeder.yaml -f iot-applications/environments/sandbox/interactive-map-feeder.yaml -f iot-applications/environments/sandbox/variables.yaml -f iot-applications/environments/sandbox/secrets.yaml
```

Uninstall from sandbox environment

```sh
helm uninstall interactive-map-feeder-sandbox -n sandbox
```

Deploy to production environment

```sh
helm upgrade --install interactive-map-feeder-production iot-applications -n production -f iot-applications/environments/interactive-map-feeder.yaml -f iot-applications/environments/production/interactive-map-feeder.yaml -f iot-applications/environments/production/variables.yaml -f iot-applications/environments/production/secrets.yaml
```

Uninstall from production environment

```sh
helm uninstall interactive-map-feeder-production -n production
```
