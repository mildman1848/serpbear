# serpbear

🇩🇪 **Deutsche Version:** [README.de.md](README.de.md)

![Version](https://img.shields.io/badge/dynamic/json-blue?label=version&query=$.version&url=https://raw.githubusercontent.com/mildman1848/serpbear/main/VERSION)
## Overview

This Docker image provides **serpbear** (v2.0.7) on the LinuxServer.io Alpine baseimage with S6 Overlay v3, enhanced security, and modern best practices.

**Key Features:**
- 🔐 **Security First:** Container hardening, capability dropping, localhost-only binding
- 🏗️ **Multi-Architecture:** AMD64 and ARM64 native builds with OCI manifest lists
- 🎯 **LinuxServer.io Standards:** FILE__ secrets, Docker Mods, S6 Overlay v3
- 📊 **Production Ready:** Health checks, structured logging, resource limits
- 🔄 **CI/CD Integration:** Automated building, testing, and security scanning

## Quick Start

### Using docker-compose (Recommended)

```bash
# 1. Clone repository and setup environment
git clone https://github.com/mildman1848/serpbear.git
cd serpbear
make setup

# 2. Start services
docker-compose up -d

# 3. Access application
open http://localhost:3000
```

### Using Docker CLI

```bash
# Create required directories
mkdir -p ./config ./data ./logs

# Run container
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

## Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |
| `TZ` | `UTC` | Timezone (see [timezone list](https://timezonedb.com/time-zones)) |
| `EXTERNAL_PORT` | `3000` | External port for web interface |

### Directory Structure

```
serpbear/
├── config/                  # Application configuration
├── data/                    # Application data
├── logs/                    # Application logs
└── secrets/                 # Secret files (FILE__ prefix)
```

### FILE__ Prefix Secrets (Recommended)

For enhanced security, use FILE__ prefix environment variables:

```bash
# Generate secrets
make secrets-generate

# Use in docker-compose.yml
FILE__SERPBEAR_PASSWORD=/run/secrets/serpbear_password
```

## Build & Development

### Make Commands

```bash
make setup                   # Complete initial setup
make build                   # Build Docker image
make test                    # Run integration tests
make start                   # Start with docker-compose
make logs                    # Show container logs
make shell                   # Access container shell
make security-scan          # Run security scans
```

### Multi-Architecture Building

```bash
make build-manifest          # Build for AMD64 + ARM64
make inspect-manifest        # Inspect manifest structure
make validate-manifest       # Validate OCI compliance
```

## Security

### Container Hardening
- ✅ **Non-root execution** (user `abc`, UID 911)
- ✅ **Capability dropping** (ALL dropped, minimal restored)
- ✅ **Seccomp filtering** (custom profile)
- ✅ **AppArmor profile** (docker-default)
- ✅ **No new privileges** (privilege escalation prevention)
- ✅ **Read-only root filesystem** (where possible)

### Network Security
- ✅ **Localhost binding** (127.0.0.1:3000)
- ✅ **Custom bridge networks** (isolation)
- ✅ **Resource limits** (CPU, memory, PIDs)

### Vulnerability Management
- 🔍 **Trivy scanning** (container & filesystem)
- 📊 **SBOM generation** (software bill of materials)
- ⚠️ **Zero CRITICAL vulnerabilities** (production standard)

## Original Project

This container packages the excellent **serpbear** project:

- **Original Repository:** [towfiqi/serpbear](https://github.com/towfiqi/serpbear)
- **License:** MIT License
- **Documentation:** [SerpBear Documentation](https://github.com/towfiqi/serpbear#readme)
- **Support:** [SerpBear Issues](https://github.com/towfiqi/serpbear/issues)

## Support & Documentation

- 📚 **LinuxServer.io Docs:** [LINUXSERVER.md](docs/LINUXSERVER.md)
- 🔒 **Security Policy:** [SECURITY.md](SECURITY.md)
- 🐛 **Issues:** [GitHub Issues](https://github.com/mildman1848/serpbear/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/mildman1848/serpbear/discussions)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

The original **serpbear** software is licensed under MIT License - see the [original repository](https://github.com/towfiqi/serpbear) for details.