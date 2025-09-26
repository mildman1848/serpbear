# LinuxServer.io Compliance Dokumentation

🇺🇸 **English Version:** [LINUXSERVER.md](LINUXSERVER.md)

## Überblick

Dieser Container folgt LinuxServer.io Standards und Best Practices für Docker Container Images basierend auf Alpine Linux mit S6 Overlay v3.

## LinuxServer.io Standards Compliance

### Base Image
- **Base:** `ghcr.io/linuxserver/baseimage-alpine:3.22`
- **Init System:** S6 Overlay v3
- **User Management:** PUID/PGID Unterstützung
- **Non-root Ausführung:** Benutzer `abc` (UID 911)

### S6 Overlay Services

Der Container implementiert die vollständige LinuxServer.io S6 Service-Struktur:

```
init-adduser → init-mods-package-install → init-custom-files → init-secrets → init-{app}-config → {app}
```

**Kern-Services:**
- `init-adduser`: PUID/PGID Benutzerverwaltung mit Custom Branding
- `init-mods-package-install`: Docker Mods Unterstützung
- `init-custom-files`: Custom Scripts und Dateien Unterstützung
- `init-secrets`: FILE__ Prefix Secret-Verarbeitung
- `init-{app}-config`: Anwendungsspezifische Konfiguration
- `{app}`: Haupt-Anwendungsservice

### Docker Mods Unterstützung

Dieser Container unterstützt LinuxServer.io Docker Mods:

```bash
# Beispiel Verwendung
DOCKER_MODS=linuxserver/mods:universal-cron
```

### FILE__ Prefix Secrets

Folgt LinuxServer.io Standards für Secret-Management:

```bash
# Umgebungsvariablen
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

### Custom Scripts Unterstützung

Der Container unterstützt benutzerdefinierte Initialisierungs-Scripts:

```bash
# Ausführbare Scripts platzieren in:
/config/custom-cont-init.d/

# Scripts werden in alphabetischer Reihenfolge beim Container-Start ausgeführt
```

### Umgebungsvariablen

Standard LinuxServer.io Umgebungsvariablen:

| Variable | Standard | Beschreibung |
|----------|----------|-------------|
| `PUID` | `1000` | Benutzer-ID für Dateiberechtigungen |
| `PGID` | `1000` | Gruppen-ID für Dateiberechtigungen |
| `TZ` | `UTC` | Zeitzone |
| `UMASK` | `022` | Datei-Erstellungsmaske |

### Volume-Struktur

Folgt LinuxServer.io Volume-Konventionen:

```
/config     # Anwendungskonfiguration und Daten
/app        # Anwendungsinstallationsverzeichnis
/defaults   # Standard-Konfigurationsvorlagen
```

## Sicherheits-Compliance

### Container-Härtung
- **User Namespacing:** Non-root Ausführung
- **Capability Dropping:** Minimale erforderliche Capabilities
- **AppArmor:** docker-default Profil
- **Seccomp:** Custom Filtering-Profil
- **No new privileges:** Verhindert Privilege Escalation

### Netzwerk-Sicherheit
- **Standard Binding:** 127.0.0.1 (localhost-only)
- **Custom Networks:** Bridge-Isolation
- **Ressourcenbegrenzungen:** CPU-, Memory-, PID-Limits

## Multi-Architecture Unterstützung

Erstellt für mehrere Architekturen nach LinuxServer.io Patterns:

```bash
# Architektur-spezifische Tags
docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:amd64-latest
docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:arm64-latest

# Multi-arch Manifest (automatische Auswahl)
docker pull ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
```

## Build-Prozess

Der Container folgt LinuxServer.io Build-Patterns:

1. **Base Layer:** LinuxServer.io Alpine Baseimage
2. **Paket-Installation:** Alpine-Pakete via apk
3. **Anwendungsinstallation:** Von offiziellen Quellen
4. **Konfiguration:** S6 Service-Setup
5. **Sicherheit:** Berechtigungseinstellung und Härtung
6. **Labels:** OCI-konforme Container-Labels

## Health Checks

Implementiert nach LinuxServer.io Patterns:

```dockerfile
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=5 \
  CMD ${APPLICATION_SPECIFIC_HEALTH_CHECK}
```

## Logging

Strukturiertes Logging nach LinuxServer.io Konventionen:

- **S6 Logging:** Service-Output zu stdout/stderr
- **Anwendungslogs:** Umgeleitet zu `/config/logs/`
- **Rotation:** Automatische Log-Rotation in Produktion

## Support

Für LinuxServer.io spezifische Fragen:
- **Dokumentation:** https://docs.linuxserver.io/
- **Discord:** https://discord.gg/YWrKVTn
- **Forum:** https://discourse.linuxserver.io/

Für diesen Container speziell:
- **Issues:** [GitHub Issues](https://github.com/${GITHUB_USERNAME}/${APPLICATION_NAME}/issues)
- **Discussions:** [GitHub Discussions](https://github.com/${GITHUB_USERNAME}/${APPLICATION_NAME}/discussions)