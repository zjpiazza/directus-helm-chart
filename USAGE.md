# Using the Improved Directus Helm Chart

This fork provides an improved, more ergonomic version of the Directus Helm chart with better configuration structure and Helm best practices.

## Installation

### Option 1: Using Helm Repo (Recommended)

Once GitHub Pages is enabled, you can add the chart repository:

```bash
# Add the chart repository
helm repo add zjpiazza-directus https://zjpiazza.github.io/directus-helm-chart

# Update repositories
helm repo update

# Install with simple configuration
helm install directus zjpiazza-directus/directus \
  --set database.client=mysql \
  --set database.host=mydb.example.com \
  --set admin.email=admin@example.com
```

### Option 2: Direct Installation from Repository

```bash
# Clone the repository
git clone https://github.com/zjpiazza/directus-helm-chart.git
cd directus-helm-chart

# Install with dependencies
helm dependency update charts/directus
helm install directus charts/directus/
```

## Key Improvements

### 🎯 Ergonomic Configuration Structure

**Before (Original Chart):**
```yaml
env:
  DB_CLIENT: mysql
  DB_HOST: mydb.com
  DB_PORT: "3306"
  ADMIN_EMAIL: admin@example.com
  REDIS_ENABLED: "true"
```

**After (This Fork):**
```yaml
database:
  client: mysql
  host: mydb.com
  port: 3306

admin:
  email: admin@example.com

directusRedis:
  enabled: true
```

### 🔧 Dual Syntax Support

**Simple syntax** for basic use cases:
```yaml
database:
  host: "mydb.example.com"
  username: "directus"
```

**Advanced syntax** for referencing secrets:
```yaml
database:
  host: 
    secretKeyRef:
      name: db-secret
      key: hostname
  username:
    configMapKeyRef:
      name: db-config
      key: username
```

### 🚀 Smart Defaults

- Automatic database connection when using dependency charts
- Auto-generated PUBLIC_URL from ingress configuration
- Proper boolean values instead of string "true"/"false"
- Stronger generated passwords (16-32 characters)

## Configuration Examples

### MySQL with External Database

```yaml
database:
  client: mysql
  host: mysql.example.com
  port: 3306
  name: directus
  username: directus
  password:
    secretKeyRef:
      name: mysql-secret
      key: password

mysql:
  enabled: false
```

### PostgreSQL with Included Chart

```yaml
database:
  client: postgresql

postgresql:
  enabled: true
  auth:
    database: directus
    username: directus
```

### Redis Configuration

```yaml
directusRedis:
  enabled: true
  host: redis.example.com
  port: 6379
  password:
    secretKeyRef:
      name: redis-secret
      key: password

redis:
  enabled: false
```

## Migration from Original Chart

The new structure is backward compatible with deprecation warnings. To migrate:

1. Move `env.DB_*` → `database.*`
2. Move `env.ADMIN_EMAIL` → `admin.email`
3. Move `env.REDIS_*` → `directusRedis.*`
4. Convert string booleans to actual booleans
5. Update secret references to use new dual syntax

## GitHub Actions Setup

This chart includes automated publishing via GitHub Actions. To enable:

1. Go to your repository Settings → Pages
2. Set Source to "GitHub Actions"
3. Push changes to trigger chart release
4. Chart will be available at `https://zjpiazza.github.io/directus-helm-chart`