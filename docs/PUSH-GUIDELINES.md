# Push Guidelines

🇩🇪 **Deutsche Version:** [PUSH-GUIDELINES.de.md](PUSH-GUIDELINES.de.md)

## Overview

This document outlines the comprehensive push guidelines for all projects in this workspace. Following these guidelines ensures code quality, security, and deployment reliability.

## Mandatory Pre-Push Validation

### Automated Validation Commands

**ALWAYS run these commands before pushing to GitHub:**

```bash
# 1. Build validation
make build              # Verify image builds successfully

# 2. Container testing
make test               # Ensure container starts and functions properly

# 3. Security scanning
make security-scan      # Check for vulnerabilities

# 4. Configuration validation
make env-validate       # Validate .env configuration
docker compose config --quiet  # Compose syntax validation

# 5. Documentation validation
make documentation-check # Ensure docs are current (if implemented)
```

### Emergency Stop Conditions

**🚫 NEVER PUSH IF:**

- Container fails to start or loops
- Critical errors in container logs
- Health checks fail
- Application not reachable on expected port
- CRITICAL security vulnerabilities detected
- Build fails on supported platforms
- Tests fail or timeout
- Documentation outdated or incorrect

## Documentation Requirements

### Critical Documentation Updates (before every push)

- [ ] **README.md updated** - Reflect current functionality
- [ ] **README.de.md updated** - Maintain bilingual documentation
- [ ] **.env.example updated** - Include all environment variables
- [ ] **.gitignore/.dockerignore checked** - Add new exclusion patterns
- [ ] **CHANGELOG.md updated** - As LAST step before push

### Cross-Reference Validation

Ensure consistency between:
- English and German documentation
- Code and documentation examples
- Environment variables in all files
- Version numbers across all files

## Container Security Validation

### Security Checklist

- [ ] **Localhost-only binding:** Port restricted to 127.0.0.1
- [ ] **NO_AUTH=false:** Authentication enabled in production
- [ ] **S6 Service Bundle:** Main service included in user/contents.d/
- [ ] **Health checks functional:** Container reports as "healthy"
- [ ] **Secrets as files:** Not as directories, all required secrets present
- [ ] **FILE__ prefix implementation:** Correct secret handling

### Application-Specific Security

**Django Applications:**
- SQLite3 as default, PostgreSQL via override
- Django-specific secrets generated correctly
- Test environment variables removed from production files

**Node.js Applications:**
- npm audit results acceptable
- package-lock.json current and consistent
- Vulnerable nested packages replaced

## Build & Test Requirements

### Multi-Platform Support

```bash
# Test both architectures
make build-manifest          # Build for AMD64 + ARM64
make inspect-manifest        # Verify manifest structure
make validate-manifest       # Validate OCI compliance
```

### Container Testing Process

The `make test` command must pass completely:
1. Container startup validation
2. Health check verification
3. Application process running
4. Port accessibility test
5. Clean container shutdown

## Version Management

### Version Consistency

- [ ] **VERSION file updated** - Central version management
- [ ] **Container branding updated** - Version numbers in init scripts
- [ ] **Documentation versions synced** - README badges, docs references
- [ ] **Upstream version current** - Check for newer application versions

### Version Check Integration

```bash
# Always check for upstream updates
make version-check          # Compare with latest upstream version

# Update if newer version available
make version-update         # Update to latest upstream (if implemented)
```

## Secrets Management

### Secret Safety Validation

- [ ] **No secrets in git** - Scan for accidentally committed secrets
- [ ] **FILE__ prefix patterns** - Correct secret configuration
- [ ] **Secret permissions** - 600 for secret files, 750 for directories
- [ ] **Secret generation** - All required secrets present and valid

### Secret Generation Standards

```bash
# Generate cryptographically secure secrets
make secrets-generate       # Standard secrets for all applications
make secrets-django         # Django-optimized secrets (if applicable)

# Validate secret status
make secrets-info           # Show current secrets status
```

## CI/CD Integration

### GitHub Actions Validation

