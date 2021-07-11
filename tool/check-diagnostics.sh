#!/usr/bin/env bash

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

cd $rootDir/tool/

set +x

dart pub get

dart run diagnostic_update_check.dart
