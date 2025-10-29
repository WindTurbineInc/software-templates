{{/*
Expand the name of the chart.
*/}}
{{- define "ace-template.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ace-template.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ace-template.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "backstage.labels" -}}
backstage.io/kubernetes-id: ${{values.component_id}}
{{- end }}

{{- define "ace-template.labels" -}}
backstage.io/kubernetes-id: ${{values.component_id}}
helm.sh/chart: {{ include "ace-template.chart" . }}
app.openshift.io/runtime: ace
{{ include "ace-template.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "ace-template.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ace-template.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "ace-template.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ace-template.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "ace-template.image" -}}
{{- if eq .Values.image.registry "Quay" }}
{{- printf "%s/%s/%s:%s" .Values.image.host .Values.image.organization .Values.image.name .Values.image.tag -}}
{{- else }}
{{- printf "%s/%s/%s:latest" .Values.image.host .Values.namespace.name .Values.image.name -}}
{{- end }}
{{- end }}
