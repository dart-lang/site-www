#!/usr/bin/env bash
#
# Run dartfmt over the examples.

set -e -o pipefail

cd `dirname $0`/..

DARTFMT="dartfmt -w"
EXAMPLES=examples/tours

# Format all example source files under lib and tests
# except for the lib/pi_*.* files
$DARTFMT -w $EXAMPLES/lib/{*_tour,util} $EXAMPLES/test

$DARTFMT -l 60 \
  $EXAMPLES/lib/language_tour/classes/immutable_point.dart \
  $EXAMPLES/lib/language_tour/classes/logger.dart \
  $EXAMPLES/lib/language_tour/classes/no_such_method.dart \
  $EXAMPLES/lib/language_tour/classes/orchestra.dart \
  $EXAMPLES/test/language_tour/built_in_types_test.dart \
  $EXAMPLES/test/language_tour/functions_test.dart \
  $EXAMPLES/lib/library_tour/core \
  $EXAMPLES/test/library_tour/html_test.dart

$DARTFMT -l 65 \
  $EXAMPLES/lib/language_tour/exceptions.dart \
  $EXAMPLES/test/library_tour/core_test.dart \
  $EXAMPLES/lib/library_tour/async/future.dart \
  $EXAMPLES/lib/library_tour/async/stream.dart \
  $EXAMPLES/test/library_tour/io_test.dart \
  $EXAMPLES/test/library_tour/mirrors_test.dart

# If any files were changed, then exit 1:
REFORMATTED_FILES=$(git status --short)
echo
echo $REFORMATTED_FILES
[[ -z $REFORMATTED_FILES ]];
