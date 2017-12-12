#!/usr/bin/env bash
#
# Run dartfmt over the examples.

set -e -o pipefail

cd `dirname $0`/..

DARTFMT="dartfmt -w"
EXAMPLES=examples

# Format all example source files under lib and tests
# except for the lib/pi_*.* files
$DARTFMT -w `find $EXAMPLES -name "*.dart" ! -path "**/.*" ! -path "**/tours/lib/pi_*"`

$DARTFMT -l 60 \
  $EXAMPLES/tours/lib/language_tour/classes/immutable_point.dart \
  $EXAMPLES/tours/lib/language_tour/classes/logger.dart \
  $EXAMPLES/tours/lib/language_tour/classes/no_such_method.dart \
  $EXAMPLES/tours/lib/language_tour/classes/orchestra.dart \
  $EXAMPLES/tours/test/language_tour/built_in_types_test.dart \
  $EXAMPLES/tours/test/language_tour/functions_test.dart \
  $EXAMPLES/tours/lib/library_tour/core \
  $EXAMPLES/tours/test/library_tour/html_test.dart \
  $EXAMPLES/tours/lib/samples/spacecraft.dart

$DARTFMT -l 65 \
  $EXAMPLES/tours/lib/language_tour/exceptions.dart \
  $EXAMPLES/tours/test/library_tour/core_test.dart \
  $EXAMPLES/tours/lib/library_tour/async/future.dart \
  $EXAMPLES/tours/lib/library_tour/async/stream.dart \
  $EXAMPLES/tours/test/library_tour/io_test.dart \
  $EXAMPLES/tours/test/library_tour/mirrors_test.dart \
  $EXAMPLES/httpserver/bin/basic_writer_server.dart \
  $EXAMPLES/httpserver/bin/note_server.dart

# If any files were changed, then exit 1:
REFORMATTED_FILES=$(git status --short)
echo
echo $REFORMATTED_FILES
[[ -z $REFORMATTED_FILES ]];
