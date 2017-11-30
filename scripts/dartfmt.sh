#!/usr/bin/env bash
#
# Run dartfmt over the examples.

set -e -o pipefail

cd `dirname $0`/..

DARTFMT="dartfmt -w"
EXAMPLES=examples

# Format all example source files under lib and tests
# except for the lib/pi_*.* files
$DARTFMT -w $EXAMPLES/lib/[^p] $EXAMPLES/test

$DARTFMT -l 60 \
  examples/lib/language_tour/classes/immutable_point.dart \
  examples/lib/language_tour/classes/logger.dart \
  examples/lib/language_tour/classes/no_such_method.dart \
  examples/lib/language_tour/classes/orchestra.dart \
  examples/test/language_tour/built_in_types_test.dart \
  examples/test/language_tour/functions_test.dart \
  examples/lib/library_tour/core \
  examples/test/library_tour/html_test.dart

$DARTFMT -l 65 \
  examples/lib/language_tour/exceptions.dart \
  examples/test/library_tour/core_test.dart \
  examples/lib/library_tour/async/future.dart \
  examples/lib/library_tour/async/stream.dart \
  examples/test/library_tour/io_test.dart \
  examples/test/library_tour/mirrors_test.dart

# If any files were changed, then exit 1:
REFORMATTED_FILES=$(git status --short)
echo
echo $REFORMATTED_FILES
[[ -z $REFORMATTED_FILES ]];
