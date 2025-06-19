# Task Completion Checklist

When completing a coding task in the Stremio Shell project:

## 1. Code Quality Checks
- [ ] Ensure C++11 standard compliance
- [ ] Follow existing code style (PascalCase for classes, camelCase for methods)
- [ ] Add appropriate header guards for new header files
- [ ] Handle platform-specific code with proper `#ifdef` directives

## 2. Build Verification
- [ ] Test build with CMake: `cmake .. && make`
- [ ] Verify no compilation warnings or errors
- [ ] Check that MOC (Meta-Object Compiler) processes Q_OBJECT classes correctly

## 3. Testing
- [ ] Test the application launches successfully
- [ ] Verify new features work on target platforms
- [ ] Test with `--development` flag if working on UI features
- [ ] Check system tray functionality if modified
- [ ] Verify MPV integration if media playback was changed

## 4. Cross-platform Considerations
- [ ] Test or consider implications for Windows, macOS, and Linux
- [ ] Ensure paths use Qt's cross-platform methods
- [ ] Check OpenSSL linking on different platforms

## 5. Version and Documentation
- [ ] Update version in `stremio.pro` and `CMakeLists.txt` if needed
- [ ] Update relevant documentation (README.md, platform-specific .md files)
- [ ] Add necessary command-line arguments to documentation

## 6. Before Committing
- [ ] Review all changes
- [ ] Ensure no hardcoded paths or platform-specific assumptions
- [ ] Verify no sensitive information in code
- [ ] Check that submodules are properly referenced if modified