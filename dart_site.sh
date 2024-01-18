#!/bin/bash

set -e

REPO_DIR=$(dirname $(dirname $BASH_SOURCE))

# Run dart pub get if the packages file doesn't exist yet.
if [[ ! -f "$REPO_DIR.dart_tool/package_config.json" ]]; then
  dart pub get
fi

# Run the dart_site tool and pass all arguments to it.
dart run dart_site "$@"
