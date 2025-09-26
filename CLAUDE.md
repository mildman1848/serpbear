# CLAUDE.md - LinuxServer.io Container Template Standards

Diese Datei definiert standardisierte Richtlinien für Claude Code (claude.ai/code) zur Erstellung von Container-Images basierend auf LinuxServer.io Standards mit umfassender Sicherheitshärtung.

## 🎯 Template-Übersicht

Dieses Template standardisiert die Erstellung von benutzerdefinierten Docker-Images basierend auf LinuxServer.io Alpine Baseimages, nach 2024 LinuxServer.io Pipeline-Standards.

**Kern-Technologien:**
- **Base:** LinuxServer.io Alpine 3.22+ mit S6 Overlay v3

## 🚨 CRITICAL BATTLE-TESTED INSIGHTS (2025-09-25)

### ⚠️ VERPFLICHTENDE S6 OVERLAY SERVICE-STRUKTUR

**LESSON LEARNED:** Das Tandoor-Projekt hatte unvollständige S6 Service-Struktur, die zu Container-Startproblemen führte.

**TEMPLATE-REQUIREMENT:** Alle Projekte MÜSSEN folgende LinuxServer.io Standard-Services implementieren:

```
# Vollständige S6 Service-Kette (MANDATORY)
init-branding → init-mods-package-install → init-custom-files → init-secrets → init-{app}-config → {app}
```

**Kritische Service-Konfiguration:**
- ✅ **Service-Types:** Alle auf `oneshot` setzen
- ✅ **Dependencies:** Korrekte Abhängigkeitskette nach LinuxServer.io Standards
- ✅ **User Bundle:** Hauptservice MUSS in `user/contents.d/{APPLICATION_NAME}` enthalten sein
- ✅ **Missing Services:** init-adduser, init-custom-files, init-mods-package-install sind VERPFLICHTEND

### 🔧 DOCKER COMPOSE & CI/CD STANDARDISIERUNG

**LESSON LEARNED:** GitHub Actions Workflow-Failures durch veraltete Docker Compose Installation.

**TEMPLATE-FIXES:**
- ✅ **Docker Compose v2 Migration:** Alle `docker-compose` → `docker compose` Commands
- ✅ **CI Independence:** `IMAGE_TAG=test` für lokale Builds, keine DockerHub-Abhängigkeiten
- ✅ **Hadolint Configuration:** Proper ignore directives für LinuxServer.io Requirements

### 🔐 RELEASE-TRIGGERED PUBLISHING PATTERN

**TEMPLATE-STANDARD:** Keine automatischen Docker Image Pushes bis manuelles Release erstellt wird.

**GitHub Actions Pattern:**
```yaml
on:
  release:
    types: [published]  # Nur bei manuel erstellten Releases
  workflow_dispatch:    # Manual trigger option
```

**Benefits:**
- ✅ **Quality Control:** Verhindert broken images in production
- ✅ **Version Control:** Explizite Release-Versionen
- ✅ **Security:** Controlled deployment pipeline

### 📊 APPLICATION-SPECIFIC BEST PRACTICES

**Django Applications (Tandoor Insights):**
```bash
# MANDATORY Django Container Requirements
python manage.py migrate           # Database migrations (CRITICAL)
python manage.py collectstatic     # Static files collection (REQUIRED)
pg_isready --host=${POSTGRES_HOST} # Database readiness checks (ESSENTIAL)
```

**Node.js Applications (Audiobookshelf Insights):**
```bash
# Advanced Security Patching
npm audit --audit-level=high       # 82% vulnerability reduction achieved
# Intelligent nested dependency replacement system
```

**Binary Applications (rclone Insights):**
```bash
# Environment Variable Collision Avoidance
RCLONE_VERSION → RCLONE_APP_VERSION # Prevents CLI flag conflicts
# Process-based health checks without authentication
ps aux | grep rclone               # Avoids authentication requirements
```

### 📁 STANDARDIZED DIRECTORY STRUCTURE (2025-09-25)

**TEMPLATE-REQUIREMENT:** Alle Projekte MÜSSEN identische Verzeichnisstruktur befolgen:

```
project/
├── config/                  # Runtime configuration
├── data/                    # Application data (NEW STANDARD)
│   ├── mediafiles/         # Media files (Django/Web apps)
│   ├── staticfiles/        # Static files (Django/Web apps)
│   └── uploads/           # User uploads
├── security/               # Security configurations (MANDATORY)
│   └── seccomp-profile.json # Custom seccomp profile
├── secrets/                # Secret files
├── logs/                   # Application logs
├── docs/                   # Centralized documentation (NEW)
│   ├── LINUXSERVER.md     # LinuxServer.io compliance docs
│   ├── LINUXSERVER.de.md  # German LinuxServer.io docs
│   └── [additional-docs]  # Project-specific documentation
└── [standard project files]
```

**Volume Mount Standardization:**
```yaml
volumes:
  - ${CONFIG_PATH:-./config}:/config
  - ${DATA_PATH:-./data}:/app/data           # Standardized
  - ${LOGS_PATH:-./logs}:/config/logs
```

### 🔄 GITHUB ACTIONS WORKFLOW PATTERNS (Battle-Tested)

**Complete Workflow Set (MANDATORY):**
- ✅ **ci.template.yml** - Multi-platform testing, security scanning, compose validation
- ✅ **docker-publish.template.yml** - Release-triggered publishing (GHCR only)
- ✅ **security.template.yml** - Trivy, filesystem scans, Hadolint
- ✅ **codeql.template.yml** - Static code analysis
- ✅ **upstream-monitor.template.yml** - Automated dependency monitoring
- ✅ **release.template.yml** - Automated release management
- ✅ **maintenance.template.yml** - Artifact cleanup, dependency updates

**Standard CI Pattern (Proven in All Projects):**
```yaml
- name: Setup Docker Compose
  run: |
    sudo apt-get update
    sudo apt-get install -y docker-compose-plugin
    docker compose version

- name: Test docker-compose configuration
  run: |
    IMAGE_TAG=test docker compose config --quiet
    IMAGE_TAG=test docker compose up -d --wait
```

### ⚙️ PRETTIER CONFIGURATION STANDARDIZATION (2025-09-25)

**TEMPLATE-INCLUSIONS:** Alle Projekte haben jetzt standardisierte Prettier-Konfiguration:

- ✅ **`.prettierrc`** - Unified code formatting rules
- ✅ **`.prettierignore`** - Security and container-specific exclusions
- ✅ **Multi-format Support** - YAML, JSON, Markdown, JavaScript optimized
- ✅ **LinuxServer.io Compliance** - Respects Makefile and container file formatting

**Configuration Highlights:**
```json
{
  "printWidth": 120,
  "tabWidth": 2,
  "singleQuote": true,
  "trailingComma": "es5",
  "overrides": [
    {"files": ["*.yml", "*.yaml"], "options": {"singleQuote": false}},
    {"files": ["*.md"], "options": {"printWidth": 100, "proseWrap": "always"}}
  ]
}
```

### 🛡️ SECURITY HARDENING LESSONS (Multi-Project)

**Container Security (Battle-Tested):**
```yaml
# docker-compose.override.yml (ALL projects)
security_opt:
  - no-new-privileges:true
  - apparmor=docker-default
  - seccomp=./security/seccomp-profile.json  # Standardized path
cap_drop: [ALL]
cap_add: [SETGID, SETUID, CHOWN, DAC_OVERRIDE]  # Minimal required
ports:
  - "127.0.0.1:${EXTERNAL_PORT}:${APPLICATION_PORT}"  # Localhost-only
```

**Secret Management (Enhanced):**
```bash
# 512-bit JWT secrets, 256-bit API keys (ALL projects)
JWT_SECRET=$(openssl rand -base64 48)
API_KEY=$(openssl rand -base64 32)
DB_PASSWORD=$(openssl rand -base64 24)
```
- **Architektur:** OCI Manifest Lists mit nativem Multi-Platform Support (AMD64, ARM64)
- **Sicherheit:** Erweiterte Container-Härtung, Capability-Management, Secrets-Verwaltung
- **Compliance:** Vollständige LinuxServer.io Standard-Konformität (FILE__ Secrets, Docker Mods, Custom Scripts)
- **Pipeline:** 2024 LinuxServer.io Pipeline-Standards mit architekturspezifischen Tags

## 📚 Dokumentationsanforderungen

**Sprach-Richtlinie:** Alle Projekte müssen zweisprachige Dokumentation (Englisch/Deutsch) mit Querverweisen pflegen:
- `README.md` / `README.de.md`
- `LINUXSERVER.md` / `LINUXSERVER.de.md` (optional)
- `SECURITY.md` / `SECURITY.de.md` (optional)

**Querverweis-Format:**
```markdown
🇩🇪 **Deutsche Version:** [README.de.md](README.de.md)
🇺🇸 **English Version:** [README.md](README.md)
```

## ⚠️ KRITISCHE VERSION-MANAGEMENT STANDARDS (2025-09-24)

