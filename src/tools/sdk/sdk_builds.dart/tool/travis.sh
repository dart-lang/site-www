#!/bin/bash

# Copyright (c) 2015, the Dart project authors. Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Fast fail the script on failures.
set -e

# Verify that the libraries are error and warning-free.
echo "Running dartanalyzer..."
dartanalyzer $DARTANALYZER_FLAGS \
  lib/sdk_builds.dart

# Run the tests.
echo "Running tests..."
pub run test

# Install dart_coveralls; gather and send coverage data.
if [ "$COVERALLS_TOKEN" ] && [ "$TRAVIS_DART_VERSION" = "stable" ]; then
  echo "Running coverage..."
  pub global activate dart_coveralls
  pub global run dart_coveralls report \
    --exclude-test-files \
    --debug \
    test/sdk_builds_test.dart
fi