- [ ] **Workflow syntax** - All .yml files valid
- [ ] **Environment secrets** - GHCR_TOKEN configured
- [ ] **Build matrix** - Multi-platform builds configured
- [ ] **Security scans** - Trivy and CodeQL integrated

### Workflow Testing

```bash
# Test workflow components locally
make validate               # Dockerfile linting
make security-scan          # Security scanning
docker compose config --quiet  # Compose validation
```

## Application-Specific Guidelines

### Django Applications (Tandoor Pattern)

**Critical Checks:**
- [ ] Database migrations valid
- [ ] Static files collected correctly
- [ ] Asset integrity verified (no empty manifest.json)
- [ ] Vue.js/React assets present (if applicable)
- [ ] Secret files generated (not directories)

**Testing Requirements:**
```bash
make secrets-django         # Django-optimized secrets
make test                   # Container startup with Django
```

### Node.js Applications

**Security Requirements:**
- [ ] npm audit acceptable
- [ ] Nested dependencies secure
- [ ] Package versions locked

**Testing Requirements:**
```bash
npm audit                   # Check for vulnerabilities
make test                   # Application startup
```

### Cloud Storage Applications (rclone Pattern)

**Configuration Validation:**
- [ ] Port 5572 configured (rclone standard)
- [ ] Web GUI functionality tested
- [ ] Process-based health checks working

## Post-Push Monitoring

### First 10 Minutes After Push

Monitor these areas immediately after pushing:

- [ ] **GitHub Actions completion** - All workflow jobs successful
- [ ] **Container registry** - New images available
- [ ] **Security scan results** - CI security scans clean
- [ ] **Multi-platform builds** - AMD64/ARM64 builds successful

### Failure Response

If issues are detected:

1. **Immediate assessment** - Determine severity
2. **Rollback if critical** - `git revert HEAD && git push origin main`
3. **Fix and re-validate** - Full pre-push process
4. **Document lessons learned** - Update guidelines if needed

## Emergency Rollback Protocol

### When to Rollback

- Container fails to start in production
- Critical security vulnerabilities discovered
- Data loss or corruption risk
- Service unavailability

### Rollback Process

```bash
# 1. Immediate revert
git revert HEAD
git push origin main

# 2. Registry cleanup (if needed)
# Remove problematic images from container registry

# 3. Verify rollback
make test                   # Ensure previous version works
```

## Quality Assurance

### Code Quality Standards

- [ ] **No hardcoded secrets** - Use environment variables or FILE__ prefixes
- [ ] **Error handling** - Proper error handling in all scripts
- [ ] **Logging standards** - Consistent logging across services
- [ ] **Resource efficiency** - No unnecessary resource usage

### Documentation Quality

- [ ] **Accuracy** - All examples work as documented
- [ ] **Completeness** - All features documented
- [ ] **Consistency** - Cross-file consistency maintained
- [ ] **Translation quality** - German documentation accurate

## Team Collaboration

### Communication Requirements

- **Breaking changes** - Communicate to team before pushing
- **Major updates** - Document in CHANGELOG.md
- **Security issues** - Follow security policy for reporting

### Review Process

For significant changes:
1. Create detailed commit messages
2. Test thoroughly before pushing
3. Monitor post-push for issues
4. Document any lessons learned

## Tools and Automation

### Required Tools

- **Make** - Build automation
- **Docker Compose** - Container orchestration
- **Trivy** - Security scanning
- **Hadolint** - Dockerfile linting

### Automation Integration

```bash
# Single command validation (if implemented)
make pre-push-check         # Comprehensive pre-push validation
make validate-push-readiness # Alias for pre-push-check
```

## Continuous Improvement

### Guideline Updates

These guidelines are living documents. Update them when:
- New security requirements identified
- Application patterns change
- Tool improvements available
- Lessons learned from issues

### Feedback Integration

Report guideline issues or improvements:
- GitHub Issues for process improvements
- Documentation updates via pull requests
- Security concerns via security policy

---

**Remember:** These guidelines exist to ensure reliable, secure deployments. When in doubt, err on the side of caution and perform additional validation steps.