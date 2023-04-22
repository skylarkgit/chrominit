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
    "manifest_version": 3,
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
        jq '.background = { "scripts": ["build/bundle.js"], "persistent": false }' manifest.json > manifest.tmp && mv manifest.tmp manifest.json
        ;;

    content)
        # touch content_script.js
        # echo "Creating content_script.js"

        # Add content_scripts property to manifest.json
        jq '.content_scripts = [ { "matches": ["<all_urls>"], "js": ["build/bundle.js"] } ]' manifest.json > manifest.tmp && mv manifest.tmp manifest.json
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
# Initialize React and TypeScript
if command -v tsc >/dev/null 2>&1 ; then
    echo "Initializing React and TypeScript"
    mkdir -p src/ts
    npm init -y
    # npm install react react-dom @types/react @types/react-dom --save
    # npm install typescript webpack webpack-cli awesome-typescript-loader @babel/plugin-syntax-jsx babel-loader css-loader style-loader --save-dev

    # Add TypeScript configuration
    cat > tsconfig.json <<EOL
{
  "compilerOptions": {
    "target": "es2016",
    "module": "commonjs",
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "skipLibCheck": true,
    "jsx": "react",
    "noImplicitAny": true,
    "outDir": "./build/",
    "preserveConstEnums": true,
    "removeComments": true,
    "sourceMap": true
  },
  "include": [
      "./src/"
  ]
}
EOL

    # Add Webpack configuration
    cat > webpack.config.js <<EOL
const path = require("path")
const appSrc = path.resolve(__dirname, './src')
const entrySrc = path.resolve(__dirname, './src/ts/main.tsx')

module.exports = {
    entry: [
        '@babel/plugin-syntax-jsx',
        entrySrc
    ],
    module: {
        rules: [
            {
                test: /\.(ts|tsx)$/,
                loader: 'awesome-typescript-loader',
                include: [appSrc],
                exclude: /node_modules/
            },
            {
                test: /\.css$/,
                use: ["style-loader", "css-loader"]
            }
        ]
    },
    output: {
        path: path.resolve(__dirname),
        filename: "build/bundle.js"
    },
    resolve: {
        extensions: [".js", ".jsx", ".json", ".ts", ".tsx"],
    },
};
EOL

    # Add npm build command to compile TypeScript files
    jq '.scripts.build = "npx webpack --config webpack.config.js"' package.json > package.tmp && mv package.tmp package.json

    # Add dependencies to package.json
    DEPS='{ "dependencies": { "jsx-dom": "^8.0.1-beta.8" }, "devDependencies": { "@babel/cli": "^7.17.10", "@babel/core": "^7.18.5", "@babel/plugin-transform-react-jsx": "^7.17.12", "@babel/preset-env": "^7.18.2", "@types/node": "^18.0.0", "awesome-typescript-loader": "^5.2.1", "babel-loader": "^8.2.5", "css-loader": "^6.7.1", "html-webpack-plugin": "^5.5.0", "style-loader": "^3.3.1", "typescript": "^4.7.4", "webpack": "^5.73.0", "webpack-cli": "^4.10.0", "webpack-dev-server": "^4.9.2" } }'
    jq ". |= . + $DEPS" package.json > package.tmp && mv package.tmp package.json
    npm install --force
else
    echo "TypeScript is not installed. If you need TypeScript support, install it globally using 'npm install -g typescript'"
fi

echo "Chrome extension $EXTENSION_NAME with $EXTENSION_TYPE type has been initialized."
