#!/bin/bash

print_help() {
  echo "Usage: $0 --action <action> --site <site>"
  echo "  <action>  The action to perform: enable or disable"
  echo "  <site>    The site URL pattern to enable or disable the extension on (e.g., https://*.example.com/*)"
}

if [ "$#" -ne 4 ]; then
  print_help
  exit 1
fi

ACTION="$2"
SITE="$4"
MANIFEST_FILE="manifest.json"

if [ ! -f "$MANIFEST_FILE" ]; then
  echo "Error: $MANIFEST_FILE not found in the current directory. Please run this script from the extension's root directory."
  exit 1
fi

case "$ACTION" in
  enable)
    # Check if the site is already enabled, if not add it to the content_scripts matches
    SITE_EXISTS=$(jq ".content_scripts[0].matches | index(\"$SITE\")" "$MANIFEST_FILE")
    if [ "$SITE_EXISTS" = "null" ]; then
      jq ".content_scripts[0].matches += [\"$SITE\"]" "$MANIFEST_FILE" > "${MANIFEST_FILE}.tmp" && mv "${MANIFEST_FILE}.tmp" "$MANIFEST_FILE"
      echo "Enabled the extension on $SITE."
    else
      echo "The extension is already enabled on $SITE."
    fi
    ;;
    
  disable)
    # Check if the site is enabled, if it is, remove it from the content_scripts matches
    SITE_INDEX=$(jq ".content_scripts[0].matches | index(\"$SITE\")" "$MANIFEST_FILE")
    if [ "$SITE_INDEX" != "null" ]; then
      jq ".content_scripts[0].matches |= .[:${SITE_INDEX}] + .[${SITE_INDEX}+1:]" "$MANIFEST_FILE" > "${MANIFEST_FILE}.tmp" && mv "${MANIFEST_FILE}.tmp" "$MANIFEST_FILE"
      echo "Disabled the extension on $SITE."
    else
      echo "The extension is already disabled on $SITE."
    fi
    ;;

  *)
    echo "Error: Invalid action. Allowed actions are enable and disable."
    exit 1
    ;;
esac
