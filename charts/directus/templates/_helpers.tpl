{{/*
Expand the name of the chart.
*/}}
{{- define "directus.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "directus.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "directus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "directus.labels" -}}
helm.sh/chart: {{ include "directus.chart" . }}
{{ include "directus.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "directus.selectorLabels" -}}
app.kubernetes.io/name: {{ include "directus.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "directus.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "directus.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Renders a value that contains template perhaps with scope if the scope is present.
*/}}
{{- define "directus.render" -}}
{{- $value := typeIs "string" .value | ternary .value (.value | toYaml) }}
{{- if contains "{{" (toJson .value) }}
  {{- if .scope }}
      {{- tpl (cat "{{- with $.RelativeScope -}}" $value "{{- end }}") (merge (dict "RelativeScope" .scope) .context) }}
  {{- else }}
    {{- tpl $value .context }}
  {{- end }}
{{- else }}
    {{- $value }}
{{- end }}
{{- end -}}

{{/*
Smart environment variable value handler - supports both shorthand and advanced syntax
Usage: {{ include "directus.smartEnvValue" (dict "value" .Values.database.host "context" $) }}

Shorthand: database.host: "mydb.com"
Advanced: database.host: { secretKeyRef: { name: "secret", key: "host" } }
*/}}
{{- define "directus.smartEnvValue" -}}
{{- $value := .value -}}
{{- if typeIs "string" $value -}}
  {{- $value | quote -}}
{{- else if typeIs "float64" $value -}}
  {{- $value | quote -}}
{{- else if typeIs "bool" $value -}}
  {{- $value | quote -}}
{{- else if and (typeIs "map[string]interface {}" $value) $value.secretKeyRef.name -}}
  valueFrom:
    secretKeyRef:
      name: {{ $value.secretKeyRef.name | quote }}
      key: {{ $value.secretKeyRef.key | quote }}
{{- else if and (typeIs "map[string]interface {}" $value) $value.configMapKeyRef.name -}}
  valueFrom:
    configMapKeyRef:
      name: {{ $value.configMapKeyRef.name | quote }}
      key: {{ $value.configMapKeyRef.key | quote }}
{{- else if and (typeIs "map[string]interface {}" $value) $value.value -}}
  {{- $value.value | quote -}}
{{- else -}}
  ""
{{- end -}}
{{- end -}}

{{/*
Check if environment variable should be rendered as valueFrom (not static in ConfigMap)
Usage: {{ if include "directus.isValueFrom" .Values.database.host }}
*/}}
{{- define "directus.isValueFrom" -}}
{{- $value := . -}}
{{- if typeIs "map[string]interface {}" $value -}}
  {{- if or $value.secretKeyRef.name $value.configMapKeyRef.name -}}
true
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Get the actual value from shorthand or advanced syntax (for use in ConfigMap)
Usage: {{ include "directus.getValue" .Values.database.host }}
*/}}
{{- define "directus.getValue" -}}
{{- $value := . -}}
{{- if typeIs "string" $value -}}
  {{- $value -}}
{{- else if typeIs "float64" $value -}}
  {{- $value -}}
{{- else if typeIs "bool" $value -}}
  {{- $value -}}
{{- else if and (typeIs "map[string]interface {}" $value) $value.value -}}
  {{- $value.value -}}
{{- else -}}
  {{- "" -}}
{{- end -}}
{{- end -}}

{{/*
Generate database host with fallbacks
*/}}
{{- define "directus.dbHost" -}}
{{- $dbHost := include "directus.getValue" .Values.database.host -}}
{{- if $dbHost -}}
  {{- $dbHost -}}
{{- else if .Values.externalDatabase.enabled -}}
  {{- .Values.externalDatabase.host -}}
{{- else if eq (include "directus.getValue" .Values.database.client | default .Values.databaseEngine) "mysql" -}}
  {{- if .Values.mysql.enabled -}}
    {{- printf "%s-mysql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
  {{- end -}}
{{- else if eq (include "directus.getValue" .Values.database.client | default .Values.databaseEngine) "postgresql" -}}
  {{- if .Values.postgresql.enabled -}}
    {{- printf "%s-postgresql.%s.svc.cluster.local" .Release.Name .Release.Namespace -}}
  {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Generate database port with fallbacks
*/}}
{{- define "directus.dbPort" -}}
{{- $dbPort := include "directus.getValue" .Values.database.port -}}
{{- if $dbPort -}}
  {{- $dbPort -}}
{{- else if .Values.externalDatabase.enabled -}}
  {{- .Values.externalDatabase.port | default "3306" -}}
{{- else if eq (include "directus.getValue" .Values.database.client | default .Values.databaseEngine) "mysql" -}}
  {{- "3306" -}}
{{- else if eq (include "directus.getValue" .Values.database.client | default .Values.databaseEngine) "postgresql" -}}
  {{- "5432" -}}
{{- end -}}
{{- end -}}

{{/*
Generate database name with fallbacks
*/}}
{{- define "directus.dbDatabase" -}}
{{- $dbName := include "directus.getValue" .Values.database.name -}}
{{- if $dbName -}}
  {{- $dbName -}}
{{- else if .Values.externalDatabase.enabled -}}
  {{- .Values.externalDatabase.database -}}
{{- else if eq (include "directus.getValue" .Values.database.client | default .Values.databaseEngine) "mysql" -}}
  {{- .Values.mysql.auth.database | default "directus" -}}
{{- else if eq (include "directus.getValue" .Values.database.client | default .Values.databaseEngine) "postgresql" -}}
  {{- .Values.postgresql.auth.database | default "directus" -}}
{{- end -}}
{{- end -}}

{{/*
Generate database username with fallbacks
*/}}
{{- define "directus.dbUser" -}}
{{- $dbUser := include "directus.getValue" .Values.database.username -}}
{{- if $dbUser -}}
  {{- $dbUser -}}
{{- else if .Values.externalDatabase.enabled -}}
  {{- .Values.externalDatabase.username -}}
{{- else if eq (include "directus.getValue" .Values.database.client | default .Values.databaseEngine) "mysql" -}}
  {{- .Values.mysql.auth.username | default "directus" -}}
{{- else if eq (include "directus.getValue" .Values.database.client | default .Values.databaseEngine) "postgresql" -}}
  {{- .Values.postgresql.auth.username | default "directus" -}}
{{- end -}}
{{- end -}}

{{/*
Generate Redis host with fallbacks
*/}}
{{- define "directus.redisHost" -}}
{{- $redisHost := include "directus.getValue" .Values.directusRedis.host -}}
{{- if $redisHost -}}
  {{- $redisHost -}}
{{- else if .Values.externalRedis.enabled -}}
  {{- .Values.externalRedis.host -}}
{{- else if .Values.redis.enabled -}}
  {{- printf "%s-redis-master" .Release.Name -}}
{{- end -}}
{{- end -}}