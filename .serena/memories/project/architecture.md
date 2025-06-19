---
timestamp: 2025-06-19 14:50:00
version: 1.0.0
type: project.architecture
status: active
dependencies: [project/overview.md]
references: [project/components/mpv.md, development/guidelines/qt.md]
---

# Stremio Shell Architecture

High-level system design and component interactions.

## Core Architecture

### Application Layers

1. **Native Shell** (C++/Qt)
   - Main application window
   - System integration (tray, shortcuts)
   - Process management
   - Native UI elements

2. **Web UI Bridge** (Qt WebEngine)
   - Hosts Stremio web application
   - JavaScript-Qt communication
   - Event forwarding

3. **Media Playback** (libmpv)
   - Hardware-accelerated video
   - Subtitle rendering
   - Audio processing
   - Stream handling

4. **Streaming Server** (Node.js subprocess)
   - Torrent streaming
   - Add-on execution
   - Content discovery
   - API server

## Component Communication

```
QML UI <-> C++ Core <-> MPV
   |          |
   v          v
WebEngine <- Process Manager -> Streaming Server
```

## Key Design Decisions

### Single Instance
- Uses SingleApplication library
- Prevents multiple server instances
- Handles deep links

### Auto-Updates
- Platform-specific mechanisms
- Signature verification
- Rollback capability

### Media Playback
See: [MPV Component](components/mpv.md#media-playback)
- Direct MPV integration over QtMultimedia
- Custom render loop for performance
- Platform-specific optimizations

### Process Architecture
- Main process: Qt application
- Render process: MPV context
- Child process: Streaming server
- Web processes: Qt WebEngine pool

## Platform Adaptations

### Windows
- WinRT for notifications
- D3D11 rendering
- Razer Chroma SDK
- NSIS installer

### macOS
- Metal rendering
- macOS services
- DMG distribution
- Notarization

### Linux
- X11/Wayland support
- AppImage/Snap/Flatpak
- Desktop integration
- GPU detection

## Security Model

- Sandboxed web content
- Signed updates only
- No direct file access from web
- Process isolation