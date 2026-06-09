# Skill: Add pgvector Database on Kubernetes

## Description
Deploys a PostgreSQL 15 database with the pgvector extension on Kubernetes/OpenShift and configures the Quarkus application to connect to it. This enables vector similarity search for RAG, embeddings, and AI/ML workloads.

## When to Use
- User wants to add a vector database to their Quarkus application
- User needs pgvector for RAG (Retrieval-Augmented Generation) or embedding storage
- User asks to set up PostgreSQL with vector support on Kubernetes

## Steps

### 1. Apply Kubernetes Manifests

Apply the manifests in this skill directory to the target namespace:

```bash
# Set the target namespace (use current context namespace if not specified)
NAMESPACE=$(oc project -q 2>/dev/null || kubectl config view --minified -o jsonpath='{..namespace}')

# Apply the PVC, Secret, Deployment, and Service
kubectl apply -f .claude/skills/add-pgvector-k8s/pgvector-pvc.yaml -n $NAMESPACE
kubectl apply -f .claude/skills/add-pgvector-k8s/pgvector-secret.yaml -n $NAMESPACE
kubectl apply -f .claude/skills/add-pgvector-k8s/pgvector-deployment.yaml -n $NAMESPACE
kubectl apply -f .claude/skills/add-pgvector-k8s/pgvector-service.yaml -n $NAMESPACE
```

### 2. Wait for the Database to be Ready

```bash
kubectl rollout status deployment/pgvector -n $NAMESPACE --timeout=120s
```

### 3. Add Quarkus Dependencies (if not already present)

Add the following dependencies to `pom.xml`:

```xml
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-hibernate-orm-panache</artifactId>
</dependency>
<dependency>
    <groupId>io.quarkus</groupId>
    <artifactId>quarkus-jdbc-postgresql</artifactId>
</dependency>
```

### 4. Configure Quarkus Datasource

Add the following to `src/main/resources/application.properties`:

```properties
# PostgreSQL pgvector datasource
quarkus.datasource.db-kind=postgresql
quarkus.datasource.username=${POSTGRESQL_USER:quarkus}
quarkus.datasource.password=${POSTGRESQL_PASSWORD:quarkus}
quarkus.datasource.jdbc.url=jdbc:postgresql://${POSTGRESQL_HOST:pgvector}:${POSTGRESQL_PORT:5432}/${POSTGRESQL_DATABASE:quarkus}
quarkus.hibernate-orm.database.generation=update
```

### 5. Verify the Connection

```bash
# Port-forward to test locally
kubectl port-forward svc/pgvector 5432:5432 -n $NAMESPACE &

# Verify pgvector extension is installed
PGPASSWORD=quarkus psql -h localhost -U quarkus -d quarkus -c "SELECT extname FROM pg_extension WHERE extname = 'vector';"
```

## Manifests Included

| File | Resource | Purpose |
|------|----------|---------|
| `pgvector-pvc.yaml` | PersistentVolumeClaim | 20Gi storage for database data |
| `pgvector-secret.yaml` | Secret | Database credentials (user/pass/dbname: quarkus) |
| `pgvector-deployment.yaml` | Deployment | PostgreSQL 15 with pgvector, lifecycle hook to enable extension |
| `pgvector-service.yaml` | Service | Exposes PostgreSQL on port 5432 |

## Configuration Details

- **Image**: `quay.io/rh-aiservices-bu/postgresql-15-pgvector-c9s:latest`
- **Port**: 5432
- **Default credentials**: user=quarkus, password=quarkus, database=quarkus
- **Storage**: 20Gi PVC at `/var/lib/pgsql/data`
- **Memory limit**: 512Mi
- **pgvector extension**: Automatically created via postStart lifecycle hook

## Important Notes

- Change the default credentials in `pgvector-secret.yaml` before deploying to production. Values are base64-encoded.
- The PVC uses the default StorageClass. Specify a `storageClassName` if needed.
- The postStart hook waits for PostgreSQL readiness before creating the vector extension.
- For production, consider increasing the PVC size and memory limits.
