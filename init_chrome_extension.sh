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

EXTENSION_NAME=$1
EXTENSION_TYPE=$2

# Create extension directory and files
mkdir -p "$EXTENSION_NAME"
cd "$EXTENSION_NAME"

# Create manifest.json
cat <<EOT > manifest.json
{
  "manifest_version": 2,
  "name": "${EXTENSION_NAME}",
  "version": "1.0",
  "description": "A simple ${EXTENSION_TYPE} extension",
  "permissions": []
EOT

# Add type-specific configuration to manifest.json
case $EXTENSION_TYPE in
    popup)
        cat <<EOT >> manifest.json
  ,
  "browser_action": {
    "default_icon": "icon.png",
    "default_popup": "popup.html"
  }
}
EOT
        # Create popup.html
        echo '<!DOCTYPE html><html><head><title>'"${EXTENSION_NAME}"'</title></head><body><h1>'"${EXTENSION_NAME}"' Popup</h1></body></html>' > popup.html
        ;;

    background)
        cat <<EOT >> manifest.json
  ,
  "background": {
    "scripts": ["background.js"],
    "persistent": false
  }
}
EOT
        # Create background.js
        echo 'console.log("Background script for '"${EXTENSION_NAME}"' extension loaded");' > background.js
        ;;

    content)
        cat <<EOT >> manifest.json
  ,
  "content_scripts": [
    {
      "matches": ["*://*/*"],
      "js": ["content.js"]
    }
  ]
}
EOT
        # Create content.js
        echo 'console.log("Content script for '"${EXTENSION_NAME}"' extension loaded");' > content.js
        ;;

    *)
        echo "Error: Invalid extension type"
        echo ""
        display_help
        rm -rf "$EXTENSION_NAME"
        exit 1
        ;;
esac

echo "Chrome extension project ${EXTENSION_NAME} with ${EXTENSION_TYPE} type initialized successfully."
