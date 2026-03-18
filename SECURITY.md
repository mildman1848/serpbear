# Security Policy

🇩🇪 **Deutsche Version:** [SECURITY.DE.md](SECURITY.DE.md)

## Supported Scope

This policy covers the SerpBear Docker image, repository automation, container configuration, Compose setup, and build pipeline maintained in this repository.

## Supported Versions

We provide security fixes for the currently supported release line and the default branch.

## Reporting a Vulnerability

Please do not publish suspected vulnerabilities as public issues.

Use one of these private paths instead:

- GitHub Security Advisories: `https://github.com/mildman1848/serpbear/security/advisories/new`
- If advisories are unavailable, create a minimal public issue without exploit details and request a private contact path.

## What to Include

Please include:

- affected image tag or commit
- host system and container runtime
- reproduction steps
- likely impact
- mitigation ideas, if available

## Response Targets

We aim to acknowledge reports within 7 business days and prioritize critical issues ahead of normal maintenance work.

## Security Practices

This repository already uses:

- automated Trivy scans
- Dockerfile linting with Hadolint
- dependency and workflow automation
- documented secrets handling and Compose-based runtime configuration

## Out of Scope

Please report issues upstream when the root cause is in:

- SerpBear upstream application code
- LinuxServer.io base images
- third-party registries or hosting infrastructure

## Related Documents

- project documentation: [README.md](README.md)
- German security policy: [SECURITY.DE.md](SECURITY.DE.md)

Last updated: 2026-03-18
