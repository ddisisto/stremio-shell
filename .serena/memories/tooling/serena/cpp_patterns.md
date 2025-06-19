---
timestamp: 2025-01-19 14:35:00
version: 1.0.0
type: tooling.serena.cpp_patterns
status: active
supersedes: [serena_lsp_support.md#navigation]
dependencies: [tooling/serena/lsp_matrix.md]
references: [development/guidelines/qt.md]
---

# C++ Navigation Patterns

Effective patterns for navigating C++ code with Serena's LSP tools.

## Discovery Flow

```bash
# 1. Unknown codebase - start broad
get_symbols_overview("src/")           # See what's there
find_symbol("Main", substring=true)    # Find entry points

# 2. Focused exploration
get_symbols_overview("mpv.h")          # Understand one component
find_symbol("MPV", "mpv.h", depth=1)   # List all methods

# 3. Precise navigation  
find_symbol("MPV/sendCommand", "mpv.cpp", include_body=true)
```

## Cross-Reference Patterns

### Before API Changes
```bash
# Always check usage before modifying public methods
find_referencing_symbols("MPV/command", "mpv.h")
```

### Inheritance Tracking
```bash
# Find subclasses (they reference the base class)
find_referencing_symbols("BaseClass", "base.h", include_kinds=[5])
```

### Signal-Slot Connections (Qt)
```bash
# Find signal emitters
find_symbol("propertyChanged", substring=true)

# Find connected slots
search_for_pattern("connect.*propertyChanged")
```

## Performance Tips

1. **Use relative_path** to scope searches
2. **Read without body first**, then drill down
3. **Batch related searches** in one operation
4. **Cache discovered paths** in conversation

## Common Pitfalls

- ❌ Reading entire files when only need one method
- ❌ Using regex for available symbol operations  
- ❌ Forgetting to check references before changes
- ✅ Use symbol tools for C++ navigation
- ✅ Start broad, narrow down systematically