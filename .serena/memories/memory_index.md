---
timestamp: 2025-01-19
version: 1.0
related: [all]
category: meta
status: active
---

# Stremio Shell Memory Index

Central navigation and reference for all project memories. This index provides quick access to project knowledge and maintains memory system health.

## Memory Categories

### 🏗️ Project Memories
- **project_overview**: High-level project description, tech stack, version info
- **project_structure**: Directory layout, file organization, component mapping

### 💻 Development Memories
- **development_guidelines**: Qt practices, platform handling, security, performance
- **code_style_conventions**: Naming, formatting, Qt-specific patterns
- **task_completion_checklist**: Verification steps for completed work

### 🔧 Tooling Memories
- **serena_lsp_support**: File type support matrix, semantic tool usage
- **suggested_commands**: Build, run, test, and maintenance commands

### 📋 Meta Memories
- **memory_index**: This file - central navigation and memory management

## Quick Reference Map

### Starting New Work
1. Read **project_overview** for context
2. Check **serena_lsp_support** for tool capabilities
3. Review **code_style_conventions** for standards

### Making Changes
1. Follow **development_guidelines** for practices
2. Use **serena_lsp_support** for navigation strategy
3. Verify with **task_completion_checklist**

### Building/Testing
1. Use **suggested_commands** for build instructions
2. Check **development_guidelines** for platform considerations

## Memory Relationships

```
project_overview
  ├── project_structure (detailed layout)
  ├── development_guidelines (how to work)
  └── suggested_commands (how to build)

development_guidelines
  ├── code_style_conventions (coding standards)
  ├── task_completion_checklist (verification)
  └── serena_lsp_support (tool usage)

serena_lsp_support
  ├── development_guidelines (best practices)
  └── project_structure (file types)
```

## Memory Management Protocol

### Reading Memories
- Start with this index to find relevant memories
- Read only what's needed for current task
- Note timestamps for currency

### Updating Memories
- Always read before writing (full replacement)
- Maintain metadata header
- Update cross-references bidirectionally
- Update this index when adding new memories

### Deprecation Process
- Mark status as "deprecated" in header
- Add deprecation notice with replacement reference
- Never delete - write minimal deprecation stub

## Version History
- v1.0 (2025-01-19): Initial memory index creation