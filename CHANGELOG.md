# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.7-1] - 2025-09-27

### 🔧 Initial Template Implementation & Container Fixes

#### Added
- **Complete LinuxServer.io Implementation**: Full S6 Overlay v3 service structure with standardized dependencies
- **Template-Based Configuration**: Complete template system with variable substitution patterns
- **Multi-Architecture Support**: OCI Manifest Lists with AMD64/ARM64 builds
- **Security Hardening**: Comprehensive Docker security with capability management and localhost binding
- **FILE__ Secrets Support**: Enhanced LinuxServer.io secrets management with path validation
- **Comprehensive CI/CD**: GitHub Actions workflows for testing, security scanning, and automated publishing

#### Fixed
- **Docker Build Arguments**: Added missing SOURCE_IMAGE, SOURCE_VERSION, and dependency version ARGs
- **S6 Service Structure**: Fixed template variable replacement in service scripts
- **Application Startup**: Corrected main script from index.js to server.js for proper Node.js application launch
- **Service Dependencies**: Implemented complete LinuxServer.io service chain: init-branding → init-mods-package-install → init-custom-files → init-secrets → init-serpbear-config → serpbear
- **Container Health Checks**: Functional container startup with proper S6 service initialization
- **Template Integration**: Replaced ${APPLICATION_NAME} variables with actual "serpbear" values

#### Changed
- **Base Image**: LinuxServer.io Alpine 3.22 with S6 Overlay v3 for standardized container management
- **Application Structure**: Organized according to workspace template standards with config/, data/, security/ directories
- **Documentation**: Added comprehensive bilingual documentation (English/German) with cross-references
- **Configuration Files**: Standardized .gitignore, .dockerignore, .prettierrc, .editorconfig, .gitattributes patterns

#### Security
- **Container Hardening**: Implemented no-new-privileges, capability dropping, and seccomp profiles
- **Secret Management**: Enhanced FILE__ prefix secret processing with validation
- **Localhost Binding**: Restricted port access to 127.0.0.1 for production security
- **Runtime Security**: Non-root execution with user abc (UID 911)

#### Infrastructure
- **CI/CD Workflows**: Complete GitHub Actions suite for testing, security scanning, and publishing
- **Version Management**: Semantic versioning with VERSION file integration
- **Build System**: Comprehensive Makefile with standardized commands for setup, build, test, and deployment
- **Security Scanning**: Integrated Trivy vulnerability scanning and CodeQL static analysis

#### Technical Implementation
- **Service Scripts**: Complete S6 service structure with proper dependency management
- **Container Configuration**: Production-ready configuration with resource limits and security options
- **Network Setup**: Custom bridge networks with proper service discovery
- **Health Monitoring**: Container health checks with application-specific validation

### 📊 Project Metrics
- **Container Build**: Successfully builds multi-architecture images (AMD64/ARM64)
- **Service Structure**: 6 S6 services properly configured and functional
- **Security Posture**: Comprehensive hardening with minimal attack surface
- **Documentation**: Complete bilingual documentation coverage

### 🛠️ Development Features
- **Make Commands**: Complete set of standardized build and development commands
- **Template Integration**: Full workspace template compliance
- **CI/CD Pipeline**: Automated testing, security scanning, and publishing workflows
- **Development Workflow**: Streamlined development environment with hot-reload capabilities

---

### Links

- [Docker Hub Repository](https://hub.docker.com/r/mildman1848/serpbear)
- [GitHub Repository](https://github.com/mildman1848/serpbear)
- [Original SerpBear](https://github.com/towfiqi/serpbear)
- [LinuxServer.io](https://www.linuxserver.io/)