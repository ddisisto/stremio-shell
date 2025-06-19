---
timestamp: 2025-01-19 14:40:00
version: 2.0.0
type: meta.index
status: active
supersedes: [memory_index.md]
---

# Stremio Shell Memory Index

LSP-like navigation for project knowledge. Start here, follow references.

## 🚨 CRITICAL: Pre-Work Memory Check

**ALWAYS run before starting any work:**
```bash
.serena/check_references.sh
```

If conflicts found:
1. **STOP** - Don't proceed with outdated info
2. **FIX** memories first (newest timestamp wins)  
3. **THEN** start actual work

### 🔧 Automatic Tools

**Update timestamp when editing:**
```bash
.serena/update_memory_timestamp.sh path/to/memory.md [patch|minor|major]
```

**Install git hook for enforcement:**
```bash
ln -sf ../../.serena/hooks/pre-commit-memory-check .git/hooks/pre-commit
```

See: [Reference Checker](meta/reference_checker.md) | [Timestamp Hygiene](meta/timestamp_hygiene.md)

## Quick Navigation

### 🎯 Common Tasks

| Task | Primary Memory | Supporting Memories |
|------|----------------|-------------------|
| Start coding | [Project Overview](project/overview.md) | [Qt Guidelines](development/guidelines/qt.md), [C++ Patterns](tooling/serena/cpp_patterns.md) |
| Fix a bug | [Debugging Guide](development/workflows/debugging.md) | [Component Map](project/architecture.md#components) |
| Add feature | [Architecture](project/architecture.md) | [Conventions](development/conventions/code_style.md), [Checklist](development/checklists/task_completion.md) |
| Build/Test | [Build Commands](tooling/commands/build.md) | [Platform Guide](development/guidelines/platforms.md) |

### 🗂️ Memory Namespaces

```
memories/
├── project/          # What is this codebase?
├── development/      # How do we work?
├── tooling/          # What tools help us?
└── meta/             # How do memories work?
```

## Symbol-like Queries

### "Go to Definition" Examples

- MPV Component → [project/components/mpv.md](project/components/mpv.md)
- Qt Guidelines → [development/guidelines/qt.md](development/guidelines/qt.md)  
- Build Process → [tooling/commands/build.md](tooling/commands/build.md)
- LSP Support → [tooling/serena/lsp_support.md](tooling/serena/lsp_support.md)

### "Find All References" Patterns

Find all memories mentioning Qt:
```bash
grep -l "Qt" .serena/memories/**/*.md
```

Find dependencies of a memory:
```bash
grep -l "dependencies:.*mpv.md" .serena/memories/**/*.md
```

## Memory Health Dashboard

### Active Development Areas
- ✅ Project structure documented
- ✅ Development guidelines split
- 🔄 Tooling patterns emerging
- 📋 Meta system defined

### Deprecation Notices
- [memory_index.md](memory_index.md) → This file (v2.0.0)
- [development_guidelines.md](development_guidelines.md) → Split into [guidelines/](development/guidelines/)

## Navigation Tips

1. **Use file paths as symbols** - they're stable references
2. **Follow type hierarchy** - namespace → category → specific
3. **Check dependencies** before reading for required context
4. **Note supersession** - always use latest version

---
*Memory system follows [Schema Definition](memory_schema.md)*