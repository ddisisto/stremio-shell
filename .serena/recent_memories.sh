#!/bin/bash
# Recent Memories Query Tool - Memory Bus "Tick" Handler
# Usage: ./recent_memories.sh [hours] [--hover]

set -e

MEMORY_DIR=".serena/memories"
HOURS=${1:-24}  # Default to last 24 hours
HOVER_MODE=false

if [[ "$2" == "--hover" ]] || [[ "$1" == "--hover" ]]; then
    HOVER_MODE=true
    [[ "$1" == "--hover" ]] && HOURS=24
fi

# Colors
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}=== Recent Memory Activity ===${NC}"
echo -e "Time window: Last ${HOURS} hours"
echo -e "Current time: $(date '+%Y-%m-%d %H:%M:%S')"
echo "==========================================="

# Find files modified in the last N hours
echo -e "\n${YELLOW}[Recently Modified Memories]${NC}"
recent_files=$(find "$MEMORY_DIR" -name "*.md" -type f -mmin -$((HOURS * 60)) 2>/dev/null | sort -r || true)

if [[ -z "$recent_files" ]]; then
    echo "No memories modified in the last $HOURS hours"
else
    while IFS= read -r file; do
        if [[ -n "$file" ]]; then
            # Extract metadata
            timestamp=$(grep "^timestamp:" "$file" 2>/dev/null | sed 's/timestamp:[ ]*//' || echo "no-timestamp")
            type=$(grep "^type:" "$file" 2>/dev/null | sed 's/type:[ ]*//' || echo "no-type")
            status=$(grep "^status:" "$file" 2>/dev/null | sed 's/status:[ ]*//' || echo "active")
            
            # Get file modification time
            if command -v gdate >/dev/null 2>&1; then
                mtime=$(gdate -r "$file" '+%Y-%m-%d %H:%M:%S' 2>/dev/null)
            else
                mtime=$(date -r "$file" '+%Y-%m-%d %H:%M:%S' 2>/dev/null || stat -c '%y' "$file" 2>/dev/null | cut -d' ' -f1-2)
            fi
            
            # Determine if this is likely from another context
            current_tty=$(tty 2>/dev/null || echo "unknown")
            
            # Display based on mode
            if [[ "$HOVER_MODE" == true ]]; then
                # Compact hover display
                echo -e "${GREEN}$(basename "$file")${NC} [$type] - $mtime"
            else
                # Detailed display
                echo -e "\n${GREEN}File:${NC} $file"
                echo -e "${BLUE}Type:${NC} $type | ${BLUE}Status:${NC} $status"
                echo -e "${BLUE}Metadata Time:${NC} $timestamp"
                echo -e "${BLUE}File Modified:${NC} $mtime"
                
                # Show first few lines of content
                echo -e "${YELLOW}Preview:${NC}"
                sed -n '/^---$/,/^---$/!p' "$file" 2>/dev/null | grep -v '^#' | head -3 | sed 's/^/  /'
            fi
        fi
    done <<< "$recent_files"
fi

# Check for new memories (created in time window)
echo -e "\n${YELLOW}[Newly Created Memories]${NC}"
new_memories=$(find "$MEMORY_DIR" -name "*.md" -type f -cmin -$((HOURS * 60)) 2>/dev/null | sort -r || true)
if [[ -n "$new_memories" ]]; then
    echo "$new_memories" | while read -r file; do
        [[ -n "$file" ]] && echo -e "${GREEN}NEW:${NC} $(basename "$file" .md)"
    done
else
    echo "No new memories created"
fi

# Message bus check - memories with specific markers
echo -e "\n${YELLOW}[Message Bus Activity]${NC}"
# Look for memories with context markers or session references
messages=$(grep -r "context\|session\|message\|TODO\|FIXME\|NOTE" "$MEMORY_DIR" --include="*.md" -l 2>/dev/null | \
           xargs -I {} find {} -mmin -$((HOURS * 60)) 2>/dev/null | sort -r || true)

if [[ -n "$messages" ]]; then
    echo "$messages" | while read -r file; do
        if [[ -n "$file" ]]; then
            echo -e "${CYAN}MSG:${NC} $(basename "$file")"
            grep -i "context\|session\|message\|TODO\|FIXME\|NOTE" "$file" | head -2 | sed 's/^/     /'
        fi
    done
else
    echo "No message-like content found in recent memories"
fi

# Summary stats
echo -e "\n${YELLOW}[Summary]${NC}"
total_recent=$(echo "$recent_files" | grep -c . || echo 0)
total_new=$(echo "$new_memories" | grep -c . || echo 0)
echo -e "Modified: $total_recent | Created: $total_new | Messages: $(echo "$messages" | grep -c . || echo 0)"

# Suggested actions
if [[ $total_recent -gt 0 ]] || [[ $total_new -gt 0 ]]; then
    echo -e "\n${YELLOW}[Suggested Actions]${NC}"
    echo "1. Review new memories for context from other sessions"
    echo "2. Check for TODO/FIXME markers in recent changes"
    echo "3. Look for supersession chains that need updating"
    echo "4. Validate references in modified memories"
fi