{{/* Returns the subdomain with a trailing dot if provided */}}
{{- define "iot-applications.subdomain" -}}
{{- if . -}}
{{- printf "%s." . }}
{{- end -}}
{{- end -}}

{{/* Returns the provided tag or defaults to latest */}}
{{- define "iot-applications.defaults.tag" -}}
{{- default "latest" . -}}
{{- end -}}

{{/* Returns the provided port or defaults to 80 */}}
{{- define "iot-applications.defaults.port" -}}
{{- int (default 80 .) -}}
{{- end -}}

{{/* Validates port range.
     Expects an integer or string to be passed as the context.
     Input is dictionary with port: string/integer, applicationName: string
*/}}
{{- define "iot-applications.validators.portRange" -}}
{{- $sanitizedPort := int .port -}}
{{- if or (lt $sanitizedPort 1) (gt $sanitizedPort 65535) -}}
{{- fail (printf "Ports must always be between 1 and 65535. Provided value: %s. [apps.%s]." .port .applicationName) -}}
{{- end -}}
{{- end -}}

{{/* Validates image.
     Input is dictionary with image: dictionary, applicationName: string
*/}}
{{- define "iot-applications.validators.image" -}}
{{- if not (hasKey .image "repository") -}}
{{- fail (printf "Image must have a repository key. [apps.%s.image]." .applicationName) -}}
{{- end -}}

{{- if hasKey .image "pullPolicy" -}}
{{- $allowed := list "Always" "IfNotPresent" "Never" -}}
{{- if not (has .image.pullPolicy $allowed) -}}
{{- fail (printf "Image has invalid pullPolicy '%s'. Allowed values are: %s. [apps.%s.image]." .image.pullPolicy (join ", " $allowed) .applicationName) -}}
{{- end -}}
{{- end -}}

{{- end -}}

{{/* Validates service.
     Input is dictionary with service: dictionary, applicationName: string
*/}}
{{- define "iot-applications.validators.service" -}}

{{- if not (hasKey .service "enabled") -}}
{{- fail (printf "Service configuration must have an 'enabled' key with boolean value. [apps.%s.service]." .applicationName) -}}
{{- end -}}

{{- if .service.enabled -}}
{{- if hasKey .service "targetPort" -}}
{{- include "iot-applications.validators.portRange" (dict "port" .service.targetPort "applicationName" .applicationName) -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/* Validates ingress.
     Input is dictionary with ingress: dictionary, applicationName: string
*/}}
{{- define "iot-applications.validators.ingress" -}}
{{- if not (hasKey .ingress "enabled") -}}
{{- fail (printf "Ingress configuration must have an 'enabled' key with boolean value.. [apps.%s.ingress]." .applicationName) -}}
{{- end -}}
{{- end -}}

{{/* Validates template.
     Input is dictionary with name: string, template: dictionary, applicationName: string
*/}}
{{- define "iot-applications.validators.template" -}}
{{- if not (hasKey .template "template") -}}
{{- fail (printf "Template '%s' must have a template key. [apps.%s.templates]." .name .applicationName) -}}
{{- end -}}

{{- if not (hasKey .template "path") -}}
{{- fail (printf "Template '%s' must have a path key. [apps.%s.templates]." .name .applicationName) -}}
{{- end -}}

{{- if not (hasKey .template "file") -}}
{{- fail (printf "Template '%s' must have a file key. [apps.%s.templates]." .name .applicationName) -}}
{{- end -}}
{{- end -}}

{{/* Returns object identifier composed of component, partOf, and name */}}
{{- define "iot-applications.identifier" -}}
{{- $identifier := printf "%s-%s-%s" .application.labels.component .application.labels.partOf .name }}
{{- $identifier | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Returns labels for selector */}}
{{- define "iot-applications.labels.selector" -}}
app: {{ include "iot-applications.identifier" . -}}
{{- end -}}

{{/* Returns standard metadata labels */}}
{{- define "iot-applications.meta.labels" -}}
{{- include "iot-applications.validators.image" (dict "image" (.application.image | default dict) "applicationName" .name) -}}
app.kubernetes.io/name: {{ .name }}
app.kubernetes.io/version: {{ include "iot-applications.defaults.tag" .application.image.tag }}
app.kubernetes.io/component: {{ .application.labels.component }}
app.kubernetes.io/part-of: {{ .application.labels.partOf }}
app.kubernetes.io/environment: {{ .release.Namespace }}
{{- end -}}