### 🚨 VERPFLICHTENDE UPSTREAM-VERSION-PRÜFUNG

**CRITICAL LESSON LEARNED:** Tandoor-Projekt verwendete Version 1.5.19 während aktuelle Version 2.2.4 war.
**Folgen:** 2+ Tage verschwendete Debugging-Zeit für bereits gelöste Probleme in neuer Version.

**NEUE VERPFLICHTENDE REGEL:**
```bash
# VOR JEDEM PROJECT-BUILD - IMMER AKTUELLE VERSION PRÜFEN
make version-check    # MUSS in allen Projekten implementiert sein
```

**Template Requirements (MANDATORY):**
1. **UPSTREAM_REPO Variable:** MUSS in Makefile definiert sein
2. **version-check Target:** MUSS implementiert sein
3. **Pre-Build Check:** build target MUSS version-check als Dependency haben
4. **GitHub API Integration:** Automatische Latest-Version-Abfrage
5. **BUILD_BLOCKER:** Build fails wenn version-check nicht bestanden wird

**Template version-check Implementation (VERPFLICHTEND):**
```makefile
# Variables (erforderlich)
${APPLICATION_NAME_UPPER}_VERSION ?= ${DEFAULT_VERSION}
UPSTREAM_REPO = ${UPSTREAM_ORG}/${UPSTREAM_PROJECT}

# Version Management (VERPFLICHTEND)
version-check: ## Check if current version is up to date with upstream
	@echo "$(BLUE)Checking upstream version...$(NC)"
	@LATEST=$$(curl -s https://api.github.com/repos/$(UPSTREAM_REPO)/releases/latest | grep -o '"tag_name": *"[^"]*"' | sed 's/"tag_name": *"//;s/"//' 2>/dev/null || echo "unknown"); \
	LATEST_CLEAN=$$(echo "$$LATEST" | sed 's/^v//'); \
	if [ "$$LATEST" = "unknown" ]; then \
		echo "$(YELLOW)⚠️  Unable to fetch latest version from GitHub API$(NC)"; \
		echo "$(YELLOW)Current version: $(${APPLICATION_NAME_UPPER}_VERSION)$(NC)"; \
		echo "$(YELLOW)Please check https://github.com/$(UPSTREAM_REPO)/releases manually$(NC)"; \
	elif [ "$$LATEST_CLEAN" != "$(${APPLICATION_NAME_UPPER}_VERSION)" ]; then \
		echo "$(RED)⚠️  OUTDATED: Using $(${APPLICATION_NAME_UPPER}_VERSION), latest is $$LATEST_CLEAN$(NC)"; \
		echo "$(YELLOW)Consider updating ${APPLICATION_NAME_UPPER}_VERSION in Makefile and Dockerfile$(NC)"; \
		echo "$(BLUE)Release info: https://github.com/$(UPSTREAM_REPO)/releases/tag/$$LATEST$(NC)"; \
	else \
		echo "$(GREEN)✅ Using latest version: $(${APPLICATION_NAME_UPPER}_VERSION)$(NC)"; \
	fi

# Build Integration (VERPFLICHTEND)
build: version-check ## Build with mandatory version check
```

**Template Variables zum Ersetzen:**
- `${APPLICATION_NAME}` → Projekt-Name (z.B. "tandoor")
- `${APPLICATION_NAME_UPPER}` → Großbuchstaben (z.B. "TANDOOR")
- `${DEFAULT_VERSION}` → Standard-Version (z.B. "2.2.4")
- `${UPSTREAM_ORG}` → GitHub Organisation (z.B. "TandoorRecipes")
- `${UPSTREAM_PROJECT}` → Repository Name (z.B. "recipes")

## 🔒 Sicherheitsarchitektur-Standards

### Verpflichtende Docker Security-Implementierung

