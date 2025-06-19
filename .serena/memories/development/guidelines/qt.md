---
timestamp: 2025-01-19 14:30:00
version: 1.0.0
type: development.guideline.qt
status: active
supersedes: [development_guidelines.md#qt-specific]
dependencies: [project/overview.md]
references: [development/conventions/naming.md, tooling/serena/cpp_patterns.md]
---

# Qt Framework Guidelines

Core practices for Qt development in Stremio Shell.

## API Usage

- **Prefer Qt over STL** for cross-platform operations
- Use `QFile`, `QNetworkAccessManager`, `QProcess`
- Qt containers when interfacing with Qt APIs: `QList`, `QMap`

## Signal-Slot Architecture

```cpp
// Prefer new connect syntax
connect(sender, &Sender::signal, receiver, &Receiver::slot);

// Not old syntax
connect(sender, SIGNAL(signal()), receiver, SLOT(slot()));
```

## QML Integration

- Context properties for C++ ↔ QML communication
- `Q_PROPERTY` for reactive bindings
- `Q_INVOKABLE` for QML-callable methods

See: [QML Patterns](../../project/architecture.md#qml-integration)

## Resource Management

- Qt Resource System (`.qrc`) for embedded files
- Parent-child hierarchy for automatic cleanup
- `QObject::deleteLater()` for safe async deletion

## Threading

- `QThread` for long operations
- `QtConcurrent` for parallel tasks
- Signal-slot connections are thread-safe

Related: [Performance Guidelines](../performance.md)