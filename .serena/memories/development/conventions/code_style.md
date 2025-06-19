---
timestamp: 2025-06-19 15:00:00
version: 1.0.0
type: development.convention.code_style
status: active
supersedes: [code_style_conventions.md]
---

# Code Style and Conventions

## C++ Style
- **Header Guards**: Use `#ifndef FILENAME_H_` with trailing underscore
- **Class Naming**: PascalCase (e.g., `MpvObject`, `MpvRenderer`, `SystemTray`)
- **Member Functions**: camelCase (e.g., `createRenderer`, `setProperty`, `getProperty`)
- **Private Members**: lowercase with underscores for some (varies)
- **Qt Signals/Slots**: camelCase, signals often prefixed with "on" (e.g., `onUpdate`)
- **File Naming**: lowercase (e.g., `mpv.cpp`, `systemtray.cpp`)

## Qt Conventions
- Use Qt's MOC system (Q_OBJECT macro)
- Signals and slots follow Qt conventions
- QML integration with context properties
- Use of Qt containers and helpers

## Include Order
1. Own header file
2. Qt headers
3. System headers
4. Third-party library headers
5. Project headers

## Preprocessor
- Use include guards for headers
- Platform-specific code with `#ifdef` (WIN32, APPLE, unix)
- Debug mode differentiation with `QT_DEBUG`

## Comments
- Minimal inline comments
- No specific documentation format (no Doxygen)