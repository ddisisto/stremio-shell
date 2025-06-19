# Project Structure

## Root Directory Files
- **Build Configuration**: `CMakeLists.txt`, `stremio.pro`, `Makefile`, `release.makefile`
- **Main Application**: `main.cpp`, `mainapplication.h`
- **Core Components**:
  - `mpv.cpp/h` - Media player integration
  - `stremioprocess.cpp/h` - Process management
  - `systemtray.cpp/h` - System tray functionality
  - `autoupdater.cpp/h` - Auto-update functionality
  - `screensaver.cpp/h` - Screensaver control
  - `razerchroma.cpp/h` - Razer Chroma integration (Windows)
  - `qclipboardproxy.cpp/h` - Clipboard access
  - `verifysig.c/h` - Signature verification

## Directories
- **deps/** - Dependencies (submodules)
  - `libmpv/` - MPV library
  - `singleapplication/` - Single instance handling
  - `chroma/` - Razer Chroma SDK
- **images/** - Application icons and images
- **distros/** - Linux distribution-specific files
- **dist-utils/** - Distribution utilities
- **mac/** - macOS-specific files
- **windows/** - Windows-specific files
- **scripts/** - Build and utility scripts
- **CMakeModules/** - CMake modules
- **.github/** - GitHub configuration (CI/CD)

## Resources
- **qml.qrc** - Qt resource file
- **main.qml** - Main QML UI file
- **server-url.txt** - Server URL configuration
- **Info.plist** - macOS bundle information

## Platform-specific Files
- **Linux**: `.desktop` files, `release.makefile`
- **Windows**: `stremio.rc`, `build_windows.bat`
- **macOS**: `Info.plist`, various scripts in `mac/`

## Documentation
- Platform-specific build instructions: `WINDOWS.md`, `DEBIAN.md`, `OpenSuseLeap.md`, `DOCKER.md`
- Main documentation: `README.md`
- License: `LICENSE.md`