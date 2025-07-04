---
timestamp: 2025-06-19 10:52:00
version: 1.0.0
type: tooling.command.build.deprecated
status: deprecated
superseded_by: tooling/commands/build.md
---

# Suggested Commands for Development

**DEPRECATED**: This memory has been moved to [tooling/commands/build.md](tooling/commands/build.md).

## Building the Project

### Using CMake (Recommended for Linux):
```bash
mkdir build
cd build
cmake -G"Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..
make -j
```

### Using qmake (Alternative, works on all platforms):
```bash
qmake
make
```

### Platform-specific builds:

**Linux (with packaging):**
```bash
make -f release.makefile
```

**Windows:**
```bash
build_windows.bat
```

**Docker builds (for Linux distros):**
```bash
./dist-utils/build-package.sh <distro_name>
```

## Running the Application

### Development mode:
```bash
./stremio --development
```
This loads from `http://127.0.0.1:11470` instead of production.

### Staging mode:
```bash
./stremio --staging
```

### With custom web UI:
```bash
./stremio --webui-url=<URL>
```

## Version Management
- Version is defined in `stremio.pro` (VERSION=4.4.168)
- Also update in `CMakeLists.txt` project version
- Create git tag for releases

## Clean Build
```bash
make -f release.makefile clean
```

## Installation (Linux)
```bash
sudo make -f release.makefile install
```

## Git Commands
- Standard git workflow
- Tag releases with version numbers
- Main branch: master