---
timestamp: 2025-06-19 10:54:00
version: 1.0.0
type: development.guideline.general.deprecated
status: deprecated
superseded_by: development/guidelines/qt.md, development/guidelines/platforms.md
---

# Development Guidelines

**DEPRECATED**: This memory has been split into:
- [Qt Guidelines](development/guidelines/qt.md) - Qt-specific development practices
- [Platform Guidelines](development/guidelines/platforms.md) - Platform-specific considerations

## Qt-specific Guidelines
- Use Qt's cross-platform APIs for file operations, networking, etc.
- Prefer Qt containers (QList, QMap) over STL when interfacing with Qt APIs
- Use signals and slots for event handling
- Context properties for QML-C++ communication
- Qt Resource System for embedding files

## Platform Handling
- Always use conditional compilation for platform-specific code
- Platform macros: `WIN32`, `APPLE`, `unix` (Linux)
- Test on target platforms or use CI/CD for validation

## Command-line Arguments
The application supports several command-line arguments:
- `--development`: Development mode (local server)
- `--staging`: Use staging server
- `--webui-url=URL`: Custom web UI URL
- `--streaming-server`: Force streaming server in dev mode
- `--autoupdater-force`: Force update check
- `--autoupdater-force-full`: Force full update
- `--autoupdater-endpoint=URL`: Custom update endpoint

## Dependencies Management
- Submodules for major dependencies (libmpv, singleapplication)
- System libraries linked differently per platform
- OpenSSL required on all platforms
- Qt 5.10+ minimum requirement

## Security Considerations
- Signature verification for updates (`verifysig.c`)
- Proper handling of web content through QtWebEngine
- No hardcoded credentials or sensitive data

## Performance
- Use Qt's threading when needed for long operations
- MPV runs in separate render context
- Efficient resource management with Qt's parent-child hierarchy

## Error Handling
- Use Qt's logging system (qDebug, qWarning, qCritical)
- Graceful degradation for missing features
- Platform-specific error handling where needed