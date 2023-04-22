#!/bin/bash

# Function to display help message
display_help() {
    echo "Usage: $0 [OPTIONS] <extension_name> <extension_type>"
    echo ""
    echo "OPTIONS:"
    echo "  -h, --help        Show this help message"
    echo ""
    echo "ARGUMENTS:"
    echo "  <extension_name>  The name of the new extension"
    echo "  <extension_type>  The type of the new extension (popup, background, content)"
    echo ""
    echo "Initialize a new Chrome extension project with the specified name and type."
}

# Check for help option
if [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    display_help
    exit 0
fi

# Check for correct number of arguments
if [ $# -ne 2 ]; then
    echo "Error: Invalid number of arguments"
    echo ""
    display_help
    exit 1
fi

EXTENSION_NAME="$1"
EXTENSION_TYPE="$2"
EXTENSION_DIR="$EXTENSION_NAME"

mkdir -p "$EXTENSION_DIR"
cd "$EXTENSION_DIR"

# Create a basic manifest.json file
cat > manifest.json <<EOL
{
    "manifest_version": 2,
    "name": "$EXTENSION_NAME",
    "version": "1.0",
    "description": "A sample $EXTENSION_TYPE Chrome extension",
    "permissions": []
}
EOL

# Create files and folders based on extension type
case "$EXTENSION_TYPE" in
    background)
        # mkdir -p background
        # touch background/background.js
        # echo "Creating background/background.js"

        # Add background property to manifest.json
        jq '.background = { "scripts": [".background/background.js"], "persistent": false }' manifest.json > manifest.tmp && mv manifest.tmp manifest.json
        ;;

    content)
        touch content_script.js
        echo "Creating content_script.js"

        # Add content_scripts property to manifest.json
        jq '.content_scripts = [ { "matches": ["<all_urls>"], "js": ["content_script.js"] } ]' manifest.json > manifest.tmp && mv manifest.tmp manifest.json
        ;;

    popup)
        touch popup.js
        echo "Creating popup.js"

        # Add browser_action property to manifest.json
        jq '.browser_action = { "default_popup": "popup.html", "default_icon": "icon.png" }' manifest.json > manifest.tmp && mv manifest.tmp manifest.json
        ;;

    *)
        echo "Error: Invalid extension type. Allowed types are background, content, popup."
        exit 1
        ;;
esac

# Create index.html and styles.css
touch index.html styles.css
echo "Creating index.html"
echo "Creating styles.css"

# Initialize TypeScript
if command -v tsc >/dev/null 2>&1 ; then
    echo "Initializing TypeScript"
    mkdir -p src/background
    touch src/background/background.ts
    mkdir -p .background
    npm init -y
    npm install typescript --save-dev
    touch tsconfig.json

    # Add TypeScript configuration
    cat > tsconfig.json <<EOL
{
    "compilerOptions": {
        "target": "ES2017",
        "module": "commonjs",
        "strict": true,
        "outDir": ".background"
    },
    "include": [
        "src/background/*.ts"
    ]
}
EOL
cat > .gitignore <<EOL
.background
EOL

    # Add npm build command to compile TypeScript files
    jq '.scripts.build = "tsc"' package.json > package.tmp && mv package.tmp package.json
else
    echo "TypeScript is not installed. If you need TypeScript support, install it globally using 'npm install -g typescript'"
fi

echo "Chrome extension $EXTENSION_NAME with $EXTENSION_TYPE type has been initialized."
