---
timestamp: 2025-06-19 14:45:00
version: 1.0.0
type: tooling.serena.memory_integration
status: active
dependencies: [memory_schema.md, meta/reference_checker.md]
references: [tooling/serena/cpp_patterns.md]
---

# Serena Memory System Integration

Opportunities for integrating the LSP-like memory system directly into Serena's core.

## Key Integration Points

### 1. Tool Enhancement
- **Native hierarchy support**: Modify `read_memory`, `write_memory` to handle paths like `project/overview.md`
- **Reference validation**: Integrate reference checker into memory write operations
- **Auto-linking**: Parse markdown links during write, validate targets exist

### 2. Prompt Factory Integration
Location: `src/serena/prompt_factory.py`
- Add memory schema awareness to initial instructions
- Include reference checker in task completion checklist
- Auto-suggest memory reads based on task context

### 3. MCP Server Extension
Location: `scripts/mcp_server.py`
- New tools: `validate_references`, `migrate_memory`, `find_memory_by_type`
- Memory graph navigation (follow dependencies/references)
- Conflict resolution assistant

### 4. Configuration Templates
Location: `src/serena/resources/config/`
- Add `memory_system.yml` mode for enhanced memory features
- Template for `.serena/check_references.sh` generation
- Project-specific memory schema definitions

## Implementation Strategy

1. **Phase 1**: Tool wrappers that understand hierarchy
2. **Phase 2**: Native tool modifications in `serena/agent.py`
3. **Phase 3**: Prompt engineering for memory-aware behavior
4. **Phase 4**: Visual memory browser in dashboard

## Benefits for All Projects

- Language-agnostic memory organization
- Automatic documentation structure
- Knowledge graph navigation
- Reduced context switching
- Better onboarding for new contributors

## Technical Considerations

- Backward compatibility with flat structure
- Performance with large memory sets
- Cross-platform path handling
- Integration with existing LSP features