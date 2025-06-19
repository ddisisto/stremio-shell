---
timestamp: 2025-01-19 15:00:00
version: 1.0.0
type: meta.reference_checker
status: active
dependencies: [meta/schema.md]
---

# Memory Reference Checker

Critical tool for maintaining memory consistency. **Always run before starting work.**

## Pre-Work Checklist

```bash
# 1. Check references in memories you'll use
grep -h "references:\|dependencies:\|supersedes:\|superseded_by:" memory1.md memory2.md

# 2. Find all memories on your topic
find .serena/memories -name "*.md" -exec grep -l "YOUR_TOPIC" {} \;

# 3. Check timestamps for conflicts
grep -h "timestamp:" file1.md file2.md | sort -r

# 4. Verify supersession chains
# If memory says "superseded_by: X", check X exists and says "supersedes: [this]"
```

## Conflict Resolution Rules

### 1. **Recency Wins**
When multiple memories cover same topic:
- Compare timestamps
- Newest is authoritative
- Update older ones immediately

### 2. **Supersession Chain**
```
old.md (deprecated) → new.md (active) → newer.md (active)
         ↓                    ↓
   superseded_by: new   superseded_by: newer
                              ↑
                        supersedes: [old, new]
```

### 3. **Broken Reference Protocol**
If reference points to non-existent memory:
1. Search for moved/renamed file
2. Update reference
3. Or create stub with explanation

## Common Conflicts

### Example: Build Commands
```bash
# Found in multiple places:
suggested_commands.md: "cmake -DCMAKE_BUILD_TYPE=Release"
tooling/commands/build.md: "cmake -DCMAKE_BUILD_TYPE=Release -DQT5=ON"

# Resolution: 
# 1. Check timestamps (newer likely correct)
# 2. Test both commands
# 3. Update older memory with deprecation notice
```

### Example: Code Patterns
```bash
# Conflict detected:
development_guidelines.md (2024-12-01): "Use SIGNAL/SLOT macros"
development/guidelines/qt.md (2025-01-19): "Use new connect syntax"

# Resolution:
# 1. Newer memory (qt.md) is authoritative
# 2. Update development_guidelines.md immediately:
#    - Add "superseded_by: development/guidelines/qt.md"
#    - Add deprecation notice in content
```

## Automated Check Script

Save as `.serena/check_references.sh`:

```bash
#!/bin/bash
echo "=== Memory Reference Check ==="

# Find broken internal links
echo -e "\n[Broken References]"
grep -r '\[.*\]([^)]*\.md[^)]*)' .serena/memories | while read line; do
    file=$(echo "$line" | cut -d: -f1)
    ref=$(echo "$line" | grep -o "(\([^)]*\.md\)[^)]*)" | sed 's/[()]//g')
    if [[ ! -f ".serena/memories/$ref" ]]; then
        echo "BROKEN: $file → $ref"
    fi
done

# Find potential conflicts (same type prefix)
echo -e "\n[Potential Conflicts]"
grep -r "^type:" .serena/memories | awk -F: '{print $3}' | sort | uniq -d

# Find outdated memories (>30 days old on critical topics)
echo -e "\n[Check for Updates]"
find .serena/memories -name "*.md" -mtime +30 -exec grep -l "development\|tooling\|build" {} \;

# Supersession chain validation
echo -e "\n[Supersession Issues]"
grep -r "superseded_by:" .serena/memories | while read line; do
    old_file=$(echo "$line" | cut -d: -f1)
    new_file=$(echo "$line" | grep -o "superseded_by: \(.*\)" | cut -d' ' -f2)
    if ! grep -q "$(basename $old_file)" ".serena/memories/$new_file" 2>/dev/null; then
        echo "CHAIN BROKEN: $old_file → $new_file"
    fi
done
```

## Memory Hygiene Workflow

### Before Starting Any Task:

1. **Identify relevant memories**
   ```bash
   grep -r "FEATURE_NAME" .serena/memories
   ```

2. **Check for conflicts**
   ```bash
   # Compare timestamps
   grep -h "timestamp:" relevant_memories.md | sort -r
   ```

3. **Update outdated first**
   - Fix conflicts before reading
   - Update supersession chains
   - Propagate latest patterns

4. **Only then proceed** with actual work

### Golden Rule

> **"Stale memories create stale code. Fix memories first, code second."**

## Conflict Priority Matrix

| Conflict Type | Priority | Action |
|--------------|----------|---------|
| Build commands differ | 🔴 HIGH | Test and update immediately |
| API patterns conflict | 🔴 HIGH | Use newest, deprecate old |
| File paths changed | 🟡 MED | Update references |
| Descriptions vary | 🟢 LOW | Consolidate when convenient |