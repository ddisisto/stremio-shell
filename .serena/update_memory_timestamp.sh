#!/bin/bash
# Automatic timestamp updater for memory files
# Usage: ./update_memory_timestamp.sh <memory_file> [version_bump_type]
# version_bump_type: patch (default), minor, major

set -e

# Check arguments
if [ $# -lt 1 ]; then
    echo "Usage: $0 <memory_file> [patch|minor|major]"
    echo "Example: $0 memories/project/overview.md minor"
    exit 1
fi

MEMORY_FILE="$1"
BUMP_TYPE="${2:-patch}"

# Validate file exists
if [ ! -f "$MEMORY_FILE" ]; then
    echo "Error: File '$MEMORY_FILE' not found"
    exit 1
fi

# Get current timestamp
CURRENT_TIME=$(date '+%Y-%m-%d %H:%M:%S')

# Function to bump version
bump_version() {
    local version=$1
    local bump_type=$2
    
    # Parse version components
    IFS='.' read -r major minor patch <<< "$version"
    
    # Bump based on type
    case "$bump_type" in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            echo "Invalid bump type: $bump_type"
            exit 1
            ;;
    esac
    
    echo "${major}.${minor}.${patch}"
}

# Create temporary file
TEMP_FILE=$(mktemp)

# Process the file
HAS_METADATA=false
TIMESTAMP_UPDATED=false
VERSION_UPDATED=false

while IFS= read -r line; do
    # Check if we're in metadata section
    if [[ "$line" == "---" ]]; then
        if [[ "$HAS_METADATA" == false ]]; then
            HAS_METADATA=true
            echo "$line" >> "$TEMP_FILE"
            continue
        else
            # End of metadata
            echo "$line" >> "$TEMP_FILE"
            HAS_METADATA=false
            continue
        fi
    fi
    
    # Update timestamp
    if [[ "$HAS_METADATA" == true ]] && [[ "$line" =~ ^timestamp: ]]; then
        echo "timestamp: $CURRENT_TIME" >> "$TEMP_FILE"
        TIMESTAMP_UPDATED=true
        echo "✓ Updated timestamp to: $CURRENT_TIME"
        continue
    fi
    
    # Update version
    if [[ "$HAS_METADATA" == true ]] && [[ "$line" =~ ^version: ]]; then
        OLD_VERSION=$(echo "$line" | sed 's/version:[ ]*//')
        NEW_VERSION=$(bump_version "$OLD_VERSION" "$BUMP_TYPE")
        echo "version: $NEW_VERSION" >> "$TEMP_FILE"
        VERSION_UPDATED=true
        echo "✓ Bumped version from $OLD_VERSION to $NEW_VERSION ($BUMP_TYPE)"
        continue
    fi
    
    # Copy other lines as-is
    echo "$line" >> "$TEMP_FILE"
done < "$MEMORY_FILE"

# Validate updates
if [[ "$TIMESTAMP_UPDATED" == false ]]; then
    echo "⚠️  Warning: No timestamp found in metadata. Adding one..."
    # Add timestamp after first ---
    sed -i '0,/^---$/!b; n; a\timestamp: '"$CURRENT_TIME"'' "$TEMP_FILE"
fi

if [[ "$VERSION_UPDATED" == false ]]; then
    echo "⚠️  Warning: No version found in metadata. Adding 1.0.0..."
    # Add version after timestamp
    sed -i '/^timestamp:/a\version: 1.0.0' "$TEMP_FILE"
fi

# Replace original file
mv "$TEMP_FILE" "$MEMORY_FILE"

echo "✅ Memory timestamp updated successfully"

# Optional: Show the updated metadata
echo -e "\nUpdated metadata:"
sed -n '/^---$/,/^---$/p' "$MEMORY_FILE" | grep -E "^(timestamp|version):" | sed 's/^/  /'