#!/bin/bash

INSTALL_DIR="/usr/local/bin"

if [ "$(id -u)" -ne 0 ]; then
  echo "Error: This script must be run as root or using sudo."
  exit 1
fi

if [ ! -d "$INSTALL_DIR" ]; then
  echo "Error: $INSTALL_DIR does not exist. Please make sure the directory exists and try again."
  exit 1
fi

cp chromex "$INSTALL_DIR"
cp init_chrome_extension.sh "$INSTALL_DIR"
cp modify_manifest.sh "$INSTALL_DIR"

chmod +x "$INSTALL_DIR/chromex"
chmod +x "$INSTALL_DIR/init_chrome_extension.sh"
chmod +x "$INSTALL_DIR/modify_manifest.sh"

echo "chromex and its subscripts have been installed successfully."
