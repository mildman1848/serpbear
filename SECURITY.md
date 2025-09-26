# Security Policy

🇩🇪 **Deutsche Version:** [SECURITY.de.md](SECURITY.de.md)

## Supported Versions

We provide security updates for the following versions:

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| main    | :white_check_mark: |

## Security Features

### Container Security Hardening

This Docker image implements comprehensive security measures:

#### **Non-root Execution**
- Container runs as user `abc` (UID 911)
- No root privileges during runtime
- PUID/PGID mapping for file permissions

#### **Capability Dropping**
```yaml
cap_drop:
  - ALL
cap_add:
  - SETGID      # User switching (LinuxServer.io requirement)
  - SETUID      # User switching (LinuxServer.io requirement)
  - CHOWN       # File permissions
  - DAC_OVERRIDE # File access (minimal)
```

#### **Security Options**
```yaml
security_opt:
  - no-new-privileges:true
  - apparmor=docker-default
  - seccomp=./security/seccomp-profile.json
```

#### **Resource Limits**
```yaml
deploy:
  resources:
    limits:
      cpus: '2.0'
      memory: 1G
      pids: 200
```

### Network Security

#### **Localhost-only Binding**
- Default binding: `127.0.0.1:${DEFAULT_PORT}`
- No external network exposure by default
- Custom bridge networks for isolation

#### **Firewall Configuration**
```bash
# Only allow localhost connections
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp --dport ${DEFAULT_PORT} -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -p tcp --dport ${DEFAULT_PORT} -j DROP
```

### Secret Management

#### **FILE__ Prefix Secrets (Recommended)**
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

#### **Secret Generation**
```bash
# Generate cryptographically secure secrets
make secrets-generate

# Secret requirements:
# - API Keys: 256-bit (32 bytes)
# - JWT Secrets: 512-bit (64 bytes)
# - Database Passwords: 192-bit (24 bytes)
```

### Vulnerability Management

#### **Automated Scanning**
- **Trivy:** Container and filesystem vulnerability scanning
- **CodeQL:** Static code analysis for security issues
- **SBOM:** Software Bill of Materials generation
- **Scheduled:** Weekly security scans via GitHub Actions

#### **Vulnerability Response**
- **CRITICAL:** Immediate patching within 24 hours
- **HIGH:** Patching within 7 days
- **MEDIUM:** Patching within 30 days
- **LOW:** Addressed in next regular update

### Build Security

#### **Supply Chain Security**
- Multi-stage builds from official sources only
- Signature verification for downloaded packages
- Reproducible builds with locked dependencies
- SBOM generation for all components

#### **Base Image Security**
- LinuxServer.io Alpine baseimage (regularly updated)
- Minimal attack surface (Alpine Linux)
- S6 Overlay v3 for secure init system

## Security Configuration

### Production Deployment

Use the production configuration for maximum security:

```bash
docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
```

**Production Security Features:**
- Enhanced resource limits
- Read-only volumes where possible
- Structured logging with rotation
- Frequent health checks
- Restrictive UMASK (027)
- Core dumps disabled

### Security Monitoring

#### **Log Analysis**
```bash
# Monitor security events
docker-compose logs | grep -E "(SECURITY|WARN|ERROR)"

# Health check monitoring
make status
```

#### **File Integrity**
```bash
# Check file permissions
docker exec ${APPLICATION_NAME} find /config -type f -perm /o+w

# Verify secret permissions
docker exec ${APPLICATION_NAME} ls -la /run/secrets/
```

## Reporting a Vulnerability

If you discover a security vulnerability, please report it responsibly:

### **DO NOT** create a public GitHub issue

### **DO** report privately via:
1. **GitHub Security Advisories:** [Create Security Advisory](https://github.com/${GITHUB_USERNAME}/${APPLICATION_NAME}/security/advisories/new)
2. **Email:** security@${DOMAIN} (if configured)
3. **Encrypted communication:** Use our PGP key if available

### **Include in your report:**
- Detailed description of the vulnerability
- Steps to reproduce the issue
- Potential impact assessment
- Suggested mitigation or fix

### **Response Timeline:**
- **Initial Response:** Within 48 hours
- **Acknowledgment:** Within 7 days
- **Status Updates:** Weekly until resolved
- **Resolution:** Based on severity (see Vulnerability Response above)

## Security Best Practices

### **For Users:**
1. **Always use FILE__ prefix secrets** instead of environment variables
2. **Bind to localhost only** (127.0.0.1) in production
3. **Use docker-compose.production.yml** for production deployments
4. **Regularly update** to the latest version
5. **Monitor logs** for security events
6. **Use custom networks** to isolate containers
7. **Set resource limits** to prevent DoS attacks

### **For Developers:**
1. **Never commit secrets** to version control
2. **Use .env.example** for environment templates
3. **Run security scans** before pushing changes
4. **Follow least privilege principle** in container design
5. **Validate all inputs** in S6 services
6. **Use secure coding practices** for application logic

## Compliance

This container aims to comply with:

- **NIST Container Security Standards**
- **CIS Docker Benchmark**
- **OWASP Container Security Guidelines**
- **Docker Security Best Practices**

## Security Tools

### **Scanning Tools Used:**
- **Trivy:** Vulnerability scanner
- **CodeQL:** Static code analysis
- **Hadolint:** Dockerfile linter
- **Docker Bench:** Security benchmark

### **Security Testing:**
```bash
# Run comprehensive security scan
make security-scan

# Run specific scans
make trivy-scan
make codeql-scan
```

## Incident Response

In case of a security incident:

1. **Immediate:** Stop affected containers
2. **Assessment:** Analyze logs and impact
3. **Containment:** Isolate affected systems
4. **Remediation:** Apply patches or workarounds
5. **Recovery:** Restore services securely
6. **Lessons Learned:** Update security measures

## Contact

For security-related questions or concerns:

- **Security Team:** security@${DOMAIN}
- **Project Maintainer:** [GitHub Profile](https://github.com/${GITHUB_USERNAME})
- **Security Advisories:** [GitHub Security](https://github.com/${GITHUB_USERNAME}/${APPLICATION_NAME}/security/advisories)