# Sicherheitsrichtlinie

🇺🇸 **English Version:** [SECURITY.md](SECURITY.md)

## Unterstützte Versionen

Wir stellen Sicherheitsupdates für die folgenden Versionen bereit:

| Version | Unterstützt        |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| main    | :white_check_mark: |

## Sicherheitsfeatures

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
- Standard Binding: `127.0.0.1:${DEFAULT_PORT}`
- Keine externe Netzwerk-Exposition standardmäßig
- Custom Bridge-Netzwerke für Isolation

#### **Firewall-Konfiguration**
```bash
# Nur localhost-Verbindungen erlauben
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport ${DEFAULT_PORT} -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -p tcp --dport ${DEFAULT_PORT} -j DROP
```

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

### Vulnerability Management

#### **Automatisiertes Scannen**
- **Trivy:** Container- und Dateisystem-Vulnerability-Scanning
- **CodeQL:** Statische Code-Analyse für Sicherheitsprobleme
- **SBOM:** Software Bill of Materials Generierung
- **Geplant:** Wöchentliche Sicherheitsscans via GitHub Actions

#### **Vulnerability Response**
- **CRITICAL:** Sofortiges Patching innerhalb von 24 Stunden
- **HIGH:** Patching innerhalb von 7 Tagen
- **MEDIUM:** Patching innerhalb von 30 Tagen
- **LOW:** Bearbeitung im nächsten regulären Update

### Build-Sicherheit

#### **Supply Chain Security**
- Multi-stage Builds nur von offiziellen Quellen
- Signaturverifikation für heruntergeladene Pakete
- Reproduzierbare Builds mit fixierten Dependencies
- SBOM-Generierung für alle Komponenten

#### **Base Image Sicherheit**
- LinuxServer.io Alpine Baseimage (regelmäßig aktualisiert)
- Minimale Angriffsfläche (Alpine Linux)
- S6 Overlay v3 für sicheres Init-System

## Sicherheitskonfiguration

### Produktions-Deployment

Verwenden Sie die Produktionskonfiguration für maximale Sicherheit:

```bash
docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
```

**Produktions-Sicherheitsfeatures:**
- Erweiterte Ressourcenbegrenzungen
- Read-only Volumes wo möglich
- Strukturiertes Logging mit Rotation
- Häufige Health Checks
- Restriktive UMASK (027)
- Core Dumps deaktiviert

### Sicherheitsüberwachung

#### **Log-Analyse**
```bash
# Sicherheitsereignisse überwachen
docker-compose logs | grep -E "(SECURITY|WARN|ERROR)"

# Health Check Überwachung
make status
```

#### **Datei-Integrität**
```bash
# Dateiberechtigungen prüfen
docker exec ${APPLICATION_NAME} find /config -type f -perm /o+w

# Secret-Berechtigungen verifizieren
docker exec ${APPLICATION_NAME} ls -la /run/secrets/
```

## Melden einer Vulnerability

Wenn Sie eine Sicherheitslücke entdecken, melden Sie diese bitte verantwortungsvoll:

### **ERSTELLEN SIE KEIN** öffentliches GitHub Issue

### **MELDEN SIE** privat über:
1. **GitHub Security Advisories:** [Security Advisory erstellen](https://github.com/${GITHUB_USERNAME}/${APPLICATION_NAME}/security/advisories/new)
2. **E-Mail:** security@${DOMAIN} (falls konfiguriert)
3. **Verschlüsselte Kommunikation:** Verwenden Sie unseren PGP-Schlüssel falls verfügbar

### **In Ihren Bericht einschließen:**
- Detaillierte Beschreibung der Vulnerability
- Schritte zur Reproduktion des Problems
- Potentielle Auswirkungsbewertung
- Vorgeschlagene Schadensbegrenzung oder Lösung

### **Antwort-Zeitrahmen:**
- **Erste Antwort:** Innerhalb von 48 Stunden
- **Bestätigung:** Innerhalb von 7 Tagen
- **Status-Updates:** Wöchentlich bis zur Lösung
- **Lösung:** Basierend auf Schweregrad (siehe Vulnerability Response oben)

## Sicherheits-Best-Practices

### **Für Benutzer:**
1. **Verwenden Sie immer FILE__ Prefix Secrets** statt Umgebungsvariablen
2. **Nur an localhost binden** (127.0.0.1) in Produktion
3. **Verwenden Sie docker-compose.production.yml** für Produktions-Deployments
4. **Regelmäßig aktualisieren** auf die neueste Version
5. **Logs überwachen** für Sicherheitsereignisse
6. **Verwenden Sie Custom Networks** zur Container-Isolation
7. **Ressourcenbegrenzungen setzen** zur DoS-Prävention

### **Für Entwickler:**
1. **Niemals Secrets committen** in die Versionskontrolle
2. **Verwenden Sie .env.example** für Umgebungsvorlagen
3. **Sicherheitsscans ausführen** vor dem Pushen von Änderungen
4. **Least Privilege Prinzip befolgen** im Container-Design
5. **Alle Eingaben validieren** in S6 Services
6. **Sichere Coding-Practices verwenden** für Anwendungslogik

## Compliance

Dieser Container strebt Compliance an mit:

- **NIST Container Security Standards**
- **CIS Docker Benchmark**
- **OWASP Container Security Guidelines**
- **Docker Security Best Practices**

## Sicherheits-Tools

### **Verwendete Scanning-Tools:**
- **Trivy:** Vulnerability Scanner
- **CodeQL:** Statische Code-Analyse
- **Hadolint:** Dockerfile Linter
- **Docker Bench:** Sicherheits-Benchmark

### **Sicherheitstests:**
```bash
# Umfassenden Sicherheitsscan ausführen
make security-scan

# Spezifische Scans ausführen
make trivy-scan
make codeql-scan
```

## Incident Response

Im Fall eines Sicherheitsvorfalls:

1. **Sofort:** Betroffene Container stoppen
2. **Bewertung:** Logs und Auswirkungen analysieren
3. **Eindämmung:** Betroffene Systeme isolieren
4. **Behebung:** Patches oder Workarounds anwenden
5. **Wiederherstellung:** Services sicher wiederherstellen
6. **Lessons Learned:** Sicherheitsmaßnahmen aktualisieren

## Kontakt

Für sicherheitsbezogene Fragen oder Bedenken:

- **Security Team:** security@${DOMAIN}
- **Projekt-Maintainer:** [GitHub Profil](https://github.com/${GITHUB_USERNAME})
- **Security Advisories:** [GitHub Security](https://github.com/${GITHUB_USERNAME}/${APPLICATION_NAME}/security/advisories)