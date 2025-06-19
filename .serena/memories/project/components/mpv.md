---
timestamp: 2025-06-19 14:14:00
version: 1.0.0
type: project.component.mpv
status: active
dependencies: [project/overview.md]
references: [development/guidelines/qt.md]
---

# MPV Media Player Component

Core media playback component using libmpv.

## Overview

The MPV component (`mpv.h`/`mpv.cpp`) provides Qt integration with libmpv for media playback.

## Key Interfaces

### Initialization
- Constructor takes QQuickItem parent
- Sets up mpv render context
- Configures hardware acceleration

### Commands
- `sendCommand()` - Send commands to mpv
- `setProperty()` - Set mpv properties
- `getProperty()` - Get mpv properties

## Events

MPV events are converted to Qt signals:
- `onMpvEvents()` - Raw mpv event handler
- `propertyChanged()` - Property change notifications
- `observeProperty()` - Watch specific properties

## Integration Points

- **QML**: Exposed as `MpvObject` type
- **Render**: OpenGL context sharing with Qt
- **Props**: Q_PROPERTY bindings for QML

## Platform Specifics

- **Windows**: D3D11 hardware acceleration
- **macOS**: VideoToolbox support
- **Linux**: VAAPI/VDPAU detection

See: [Architecture](../architecture.md#media-playback)