# directus

![Version: 3.0.0](https://img.shields.io/badge/Version-3.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 11.9.3](https://img.shields.io/badge/AppVersion-11.9.3-informational?style=flat-square)

A Helm chart for installing Directus on Kubernetes.
Directus is a real-time API and App dashboard for managing SQL database content.

**Homepage:** <https://directus.io/>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| zjpiazza |  | <https://github.com/zjpiazza/directus-helm-chart> |

## Source Code

* <https://github.com/zjpiazza/directus-helm-chart>
* <https://github.com/directus/directus>

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | mysql | ~13.0.0 |
| https://charts.bitnami.com/bitnami | postgresql | ~16.7.8 |
| https://charts.bitnami.com/bitnami | redis | ~21.1.11 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| admin.email | string | `"directus-admin@example.com"` | Admin email for Directus |
| adminEmail | string | `"directus-admin@example.com"` | Admin email (deprecated - use admin.email instead)   |
| affinity | object | `{}` |  |
| application.publicUrl | string | `""` | Public URL (auto-generated from ingress if empty) |
| applicationSecretName | string | `"directus-application"` | Application secret name (deprecated - use secrets.application.name instead) |
| autoscaling | object | `{"enabled":false,"maxReplicas":100,"minReplicas":1,"targetCpuUtilizationPercentage":80}` | Horizontal Pod Autoscaler |
| createApplicationSecret | bool | `true` | Create application secret (deprecated - use secrets.createApplication instead) |
| createMysqlSecret | bool | `true` | Create MySQL secret (deprecated - use secrets.createDatabase instead) |
| createPostgresqlSecret | bool | `false` | Create PostgreSQL secret (deprecated - use secrets.createDatabase instead) |
| database.client | string | `"mysql"` | Database client type (mysql, postgresql) |
| database.host | string | `""` | Database host (auto-generated from dependency charts if empty) |
| database.name | string | `""` | Database name (auto-generated if empty) |
| database.password | string | `""` | Database password (recommended to use secretKeyRef for security) Example: password: { secretKeyRef: { name: "db-secret", key: "password" } } |
| database.port | string | `nil` | Database port (auto-detected based on client if empty) |
| database.username | string | `""` | Database username (auto-generated if empty) |
| databaseEngine | string | `"mysql"` | Database engine (deprecated - use database.client instead) |
| directusRedis.enabled | bool | `true` | Enable Redis connection |
| directusRedis.host | string | `""` | Redis host (auto-generated if Redis dependency enabled) |
| directusRedis.password | string | `""` | Redis password Example: password: { secretKeyRef: { name: "redis-secret", key: "password" } } |
| directusRedis.port | int | `6379` | Redis port |
| directusRedis.username | string | `"default"` | Redis username |
| externalRedis.enabled | bool | `false` | Use external Redis instead of installing Redis |
| externalRedis.existingSecret | string | `""` | Existing secret containing Redis credentials |
| externalRedis.existingSecretPasswordKey | string | `"password"` |  |
| externalRedis.host | string | `""` | External Redis host |
| externalRedis.password | string | `""` | External Redis password |
| externalRedis.port | int | `6379` | External Redis port |
| externalRedis.username | string | `"default"` | External Redis username |
| extraEnv | list | `[]` | Additional environment variables (for custom env vars) |
| extraEnvVars | list | `[]` | Extra environment variables (deprecated - use extraEnv instead) |
| extraVolumeMounts | list | `[]` |  |
| extraVolumes | list | `[]` | Volumes |
| fullnameOverride | string | `""` |  |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"directus/directus","tag":""}` | Docker image configuration |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy |
| image.repository | string | `"directus/directus"` | Directus image repository |
| image.tag | string | `""` | Image tag (defaults to chart appVersion) |
| imagePullSecrets | list | `[]` | Image pull secrets |
| ingress | object | `{"annotations":{},"className":"","enableTLS":true,"enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"Prefix"}]}],"tls":[]}` | Ingress configuration |
| initContainers | list | `[]` | Init containers |
| livenessProbe | object | `{"enabled":true,"httpGet":{"path":"/","port":"http"}}` | Health checks |
| mysql | object | `{"auth":{"database":"directus","existingSecret":"","rootPassword":"","username":"directus"},"enabled":true,"external":{"database":"directus","enabled":false,"existingSecret":"","existingSecretPasswordKey":"password","existingSecretUsernameKey":"username","host":"","password":"","port":3306,"username":"directus"}}` | MySQL configuration (Bitnami chart and external) |
| mysql.auth | object | `{"database":"directus","existingSecret":"","rootPassword":"","username":"directus"}` | MySQL subchart authentication (when enabled: true) |
| mysql.auth.database | string | `"directus"` | Database name |
| mysql.auth.existingSecret | string | `""` | Use existing secret for MySQL passwords |
| mysql.auth.rootPassword | string | `""` | Root password (generated if not set) |
| mysql.auth.username | string | `"directus"` | Database username   |
| mysql.enabled | bool | `true` | Enable MySQL subchart installation |
| mysql.external | object | `{"database":"directus","enabled":false,"existingSecret":"","existingSecretPasswordKey":"password","existingSecretUsernameKey":"username","host":"","password":"","port":3306,"username":"directus"}` | External MySQL configuration |
| mysql.external.database | string | `"directus"` | External MySQL database name |
| mysql.external.enabled | bool | `false` | Use external MySQL database instead of subchart |
| mysql.external.existingSecret | string | `""` | Use existing secret for MySQL credentials |
| mysql.external.host | string | `""` | External MySQL host |
| mysql.external.password | string | `""` | External MySQL password (supports secretKeyRef) Example: password: { secretKeyRef: { name: "mysql-secret", key: "password" } } |
| mysql.external.port | int | `3306` | External MySQL port |
| mysql.external.username | string | `"directus"` | External MySQL username |
| nameOverride | string | `""` | Name overrides |
| nodeSelector | object | `{}` | Node selection |
| podAnnotations | object | `{}` | Pod configuration |
| podSecurityContext | object | `{}` |  |
| postgresql | object | `{"auth":{"database":"directus","existingSecret":"","postgresPassword":"","username":"directus"},"enabled":false,"external":{"database":"directus","enabled":false,"existingSecret":"","existingSecretPasswordKey":"password","existingSecretUsernameKey":"username","host":"","password":"","port":5432,"username":"directus"}}` | PostgreSQL configuration (Bitnami chart and external) |
| postgresql.auth | object | `{"database":"directus","existingSecret":"","postgresPassword":"","username":"directus"}` | PostgreSQL subchart authentication (when enabled: true) |
| postgresql.auth.database | string | `"directus"` | Database name |
| postgresql.auth.existingSecret | string | `""` | Use existing secret for PostgreSQL passwords |
| postgresql.auth.postgresPassword | string | `""` | Postgres password (generated if not set) |
| postgresql.auth.username | string | `"directus"` | Database username |
| postgresql.enabled | bool | `false` | Enable PostgreSQL subchart installation |
| postgresql.external | object | `{"database":"directus","enabled":false,"existingSecret":"","existingSecretPasswordKey":"password","existingSecretUsernameKey":"username","host":"","password":"","port":5432,"username":"directus"}` | External PostgreSQL configuration |
| postgresql.external.database | string | `"directus"` | External PostgreSQL database name |
| postgresql.external.enabled | bool | `false` | Use external PostgreSQL database instead of subchart |
| postgresql.external.existingSecret | string | `""` | Use existing secret for PostgreSQL credentials |
| postgresql.external.host | string | `""` | External PostgreSQL host |
| postgresql.external.password | string | `""` | External PostgreSQL password (supports secretKeyRef) Example: password: { secretKeyRef: { name: "postgres-secret", key: "password" } } |
| postgresql.external.port | int | `5432` | External PostgreSQL port |
| postgresql.external.username | string | `"directus"` | External PostgreSQL username |
| readinessProbe.enabled | bool | `true` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| redis | object | `{"auth":{"enabled":true,"existingSecret":"","existingSecretPasswordKey":"","password":""},"enabled":true,"replica":{"replicaCount":0}}` | Redis configuration (Bitnami chart)  Note: This configures the Redis dependency installation, not Directus Redis connection Use directusRedis.* above to configure how Directus connects to Redis |
| redis.auth | object | `{"enabled":true,"existingSecret":"","existingSecretPasswordKey":"","password":""}` | Redis authentication |
| redis.auth.enabled | bool | `true` | Enable Redis AUTH |
| redis.auth.existingSecret | string | `""` | Use existing secret for Redis password |
| redis.auth.password | string | `""` | Redis password (generated if not set) |
| redis.enabled | bool | `true` | Enable Redis installation |
| redis.replica | object | `{"replicaCount":0}` | Redis replica configuration |
| replicaCount | int | `1` | Number of Directus replicas |
| resources | object | `{}` | Resource limits and requests |
| secrets.application | object | `{"name":"directus-application"}` | Application secret configuration |
| secrets.createApplication | bool | `true` | Create application secrets (ADMIN_PASSWORD, SECRET, KEY) |
| secrets.createDatabase | bool | `true` | Create database secrets for dependency charts |
| secrets.database | object | `{"name":"directus-database"}` | Database secret configuration   |
| securityContext | object | `{}` |  |
| service | object | `{"port":80,"type":"ClusterIP"}` | Service configuration |
| serviceAccount | object | `{"annotations":{},"create":true,"name":""}` | Service account configuration |
| sidecars | list | `[]` | Sidecars |
| startupProbe.enabled | bool | `false` |  |
| startupProbe.httpGet.path | string | `"/"` |  |
| startupProbe.httpGet.port | string | `"http"` |  |
| tolerations | list | `[]` |  |
| updateStrategy | object | `{"type":"RollingUpdate"}` | Deployment strategy |