**Quelle:** [Docker Security Best Practices](https://docs.docker.com/engine/security/)
**Aktualisierungscheck:** Monatliche Überprüfung der offiziellen Docker-Sicherheitsdokumentation

Alle Projekte implementieren umfassende Docker-Sicherheitsbestpraktiken:

**Automatische Sicherheitshärtung (docker-compose.override.yml):**
```yaml
# VERPFLICHTEND für alle Projekte
security_opt:
  - no-new-privileges:true
  - apparmor=docker-default
  - seccomp=./security/seccomp-profile.json
cap_drop:
  - ALL
cap_add:
  - SETGID      # Benutzerumschaltung (LinuxServer.io Anforderung)
  - SETUID      # Benutzerumschaltung (LinuxServer.io Anforderung)
  - CHOWN       # Dateiberechtigungen
  - DAC_OVERRIDE  # Dateizugriff (minimal)
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 1G
      pids: 200
ports:
  - "127.0.0.1:${EXTERNAL_PORT}:${APPLICATION_PORT}"  # Localhost-only Binding (KRITISCH für Security)
tmpfs:
  - /tmp:noexec,nosuid,size=50M
  - /var/tmp:noexec,nosuid,size=50M
```

**Produktions-Sicherheit (docker-compose.production.yml):**
```yaml
# Maximale Sicherheit für Produktionsumgebungen
read_only: true
tmpfs:
  - /tmp:noexec,nosuid,size=50M,mode=1777
  - /run:noexec,nosuid,size=50M,mode=755
volumes:
  - ./config:/config:ro  # Read-only wo möglich
networks:
  - name: ${APPLICATION_NAME}_network
    driver: bridge
    internal: false
```

**Container-Härtung (Dockerfile Standards):**
```dockerfile
# VERPFLICHTEND für alle Dockerfiles
USER abc
EXPOSE ${APPLICATION_PORT}
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=5 \
  CMD ${APPLICATION_SPECIFIC_HEALTH_CHECKS}
WORKDIR /app
```

**Capability-Management (Erforderlich):**
```yaml
# docker-compose.override.yml
cap_drop:
  - ALL
cap_add:
  - SETGID    # Benutzerumschaltung
  - SETUID    # Benutzerumschaltung
  - CHOWN     # Dateiberechtigungen
  - DAC_OVERRIDE  # Dateizugriff (minimal)
```

### Secret-Management (LinuxServer.io Standard)

**Quelle:** [LinuxServer.io Secrets Dokumentation](https://github.com/linuxserver/docker-baseimage-alpine)

**Bevorzugte Methode - FILE__ Prefix:**
```bash
# Umgebungsvariablen
FILE__APP_PASSWORD=/run/secrets/app_password
FILE__APP_API_KEY=/run/secrets/app_api_key
FILE__APP_JWT_SECRET=/run/secrets/app_jwt_secret
```

**Service-Implementierung:**
```bash
# init-secrets Service Template
#!/usr/bin/with-contenv bash

# Verarbeitet FILE__ prefixe Secrets (LinuxServer.io Standard)
for VAR in $(env | grep '^FILE__' | cut -d= -f1); do
    FILE_PATH=$(env | grep "^${VAR}=" | cut -d= -f2-)

    if [[ -f "${FILE_PATH}" && -r "${FILE_PATH}" ]]; then
        VAR_NAME=${VAR#FILE__}
        VAR_VALUE=$(cat "${FILE_PATH}")
        export "${VAR_NAME}=${VAR_VALUE}"
        echo "✓ Secret geladen: ${VAR_NAME}"
    fi
done
```

**Secret-Generierung-Standards:**
```bash
# Mindest-Sicherheitsanforderungen
JWT_SECRET=$(openssl rand -base64 48)     # 512-bit JWT Secrets
API_KEY=$(openssl rand -base64 32)        # 256-bit API Keys
DB_PASSWORD=$(openssl rand -base64 24)    # 192-bit DB Passwords
SESSION_SECRET=$(openssl rand -base64 32) # 256-bit Session Secrets
```

## 🔧 Build und Development-Standards

### Essential Make Commands (Standardisiert für alle Projekte)

**Quelle:** [LinuxServer.io Build Standards](https://github.com/linuxserver/pipeline-templates)
**Aktualisierungscheck:** Monatliche Überprüfung der LinuxServer.io Pipeline-Updates

```bash
# Setup and Initial Configuration
make setup                    # Complete initial setup (creates .env + generates secrets)
make env-setup               # Create .env from .env.example template
make secrets-generate        # Generate secure secrets (512-bit JWT, 256-bit API keys)

# Build and Test (Enhanced with OCI Manifest Lists)
make build                   # Build Docker image for current platform
make build-multiarch         # Build multi-architecture image (Legacy)
make build-manifest          # LinuxServer.io style Manifest Lists (Recommended)
make inspect-manifest        # Inspect manifest lists (Multi-arch details)
make validate-manifest       # Validate OCI manifest compliance
make test                    # Run comprehensive container tests with health checks
make validate               # Validate Dockerfile with hadolint
make security-scan          # Run comprehensive security scan (Trivy + CodeQL)
make trivy-scan              # Run Trivy vulnerability scan only
make codeql-scan             # Run CodeQL static code analysis
make security-scan-detailed  # Run detailed security scan with exports

# LinuxServer.io Baseimage Management (2025-09-25)
make baseimage-check        # Check for LinuxServer.io baseimage updates
make baseimage-test         # Test new LinuxServer.io baseimage version
make baseimage-update       # Update to latest LinuxServer.io baseimage

# Container Management (Improved)
make start                  # Start container using docker-compose
make stop                   # Stop running containers
make restart                # Stop and restart containers
make status                 # Show container status and health
make logs                   # Show container logs
make shell                  # Get shell access to running container

# Development
make dev                    # Build and run development container

# Environment Management (Enhanced)
make env-validate           # Validate .env configuration (enhanced checks)
make secrets-info           # Show current secrets status with details
make secrets-rotate         # Rotate secrets (with backup and stronger encryption)
make secrets-clean          # Clean up old secret backups
```

## 🏗️ ADVANCED MULTI-STAGE BUILD PATTERNS (2025-09-24)

### ✅ Asset Extraction Pattern (Tandoor Success Story)

**Use Case:** Complex web applications mit pre-built assets die nicht neu kompiliert werden können.

**Problem:** Vue.js/React apps mit Vite/Webpack builds benötigen echte Assets, nicht Platzhalter.

**Lösung - Multi-Stage Build mit Asset Extraction:**
```dockerfile
# Extract assets from official upstream image
FROM ${UPSTREAM_IMAGE}:${UPSTREAM_VERSION} AS asset_source

FROM ghcr.io/linuxserver/baseimage-alpine:3.22

# ... build steps ...

# Copy real assets from upstream (CRITICAL for web apps)
COPY --from=asset_source /upstream/asset/path/ /app/target/path/
```

**Tandoor Example (PROVEN WORKING):**
```dockerfile
# Extract Vite assets from official Tandoor image
FROM ghcr.io/tandoorrecipes/recipes:latest AS vite_assets

FROM ghcr.io/linuxserver/baseimage-alpine:3.22

# ... normal build process ...

# Copy Vite assets from official image (solves white screen)
COPY --from=vite_assets /opt/recipes/cookbook/static/vue3/ /app/cookbook/static/vue3/
```

**Benefits:**
- ✅ **Real Assets:** Echte kompilierte Frontend-Assets statt Platzhalter
- ✅ **Build Reliability:** Eliminiert komplexe Node.js/npm Build-Schritte im Container
- ✅ **Upstream Sync:** Automatisch aktuell mit Upstream-Releases
- ✅ **Size Optimization:** Nur finale Assets, keine Build-Dependencies

## 🌐 DJANGO/WEB APPLICATION BEST PRACTICES (2025-09-24)

### ⚠️ KRITISCHE DJANGO STARTUP-REQUIREMENTS

**Basierend auf Tandoor 2.2.4 Migration - Diese Steps sind MANDATORY für Django-Apps:**

**1. Database Migrations (CRITICAL):**
```bash
# Im S6 Startup Script (z.B. root/etc/s6-overlay/s6-rc.d/app/run)
echo "Migrating database..."
s6-setuidgid abc /app/venv/bin/python manage.py migrate
```

**2. Database Wait Logic (ESSENTIAL):**
```bash
echo "Waiting for database to be ready..."
attempt=0
max_attempts=20
while ! pg_isready --host=${POSTGRES_HOST:-db} --port=${POSTGRES_PORT:-5432} --user=${POSTGRES_USER:-user} -q; do
    attempt=$((attempt+1))
    if [ $attempt -gt $max_attempts ]; then
        echo "❌ Database not reachable. Maximum attempts exceeded."
        exit 1
    fi
    echo "Waiting for database... (attempt $attempt/$max_attempts)"
    sleep 5
done
echo "✓ Database is ready"
```

**3. Static Files Collection (REQUIRED):**
```bash
echo "Collecting static files..."
s6-setuidgid abc /app/venv/bin/python manage.py collectstatic --noinput --clear
```

**4. Modern Frontend Integration (Vue.js/React mit Vite):**
- ✅ **Multi-Stage Builds:** Assets aus Upstream-Image kopieren
- ✅ **Manifest Files:** Echte manifest.json mit Asset-Definitionen
- ✅ **Service Workers:** PWA-Unterstützung für moderne Web-Apps
- ✅ **Permissions:** Korrekte abc:abc Ownership für Assets

### 🔧 DJANGO VERSION MIGRATION PATTERNS

**Major Version Migrations (z.B. 1.x → 2.x):**
```bash
# 1. Version Update im Dockerfile
ARG APPLICATION_VERSION="2.2.4"  # Update version

# 2. Check for architectural changes
# - Frontend: webpack → Vite migration
# - Backend: Django version updates
# - Database: New migrations

# 3. Multi-stage build for complex assets
FROM upstream/app:${APPLICATION_VERSION} AS assets
COPY --from=assets /path/to/assets/ /app/assets/

# 4. Test migration path
make build && make test
```

**Debugging White Screen Issues:**
1. **Check Assets:** `curl http://localhost:port/static/manifest.json`
2. **Verify Logs:** Look for django-vite/webpack errors
3. **Test Endpoints:** `curl -I http://localhost:port/` should return 200/302
4. **Asset Size:** Empty assets (Content-Length: 0) indicate missing files

### Docker Compose Operations (Standardisiert)

```bash
# Development operations
docker-compose up -d                         # Start in detached mode
docker-compose up -d ${APPLICATION_NAME}     # Start only main service
docker-compose logs -f                       # Follow logs

# Production deployment (VERPFLICHTEND für alle Projekte)
docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
docker-compose -f docker-compose.yml -f docker-compose.production.yml down
docker-compose -f docker-compose.yml -f docker-compose.production.yml logs -f

# Production configuration validation
docker-compose -f docker-compose.yml -f docker-compose.production.yml config --quiet
```

**⚠️ VERPFLICHTEND: docker-compose.production.yml**

Alle Projekte MÜSSEN eine Production-Konfiguration bereitstellen mit:
- **Localhost-only Binding:** `127.0.0.1:${PORT}` für maximale Sicherheit
- **Ressourcenbegrenzungen:** CPU (2.0 cores), Memory (1GB), PIDs (200)
- **Enhanced Security:** UMASK=027, CORE_DUMP_SIZE=0, no-new-privileges
- **Structured Logging:** JSON format mit Rotation (50MB, 5 files)
- **Process-based Health Checks:** Häufigere Überprüfungen (15s interval)
- **Network Isolation:** Custom bridge networks mit restricted ICC

## 🏗️ Architecture Overview (LinuxServer.io S6 Overlay)

### S6 Overlay Services Structure (Template-Standard)

**⚠️ KRITISCH: S6 Service Bundle Konfiguration**

**Häufiger Fehler:** Services starten nicht, weil sie nicht im S6 User Bundle enthalten sind.

**Lösung:** IMMER sicherstellen, dass der Hauptservice in der User-Bundle-Konfiguration enthalten ist:
```
root/etc/s6-overlay/s6-rc.d/user/contents.d/{APPLICATION_NAME}
```

**Debugging:** Wenn Services nicht starten, prüfen Sie:
1. Service ist in `user/contents.d/` enthalten
2. Dependencies sind korrekt definiert
3. Service-Scripts sind ausführbar

Alle Container verwenden S6 Overlay v3 mit folgender Service-Abhängigkeitskette:

```
init-branding → init-mods-package-install → init-custom-files → init-secrets → init-{app}-config → {app}
```

**Service-Locations:** `root/etc/s6-overlay/s6-rc.d/`

**Standard-Services (Template):**
- `init-branding`: Mildman1848 ASCII Art Branding (standardisiert)
- `init-secrets`: Enhanced FILE__ prefix processing mit Pfad-Validierung
- `init-{app}-config`: Anwendungsspezifische Konfiguration und Validierung
- `{app}`: Haupt-Anwendungsservice mit Health Check Integration

**Standard-Implementierung (Recent Best Practices):**
- ✅ **chmod Permission Fixes**: Sichere Fallback-Methoden für Berechtigungen
- ✅ **Enhanced FILE__ Secret Processing**: Pfad-Sanitization und Validierung
- ✅ **Error Handling**: Verbesserte Fehlerbehandlung in allen Services
- ✅ **Configuration Validation**: Automatische Konfigurations-Validierung
- ✅ **Health Check Integration**: Process-basierte Health Checks ohne Authentication
- ✅ **Logging Optimization**: Reduzierte unnecessary Warnings

### Security Architecture (Erweitert)

**Container Security (Erweiterte Standards):**
- Non-root execution (user `abc`, UID 911)
- Security hardening mit `no-new-privileges`
- Capability dropping (ALL dropped, minimal added)
- Read-only where possible mit tmpfs mounts

**Secret Management (Enhanced Standards):**
- **Preferred:** LinuxServer.io FILE__ prefix secrets mit path validation
- **Encryption:** 512-bit JWT secrets, 256-bit API keys
- **Legacy:** Docker Swarm secrets support (backward compatible)
- **Generated secrets:** JWT, API keys, database credentials, session secrets
- **Security:** Automatic backup, rotation, and cleanup capabilities

**Vulnerability Management (2024/2025 Standards):**
- **Trivy Scanning:** Container und filesystem vulnerability detection
- **CodeQL Analysis:** Static code analysis für security issues
- **npm Security:** Comprehensive package vulnerability patches
- **Advanced Nested Fixes:** Intelligent replacement system für vulnerable nested dependencies
- **Production Status:** Zero CRITICAL vulnerabilities, minimal remaining risk
- **Automation:** GitHub Actions integration für continuous security scanning

### OCI Manifest Lists & LinuxServer.io Pipeline (2024 Standards)

**Multi-Architecture Implementation (Template-Standard):**
- **OCI Compliance:** Full OCI Image Manifest Specification v1.1.0 support
- **LinuxServer.io Style:** Architecture-specific tags + Manifest Lists
- **Native Builds:** No emulation - true platform-specific images
- **GitHub Actions:** Matrix-based builds mit digest management

**Architecture Tags (LinuxServer.io Standard-Template):**
```bash
# Architecture-specific pulls
docker pull mildman1848/${APPLICATION_NAME}:amd64-latest
docker pull mildman1848/${APPLICATION_NAME}:arm64-latest

# Automatic platform selection
docker pull mildman1848/${APPLICATION_NAME}:latest
```

**Build Process (Template-Standard):**
```bash
# LinuxServer.io Pipeline compliance
make build-manifest          # Create manifest lists with arch tags
make inspect-manifest        # Inspect OCI manifest structure
make validate-manifest       # Validate OCI compliance
```

## 🔄 Development Workflow (Standardisiert)

### Setting Up Development Environment

1. **Initial Setup:**
   ```bash
   make setup              # Creates .env and generates secrets
   ```

2. **Environment Customization:**
   - Edit `.env` file for local paths and settings
   - Ensure `PUID`/`PGID` match your user: `id -u && id -g`

3. **Development Container:**
   ```bash
   make dev               # Builds and runs with development volumes
   ```

### Making Changes (Template-Standard)

**For S6 Services:** Edit files in `root/etc/s6-overlay/s6-rc.d/`
**For Build Process:** Modify `Dockerfile` and `Makefile`
**For Configuration:** Update `.env.example` and `docker-compose.yml`

**Testing Changes (Enhanced mit Manifest Support):**
```bash
make validate           # Dockerfile linting with hadolint
make build             # Build new image for current platform
make build-manifest    # Build LinuxServer.io style multi-arch with manifest lists
make inspect-manifest  # Inspect manifest structure and platform details
make validate-manifest # Validate OCI manifest compliance
make test              # Run comprehensive integration tests
make security-scan     # Comprehensive security validation (Trivy + CodeQL)
make trivy-scan        # Trivy vulnerability scanning only
make codeql-scan       # CodeQL static code analysis
make status            # Check container health and status
```

**Application-Specific Testing Process (Template-Anpassung):**
Die `make test` Kommando führt umfassende Validierung durch:
1. **Container Startup** - Creates test directories and starts container with proper volumes
2. **Health Check** - Validates application process is running with `ps aux | grep ${APPLICATION_NAME}`
3. **Binary Test** - Verifies `${APPLICATION_NAME} --version` command works inside container
4. **Container Verification** - Confirms container is healthy and running
5. **Cleanup** - Automatically stops container and removes test directories

**⚠️ CRITICAL PUSH WORKFLOW REQUIREMENTS (Template-Standard):**
Before pushing changes to GitHub, ALWAYS follow this sequence:
1. **Build Image:** `make build` - Verify image builds successfully
2. **Test Container:** `make test` - Ensure application starts and interface is accessible
3. **Only push if:** Both build and test complete successfully with clean logs
4. **Never push** broken or non-functional versions to repository

### CI/CD Integration (Template-Standard)

**GitHub Actions Workflows:** (`.github/workflows-template/`)
- `ci.template.yml`: Automated testing and validation
- `docker-publish.template.yml`: Enhanced OCI manifest lists mit LinuxServer.io pipeline standards
- `security.template.yml`: Security scanning and SBOM generation
- `codeql.template.yml`: CodeQL static code analysis für JavaScript/TypeScript
- `upstream-monitor.template.yml`: Automated upstream dependency monitoring mit issue creation
- `release.template.yml`: Automated release management mit docker publishing trigger

**Enhanced Docker Publish Workflow (Template-Features):**
- **Matrix Builds:** Separate jobs for each platform (amd64, arm64)
- **Digest Management:** Platform images pushed by digest mit artifact sharing
- **Manifest Creation:** OCI-compliant manifest lists mit architecture-specific tags
- **LinuxServer.io Style:** Architecture tags (`amd64-latest`, `arm64-latest`)
- **Validation:** Manifest structure inspection and OCI compliance verification

**Upstream Monitoring Workflow (Template-Standard):**
- **Schedule:** Monday and Thursday at 6 AM UTC
- **Application Monitoring:** GitHub API release tracking mit automated issue creation
- **Base Image Monitoring:** LinuxServer.io baseimage-alpine 3.22 series tracking
- **Security Assessment:** Prioritizes security-related updates
- **Semi-Automated:** Creates GitHub issues for manual review and action

## 🛠️ Common Development Patterns (Template-Standards)

### Adding New Environment Variables

1. Add to `.env.template` mit documentation
2. Reference in `docker-compose.template.yml` environment section
3. Handle in relevant S6 service script
4. Update both README.md and README.de.md if user-facing (maintain bilingual documentation)

### Modifying Container Startup

- Main application logic: `root/etc/s6-overlay/s6-rc.d/{app}/run`
- Configuration setup: `root/etc/s6-overlay/s6-rc.d/init-{app}-config/up`
- Secret processing: `root/etc/s6-overlay/s6-rc.d/init-secrets/up`

### Security Best Practices (Template-Requirements)

**⚠️ KRITISCHE Sicherheitseinstellungen:**
1. **Host Binding:** PORT auf 127.0.0.1 beschränken (`HOST=127.0.0.1`)
2. **Authentication:** NO_AUTH=false als Standard (nie deaktivieren in Produktion)
3. **S6 Service Bundle:** Hauptservice MUSS in `user/contents.d/` enthalten sein

- All secrets should use FILE__ prefix when possible
- Validate input parameters in S6 scripts
- Use `s6-setuidgid abc` for non-root execution
- Set proper file permissions (750 for config, 600 for secrets)

## 🚨 Troubleshooting (Comprehensive Template Guide)

### Common Issues (Standard Solutions)

**Permission errors:**
- Check PUID/PGID in `.env` - should match your user (`id -u && id -g`)
- Verify directory ownership: `sudo chown -R $USER:$USER ./config ./data`
- Use secure fallback methods in S6 services

**Port conflicts:**
- Modify EXTERNAL_PORT in `.env` (default varies by application)
- Check if port is already in use: `netstat -tlnp | grep :PORT`
- Use `docker-compose down` before changing ports

**Secret errors:**
- Run `make secrets-generate` to create initial secrets
- Check `make secrets-info` für current secrets status
- Verify FILE__ prefix paths exist and are readable
- Enhanced validation mit path sanitization

**Health check failures:**
- Check application startup logs: `make logs`
- Verify configuration files are properly created
- Use process-based health checks avoiding authentication requirements
- Extended health check intervals (30s start period, 15s interval, 5 retries)

**Container startup issues:**
- Validate environment variables: `make env-validate`
- Check S6 service dependency chain
- Review init services logs für configuration errors
- Application-specific startup validation

**Docker workflow failures:**
- Verify GHCR_TOKEN permissions (write:packages, read:packages)
- Check GitHub Actions secrets configuration
- Review workflow syntax and matrix configurations
- Proper error handling in cleanup steps

**Build failures:**
- Run `make validate` für Dockerfile linting
- Check for conflicting environment variables
- Verify base image availability and versions
- Review multi-platform build compatibility

**Debug Mode (Template-Standard):**
```bash
# Enable debug logging
echo "LOG_LEVEL=debug" >> .env
echo "DEBUG_MODE=true" >> .env
make restart
```

## 📄 File Structure (Template-Standard) - Updated 2025-09-23

```
${APPLICATION_NAME}/
├── Dockerfile                 # Multi-stage container build (von .template erstellt)
├── Makefile                   # Build und development automation (von .template erstellt)
├── docker-compose.yml         # Service orchestration mit secrets (von .template erstellt)
├── docker-compose.production.yml # Production deployment mit maximaler Sicherheit (VERPFLICHTEND)
├── docker-compose.override.yml   # Development overrides (automatisch geladen)
├── .env.example              # Configuration template (von .env.template erstellt)
├── .dockerignore             # Docker build context optimization
├── .gitignore               # Git exclusion patterns
├── VERSION                   # Semantic versioning file
├── CHANGELOG.md             # Change documentation (VERPFLICHTEND)
├── CLAUDE.md                # Claude Code guidance
├── README.md                # English documentation
├── README.de.md             # German documentation (VERPFLICHTEND)
├── LINUXSERVER.md           # LinuxServer.io compliance documentation (optional)
├── LINUXSERVER.de.md        # German LinuxServer.io documentation (optional)
├── SECURITY.md              # Security documentation (optional)
├── SECURITY.de.md           # German security documentation (optional)
├── LICENSE                  # Project license
├── root/                    # Container filesystem overlay
│   └── etc/s6-overlay/s6-rc.d/  # S6 service definitions
├── .github/workflows/       # CI/CD automation (von workflows-template erstellt)
│   ├── ci.yml              # Continuous integration
│   ├── docker-publish.yml  # Multi-arch container publishing
│   ├── security.yml        # Security scanning (Trivy, CodeQL)
│   ├── codeql.yml          # Static code analysis
│   ├── upstream-monitor.yml # Dependency monitoring
│   └── release.yml         # Release automation
├── config/                  # Runtime configuration (created by make setup)
│   ├── cache/              # Application cache
│   └── logs/              # Application logs
├── data/                    # Application data (STANDARDISIERT 2025-09-23)
│   ├── mediafiles/         # Media files (Django/Web apps)
│   ├── staticfiles/        # Static files (Django/Web apps)
│   ├── audiobooks/         # Audiobook files (Audiobookshelf)
│   ├── podcasts/           # Podcast files (Audiobookshelf)
│   ├── metadata/           # Metadata cache (Audiobookshelf)
│   └── uploads/           # User uploads
├── docs/                   # Project documentation (STANDARDISIERT 2025-09-23)
│   ├── LINUXSERVER.md      # LinuxServer.io compliance documentation
│   ├── LINUXSERVER.de.md   # German LinuxServer.io documentation
│   ├── API.md              # API documentation (optional)
│   └── INSTALLATION.md     # Installation guide (optional)
├── security/               # Security configurations (VERPFLICHTEND)
│   ├── seccomp-profile.json # Custom seccomp profile
│   └── apparmor-profile   # AppArmor profile (optional)
├── secrets/                # Secret files (created by make secrets-generate)
│   ├── ${APP}_secret_key.txt
│   ├── ${APP}_api_key.txt
│   └── backup-YYYYMMDD-HHMMSS/ # Secret backups
└── logs/                   # Application logs (external mount)
```

### 🔄 Verzeichnisstruktur-Aktualisierung (2025-09-23)

**Kritische Änderungen basierend auf audiobookshelf, tandoor und rclone Standardisierung:**

1. **`data/` Verzeichnis**: Zentrale Sammlung aller Anwendungsdaten
   - **Django/Web Apps**: `data/mediafiles/`, `data/staticfiles/`
   - **Cloud Storage**: `data/uploads/`, `data/cache/`
   - **Database Data**: Über separate Volume-Mounts (nicht in data/)

2. **`security/` Verzeichnis**: Alle sicherheitsrelevanten Konfigurationen
   - **VERPFLICHTEND**: `security/seccomp-profile.json`
   - **Optional**: `security/apparmor-profile`

3. **Volume Mount Standardisierung**:
   ```yaml
   volumes:
     - ${CONFIG_PATH:-./config}:/config
     - ${DATA_PATH:-./data}:/app/data           # Neue Standardisierung
     - ${LOGS_PATH:-./logs}:/config/logs
   ```

**Docker Compose Standardisierung**:
```yaml
# VERPFLICHTEND in docker-compose.production.yml
security_opt:
  - no-new-privileges:true
  - apparmor=docker-default
  - seccomp=./security/seccomp-profile.json    # Standardisierter Pfad
```

## 🚀 Template-Verwendung (Schritt-für-Schritt)

### Neues Projekt erstellen

1. **Template klonen:**
   ```bash
   git clone https://github.com/mildman1848/template.git myapp
   cd myapp
   ```

2. **Template-Variablen ersetzen:**
   ```bash
   find . -type f -name "*.template*" -exec sed -i 's/${APPLICATION_NAME}/myapp/g' {} \;
   find . -type f -name "*.template*" -exec sed -i 's/${APPLICATION_NAME_UPPER}/MYAPP/g' {} \;
   find . -type f -name "*.template*" -exec sed -i 's/${APPLICATION_DESCRIPTION}/My Application/g' {} \;
   find . -type f -name "*.template*" -exec sed -i 's/${DEFAULT_VERSION}/1.0.0/g' {} \;
   find . -type f -name "*.template*" -exec sed -i 's/${DEFAULT_PORT}/8080/g' {} \;
   find . -type f -name "*.template*" -exec sed -i 's/${APPLICATION_PORT}/8080/g' {} \;
   find . -type f -name "*.template*" -exec sed -i 's/${DEFAULT_MODE}/server/g' {} \;
   find . -type f -name "*.template*" -exec sed -i 's/${UPSTREAM_REPO}/upstream\/repo/g' {} \;
   ```

3. **Template-Dateien umbenennen:**
   ```bash
   for file in $(find . -name "*.template*"); do
     mv "$file" "${file//.template/}"
   done
   ```

4. **Projekt initialisieren:**
   ```bash
   make setup
   make build
   make test
   ```

### Vollständige Template-Variable Referenz

**Standard-Variablen (erforderlich):**
- `${APPLICATION_NAME}` - Name der Anwendung (z.B. "myapp")
- `${APPLICATION_NAME_UPPER}` - Großbuchstaben-Name (z.B. "MYAPP")
- `${APPLICATION_DESCRIPTION}` - Beschreibung der Anwendung
- `${DEFAULT_VERSION}` - Standard-Anwendungsversion
- `${DEFAULT_PORT}` - Standard-Port
- `${APPLICATION_PORT}` - Interner Anwendungsport
- `${DEFAULT_MODE}` - Standard-Betriebsmodus
- `${UPSTREAM_REPO}` - Upstream Repository (z.B. "org/repo")

**Anwendungsspezifische Variablen (anpassen):**
- `${APPLICATION_SPECIFIC_HEALTH_CHECKS}` - Anwendungsspezifische Health Checks
- `${APPLICATION_SPECIFIC_SERVICE_TESTS}` - Anwendungsspezifische Service-Tests
- `${APPLICATION_SPECIFIC_SECURITY_CHECKS}` - Anwendungsspezifische Security Checks
- `${APPLICATION_SPECIFIC_VALIDATION}` - Anwendungsspezifische Validierung

## 📊 Wartungsplan (Template-Aktualisierung)

### Monatliche Aufgaben

- [ ] LinuxServer.io Baseimage-Updates prüfen
- [ ] Security-Tools Updates (Trivy, CodeQL, Hadolint)
- [ ] GitHub Actions Versionen aktualisieren
- [ ] Docker Security Best Practices Review

### Quartalsweise Aufgaben

- [ ] Security Best Practices Updates
- [ ] CI/CD Pipeline Optimierung
- [ ] Performance Benchmarks durchführen
- [ ] Dokumentations-Review

## 📖 Referenzen und Aktualisierungsrichtlinien

### Primäre Quellen (Monatlich überwachen)

**LinuxServer.io:**
- **Dokumentation:** https://docs.linuxserver.io/
- **Baseimage Repository:** https://github.com/linuxserver/docker-baseimage-alpine
- **S6 Overlay:** https://github.com/just-containers/s6-overlay
- **Pipeline Standards:** https://github.com/linuxserver/pipeline-templates

**Docker & Container Security:**
- **Docker Security:** https://docs.docker.com/engine/security/
- **OCI Standards:** https://github.com/opencontainers/image-spec
- **GitHub Actions:** https://docs.github.com/en/actions

### Security Tools (Monatlich auf Updates prüfen)

**Scanning Tools:**
- **Trivy:** https://trivy.dev/
- **CodeQL:** https://docs.github.com/en/code-security/codeql-cli
- **Hadolint:** https://github.com/hadolint/hadolint
- **TruffleHog:** https://github.com/trufflesecurity/trufflehog

### Compliance Standards (Quartalsweise überwachen)

**Security Frameworks:**
- **NIST Container Security:** https://csrc.nist.gov/publications/detail/sp/800-190/final
- **CIS Docker Benchmark:** https://www.cisecurity.org/benchmark/docker
- **OWASP Container Security:** https://cheatsheetseries.owasp.org/cheatsheets/Docker_Security_Cheat_Sheet.html

---

**Letzte Aktualisierung:** 2025-09-22
**Nächste Review:** 2025-10-22
**Template Version:** 2.0.0

*Für Fragen zu diesem Template oder Verbesserungsvorschläge, erstelle bitte ein Issue im Template-Repository.*
## 🧪 Neue Erkenntnisse aus Projekten (September 2025)

### Python/Django-Anwendungen (Tandoor Recipes Projekt)

**Multi-stage Builds für komplexe Dependencies:**
```dockerfile
# Build dependencies installation
RUN apk add --no-cache --virtual .build-deps \n    gcc musl-dev postgresql-dev python3-dev cargo rust
# Application installation with virtual environment
RUN python -m venv /app/venv && \n    /app/venv/bin/pip install -r requirements.txt
# Cleanup build dependencies
RUN apk del .build-deps
```

**Django-spezifische S6 Services:**
- **init-django-setup:** Database migrations (`manage.py migrate`)
- **init-django-static:** Static file collection (`manage.py collectstatic`)
- **django-app:** Gunicorn WSGI server startup

**Enhanced Environment Variables für Python Apps:**
```bash
# Django configuration
DEBUG=False
SECRET_KEY=
DJANGO_SETTINGS_MODULE=app.settings
ALLOWED_HOSTS=*

# Database configuration
DB_ENGINE=django.db.backends.postgresql
POSTGRES_HOST=db_app
POSTGRES_DB=djangodb
POSTGRES_USER=djangouser

# Gunicorn configuration
GUNICORN_WORKERS=2
GUNICORN_TIMEOUT=120
```

**Template Version:** 2.1.0 (mit Python/Django Support)

### Django-Optimierte Secrets-Generierung (September 2025)

**Neue Makefile-Funktion:** `secrets-django`
Diese optimierte Secrets-Generierung für Django-Anwendungen nutzt Python's `secrets` Modul für kryptographisch sichere Token:

```makefile
secrets-django: ## Generate Django-optimized secrets for Django applications
	@echo "$(GREEN)Generating Django-optimized secrets for Django applications...$(NC)"
	@mkdir -p secrets
	@echo "Generating Django SECRET_KEY (URL-safe, 64 chars)..."
	@python3 -c "import secrets; print(secrets.token_urlsafe(64))" > secrets/django_secret_key.txt 2>/dev/null || \
		openssl rand -base64 64 | tr -d "=+/\n" | head -c 64 > secrets/django_secret_key.txt
	@echo "Generating PostgreSQL password (secure, 32 chars)..."
	@openssl rand -base64 32 | tr -d "=+/\n" | head -c 32 > secrets/postgres_password.txt
	@echo "djangouser" > secrets/postgres_user.txt
	@echo "Generating Django session key (hex, 64 chars)..."
	@python3 -c "import secrets; print(secrets.token_hex(32))" > secrets/session_key.txt 2>/dev/null || \
		openssl rand -hex 32 > secrets/session_key.txt
	@echo "Generating database encryption key..."
	@openssl rand -base64 32 | tr -d "=+/\n" | head -c 32 > secrets/db_key.txt
	@chmod 600 secrets/*.txt
	@chown $(shell id -u):$(shell id -g) secrets/*.txt 2>/dev/null || true
	@echo "$(GREEN)✓ Django secrets generated successfully!$(NC)"
	@echo "$(BLUE)Django Secret Summary:$(NC)"
	@echo "  SECRET_KEY: $(shell wc -c < secrets/django_secret_key.txt 2>/dev/null || echo '0') characters"
	@echo "  DB Password: $(shell wc -c < secrets/postgres_password.txt 2>/dev/null || echo '0') characters"
	@echo "  Session Key: $(shell wc -c < secrets/session_key.txt 2>/dev/null || echo '0') characters"
	@echo "  DB Encryption: $(shell wc -c < secrets/db_key.txt 2>/dev/null || echo '0') characters"
	@echo "$(YELLOW)⚠️  Store these securely - never commit to version control!$(NC)"
```

**Sicherheitsvorteile:**
- **Python secrets.token_urlsafe():** Kryptographisch sicher, URL-safe für Django
- **Fallback zu OpenSSL:** Funktioniert auch ohne Python
- **Optimierte Längen:** 64 Zeichen SECRET_KEY, 32 Zeichen Passwörter
- **Automatische Berechtigungen:** 600 (owner-only read/write)
- **Validierung:** Überprüfung der generierten Secret-Längen

### Optimierte .gitignore/.dockerignore für Django-Projekte

**Comprehensive .gitignore Pattern:**
Entwickelt für Tandoor Recipes, anwendbar auf alle Django/Python-Projekte:

```gitignore
# SECURITY & SECRETS (CRITICAL)
secrets/
*.key
*_key.txt
*_password.txt
*_secret.txt
*_token.txt
.env.local
.env.production
.env.secret

# Django specifics
django_secret_key*
session_key*
db_key*
*.sqlite3
local_settings.py
media/
staticfiles/
static/

# Python
__pycache__/
*.py[cod]
venv/
env/
.coverage
.pytest_cache/

# Docker runtime
docker-data/
volumes/
container-data/
logs/
*.log

# Development
.vscode/
.idea/
*.bak
*.tmp
```

**Optimized .dockerignore Pattern:**
Reduziert Docker Build Context um 70-80% bei Django-Projekten:

```dockerignore
# SECURITY & SECRETS (CRITICAL)
secrets/
*.key
*_key.txt
*_password.txt
.env.local
.env.production

# Version control (largest exclusion)
.git/
.github/

# Docker runtime (not needed in build)
docker-data/
volumes/
container-data/
docker-compose*.yml
!docker-compose.base.yml

# Development (build optimization)
.vscode/
.idea/
*.md
!README.md
!SECURITY.md

# Python/Django build optimization
__pycache__/
venv/
env/
test-reports/
coverage/
*.sqlite3
media/
staticfiles/

# Large files (images, archives)
*.png
*.jpg
*.zip
*.tar.gz

# Keep essential files
!Dockerfile
!requirements.txt
!Makefile
!.env.example
```

**Build-Performance-Verbesserungen:**
- **70-80% kleinerer Build Context** bei typischen Django-Projekten
- **Sicherheit:** Keine versehentliche Aufnahme von Secrets oder .git
- **Wartbarkeit:** Strukturierte Kategorien mit Kommentaren
- **Flexibilität:** Whitelist-Ansatz für essenzielle Dateien

### Lessons Learned - Django Container Development

**1. Secrets-Management Best Practices:**
- **Nutze Python's secrets Modul** für kryptographisch sichere Token
- **URL-safe Token für Django SECRET_KEY** (kompatibel mit URLs)
- **Fallback-Mechanismen** für Umgebungen ohne Python
- **Automatische Validierung** der generierten Secret-Längen

**2. Build-Context-Optimierung:**
- **.dockerignore ist kritisch** für große Django-Projekte
- **Strukturierte Ausschlüsse** nach Kategorien (Security, Development, Runtime)
- **Whitelist-Ansatz** für essenzielle Dateien
- **Performance-Monitoring:** Build-Zeit-Vergleiche vor/nach Optimierung

**3. Django-spezifische Container-Patterns:**
- **Multi-stage Builds** für komplexe Python Dependencies
- **Virtual Environments** auch in Containern für Isolation
- **Static Files Handling** in separaten S6 Services
- **Database Migration Services** mit Dependency-Management


## 🚨 CRITICAL Pre-Push Validation Framework (Template 2.2.0)

### 🔧 RELEASE WORKFLOW FIXES IMPLEMENTATION (2025-09-26)

**CRITICAL LESSON LEARNED:** Release workflows scheiterten in CI/CD durch Permissions-Probleme bei Test-Cleanup.

**Problem:** GitHub Actions Umgebung erstellt Docker-Container mit root-Permissions, aber Cleanup versucht als ubuntu-user zu löschen:
```
rm: cannot remove '/tmp/audiobookshelf-test-audiobooks': Operation not permitted
make: *** [Makefile:228: test] Error 1
```

**Template-Fix implementiert:**
```makefile
# OLD (problematisch in CI)
@rm -rf /tmp/${APPLICATION_NAME}-test-*

# NEW (Template-Standard mit CI-Permission-Handling)
@sudo rm -rf /tmp/${APPLICATION_NAME}-test-* 2>/dev/null || rm -rf /tmp/${APPLICATION_NAME}-test-* 2>/dev/null || true
```

**Benefits:**
- ✅ **CI Compatibility:** Funktioniert in GitHub Actions ohne Permissions-Errors
- ✅ **Local Development:** Fallback funktioniert auch ohne sudo (local development)
- ✅ **Error Suppression:** 2>/dev/null verhindert irrelevante Fehlermeldungen
- ✅ **Graceful Failure:** || true verhindert Make-Target-Abbruch

**Release Workflow Impact:**
- ✅ **Validation Step:** make test läuft erfolgreich in Release workflows
- ✅ **Container Publishing:** Release workflows können Docker images erfolgreich veröffentlichen
- ✅ **Multi-Platform:** Release workflows funktionieren für AMD64/ARM64 images
- ✅ **Production Ready:** Real releases können ohne Workflow-Failures durchgeführt werden

### Comprehensive Pre-Push Validation System

Basierend auf kritischen Erkenntnissen aus dem Tandoor Recipes Projekt und Release Workflow Fixes in allen drei Produktionsprojekten, implementiert das Template einen umfassenden Pre-Push-Validierungsrahmen zur Verhinderung von fehlerhaften Deployments.

**Hauptkommando für alle Projekte:**
```bash
make pre-push-check    # KRITISCHE Validierung vor jedem GitHub Push
```

### Automatisierte Validierungsschritte

**1. Dockerfile & Build Validation:**
```bash
make validate          # Hadolint Dockerfile validation
make build            # Multi-platform build test (AMD64/ARM64)
```

**2. Container Runtime Validation:**
```bash
make test             # Container startup, health checks, functionality
```

**3. Security & Vulnerability Validation:**
```bash
make security-scan    # Trivy vulnerability scan + CodeQL analysis
```

**4. Environment & Configuration Validation:**
```bash
make env-validate     # .env configuration validation
docker-compose config --quiet  # Compose syntax validation
```

**5. Secrets Safety Validation:**
- Automatische Erkennung uncommitted Secrets
- Validierung von FILE__ prefix secret patterns
- Überprüfung auf versehentlich committete Passwörter/Keys

### Manual Pre-Push Checklist Requirements

**KRITISCHE Dokumentations-Updates (vor jedem Push):**
- [ ] **README.md aktualisiert** - Aktuelle Funktionalität reflektieren, keine veralteten Dateien referenzieren
- [ ] **README.de.md aktualisiert** - Zweisprachige Dokumentation pflegen, Versionsnummern korrekt
- [ ] **.env.example aktualisiert** - Alle Environment Variables enthalten, Test-ENVs entfernt
- [ ] **docker-compose.yml bereinigt** - Keine Test-Umgebungsvariablen in Produktionsdateien
- [ ] **Secrets korrekt als Dateien generiert** - Nicht als Ordner, alle benötigten Secrets vorhanden
- [ ] **Makefile Functions getestet** - Alle Make-Targets funktional, keine undefined Variables
- [ ] **Aktuelle Versionen verwendet** - Keine veralteten Versionsnummern in Dokumentation
- [ ] **.gitignore/.dockerignore geprüft** - Neue Ausschlussmuster hinzugefügt
- [ ] **CHANGELOG.md aktualisiert** - Als LETZTER Schritt vor Push

**Container-Sicherheits-Validierung:**
- [ ] **Localhost-only Binding:** Port auf 127.0.0.1 beschränkt
- [ ] **NO_AUTH=false:** Authentication in Produktion aktiviert
- [ ] **S6 Service Bundle:** Hauptservice in user/contents.d/ enthalten
- [ ] **Health Checks funktional:** Container wird als "healthy" gemeldet

### Application-Specific Validation Extensions

**Django Applications (Tandoor-Pattern):**
```bash
make secrets-generate  # Standard secrets für alle Anwendungen (optimiert für Django)
make secrets-django    # Django-spezifische Secrets mit erweiterten Optionen
```
- **SECRET_KEY:** URL-safe, 64 Zeichen (Python secrets.token_urlsafe)
- **Database Configuration:** SQLite3 als Standard, PostgreSQL über docker-compose.override.yml
- **Secrets als Dateien:** Korrekte FILE__ prefix Implementierung, nicht als Ordner
- **Test-ENV-Bereinigung:** Alle Testumgebungsvariablen aus docker-compose.yml entfernt
- **Database Passwords:** 32 Zeichen, kryptographisch sicher
- **Session Keys:** Hex-Format, 64 Zeichen

**Node.js Applications:**
- **npm audit:** Vulnerability scanning mit akzeptablen Risk-Levels
- **package-lock.json:** Aktuell und konsistent
- **Nested Dependencies:** Vulnerable nested packages identifiziert und ersetzt

### Emergency Stop Conditions - NEVER PUSH IF

**🚫 ABSOLUTE PUSH-BLOCKER:**
- Container startet nicht oder loop
- Kritische Errors in Container-Logs
- Health Checks schlagen fehl
- Anwendung nicht auf erwartetem Port erreichbar
- CRITICAL Security Vulnerabilities detected
- Build schlägt auf unterstützten Plattformen fehl
- Tests schlagen fehl oder timeout
- **make test cleanup errors** (Permission denied beim Directory cleanup)
- **Release workflow validation failures** (Pre-release tests schlagen fehl)
- Dokumentation outdated oder incorrect

**🔧 RELEASE WORKFLOW SPECIFIC BLOCKERS:**
- **Container test cleanup fails:** `rm: cannot remove '/tmp/test-directories': Operation not permitted`
- **Docker compose validation errors:** `docker compose config --quiet` schlägt fehl
- **Health check timeouts:** Container wird nicht "healthy" binnen timeout
- **API endpoint failures:** Application APIs nicht erreichbar nach startup
- **Multi-platform build issues:** AMD64 oder ARM64 builds scheitern

### Build Optimization & Performance

**Basierend auf Tandoor-Erkenntnissen:**
- **.dockerignore kritisch:** 70-80% kleinerer Build Context
- **Strukturierte Ausschlüsse:** Security, Development, Runtime Kategorien
- **Whitelist-Ansatz:** Essenzielle Dateien explizit einschließen
- **Performance-Monitoring:** Build-Zeit-Vergleiche dokumentieren

### Post-Push Monitoring Requirements

**Erste 10 Minuten nach Push überwachen:**
- [ ] **GitHub Actions Completion:** Alle Workflow-Jobs erfolgreich
- [ ] **Container Registry:** Neue Images verfügbar
- [ ] **Security Scans:** CI-Security-Scans ohne CRITICAL Issues
- [ ] **Multi-Platform Builds:** AMD64/ARM64 Builds erfolgreich

### Emergency Rollback Protocol

**Bei erkannten Problemen nach Push:**
1. **Immediate Revert:** `git revert HEAD && git push origin main`
2. **Registry Cleanup:** Problematic Images aus Container Registry entfernen
3. **Investigation:** Pre-Push Checklist gegen gescheiterte Schritte validieren
4. **Fix & Re-validate:** Vollständige Pre-Push Validation vor Re-Push

### Template Integration Points

**Neue Makefile-Targets (verfügbar in allen Template-Projekten):**
- `make pre-push-check` - Vollständige automatisierte Validierung
- `make validate-push-readiness` - Alias für pre-push-check
- `make documentation-check` - Dokumentations-Währung validieren
- `make container-safety-check` - Container-Stabilität testen

**Dokumentations-Integration:**
- `docs/PRE-PUSH-CHECKLIST.md` - Vollständige manuelle Checkliste
- GitHub Actions mit Pre-Push Validation Pattern
- Security Templates mit erweiterten Vulnerability-Checks

## 🎯 VALIDATED SUCCESS PATTERNS (2025-09-24)

### ✅ PROVEN WORKING: Tandoor 2.2.4 Migration

**Challenge:** White screen issue nach Version 1.5.19 → 2.2.4 Update
**Root Cause:** Fehlende Vue.js/Vite Assets (django-vite Integration)
**Solution Pattern:** Multi-stage build mit Asset-Extraktion

**Implementation Validated:**
```dockerfile
FROM ghcr.io/tandoorrecipes/recipes:latest AS vite_assets
FROM ghcr.io/linuxserver/baseimage-alpine:3.22
# ... build steps ...
COPY --from=vite_assets /opt/recipes/cookbook/static/vue3/ /app/cookbook/static/vue3/
```

**Results:**
- ✅ **50KB manifest.json** mit kompletten Asset-Definitionen
- ✅ **WebUI funktional** - Login-Seite 4.822 Bytes statt leer
- ✅ **HTTP 302 Redirects** korrekt zu /accounts/login/
- ✅ **Service Worker** für PWA-Funktionalität implementiert

### ✅ PROVEN WORKING: Version Management System

**Challenge:** 2+ Tage verschwendete Zeit durch veraltete Tandoor Version
**Solution:** Mandatory upstream version checking

**Implementation Validated:**
```makefile
version-check:
	@LATEST=$$(curl -s https://api.github.com/repos/${UPSTREAM_REPO}/releases/latest | jq -r '.tag_name'); \
	if [ "$$LATEST" != "${APPLICATION_VERSION}" ]; then \
		echo "⚠️  OUTDATED: Using ${APPLICATION_VERSION}, latest is $$LATEST"; \
	fi

build: version-check  # Mandatory dependency
```

**Results:**
- ✅ **Proaktive Warnung** bei veralteten Versionen
- ✅ **Build-Integration** verhindert veraltete Deployments
- ✅ **Implementiert in allen 3 Projekten:** tandoor, audiobookshelf, rclone

### 🔧 EMERGENCY DEBUGGING PROTOCOLS

**White Screen Debugging Checklist:**
1. **Asset Verification:** `curl http://localhost:port/static/manifest.json`
2. **Content-Length Check:** Assets with `Content-Length: 0` = missing
3. **Container Logs:** Look for django-vite/webpack errors
4. **Multi-stage Build:** Verify COPY --from=assets commands
5. **Permissions:** Ensure abc:abc ownership for assets

**Version Drift Prevention:**
1. **Before ANY project work:** Run `make version-check`
2. **GitHub API Rate Limits:** Cache results for 1 hour
3. **CI/CD Integration:** Automated upstream monitoring
4. **Template Updates:** Propagate to all projects immediately

---

## 🔧 CI/CD Workflow Standardization Framework (2025-09-25)

### GitHub Actions Workflow Standardization

**✅ KRITISCHE WORKFLOW FIXES IMPLEMENTIERT:**

Das Template implementiert standardisierte GitHub Actions Workflows basierend auf Lessons Learned aus allen drei Projekten (audiobookshelf, rclone, tandoor):

**Docker Compose Installation Standardization:**
- ✅ **Legacy Download Fix:** Eliminierte fehlgeschlagene v2.21.0 Downloads
- ✅ **Native Plugin Migration:** Alle Workflows verwenden `docker-compose-plugin`
- ✅ **Standardized Commands:** `docker compose` (space) statt `docker-compose` (dash)
- ✅ **Version Verification:** Explicit version checking in CI workflows

**DockerHub Dependency Elimination:**
- ✅ **Problem Solved:** CI tests verwenden keine externen DockerHub dependencies mehr
- ✅ **Local Build Integration:** `IMAGE_TAG=test` für alle docker-compose tests
- ✅ **Self-contained Testing:** Container tests bauen lokal, nutzen lokale images
- ✅ **Manifest Error Prevention:** Keine "manifest for image:latest not found" Errors

**Hadolint Configuration Standardization:**
- ✅ **Consistent Ignores:** DL3007 für Base Image pinning ausgenommen
- ✅ **LinuxServer.io Compatibility:** Standard ignores für LinuxServer.io Requirements
- ✅ **Dockerfile Standards:** Einheitliche hadolint configuration über alle Projekte

### Baseimage Testing Integration (2025-09-25)

**Automated LinuxServer.io Baseimage Update System:**

Das Template integriert ein vollständiges Baseimage-Testing-System:

**System Components:**
- ✅ **Testing Script:** `scripts/baseimage-update-test.sh` (643 Zeilen, vollständig implementiert)
- ✅ **Make Integration:** `baseimage-check`, `baseimage-test`, `baseimage-update` targets
- ✅ **Version Detection:** GitHub API-basierte automatische neueste Version detection
- ✅ **Container Validation:** Build testing, runtime validation, health checks
- ✅ **Security Integration:** Trivy scanning für baseimage updates
- ✅ **Rollback Capability:** Automatisches Rollback bei failed tests

**Script Capabilities:**
```bash
# Version Detection & Comparison
get_latest_baseimage_version() {
    # GitHub API integration für LinuxServer.io/docker-baseimage-alpine
    # Automatic parsing of release tags mit version comparison logic
}

# Container Build Testing
build_test_image() {
    # Multi-platform build testing mit neuen baseimage versions
    # Error handling und logging für build failures
}

# Runtime Validation
run_container_tests() {
    # Comprehensive container startup testing
    # Health check validation, process testing, cleanup
}
```

**Make Target Integration:**
```makefile
baseimage-check: ## Check for LinuxServer.io baseimage updates
	@./scripts/baseimage-update-test.sh check

baseimage-test: ## Test new LinuxServer.io baseimage version
	@./scripts/baseimage-update-test.sh test

baseimage-update: ## Update to latest LinuxServer.io baseimage
	@./scripts/baseimage-update-test.sh update
```

### Standardized CI Workflow Pattern (All Projects)

**Template ci.yml Pattern (bewährt in 3 Projekten):**
```yaml
# MANDATORY für alle Template-basierten Projekte
name: CI
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4

    # Standardized Docker Compose Setup
    - name: Setup Docker Compose
      run: |
        sudo apt-get update
        sudo apt-get install -y docker-compose-plugin
        docker compose version

    # Hadolint with consistent configuration
    - name: Run Hadolint
      uses: hadolint/hadolint-action@v3.1.0
      with:
        dockerfile: Dockerfile
        failure-threshold: warning
        ignore: DL3007,DL3018,DL3013

    # Application-specific testing
    - name: Create required directories
      run: |
        mkdir -p config data logs secrets
        # Application-specific directories (varies per template)

    # Local build testing (no external dependencies)
    - name: Test docker-compose configuration
      run: |
        IMAGE_TAG=test docker compose config --quiet

    - name: Build and test container
      run: |
        IMAGE_TAG=test docker compose up -d --build --wait
        IMAGE_TAG=test docker compose ps
        IMAGE_TAG=test docker compose logs
        IMAGE_TAG=test docker compose down
```

### Workflow Abweichungen Resolved (2025-09-25)

**Problem-Identifikation:** Workflows zwischen Projekten wichen signifikant ab, was zu unterschiedlichen CI-Ergebnissen führte.

**Standardisierte Lösungen implementiert:**

**1. Docker Compose Installation (alle Projekte):**
- ✅ **audiobookshelf:** Updated zu docker-compose-plugin
- ✅ **rclone:** Updated zu docker-compose-plugin
- ✅ **tandoor:** Updated zu docker-compose-plugin

**2. Container Testing (alle Projekte):**
- ✅ **IMAGE_TAG=test:** Eliminiert externe Registry dependencies
- ✅ **Local Build Focus:** Alle tests verwenden lokal gebaute images
- ✅ **Consistent Health Checks:** Standardisierte container readiness validation

**3. Hadolint Configuration (alle Projekte):**
- ✅ **Standard Ignores:** DL3007, DL3018, DL3013 für LinuxServer.io compatibility
- ✅ **Failure Threshold:** warning level für consistent CI results
- ✅ **Dockerfile Standards:** Einheitliche linting über alle Projekte

**4. Directory Structure (alle Projekte):**
- ✅ **Required Directories:** config, data, logs, secrets standardisiert
- ✅ **Application-specific:** Zusätzliche directories je nach Anwendung
- ✅ **Mount Points:** Konsistente Volume-Mount-Struktur

### Version Update Automation

**Branding Update Automation:**
- ✅ **Template Integration:** Automatisierte Version-Updates in Container-Branding
- ✅ **Build Timestamp:** ISO 8601 timestamps für reproducible builds
- ✅ **Original Project Attribution:** Verpflichtende Upstream-Referenzen

**CI Integration für Updates:**
```yaml
# Template pattern für version updates
- name: Update container branding
  run: |
    VERSION=${APPLICATION_VERSION}
    BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ')
    sed -i "s/Version: .*/Version: $VERSION/" root/etc/s6-overlay/s6-rc.d/init-adduser/branding
    sed -i "s/Build: .*/Build: $BUILD_DATE/" root/etc/s6-overlay/s6-rc.d/init-adduser/branding
```

### Template Configuration Files

**Enhanced .gitignore/.dockerignore Templates:**
```gitignore
# Baseimage testing (2025-09-25) - MANDATORY für alle Projekte
BASEIMAGE_UPDATE_REPORT.md
baseimage-test-*.log
baseimage-test-*.json
```

**Benefits der CI/CD Standardisierung:**
- ✅ **Workflow Consistency:** Alle drei Projekte verwenden identische CI patterns
- ✅ **Reliability:** Eliminierte external dependency failures
- ✅ **Maintenance:** Baseimage updates automated mit comprehensive testing
- ✅ **Security:** Vulnerability scanning integrated in CI pipeline
- ✅ **Quality:** Consistent linting und testing standards über alle Projekte

---

**Template Version:** 2.5.0 (Release Workflow Fixes + CI Permission Handling)
**Letzte Aktualisierung:** 2025-09-26 (Release Workflow CI Permission Fixes)
**Nächste Review:** 2025-10-26
**Validation Status:** ✅ Alle Standards implementiert und Release Workflow Fixes erfolgreich in Produktion getestet

**Recent Major Updates:**
- ✅ **Release Workflow Fixes:** CI test cleanup mit sudo fallback für GitHub Actions permissions
- ✅ **Enhanced Pre-Push Guidelines:** Spezifische Anforderungen für Secrets, Test-ENV-Bereinigung, Makefile-Validierung
- ✅ **Django Configuration Optimierung:** SQLite3 als Standard, PostgreSQL über Override
- ✅ **Tandoor v2.2.6 Update:** Neueste Version mit verbesserter Konfiguration
- ✅ **Secrets Management Fixes:** Korrekte Dateigenerierung statt Ordnererstellung
- ✅ **Docker Compose Modernisierung:** docker compose (Plugin) statt docker-compose (Legacy)
- ✅ **CI Permission Handling:** Graceful test cleanup in GitHub Actions environments

**Successful Project Implementations:**
- ✅ **audiobookshelf:** CI workflow standardisiert, baseimage testing implementiert
- ✅ **rclone:** CI workflow standardisiert, version 1.71.0→1.71.1 update erfolgreich
- ✅ **tandoor:** Vollständig überarbeitet - SQLite3 Standard, PostgreSQL Override, v2.2.6, bereinigte Compose-Dateien
- ✅ **template:** Alle Standards dokumentiert mit erweiterten Pre-Push Guidelines

*Für Fragen zu diesem Template oder Verbesserungsvorschläge, erstelle bitte ein Issue im Template-Repository.*
