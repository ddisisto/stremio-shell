---
timestamp: 2025-01-19
version: 1.0
type: meta.schema
status: active
---

# Memory Schema Definition

This document defines the LSP-like structure for Stremio Shell's memory system.

## Memory File Format

```yaml
---
timestamp: YYYY-MM-DD HH:MM:SS
version: X.Y.Z
type: namespace.category.subcategory
status: active|deprecated|stub
supersedes: [older/memory/path.md]  # if replacing
superseded_by: newer/memory/path.md  # if deprecated
dependencies: [memory/paths.md]      # required context
references: [memory/paths.md]        # related info
---

# Title (matches filename without .md)

Content using markdown...
```

## Type Hierarchy

Like LSP symbol kinds, memories have semantic types:

```
project
├── project.overview          # Basic project info
├── project.architecture      # System design
├── project.component.{name}  # Specific components
└── project.structure.{area}  # Code organization

development  
├── development.guideline.{topic}   # Best practices
├── development.convention.{type}   # Code standards
├── development.workflow.{process}  # How to do X
└── development.checklist.{phase}   # Verification steps

tooling
├── tooling.serena.{feature}       # Serena capabilities
├── tooling.command.{action}       # CLI commands
├── tooling.integration.{tool}     # External tools
└── tooling.debug.{scenario}       # Troubleshooting

meta
├── meta.schema                     # This file
├── meta.index                      # Navigation
└── meta.migration.{version}        # System changes
```

## Memory Atomicity Rules

1. **Single Responsibility**: Each file covers ONE concept
2. **Size Limit**: Split files >150 lines into sub-topics
3. **Granularity**: Prefer many small files over few large ones
4. **Naming**: File name = last segment of type (e.g., `type: project.component.mpv` → `mpv.md`)

## Reference Patterns

### Internal References (within memories)
```markdown
See: [Qt Guidelines](development/guidelines/qt.md)
Related: [MPV Component](project/components/mpv.md#events)
```

### External References (to code)
```markdown
Implementation: `mpv.cpp:142` (MPV::sendCommand)
Config: `CMakeLists.txt:55-72`
```

### Semantic Links
```markdown
Implements: [Media Playback](../project/architecture.md#media)
Extended by: [Razer Integration](../project/components/razer.md)
Requires: [Qt Framework](../development/guidelines/qt.md)
```

## Migration Protocol

When refactoring memories:

1. **Create new structure** with atomic files
2. **Set supersedes** in new files
3. **Set superseded_by** in old files  
4. **Update status** to deprecated in old files
5. **Add migration note** in old file content
6. **Update references** in dependent memories

## Query Patterns (Future)

Emulating LSP-like queries:

- **Go to Definition**: Follow type hierarchy
- **Find References**: Search for file links
- **Hover Info**: Read metadata without content
- **Rename Symbol**: Update all references
- **Workspace Symbol**: Search by type prefix

## Version Control Integration

- Each file change = semantic version bump
- Major: Structure change
- Minor: Content addition  
- Patch: Typo/clarification

This schema enables treating memories like a symbol database, with clear relationships and navigation paths.