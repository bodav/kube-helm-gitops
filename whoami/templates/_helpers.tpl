{{- define "whoami.name" -}}
{{- .Chart.Name }}
{{- end }}

{{- define "whoami.labels" -}}
app: {{ include "whoami.name" . }}
{{- end }}
