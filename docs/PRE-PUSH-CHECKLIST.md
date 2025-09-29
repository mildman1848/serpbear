# Pre-Push Checklist

🇩🇪 **Deutsche Version:** [PRE-PUSH-CHECKLIST.de.md](PRE-PUSH-CHECKLIST.de.md)

## Quick Reference Checklist

**Print this checklist and check off each item before pushing to GitHub:**

### 🔧 Automated Validation
- [ ] `make build` - Image builds successfully
- [ ] `make test` - Container starts and functions properly
- [ ] `make security-scan` - No CRITICAL vulnerabilities
- [ ] `make env-validate` - Environment configuration valid
- [ ] `docker compose config --quiet` - Compose syntax valid

### 📚 Documentation Updates
- [ ] **README.md** - Current functionality, no outdated references
- [ ] **README.de.md** - German version synchronized
- [ ] **.env.example** - All environment variables included
- [ ] **.gitignore/.dockerignore** - New patterns added if needed
- [ ] **CHANGELOG.md** - Updated as LAST step

### 🔒 Security & Configuration
- [ ] **Localhost binding** - Port restricted to 127.0.0.1
- [ ] **Authentication enabled** - NO_AUTH=false in production
- [ ] **S6 service bundle** - Main service in user/contents.d/
- [ ] **Health checks working** - Container reports "healthy"
- [ ] **Secrets as files** - Not directories, all required secrets present

### 🏗️ Build & Test Validation
- [ ] **Multi-platform builds** - `make build-manifest` succeeds
- [ ] **Container health** - No errors in container logs
- [ ] **Application accessibility** - Service reachable on expected port
- [ ] **Clean shutdown** - Container stops gracefully

### 📋 Application-Specific Checks

#### Django Applications
- [ ] **Database config** - SQLite3 default, PostgreSQL override
- [ ] **Secret generation** - `make secrets-django` completed
- [ ] **Test vars removed** - No test environment vars in production files
- [ ] **Asset integrity** - No empty manifest.json files

#### Node.js Applications
- [ ] **npm audit** - Acceptable vulnerability levels
- [ ] **Package locks** - package-lock.json current
- [ ] **Dependencies** - Vulnerable nested packages replaced

#### Cloud Storage Apps (rclone)
- [ ] **Port 5572** - Official rclone Web GUI port configured
- [ ] **Web GUI functional** - Interface accessible and working
- [ ] **Process health checks** - Using ps aux instead of HTTP

### 🚫 Emergency Stop Conditions

**NEVER PUSH IF ANY OF THESE ARE TRUE:**

- [ ] Container fails to start or loops
- [ ] Critical errors in container logs
- [ ] Health checks fail
- [ ] Application not reachable on expected port
- [ ] CRITICAL security vulnerabilities detected
- [ ] Build fails on supported platforms
- [ ] Tests fail or timeout
- [ ] Documentation is outdated or incorrect

## Detailed Validation Steps

### Step 1: Clean Build Test
```bash
# Remove any existing images
docker rmi $(docker images -q ${DOCKER_USERNAME}/${APPLICATION_NAME}) 2>/dev/null || true

# Build from scratch
make build

# Verify no errors in build process
echo "Build completed successfully: $?"
```

### Step 2: Container Runtime Test
```bash
# Run comprehensive tests
make test

# Check specific application behavior
make logs | grep -E "(ERROR|WARN|FAIL)" | wc -l
# Should return 0 for production-ready containers
```

### Step 3: Security Validation
```bash
# Run security scans
make security-scan

# Check for critical vulnerabilities
make trivy-scan | grep -i critical
# Should return no results
```

### Step 4: Configuration Validation
```bash
# Validate all configuration files
make env-validate
docker compose config --quiet
docker compose -f docker-compose.yml -f docker-compose.production.yml config --quiet

# Check for syntax errors
echo "Configuration validation: $?"
```

### Step 5: Documentation Consistency Check
```bash
# Verify version consistency
grep -r "${APPLICATION_VERSION}" README.md .env.example VERSION
# All should show same version

# Check cross-references
grep -r "README.de.md" README.md
grep -r "README.md" README.de.md
# Should have mutual references
```

