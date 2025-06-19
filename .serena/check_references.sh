#!/bin/bash
# Memory Reference Integrity Checker for Stremio Shell
# Run before starting any work to ensure memory consistency

set -e

MEMORY_DIR=".serena/memories"
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

echo "=== Stremio Shell Memory Reference Check ==="
echo "Timestamp: $(date '+%Y-%m-%d %H:%M:%S')"
echo "==========================================="

# Track issues found
ISSUES_FOUND=0

# 1. Check for broken markdown links
echo -e "\n${YELLOW}[Checking Broken References]${NC}"
while IFS= read -r line; do
    if [[ -n "$line" ]]; then
        file=$(echo "$line" | cut -d: -f1)
        # Extract markdown link paths
        echo "$line" | grep -o '\[.[^]]*\]([^)]*\.md[^)]*)' | sed 's/.*(\([^)]*\.md\)[^)]*).*/\1/' | while read -r ref; do
            # Handle relative paths
            ref_dir=$(dirname "$file")
            if [[ "$ref" == ../* ]]; then
                full_path=$(cd "$ref_dir" && cd "$(dirname "$ref")" 2>/dev/null && pwd)/$(basename "$ref")
                check_path="${full_path#$(pwd)/$MEMORY_DIR/}"
            else
                check_path="$ref"
            fi
            
            if [[ ! -f "$MEMORY_DIR/$check_path" ]] && [[ ! -f "$ref_dir/$ref" ]]; then
                echo -e "${RED}✗ BROKEN:${NC} $file → $ref"
                ((ISSUES_FOUND++))
            fi
        done
    fi
done < <(grep -r '\[.*\]([^)]*\.md[^)]*)' "$MEMORY_DIR" 2>/dev/null || true)

# 2. Find duplicate type definitions (potential conflicts)
echo -e "\n${YELLOW}[Checking Duplicate Types]${NC}"
duplicates=$(grep -r "^type:" "$MEMORY_DIR" | awk -F: '{gsub(/^[ \t]+/, "", $3); print $3}' | sort | uniq -d)
if [[ -n "$duplicates" ]]; then
    while IFS= read -r dup_type; do
        echo -e "${RED}✗ DUPLICATE TYPE:${NC} $dup_type"
        grep -r "^type:.*$dup_type" "$MEMORY_DIR" | sed 's/^/    /'
        ((ISSUES_FOUND++))
    done <<< "$duplicates"
fi

# 3. Check supersession chain integrity
echo -e "\n${YELLOW}[Checking Supersession Chains]${NC}"
grep -r "superseded_by:" "$MEMORY_DIR" 2>/dev/null | while read -r line; do
    old_file=$(echo "$line" | cut -d: -f1)
    # Extract the superseding file path
    new_file=$(echo "$line" | sed 's/.*superseded_by:[ ]*//' | sed 's/[ ].*//')
    
    if [[ -f "$MEMORY_DIR/$new_file" ]]; then
        # Check if new file references the old one
        old_basename=$(basename "$old_file" .md)
        if ! grep -q "$old_basename" "$MEMORY_DIR/$new_file" 2>/dev/null; then
            echo -e "${YELLOW}⚠ CHAIN INCOMPLETE:${NC} $(basename "$old_file") → $new_file"
            echo "    $new_file should reference $old_basename in 'supersedes:'"
            ((ISSUES_FOUND++))
        fi
    else
        echo -e "${RED}✗ MISSING SUPERSEDING FILE:${NC} $old_file → $new_file"
        ((ISSUES_FOUND++))
    fi
done || true

# 4. Find conflicts by topic (same keywords in different files)
echo -e "\n${YELLOW}[Checking Topic Conflicts]${NC}"
# Check for common conflicting topics
for topic in "build command" "cmake" "qt guideline" "code style" "lsp support"; do
    files=$(grep -l -i "$topic" "$MEMORY_DIR"/*.md "$MEMORY_DIR"/**/*.md 2>/dev/null | grep -v "/meta/" || true)
    if [[ $(echo "$files" | wc -l) -gt 1 ]] && [[ -n "$files" ]]; then
        echo -e "${YELLOW}⚠ Multiple memories for '${topic}':${NC}"
        for f in $files; do
            timestamp=$(grep "^timestamp:" "$f" | cut -d' ' -f2 || echo "no-timestamp")
            echo "    $timestamp - $(basename "$f")"
        done
        echo "    → Newest timestamp should be authoritative"
    fi
done

# 5. Find stale memories (modified >30 days ago)
echo -e "\n${YELLOW}[Checking Stale Memories]${NC}"
stale_files=$(find "$MEMORY_DIR" -name "*.md" -mtime +30 -not -path "*/meta/*" 2>/dev/null || true)
if [[ -n "$stale_files" ]]; then
    echo -e "${YELLOW}⚠ Memories not updated in 30+ days:${NC}"
    echo "$stale_files" | while read -r f; do
        [[ -n "$f" ]] && echo "    $(basename "$f")"
    done
fi

# 6. Summary
echo -e "\n${YELLOW}[Summary]${NC}"
if [[ $ISSUES_FOUND -eq 0 ]]; then
    echo -e "${GREEN}✓ All reference checks passed!${NC}"
else
    echo -e "${RED}✗ Found $ISSUES_FOUND issues that need attention${NC}"
    echo -e "\n${YELLOW}Before proceeding with work:${NC}"
    echo "1. Fix broken references"
    echo "2. Resolve type duplicates"  
    echo "3. Update supersession chains"
    echo "4. Review topic conflicts - newest wins"
    echo -e "\nSee ${MEMORY_DIR}/meta/reference_checker.md for resolution guidelines"
fi

exit $ISSUES_FOUND