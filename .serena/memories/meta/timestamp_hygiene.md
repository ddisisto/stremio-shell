---
timestamp: 2025-01-19 16:00:00
version: 1.0.0
type: meta.timestamp_hygiene
status: active
dependencies: [meta/schema.md, meta/reference_checker.md]
references: []
---

# Timestamp Hygiene Best Practices

Critical practices that must become automatic for memory system integrity.

## The Golden Rule

> **Every memory edit MUST update the timestamp to NOW**

No exceptions. This is how we track currency and resolve conflicts.

## Automatic Practices

### 1. **When Creating a Memory**
```yaml
---
timestamp: YYYY-MM-DD HH:MM:SS  # Current time when writing
version: 1.0.0                  # Start at 1.0.0
type: namespace.category.item   # Follow hierarchy
status: active                  # New memories are active
---
```

### 2. **When Editing a Memory**
```yaml
# ALWAYS update these together:
timestamp: 2025-01-19 16:05:00  # NOW (time of edit)
version: 1.0.1                   # Bump patch/minor/major
```

### 3. **Version Bumping Rules**
- **Patch (1.0.0 → 1.0.1)**: Typos, clarifications, formatting
- **Minor (1.0.0 → 1.1.0)**: New content, additional sections
- **Major (1.0.0 → 2.0.0)**: Structure change, breaking updates

## Implementation in Tools

### Serena Memory Write
When implementing `write_memory` or file editing:
```python
def update_memory(path, content):
    # ALWAYS inject current timestamp
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    
    # Parse existing version and bump
    old_version = extract_version(content)
    new_version = bump_version(old_version, change_type)
    
    # Update metadata
    content = update_metadata(content, {
        'timestamp': now,
        'version': new_version
    })
```

### Git Hooks
Add to `.git/hooks/pre-commit`:
```bash
#!/bin/bash
# Check for memory files with timestamp drift
modified_memories=$(git diff --cached --name-only | grep "\.serena/memories/.*\.md$")

for file in $modified_memories; do
    # Extract timestamp
    timestamp=$(grep "^timestamp:" "$file" | cut -d' ' -f2-)
    
    # If timestamp wasn't updated today, fail
    if [[ "$timestamp" < "$(date +%Y-%m-%d)" ]]; then
        echo "ERROR: $file has stale timestamp: $timestamp"
        echo "Update timestamp to current time before committing"
        exit 1
    fi
done
```

## Conflict Resolution Process

When timestamps conflict:

1. **Newest timestamp is authoritative**
2. **Merge content thoughtfully**:
   ```yaml
   # Memory A (2025-01-19 10:00:00)
   # Memory B (2025-01-19 15:00:00) <- This wins
   
   # But still review Memory A for unique content to preserve
   ```

3. **Update the older memory**:
   ```yaml
   status: deprecated
   superseded_by: path/to/newer.md
   ```

## Enforcement Mechanisms

### 1. **Reference Checker Integration**
The checker already detects drift. Make it fail CI:
```yaml
# .github/workflows/memory-check.yml
- name: Check Memory Integrity
  run: |
    .serena/check_references.sh
    if [ $? -ne 0 ]; then
      echo "Memory integrity check failed"
      exit 1
    fi
```

### 2. **Editor Integration**
VSCode snippet for memory header:
```json
"Memory Header": {
  "prefix": "mem",
  "body": [
    "---",
    "timestamp: $CURRENT_YEAR-$CURRENT_MONTH-$CURRENT_DATE $CURRENT_HOUR:$CURRENT_MINUTE:00",
    "version: 1.0.0",
    "type: ${1:namespace}.${2:category}.${3:item}",
    "status: active",
    "dependencies: [${4}]",
    "references: [${5}]",
    "---",
    "",
    "# ${6:Title}",
    "",
    "${7:Content}"
  ]
}
```

## Common Pitfalls to Avoid

### ❌ DON'T: Edit without updating timestamp
```yaml
timestamp: 2025-01-15 10:00:00  # Old! File edited today
version: 1.0.0                  # Version not bumped
```

### ❌ DON'T: Update timestamp without version bump
```yaml
timestamp: 2025-01-19 16:00:00  # Updated
version: 1.0.0                  # Forgot to bump!
```

### ❌ DON'T: Use approximate timestamps
```yaml
timestamp: 2025-01-19  # Missing time = ambiguous
```

### ✅ DO: Always use precise current time
```yaml
timestamp: 2025-01-19 16:15:32  # Exact time of edit
version: 1.0.1                  # Properly bumped
```

## Making it Unconscious

1. **Tool Support**: Every memory tool auto-injects timestamps
2. **Validation**: Can't save without current timestamp
3. **Visibility**: Show drift warnings in prompts
4. **Habit**: Check → Edit → Update timestamp → Save

## The Payoff

With rigorous timestamp hygiene:
- **No silent conflicts** - newest always identifiable
- **Clear audit trail** - when was what changed
- **Automatic precedence** - no manual conflict resolution
- **Trust in currency** - timestamps = truth

This discipline enables the memory system to scale without human oversight.