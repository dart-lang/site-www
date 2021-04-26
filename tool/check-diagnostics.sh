#!/usr/bin/env bash

set +x

dart pub get

dart run diagnostic_update_check.dart
