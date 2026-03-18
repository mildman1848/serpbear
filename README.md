# SerpBear Docker Image

> 📖 **[Deutsche Version](README.DE.md)** | 🇬🇧 **English Version**

![Build Status](https://github.com/mildman1848/serpbear/workflows/CI/badge.svg)
![Security Scan](https://github.com/mildman1848/serpbear/workflows/Security%20Scan/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/mildman1848/serpbear)
![Docker Image Size](https://img.shields.io/docker/image-size/mildman1848/serpbear/latest)
![License](https://img.shields.io/github/license/mildman1848/serpbear)
![Version](https://img.shields.io/badge/version-2.0.7-blue)

🐳 **[Docker Hub: mildman1848/serpbear](https://hub.docker.com/r/mildman1848/serpbear)**

A production-ready Docker image for [SerpBear](https://github.com/towfiqi/serpbear) based on the LinuxServer.io Alpine baseimage with enhanced security features, automatic secret management, full LinuxServer.io compliance, and CI/CD integration.

## 🚀 Features

- ✅ **LinuxServer.io Alpine Baseimage 3.22** - Optimized and secure
- ✅ **S6 Overlay v3** - Professional process management
- ✅ **Full LinuxServer.io Compliance** - FILE__ secrets, Docker Mods, custom scripts
- ✅ **Enhanced Security Hardening** - Non-root execution, capability dropping, secure permissions
- ✅ **OCI Manifest Lists** - True multi-architecture support following OCI standard
- ✅ **LinuxServer.io Pipeline** - Architecture-specific tags + manifest lists
- ✅ **Multi-Platform Support** - AMD64, ARM64 with native performance
- ✅ **Advanced Health Checks** - Automatic monitoring with failover
- ✅ **Robust Secret Management** - 512-bit JWT, 256-bit API keys, secure rotation
- ✅ **Automated Build System** - Make + GitHub Actions CI/CD with manifest validation
- ✅ **Environment Validation** - Comprehensive configuration checks
- ✅ **Security Scanning** - Integrated vulnerability scans with Trivy + CodeQL
- ✅ **OCI Compliance** - Standard-compliant container labels and manifest structure
- ✅ **Next.js Support** - Node.js/Next.js compatible with S6 Overlay v3

## 🚀 Quick Start

### Automated Setup (Recommended)

```bash
# Clone repository
git clone https://github.com/mildman1848/serpbear.git
cd serpbear

# Complete setup (environment + secrets)
make setup

# Start container
docker-compose up -d
```

### With Docker Compose (Manual)

```bash
# Clone repository
git clone https://github.com/mildman1848/serpbear.git
cd serpbear

# Configure environment
cp .env.example .env
# Adjust .env as needed

# Generate secure secrets
make secrets-generate

# Start container
docker-compose up -d
```

### With Docker Run

```bash
docker run -d \
  --name serpbear \
  -p 3000:3000 \
  -v ./config:/config \
  -v ./data:/data \
  -v ./logs:/config/logs \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/Berlin \
  --restart unless-stopped \
  mildman1848/serpbear:latest
```

## 🛠️ Build & Development

### Makefile Targets

```bash
# Show help
make help

# Complete setup
make setup                   # Initial setup (env + secrets)
make env-setup               # Create environment from .env.example
make env-validate            # Validate environment

# Secret Management (Enhanced)
make secrets-generate        # Generate secure secrets (512-bit JWT, 256-bit API)
make secrets-rotate          # Rotate secrets (with backup)
make secrets-clean           # Clean up old secret backups
make secrets-info            # Show secret status

# Build & Test (Enhanced with OCI Manifest Lists)
make build                   # Build image for current platform
make build-multiarch         # Multi-architecture build (legacy)
make build-manifest          # LinuxServer.io style manifest lists (recommended)
make inspect-manifest        # Inspect manifest lists (multi-arch details)
make validate-manifest       # Validate OCI manifest compliance
make test                    # Test container (with health checks)
make security-scan           # Run comprehensive security scan (Trivy + CodeQL)
make trivy-scan              # Run Trivy vulnerability scan only
make codeql-scan             # Run CodeQL static code analysis
make validate                # Validate Dockerfile

# Container Management
make start                   # Start container
make stop                    # Stop container
make restart                 # Restart container
make status                  # Show container status and health
make logs                    # Show container logs
make shell                   # Open shell in container

# Development
make dev                     # Start development container

# Release
make release                 # Complete release workflow
make push                    # Push image to registry
```

### Manual Build

```bash
# Build image
docker build -t mildman1848/serpbear:latest .

# With specific arguments
docker build \
  --build-arg SERPBEAR_VERSION=2.0.7 \
  --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
  -t mildman1848/serpbear:latest .
```

## ⚙️ Configuration

### Environment File

Configuration is done via a `.env` file containing all environment variables:

```bash
# Create .env from template
cp .env.example .env

# Adjust values as needed
nano .env
```

The `.env.example` contains all available options with documentation and links to the official SerpBear documentation.

### Important Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |
| `TZ` | `Europe/Berlin` | Timezone |
| `EXTERNAL_PORT` | `3000` | External host port |
| `DATABASE_URL` | `file:/data/database/serpbear.db` | SQLite database location |
| `LOG_LEVEL` | `info` | Log level (debug, info, warn, error) |

> 📖 **Full Documentation:** See [.env.example](.env.example) for all available options

### 🔐 Enhanced LinuxServer.io Secrets Management

**FILE__ Prefix (Recommended):**
The image supports the LinuxServer.io standard `FILE__` prefix for secure secret management:

```bash
# .env file - FILE__ prefix secrets
FILE__API_KEY=/run/secrets/api_key
FILE__SESSION_SECRET=/run/secrets/session_secret
FILE__DB_PASSWORD=/run/secrets/db_password

# Docker Compose example
environment:
  - FILE__API_KEY=/run/secrets/api_key
```

**Enhanced Secret Generation:**

```bash
# Secure secret generation (improved algorithms)
make secrets-generate        # 512-bit JWT, 256-bit API keys

# Secret rotation with backup
make secrets-rotate

# Check secret status
make secrets-info
```

**Supported Secrets (Enhanced):**

| FILE__ Variable | Description | Security | Make Generated |
|----------------|-------------|----------|----------------|
| `FILE__SESSION_SECRET` | Session Secret Key (512-bit) | ✅ High | ✅ |
| `FILE__API_KEY` | API Key (256-bit hex) | ✅ High | ✅ |
| `FILE__DB_PASSWORD` | Database password (256-bit) | ✅ High | ✅ |

> 📖 **LinuxServer.io Documentation:** [FILE__ Prefix](https://docs.linuxserver.io/FAQ)

### Volumes

| Container Path | Description |
|----------------|-------------|
| `/config` | Configuration files |
| `/data` | Application data (including SQLite database) |
| `/config/logs` | Application logs |

## 🔧 Enhanced LinuxServer.io S6 Overlay Services

The image uses S6 Overlay v3 with optimized services following LinuxServer.io standards:

- **init-adduser** - PUID/PGID user management (critical for LinuxServer.io)
- **init-mods-package-install** - Docker Mods installation
- **init-custom-files** - Custom scripts & UMASK setup
- **init-secrets** - Enhanced FILE__ prefix & legacy secret processing
- **init-serpbear-config** - SerpBear configuration with validation
- **serpbear** - Main Next.js application service

### Service Dependencies

```
init-adduser → init-mods-package-install → init-custom-files → init-secrets → init-serpbear-config → serpbear
```

### Service Improvements
- ✅ **Secure Permissions** - Correct file and directory permissions
- ✅ **Enhanced Validation** - Configuration validation
- ✅ **Robust Error Handling** - Graceful fallbacks on errors
- ✅ **Security Hardening** - Path validation for FILE__ secrets
- ✅ **Node.js Compatibility** - Direct Node.js execution without s6-setuidgid

### LinuxServer.io Features

**Docker Mods Support:**
```bash
# Single mod
DOCKER_MODS=linuxserver/mods:universal-cron

# Multiple mods (separated by |)
DOCKER_MODS=linuxserver/mods:universal-cron|linuxserver/mods:custom-mod
```

**Custom Scripts:**
```bash
# Scripts in /custom-cont-init.d are executed before services
docker run -v ./my-scripts:/custom-cont-init.d:ro mildman1848/serpbear
```

**UMASK Support:**
```bash
# Default: 022 (files: 644, directories: 755)
UMASK=022
```

> 📖 **Available Mods:** [mods.linuxserver.io](https://mods.linuxserver.io/)

## 🔒 Enhanced Security

> 🛡️ **Security Policy**: See our [Security Policy](SECURITY.md) for reporting vulnerabilities and security guidelines

### Advanced Security Hardening

The image implements comprehensive security measures:

- ✅ **Non-root Execution** - Container runs as user `abc` (UID 911)
- ✅ **Capability Dropping** - ALL capabilities dropped, minimal required added
- ✅ **no-new-privileges** - Prevents privilege escalation
- ✅ **Secure File Permissions** - 750 for directories, 640 for files
- ✅ **Path Validation** - FILE__ secret path sanitization
- ✅ **Enhanced Error Handling** - Secure fallbacks for permission issues
- ✅ **tmpfs Mounts** - Temporary files in memory
- ✅ **Security Opt** - Additional kernel security features
- ✅ **Robust Secret Handling** - 512-bit encryption, secure rotation

### Security Scanning & Vulnerability Management

```bash
# Comprehensive security scan (Trivy + CodeQL)
make security-scan

# Individual scanning tools
make trivy-scan              # Vulnerability scanning only
make codeql-scan             # Static code analysis only
make security-scan-detailed  # Detailed scan with exports

# Manual scanning
trivy image mildman1848/serpbear:latest
trivy fs --format sarif --output trivy-results.sarif .

# Dockerfile validation
make validate
```

### Best Practices

```bash
# 1. Use LinuxServer.io FILE__ secrets
FILE__SESSION_SECRET=/run/secrets/session_secret
FILE__API_KEY=/run/secrets/api_key

# 2. Set host user IDs (LinuxServer.io standard)
export PUID=$(id -u)
export PGID=$(id -g)

# 3. UMASK for correct file permissions
export UMASK=022

# 4. Secure secret generation
make secrets-generate

# 5. Validate configuration
make env-validate

# 6. Use specific image tags
docker run mildman1848/serpbear:2.0.7  # instead of :latest

# 7. Monitor container health
make status  # Container status and health checks

# 8. Use enhanced secret management
make secrets-generate  # 512-bit JWT, 256-bit API keys
```

### OCI Manifest Lists & LinuxServer.io Pipeline

**OCI-compliant Multi-Architecture Support:**

```bash
# Automatic platform detection (Docker pulls the right image)
docker pull mildman1848/serpbear:latest

# Platform-specific tags (LinuxServer.io style)
docker pull mildman1848/serpbear:amd64-latest    # Intel/AMD 64-bit
docker pull mildman1848/serpbear:arm64-latest    # ARM 64-bit (Apple M1, Pi 4)

# Inspect manifest lists
make inspect-manifest
docker manifest inspect mildman1848/serpbear:latest
```

**Technical Details:**
- ✅ **OCI Image Manifest Specification v1.1.0** compliant
- ✅ **LinuxServer.io Pipeline Standards** - Architecture tags + manifest lists
- ✅ **Native Performance** - No emulation, real platform builds
- ✅ **Automatic Platform Selection** - Docker chooses optimal image
- ✅ **Backward Compatibility** - Works with all Docker clients

### LinuxServer.io Compatibility

```bash
# Fully compatible with LinuxServer.io standards
# ✅ S6 Overlay v3
# ✅ FILE__ Prefix Secrets
# ✅ DOCKER_MODS Support
# ✅ Custom Scripts (/custom-cont-init.d)
# ✅ UMASK Support
# ✅ PUID/PGID Management
# ✅ Custom Branding (LinuxServer.io compliant)
# ✅ OCI Manifest Lists (2024 Pipeline Standard)
```

### 🎨 Container Branding

The container shows a **custom ASCII-art branding** for "Mildman1848" at startup with original project attribution.

**Branding Features:**
- ✅ **LinuxServer.io Compliance** - Correct branding implementation
- ✅ **Custom ASCII Art** - Unique Mildman1848 representation
- ✅ **Version Information** - Build details and SerpBear version
- ✅ **Original Project Attribution** - Clear attribution to towfiqi/serpbear
- ✅ **Support Links** - Clear references for help and documentation
- ✅ **Feature Overview** - Overview of implemented LinuxServer.io features

> ⚠️ **Note:** This container is **NOT** officially supported by LinuxServer.io

## Monitoring & Health Checks

### Health Check

The image includes automatic health checks:

```bash
# Check status
docker inspect --format='{{.State.Health.Status}}' serpbear

# Show logs
docker logs serpbear
```

## 🔧 Troubleshooting

### Common Issues

<details>
<summary><strong>File Permissions</strong></summary>

```bash
# Adjust PUID/PGID to host user
export PUID=$(id -u)
export PGID=$(id -g)
docker-compose up -d

# Or set in .env
echo "PUID=$(id -u)" >> .env
echo "PGID=$(id -g)" >> .env
```
</details>

<details>
<summary><strong>Port Already in Use</strong></summary>

```bash
# Change port in .env
echo "EXTERNAL_PORT=3001" >> .env

# Or directly in docker-compose.yml
ports:
  - "3001:3000"
```
</details>

<details>
<summary><strong>Container Won't Start</strong></summary>

```bash
# 1. Check logs
make logs

# 2. Health check status
docker inspect --format='{{.State.Health.Status}}' serpbear

# 3. Validate environment
make env-validate

# 4. Debug shell
make shell
```
</details>

<details>
<summary><strong>Database Issues</strong></summary>

```bash
# Ensure /data directory is writable
chmod 755 ./data

# Check database location
echo "DATABASE_URL=file:/data/database/serpbear.db" >> .env

# Verify permissions
make shell
ls -la /data/database/
```
</details>

### Debug Mode

```bash
# Development container with debug logging
echo "LOG_LEVEL=debug" >> .env
echo "DEBUG_MODE=true" >> .env
make dev

# Shell access
make shell

# Container inspection
docker exec -it serpbear /bin/bash
```

## 🤝 Contributing

### Development Workflow

1. **Fork & Clone**
   ```bash
   git clone https://github.com/yourusername/serpbear.git
   cd serpbear
   ```

2. **Setup Development Environment**
   ```bash
   make setup
   make dev
   ```

3. **Make Changes & Test**
   ```bash
   make validate      # Dockerfile linting
   make build         # Build image
   make test          # Run tests
   make security-scan # Security check
   ```

4. **Submit PR**
   - Create a feature branch
   - Test all changes
   - Create a pull request

> 🛡️ **Security Issues**: Please read our [Security Policy](SECURITY.md) before reporting security vulnerabilities

### CI/CD Pipeline

The project uses GitHub Actions for:
- ✅ **Automated Testing** - Dockerfile, container, integration tests
- ✅ **Security Scanning** - Trivy, Hadolint, SBOM generation
- ✅ **OCI Manifest Lists** - LinuxServer.io pipeline with architecture-specific tags
- ✅ **Multi-Architecture Builds** - AMD64, ARM64 with native performance
- ✅ **Manifest Validation** - OCI compliance and platform verification
- ✅ **Automated Releases** - Semantic versioning, Docker Hub/GHCR
- ✅ **Dependency Updates** - Dependabot integration
- ✅ **Upstream Monitoring** - Automated dependency tracking and update notifications

### 🔄 Upstream Dependency Monitoring

The project includes automated monitoring of upstream dependencies:

- **SerpBear Application**: Monitors [towfiqi/serpbear](https://github.com/towfiqi/serpbear) releases
- **LinuxServer.io Base Image**: Tracks [linuxserver/docker-baseimage-alpine](https://github.com/linuxserver/docker-baseimage-alpine) updates
- **Automated Notifications**: Creates GitHub issues for new releases
- **Security Assessment**: Prioritizes security-related updates

**Monitoring Schedule**: Monday and Thursday at 6 AM UTC

## Original Project

This container packages the excellent **SerpBear** project:

- **Original Repository:** [towfiqi/serpbear](https://github.com/towfiqi/serpbear)
- **License:** MIT License
- **Documentation:** [SerpBear Documentation](https://docs.serpbear.com)
- **Support:** [SerpBear Issues](https://github.com/towfiqi/serpbear/issues)

**To support the original SerpBear project:**
- ⭐ Star the repository
- 💰 Sponsor via GitHub Sponsors
- 🐛 Report bugs and feature requests

## Support & Documentation

- 📚 **LinuxServer.io Docs:** [LINUXSERVER.md](docs/LINUXSERVER.md)
- 🔒 **Security Policy:** [SECURITY.md](SECURITY.md)
- 🐛 **Issues:** [GitHub Issues](https://github.com/mildman1848/serpbear/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/mildman1848/serpbear/discussions)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

The original **SerpBear** software is licensed under MIT License - see the [original repository](https://github.com/towfiqi/serpbear) for details.

## Acknowledgments

- [SerpBear](https://github.com/towfiqi/serpbear) - Original project
- [LinuxServer.io](https://www.linuxserver.io/) - Baseimage and best practices
- [S6 Overlay](https://github.com/just-containers/s6-overlay) - Process management
