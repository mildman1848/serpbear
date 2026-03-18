# Sicherheitsrichtlinie

🇺🇸 **English Version:** [SECURITY.md](SECURITY.md)

## Geltungsbereich

Diese Richtlinie gilt für das SerpBear-Docker-Image, die Repository-Automation, die Container-Konfiguration, den Compose-Stack und die Build-Pipeline in diesem Repository.

## Unterstützte Versionen

Sicherheitsfixes stellen wir für die aktuell unterstützte Release-Linie und den Standard-Branch bereit.

## Meldung einer Sicherheitslücke

Bitte veröffentlichen Sie vermutete Sicherheitslücken nicht als öffentliche Issues.

Nutzen Sie stattdessen einen privaten Meldeweg:

- GitHub Security Advisories: `https://github.com/mildman1848/serpbear/security/advisories/new`
- Falls Advisories nicht verfügbar sind, zunächst eine knappe öffentliche Issue ohne Exploit-Details eröffnen und um einen privaten Kontaktweg bitten.

## Benötigte Informationen

Bitte senden Sie möglichst:

- betroffenen Image-Tag oder Commit
- Host-System und Container-Runtime
- Reproduktionsschritte
- vermutete Auswirkungen
- mögliche Gegenmaßnahmen oder Fix-Ideen

## Reaktionsziele

Wir versuchen, Berichte innerhalb von 7 Werktagen zu bestätigen und kritische Themen vor normaler Wartungsarbeit zu priorisieren.

## Sicherheitspraktiken

Dieses Repository nutzt bereits:

- automatisierte Trivy-Scans
- Dockerfile-Linting mit Hadolint
- Automatisierung für Abhängigkeiten und Workflows
- dokumentiertes Secrets-Handling und Compose-basierte Laufzeitkonfiguration

## Außerhalb des Geltungsbereichs

Bitte melden Sie Probleme direkt an die jeweiligen Upstream-Maintainer, wenn die Ursache in einem der folgenden Bereiche liegt:

- SerpBear-Upstream-Code
- LinuxServer.io-Base-Images
- Drittanbieter-Registries oder Hosting-Infrastruktur

## Verwandte Dokumente

- Projektdokumentation: [README.md](README.md)
- Englische Sicherheitsrichtlinie: [SECURITY.md](SECURITY.md)

Letzte Aktualisierung: 2026-03-18
