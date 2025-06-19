# Stremio Shell Project Overview

**Purpose**: Stremio Shell is the desktop application shell for Stremio, a media streaming platform. It provides the native application wrapper for the Stremio web interface, enabling users to stream content with the tagline "Freedom to Stream".

**Tech Stack**:
- **Language**: C++ (C++11 standard)
- **Framework**: Qt 5.10+ (with Qt Quick/QML for UI)
- **Build System**: CMake (3.13+) and qmake
- **Media Playback**: MPV (libmpv) for video playback
- **Additional Libraries**: 
  - OpenSSL for cryptography
  - SingleApplication for single instance handling
  - Razer Chroma SDK (Windows only)
  - QtWebEngine for web content

**Key Components**:
- Media player integration (MPV)
- Auto-updater functionality
- System tray support
- Screensaver control
- Process management for streaming server
- Cross-platform support (Windows, macOS, Linux)

**Version**: 4.4.168 (as defined in stremio.pro and CMakeLists.txt)