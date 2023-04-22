#!/bin/bash

valid_properties=("manifest_version" "name" "version" "description" "icons" "permissions" "browser_action" "page_action" "background" "content_scripts" "options_page" "options_ui" "commands" "web_accessible_resources" "storage" "omnibox" "devtools_page" "sidebar_action" "action")

containsElement() {
  local e
  for e in "${@:2}"; do
    [[ "$e" == "$1" ]] && return 0
  done
  return 1
}

validate_value() {
  local property="$1"
  local value="$2"
  
  case "$property" in
    manifest_version|version)
      if [[ ! "$value" =~ ^[1-9][0-9]*$ ]]; then
        echo "Invalid value for $property. Must be an integer greater than 0."
        exit 1
      fi
      ;;
    name|description)
      if [[ -z "$value" ]]; then
        echo "Invalid value for $property. Must be a non-empty string."
        exit 1
      fi
      ;;
  esac
}

ACTION=""
PROPERTY=""
VALUE=""

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    -a|--action)
      ACTION="$2"
      shift
      ;;
    -p|--property)
      PROPERTY="$2"
      shift
      ;;
    -v|--value)
      VALUE="$2"
      shift
      ;;
    *)
      echo "Unknown parameter: $1"
      exit 1
      ;;
  esac
  shift
done

if [ -z "$ACTION" ] || [ -z "$PROPERTY" ]; then
    echo "Usage: $0 --action <action> --property <property> [--value <value>]"
    echo "  <action>     add or remove"
    echo "  <property>   The property to be modified in the manifest.json file"
    echo "  <value>      The new value of the property (required for add action)"
    exit 1
fi

if ! containsElement "$PROPERTY" "${valid_properties[@]}"; then
  echo "Error: Invalid property. Allowed properties are: ${valid_properties[*]}"
  exit 1
fi

if [ "$ACTION" != "add" ] && [ "$ACTION" != "remove" ]; then
  echo "Error: Invalid action. Allowed actions are add and remove."
  exit 1
fi

if [ "$ACTION" == "add" ]; then
  validate_value "$PROPERTY" "$VALUE"
fi

MANIFEST_FILE="./manifest.json"

if [ ! -f "$MANIFEST_FILE" ]; then
    echo "Error: manifest.json not found in the current directory"
    exit 1
fi

case "$ACTION" in
    add)
        if [[ $VALUE =~ ^\" ]]; then
        jq ".${PROPERTY} = ${VALUE}" "$MANIFEST_FILE" > "${MANIFEST_FILE}.tmp"
        else
        jq ".${PROPERTY} = \"${VALUE}\"" "$MANIFEST_FILE" > "${MANIFEST_FILE}.tmp"
        fi
        mv "${MANIFEST_FILE}.tmp" "$MANIFEST_FILE"
        ;;

    remove)
        jq "del(.$PROPERTY)" "$MANIFEST_FILE" > "${MANIFEST_FILE}.tmp" && mv "${MANIFEST_FILE}.tmp" "$MANIFEST_FILE"
        ;;

    *)
        echo "Error: Invalid action. Allowed actions are add and remove."
        exit 1
        ;;
esac

echo "manifest.json has been successfully updated."
