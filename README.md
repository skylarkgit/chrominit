# Chromex Tool
This command-line tool streamlines Chrome extension project initialization, supporting popup, background, and content extensions. It auto-generates a manifest file, extension-specific files, and directory structure, allowing users to dive into development immediately. The tool also offers a help option, and an installation script for global access. It also simplifies the process of creating and modifying the manifest.json file for Chrome extensions. It allows you to add or remove manifest properties quickly without manually editing the JSON file.

## Prerequisites

- [jq](https://stedolan.github.io/jq/) command-line JSON processor

  Install jq using a package manager:

  - For Ubuntu/Debian: `sudo apt-get install jq`
  - For CentOS/RHEL: `sudo yum install jq`
  - For macOS: `brew install jq`

## Usage

### Creating a new Chrome extension

Use the `init_chrome_extension.sh` script to create a new Chrome extension project:

```bash
./init_chrome_extension.sh <extension_name> <extension_type>
```

- `<extension_name>`: The desired name of your Chrome extension.
- `<extension_type>`: The type of extension (popup, background, or content).

This will generate the required files and structure for the specified extension type.

### Modifying the manifest.json file

Use the `modify_manifest.sh` script to add or remove properties in the manifest.json file:

```bash
./modify_manifest.sh --action <action> --property <property> [--value <value>]
```

- `<action>`: The action to perform on the property (add or remove).
- `<property>`: The property to be modified in the manifest.json file.
- `<value>`: The new value of the property (required for the add action).

The script validates the property and value (if applicable) before making any changes.

## Properties

Here is a brief description of some common manifest properties and when to use them:

- `manifest_version`: Specifies the version of the manifest file format. It must be set to 2.
- `name`: The name of your Chrome extension.
- `version`: The version number of your Chrome extension.
- `description`: A brief description of your Chrome extension.
- `icons`: A set of icons representing your Chrome extension.
- `permissions`: The permissions required by your Chrome extension.
- `browser_action`: Defines a browser action (e.g., a toolbar button) for your extension.
- `page_action`: Defines a page action (e.g., an icon in the address bar) for your extension.
- `background`: Specifies background scripts for your extension.
- `content_scripts`: Injects scripts into web pages that match specified patterns.
- `options_page`: Specifies a legacy options page for your extension.
- `options_ui`: Specifies a modern options page with a consistent look and feel.
- `commands`: Defines keyboard shortcuts for your extension.
- `web_accessible_resources`: Lists resources accessible to web pages.
- `storage`: Allows your extension to store data using the `chrome.storage` API.
- `omnibox`: Provides a search box in the address bar for your extension.
- `devtools_page`: Extends the Chrome Developer Tools for your extension.
- `sidebar_action`: Defines a sidebar action for your extension (only available in Firefox).
- `action`: Defines a unified toolbar button for your extension (only available in Firefox).

For more information on manifest properties and their usage, refer to the [Chrome extension manifest documentation](https://developer.chrome.com/docs/extensions/mv3/manifest/).