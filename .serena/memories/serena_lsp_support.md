---
timestamp: 2025-01-19
version: 1.1
related: [development_guidelines, project_structure, memory_index]
category: tooling
status: active
---

# Serena LSP Support in Stremio Shell

Critical knowledge for effective use of Serena's semantic code tools in this C++ project.

## File Type Support Matrix

### ✅ FULL Semantic Support: C++ Files

**Supported**: `.cpp`, `.h`, `.hpp`, `.cc`, `.cxx`

**Available Operations**:
- `get_symbols_overview()` - List all symbols in file/directory
- `find_symbol()` - Navigate to specific symbols with paths
- `find_referencing_symbols()` - Find all usages of a symbol
- `replace_symbol_body()` - Replace entire methods/classes
- `insert_before_symbol()` / `insert_after_symbol()` - Precise insertions

**Symbol Kinds**: 
- 5=Class, 6=Method, 8=Field, 9=Constructor, 12=Function
- 10=Enum, 11=Interface, 13=Variable, 14=Constant

### ❌ NO Semantic Support: All Other Files

**Unsupported** (return "invalid AST" errors):
- **QML**: `.qml` - Qt declarative UI files
- **CMake**: `CMakeLists.txt`, `.cmake` - Build configuration
- **Scripts**: `.sh`, `.bat`, `.py` - Build and utility scripts
- **Config**: `.json`, `.xml`, `.qrc`, `.rc` - Configuration/resources
- **Docs**: `.md`, `.txt` - Documentation

**Required Fallback**: Use text-based tools
- `search_for_pattern()` - Find content
- `replace_regex()` - Make edits
- Standard file reading

## Effective Usage Patterns

### C++ Navigation Strategy

```bash
# 1. Overview first (for unfamiliar code)
get_symbols_overview("mpv.h")

# 2. Find specific symbol
find_symbol("MPV/sendCommand", "mpv.cpp", include_body=True)

# 3. Explore class hierarchy
find_symbol("MainApp", "mainapplication.h", depth=1, include_body=False)

# 4. Trace usage before modifying
find_referencing_symbols("MPV/command", "mpv.h")
```

### Cross-Language Integration

When working with QML-C++ integration:
1. Start from C++ side (has symbols): Find Q_PROPERTY, Q_INVOKABLE
2. Use pattern search for QML side: Search for property names
3. Track connections via signal/slot names

### Performance Optimization

- **DON'T**: `get_symbols_overview(".")` - Too many results
- **DO**: Use `relative_path` parameter to narrow scope
- **DO**: Read symbols without body first, then drill down
- **DON'T**: Read whole files if only need specific symbols

## Common Pitfalls & Solutions

### Pitfall: Assuming QML has symbols
**Solution**: Always check file extension first, use pattern search for `.qml`

### Pitfall: Using regex for large C++ refactors
**Solution**: Use `replace_symbol_body()` for whole method/class changes

### Pitfall: Not checking references before API changes
**Solution**: Always run `find_referencing_symbols()` first

## Integration with Project Workflow

**See also**:
- **development_guidelines**: For when to use semantic vs text tools
- **project_structure**: To understand which directories have C++ code
- **task_completion_checklist**: Includes "verify symbol references"

This knowledge is essential for efficient navigation and modification of the Stremio Shell codebase, as ~80% of the core logic is in C++ files where Serena excels.