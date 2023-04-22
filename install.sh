#!/bin/bash

INSTALL_DIR="/usr/local/bin"
SCRIPTS_DIR="$INSTALL_DIR/chromex_scripts"

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root or using sudo."
  exit 1
fi

if [ ! -d "$INSTALL_DIR" ]; then
  echo "Error: $INSTALL_DIR does not exist. Please make sure the directory exists and try again."
  exit 1
fi

# Create the chromex_scripts directory
mkdir -p "$SCRIPTS_DIR"

cp chromex "$INSTALL_DIR"
cp init_chrome_extension.sh "$SCRIPTS_DIR"
cp modify_manifest.sh "$SCRIPTS_DIR"
cp toggle_sites.sh "$SCRIPTS_DIR"

chmod +x "$INSTALL_DIR/chromex"
chmod +x "$SCRIPTS_DIR/init_chrome_extension.sh"
chmod +x "$SCRIPTS_DIR/modify_manifest.sh"
chmod +x "$SCRIPTS_DIR/toggle_sites.sh"

echo "chromex and its subscripts have been installed successfully."
