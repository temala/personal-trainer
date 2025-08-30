#!/bin/bash

# debug_run.sh - Simplified debug version

echo "=== Debug Flutter Environment Script ==="
echo "Script starting..."
echo "Working directory: $(pwd)"
echo "Script location: $0"
echo "Arguments passed: $@"
echo ""

# Check Flutter
echo "Checking Flutter installation..."
if command -v flutter &> /dev/null; then
    echo "✅ Flutter found: $(flutter --version | head -n 1)"
else
    echo "❌ Flutter not found in PATH"
    exit 1
fi
echo ""

# Default env file
ENV_FILE=".env"

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -f|--file)
            ENV_FILE="$2"
            echo "Using env file: $ENV_FILE"
            shift 2
            ;;
        *)
            echo "Unknown option: $1"
            shift
            ;;
    esac
done

# Check env file
echo "Checking environment file: $ENV_FILE"
if [[ -f "$ENV_FILE" ]]; then
    echo "✅ Environment file found"
    echo "File contents:"
    echo "----------------------------------------"
    cat "$ENV_FILE"
    echo "----------------------------------------"
else
    echo "❌ Environment file '$ENV_FILE' not found!"
    echo "Looking for files in current directory:"
    ls -la | grep -E '\.(env|ENV)'
    exit 1
fi
echo ""

# Build dart-define arguments
echo "Building dart-define arguments..."
DART_DEFINES=()

while IFS='=' read -r key value; do
    # Skip empty lines and comments
    [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]] && continue
    
    # Clean up key and value
    key=$(echo "$key" | xargs)
    value=$(echo "$value" | xargs | sed 's/^["'"'"']\(.*\)["'"'"']$/\1/')
    
    if [[ -n "$key" && -n "$value" ]]; then
        DART_DEFINES+=("--dart-define=$key=$value")
        echo "  Found: $key=${value:0:10}..."
    fi
done < "$ENV_FILE"

echo "Total dart-define arguments: ${#DART_DEFINES[@]}"
echo ""

# Show final command
FLUTTER_COMMAND="flutter run --debug"
for define in "${DART_DEFINES[@]}"; do
    FLUTTER_COMMAND="$FLUTTER_COMMAND $define"
done

echo "Final command would be:"
echo "$FLUTTER_COMMAND"
echo ""

# Ask user if they want to run it
read -p "Do you want to execute this command? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Executing command..."
    exec $FLUTTER_COMMAND
else
    echo "Command not executed."
fi