## Version-Specific Validations

### For Version Updates
- [ ] **Upstream check** - `make version-check` shows current version
- [ ] **Branding updated** - Container startup shows correct version
- [ ] **Documentation sync** - All files reference new version
- [ ] **Changelog entry** - Version changes documented

### For Security Updates
- [ ] **Vulnerability assessment** - Document what was fixed
- [ ] **Impact analysis** - Determine if emergency update needed
- [ ] **Testing priority** - Extra validation for security changes
- [ ] **Communication plan** - Notify users if critical

### For Feature Additions
- [ ] **Feature documentation** - New features fully documented
- [ ] **Example configurations** - Working examples provided
- [ ] **Backward compatibility** - No breaking changes without notice
- [ ] **Test coverage** - New features tested

## Application-Specific Deep Checks

### Django Applications (Extended)
```bash
# Verify Django-specific requirements
docker run --rm ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest \
  /app/venv/bin/python manage.py check --deploy

# Check static files
docker run --rm ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest \
  find /app -name "manifest.json" -exec wc -l {} \;
# Should show non-zero line count

# Test database migrations
docker run --rm ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest \
  /app/venv/bin/python manage.py showmigrations
```

### Node.js Applications (Extended)
```bash
# Security audit
npm audit --audit-level critical
# Should show 0 critical vulnerabilities

# Package verification
npm ls --depth=0 | grep -i "missing\|invalid"
# Should return no results

# Application startup test
timeout 30s docker run --rm ${DOCKER_USERNAME}/${APPLICATION_NAME}:latest
# Should start and stop cleanly
```

### Multi-Architecture Validation
```bash
# Test both architectures
make build-manifest
make inspect-manifest | grep -E "(amd64|arm64)"
# Should show both architectures

# Validate OCI compliance
make validate-manifest
echo "OCI validation: $?"
```

## Post-Validation Actions

### Before Committing
```bash
# Stage all changes
git add .

# Create descriptive commit message
git commit -m "feat: ${DESCRIPTION}

- Added: ${NEW_FEATURES}
- Fixed: ${BUG_FIXES}
- Security: ${SECURITY_UPDATES}
- Docs: ${DOC_UPDATES}

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>"
```

### Push Sequence
```bash
# Push to repository
git push origin main

# Monitor initial results
# Check GitHub Actions within 5 minutes
# Verify container registry within 10 minutes
```

## Failure Recovery

### If Validation Fails

1. **Stop immediately** - Do not push
2. **Document the failure** - Note what failed and why
3. **Fix the issue** - Address root cause
4. **Re-run full checklist** - Don't skip steps
5. **Verify fix** - Ensure problem resolved

### If Post-Push Issues Detected

1. **Assess severity** - Determine impact
2. **Consider rollback** - If critical issues found
3. **Communicate status** - Update stakeholders
4. **Plan fix** - Address issues systematically
5. **Document lessons** - Update checklist if needed

## Continuous Improvement

### Checklist Updates

This checklist should be updated when:
- New validation tools added
- Application patterns change
- Security requirements evolve
- Issues discovered in production

### Team Feedback

Encourage team members to:
- Report checklist gaps
- Suggest additional validations
- Share lessons learned
- Propose automation improvements

## Automation Goals

### Future Enhancements
- [ ] Single `make pre-push-check` command
- [ ] Automated documentation consistency checking
- [ ] Cross-file version validation
- [ ] Automated security baseline enforcement

### Tool Integration
- [ ] Git hooks for validation
- [ ] IDE integration for real-time checking
- [ ] CI/CD pipeline integration
- [ ] Slack/notification integration for failures

---

**Remember: This checklist is your safety net. Taking shortcuts here can lead to production issues that are much more costly to fix later.**

## Quick Start

**For experienced users, minimum required checks:**

```bash
make build && make test && make security-scan && git push origin main
```

**But always prefer the full checklist for reliability.**