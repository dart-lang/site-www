#!/usr/bin/env bash
#
# Run `dart format` over the examples.

set -e -o pipefail

cd `dirname $0`/..

DARTFORMAT="dart format"
EXAMPLES=examples

# TODO: Remove this comment and down to TODO_END after the new dart cli ships to stable.
DART_VERS=$(dart --version 2>&1 | perl -pe '($_)=/version: (\S+)/')
if [[ $DART_VERS == *beta* ]]; then
  DARTFORMAT="dart format"
elif [[ $DART_VERS == *dev* ]]; then
  DARTFORMAT="dart format"
else # stable
  DARTFORMAT="dartfmt -w"
fi
# TODO_END

# Format all example source files, except the excluded paths:
$DARTFORMAT $* `find $EXAMPLES -name "*.dart" \
    ! -path "**/.*" \
    ! -path "**/build/**"`

$DARTFORMAT -l 60 \
  $EXAMPLES/misc/lib/language_tour/classes/immutable_point.dart \
  $EXAMPLES/misc/lib/language_tour/classes/logger.dart \
  $EXAMPLES/misc/lib/language_tour/classes/no_such_method.dart \
  $EXAMPLES/misc/lib/language_tour/classes/orchestra.dart \
  $EXAMPLES/misc/test/language_tour/built_in_types_test.dart \
  $EXAMPLES/misc/test/language_tour/functions_test.dart \
  $EXAMPLES/misc/test/library_tour/html_test.dart \
  $EXAMPLES/misc/lib/samples/spacecraft.dart

$DARTFORMAT -l 65 \
  $EXAMPLES/httpserver/bin/basic_writer_server.dart \
  $EXAMPLES/httpserver/bin/note_server.dart \
  $EXAMPLES/misc/bin/dcat.dart \
  $EXAMPLES/misc/lib/language_tour/exceptions.dart \
  $EXAMPLES/misc/lib/library_tour/core \
  $EXAMPLES/misc/lib/library_tour/async/future.dart \
  $EXAMPLES/misc/lib/library_tour/async/stream.dart \
  $EXAMPLES/misc/test/library_tour/core_test.dart \
  $EXAMPLES/misc/test/library_tour/io_test.dart \
  $EXAMPLES/misc/lib/effective_dart/style_lib_good.dart \
  $EXAMPLES/misc/lib/effective_dart/usage_good.dart

# If any files were changed, then exit 1:
REFORMATTED_FILES=$(git status --short)
echo
echo $REFORMATTED_FILES
[[ -z $REFORMATTED_FILES ]];
