---
timestamp: 2025-06-19 15:15:00
version: 1.0.0
type: development.guideline.platforms
status: active
dependencies: [project/overview.md, development/guidelines/qt.md]
references: [tooling/commands/build.md]
---

# Platform-Specific Development Guidelines

## Windows

### Build Requirements
- Qt 5.10+ with MSVC 2017 or MinGW
- OpenSSL 1.1.x
- Windows SDK for notifications
- NSIS for installer creation

### Key Considerations
- Use `WIN32` preprocessor directive
- D3D11 rendering for MPV
- WinRT for modern notifications
- Razer Chroma SDK integration
- Code signing for distribution

### Common Issues
- Path separators (use QDir::separator())
- DLL dependencies must be bundled
- Manifest for admin privileges

## macOS

### Build Requirements
- Qt 5.10+ with Xcode
- macOS 10.12+ SDK
- OpenSSL via Homebrew
- Certificates for notarization

### Key Considerations
- Use `APPLE` preprocessor directive
- Metal rendering support
- macOS services integration
- Bundle structure requirements
- Entitlements for hardened runtime

### Common Issues
- Notarization requirements
- Library paths (@rpath)
- Info.plist configuration

## Linux

### Build Requirements
- Qt 5.10+ development packages
- GCC 7+ or Clang 5+
- OpenSSL development headers
- Desktop integration packages

### Key Considerations
- Use `unix` preprocessor directive (not `linux`)
- Support both X11 and Wayland
- Multiple packaging formats (AppImage, Snap, Flatpak)
- GPU driver detection for hardware acceleration

### Common Issues
- Distribution-specific dependencies
- Desktop file integration
- Icon theme compliance
- Library version conflicts

## Cross-Platform Best Practices

### File Paths
```cpp
// Bad
QString path = "/home/user/.config/stremio";

// Good
QString path = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation) + "/stremio";
```

### Process Handling
```cpp
// Use Qt's process management
QProcess process;
process.setProgram(executable);
process.setArguments(args);
```

### Network Operations
- Always use Qt's network classes
- Handle proxy settings via QNetworkProxy
- SSL/TLS via Qt's SSL support

### Testing Strategy
1. Primary development on one platform
2. CI/CD for all platforms
3. Platform-specific test cases
4. Virtual machines for testing