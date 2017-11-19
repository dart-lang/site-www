#!/usr/bin/env bash
#
# Run dartfmt over the examples.

set -e -o pipefail

cd `dirname $0`/..

DARTFMT="dartfmt -w"
EXAMPLES=examples

# Format all example source files using default settings:
$DARTFMT -w $EXAMPLES

# Re-run dartfmt with custom settings for the few files that need it:
$DARTFMT -l 60 \
  examples/language_tour/color/bin/main.dart \
  examples/language_tour/factory-constructor/bin/main.dart \
  examples/language_tour/mixins/bin/main.dart \
  examples/language_tour/no-such-method/bin/main.dart \
  examples/language_tour/optional-positional-parameter-default/bin/main.dart \
  examples/language_tour/reference/immutable_point.dart \
  examples/language_tour/string-interpolation/bin/main.dart

$DARTFMT -l 62 examples/language_tour/flow/exceptions/web/main.dart

$DARTFMT -l 75 examples/language_tour/flow/break-continue/web/main.dart

# New code

$DARTFMT -l 60 \
  examples/lib/language_tour/classes/immutable_point.dart \
  examples/lib/language_tour/classes/logger_with_main.dart \
  examples/lib/language_tour/classes/no_such_method.dart \
  examples/lib/language_tour/classes/orchestra.dart \
  examples/test/language_tour/built_in_types_test.dart \
  examples/test/language_tour/functions_test.dart \
  examples/lib/library_tour/core

$DARTFMT -l 65 \
  examples/lib/language_tour/exceptions.dart \
  examples/test/library_tour/core_test.dart \
  examples/lib/library_tour/async/future.dart \
  examples/lib/library_tour/async/stream.dart

# If any files were changed, then exit 1:
REFORMATTED_FILES=$(git status --short)
echo
echo $REFORMATTED_FILES
[[ -z $REFORMATTED_FILES ]];
