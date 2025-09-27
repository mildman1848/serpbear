# serpbear

🇺🇸 **English Version:** [README.md](README.md)

![Version](https://img.shields.io/badge/dynamic/json-blue?label=version&query=$.version&url=https://raw.githubusercontent.com/mildman1848/serpbear/main/VERSION)
## Überblick

Dieses Docker-Image stellt **serpbear** (v2.0.7) auf der LinuxServer.io Alpine Baseimage mit S6 Overlay v3, erweiterte Sicherheit und moderne Best Practices bereit.

**Hauptmerkmale:**
- 🔐 **Sicherheit Zuerst:** Container-Härtung, Capability-Dropping, localhost-only Binding
- 🏗️ **Multi-Architektur:** AMD64 und ARM64 native Builds mit OCI Manifest Lists
- 🎯 **LinuxServer.io Standards:** FILE__ Secrets, Docker Mods, S6 Overlay v3
- 📊 **Produktionsbereit:** Health Checks, strukturiertes Logging, Ressourcenbegrenzungen
- 🔄 **CI/CD Integration:** Automatisiertes Building, Testing und Sicherheitsscanning

## Schnellstart

### Mit docker-compose (Empfohlen)

```bash
# 1. Repository klonen und Umgebung einrichten
git clone https://github.com/mildman1848/serpbear.git
cd serpbear
make setup

# 2. Services starten
docker-compose up -d

# 3. Anwendung aufrufen
open http://localhost:3000
```

### Mit Docker CLI

```bash
# Erforderliche Verzeichnisse erstellen
mkdir -p ./config ./data ./logs

# Container ausführen
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

## Konfiguration

### Umgebungsvariablen

| Variable | Standard | Beschreibung |
|----------|----------|-------------|
| `PUID` | `1000` | Benutzer-ID für Dateiberechtigungen |
| `PGID` | `1000` | Gruppen-ID für Dateiberechtigungen |
| `TZ` | `UTC` | Zeitzone (siehe [Zeitzonen-Liste](https://timezonedb.com/time-zones)) |
| `EXTERNAL_PORT` | `3000` | Externer Port für Web-Interface |

### Verzeichnisstruktur

```
serpbear/
├── config/                  # Anwendungskonfiguration
├── data/                    # Anwendungsdaten
├── logs/                    # Anwendungslogs
└── secrets/                 # Secret-Dateien (FILE__ Prefix)
```

### FILE__ Prefix Secrets (Empfohlen)

Für erhöhte Sicherheit verwenden Sie FILE__ Prefix Umgebungsvariablen:

```bash
# Secrets generieren
make secrets-generate

# In docker-compose.yml verwenden
FILE__SERPBEAR_PASSWORD=/run/secrets/serpbear_password
```

## Build & Entwicklung

### Make-Kommandos

```bash
make setup                   # Komplette Ersteinrichtung
make build                   # Docker-Image erstellen
make test                    # Integrationstests ausführen
make start                   # Mit docker-compose starten
make logs                    # Container-Logs anzeigen
make shell                   # Container-Shell aufrufen
make security-scan          # Sicherheitsscans ausführen
```

### Multi-Architektur Building

```bash
make build-manifest          # Build für AMD64 + ARM64
make inspect-manifest        # Manifest-Struktur inspizieren
make validate-manifest       # OCI-Compliance validieren
```

## Sicherheit

### Container-Sicherheitshärtung

Dieses Docker-Image implementiert umfassende Sicherheitsmaßnahmen:

#### **Non-root Ausführung**
- Container läuft als Benutzer `abc` (UID 911)
- Keine Root-Privilegien während der Laufzeit
- PUID/PGID Mapping für Dateiberechtigungen

#### **Capability Dropping**
```yaml
cap_drop:
  - ALL
cap_add:
  - SETGID      # Benutzerumschaltung (LinuxServer.io Anforderung)
  - SETUID      # Benutzerumschaltung (LinuxServer.io Anforderung)
  - CHOWN       # Dateiberechtigungen
  - DAC_OVERRIDE # Dateizugriff (minimal)
```

#### **Sicherheitsoptionen**
```yaml
security_opt:
  - no-new-privileges:true
  - apparmor=docker-default
  - seccomp=./security/seccomp-profile.json
```

#### **Ressourcenbegrenzungen**
```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 1G
      pids: 200
```

### Netzwerk-Sicherheit

#### **Localhost-only Binding**
- Standard Binding: `127.0.0.1:3000`
- Keine externe Netzwerk-Exposition standardmäßig
- Custom Bridge-Netzwerke für Isolation

### Secret-Management

#### **FILE__ Prefix Secrets (Empfohlen)**
```yaml
environment:
  - FILE__API_KEY=/run/secrets/api_key
  - FILE__DB_PASSWORD=/run/secrets/db_password

secrets:
  api_key:
    file: ./secrets/api_key.txt
  db_password:
    file: ./secrets/db_password.txt
```

#### **Secret-Generierung**
```bash
# Kryptographisch sichere Secrets generieren
make secrets-generate

# Secret-Anforderungen:
# - API Keys: 256-bit (32 Bytes)
# - JWT Secrets: 512-bit (64 Bytes)
# - Database Passwords: 192-bit (24 Bytes)
```

## Ursprüngliches Projekt

Dieser Container verpackt das exzellente **serpbear** Projekt:

- **Ursprüngliches Repository:** [towfiqi/serpbear](https://github.com/towfiqi/serpbear)
- **Lizenz:** MIT License
- **Dokumentation:** [SerpBear Dokumentation](https://github.com/towfiqi/serpbear#readme)
- **Support:** [SerpBear Issues](https://github.com/towfiqi/serpbear/issues)

## Support & Dokumentation

- 📚 **LinuxServer.io Docs:** [LINUXSERVER.de.md](docs/LINUXSERVER.de.md)
- 🔒 **Sicherheitsrichtlinie:** [SECURITY.de.md](SECURITY.de.md)
- 🐛 **Issues:** [GitHub Issues](https://github.com/mildman1848/serpbear/issues)
- 💬 **Discussions:** [GitHub Discussions](https://github.com/mildman1848/serpbear/discussions)

## Lizenz

Dieses Projekt ist unter der MIT Lizenz lizenziert - siehe die [LICENSE](LICENSE) Datei für Details.

Die ursprüngliche **serpbear** Software ist unter MIT License lizenziert - siehe das [ursprüngliche Repository](https://github.com/towfiqi/serpbear) für Details.