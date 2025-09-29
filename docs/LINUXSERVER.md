# LinuxServer.io Compliance Documentation

🇩🇪 **Deutsche Version:** [LINUXSERVER.de.md](LINUXSERVER.de.md)

## Overview

This container follows LinuxServer.io standards and best practices for Docker container images based on Alpine Linux with S6 Overlay v3.

## LinuxServer.io Standards Compliance

### Base Image
- **Base:** `ghcr.io/linuxserver/baseimage-alpine:3.22`
- **Init System:** S6 Overlay v3
- **User Management:** PUID/PGID support
- **Non-root execution:** User `abc` (UID 911)

### S6 Overlay Services

The container implements the full LinuxServer.io S6 service structure:

```
init-adduser → init-mods-package-install → init-custom-files → init-secrets → init-{app}-config → {app}
```

**Core Services:**
- `init-adduser`: PUID/PGID user management with custom branding
- `init-mods-package-install`: Docker Mods support
- `init-custom-files`: Custom scripts and files support
- `init-secrets`: FILE__ prefix secret processing
- `init-{app}-config`: Application-specific configuration
- `{app}`: Main application service

### Docker Mods Support

This container supports LinuxServer.io Docker Mods:

```bash
# Example usage
DOCKER_MODS=linuxserver/mods:universal-cron
```

### FILE__ Prefix Secrets

Following LinuxServer.io standards for secret management:

```bash
# Environment variables
FILE__API_KEY=/run/secrets/api_key
FILE__DB_PASSWORD=/run/secrets/db_password

# Docker Compose secrets
services:
  ${APPLICATION_NAME}:
    secrets:
      - api_key
      - db_password

secrets:
  api_key:
    file: ./secrets/api_key.txt
  db_password:
    file: ./secrets/db_password.txt
```

### Custom Scripts Support

The container supports custom initialization scripts:

```bash
# Place executable scripts in:
/config/custom-cont-init.d/

# Scripts are executed in alphabetical order during container startup
```

### Environment Variables

Standard LinuxServer.io environment variables:

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | `1000` | User ID for file permissions |
| `PGID` | `1000` | Group ID for file permissions |
| `TZ` | `UTC` | Timezone |
| `UMASK` | `022` | File creation mask |

### Volume Structure

Following LinuxServer.io volume conventions:

```
/config     # Application configuration and data
/app        # Application installation directory
/defaults   # Default configuration templates
```

## Security Compliance

### Container Hardening
- **User namespacing:** Non-root execution
- **Capability dropping:** Minimal required capabilities
- **AppArmor:** docker-default profile
- **Seccomp:** Custom filtering profile
- **No new privileges:** Prevents privilege escalation

### Network Security
- **Default binding:** 127.0.0.1 (localhost-only)
- **Custom networks:** Bridge isolation
- **Resource limits:** CPU, memory, PID limits

## Multi-Architecture Support

Built for multiple architectures following LinuxServer.io patterns:

```bash
# Architecture-specific tags
docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:amd64-latest
docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:arm64-latest

# Multi-arch manifest (automatic selection)
docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
```

## Build Process

The container follows LinuxServer.io build patterns:

1. **Base Layer:** LinuxServer.io Alpine baseimage
2. **Package Installation:** Alpine packages via apk
3. **Application Installation:** From official sources
4. **Configuration:** S6 service setup
5. **Security:** Permission setting and hardening
6. **Labels:** OCI-compliant container labels

## Health Checks

Implemented following LinuxServer.io patterns:

```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=5 \
  CMD ${APPLICATION_SPECIFIC_HEALTH_CHECK}
```

## Logging

Structured logging following LinuxServer.io conventions:

- **S6 logging:** Service output to stdout/stderr
- **Application logs:** Redirected to `/config/logs/`
- **Rotation:** Automatic log rotation in production

## Support

For LinuxServer.io specific questions:
- **Documentation:** https://docs.linuxserver.io/
- **Discord:** https://discord.gg/YWrKVTn
- **Forum:** https://discourse.linuxserver.io/

For this container specifically:
- **Issues:** [GitHub Issues](https://github.com/${GITHUB_USERNAME}/${APPLICATION_NAME}/issues)
- **Discussions:** [GitHub Discussions](https://github.com/${GITHUB_USERNAME}/${APPLICATION_NAME}/discussions)