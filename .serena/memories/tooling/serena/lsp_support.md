---
timestamp: 2025-06-19 15:10:00
version: 1.1.1
type: tooling.serena.lsp_support
status: active
supersedes: [serena_lsp_support.md]
related: [development/guidelines/qt.md, project/structure.md, meta/index.md]
category: tooling
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
  → Output: MpvObject (class), eventHandler (method), etc.

# 2. Deep dive into specific symbols
find_symbol("MpvObject", "mpv.h", depth=1)
  → Shows all methods/fields of MpvObject

# 3. Find all usages
find_referencing_symbols("MpvObject::setProperty", "mpv.h")
  → Shows where setProperty is called
```

### QML/CMake Editing Strategy

Since semantic tools fail on non-C++ files:

```bash
# 1. Search for patterns
search_for_pattern("Q_PROPERTY.*mpv", only_in_code_files=True)

# 2. Read specific sections
read_file("main.qml", offset=100, limit=50)

# 3. Edit with regex
replace_regex("CMakeLists.txt", 
  "VERSION [0-9.]+", 
  "VERSION 4.4.169")
```

## Common Pitfalls & Solutions

### ❌ DON'T: Try semantic operations on QML
```bash
find_symbol("MpvRenderer", "main.qml")  # FAILS!
```

### ✅ DO: Use text search for QML
```bash
search_for_pattern("MpvRenderer", paths_include_glob="*.qml")
```

### ❌ DON'T: Semantic edit of CMakeLists.txt
```bash
replace_symbol_body("project", "CMakeLists.txt", ...)  # FAILS!
```

### ✅ DO: Regex replacement for CMake
```bash
replace_regex("CMakeLists.txt", "project\\(.*\\)", "project(stremio VERSION 4.4.169)")
```

## Performance Tips

1. **Batch symbol queries** - Get overview once, then drill down
2. **Use path restrictions** - Pass `relative_path` to narrow scope
3. **Prefer semantic over text** for C++ - More accurate & faster
4. **Cache symbol locations** - Reuse paths from previous queries

## Integration with Memory System

When documenting findings:
- Store symbol paths in memories for quick reference
- Document file type limitations discovered
- Create lookup tables for common symbols
- Note platform-specific symbol variations