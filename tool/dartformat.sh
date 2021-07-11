#!/usr/bin/env bash
#
# Run `dart format` over the examples.

set -e -o pipefail

cd `dirname $0`/..

EXAMPLES=examples
NULL_SAFETY_EXAMPLES=null_safety_examples
DART_VERS=$(dart --version 2>&1 | perl -pe '($_)=/version: (\S+)/')

while [[ $# -gt 0 ]]; do
  case "$1" in
    --null-safety)  NULL_SAFETY=1; shift;;
    -h|--help)      echo "Usage: $(basename $0) [--null-safety] [--help]"; exit 0;;
    *)              echo "ERROR: Unrecognized option: $1. Use --help for details."; exit 1;;
  esac
done

if [[ $NULL_SAFETY == 1 ]]; then
  echo "Formatting null safety example files..."
  dart format $* `find $NULL_SAFETY_EXAMPLES -name "*.dart" \
      ! -path "**/.*" \
      ! -path "**/build/**"`

  dart format -l 60 \
    $NULL_SAFETY_EXAMPLES/misc/lib/language_tour/classes/immutable_point.dart \
    $NULL_SAFETY_EXAMPLES/misc/lib/language_tour/classes/logger.dart \
    $NULL_SAFETY_EXAMPLES/misc/lib/language_tour/classes/no_such_method.dart \
    $NULL_SAFETY_EXAMPLES/misc/lib/language_tour/classes/orchestra.dart \
    $NULL_SAFETY_EXAMPLES/misc/test/language_tour/built_in_types_test.dart \
    $NULL_SAFETY_EXAMPLES/misc/test/language_tour/functions_test.dart \
    # $NULL_SAFETY_EXAMPLES/misc/test/library_tour/html_test.dart
    # $NULL_SAFETY_EXAMPLES/misc/lib/samples/spacecraft.dart

  dart format -l 65 \
    $NULL_SAFETY_EXAMPLES/misc/lib/language_tour/exceptions.dart \
    $NULL_SAFETY_EXAMPLES/misc/lib/effective_dart/style_lib_good.dart \
    $NULL_SAFETY_EXAMPLES/misc/lib/effective_dart/usage_good.dart \
    $NULL_SAFETY_EXAMPLES/misc/lib/library_tour/core \
    $NULL_SAFETY_EXAMPLES/misc/lib/library_tour/async/future.dart \
    $NULL_SAFETY_EXAMPLES/misc/lib/library_tour/async/stream.dart \
    $NULL_SAFETY_EXAMPLES/misc/test/library_tour/core_test.dart \
    $NULL_SAFETY_EXAMPLES/misc/test/library_tour/io_test.dart
    # $NULL_SAFETY_EXAMPLES/httpserver/bin/basic_writer_server.dart \
    # $NULL_SAFETY_EXAMPLES/httpserver/bin/note_server.dart \
    # $NULL_SAFETY_EXAMPLES/misc/bin/dcat.dart \
else
  echo "Formatting example files..."
  dart format $* `find $EXAMPLES -name "*.dart" \
      ! -path "**/.*" \
      ! -path "**/build/**"`

  dart format -l 60 \
    $EXAMPLES/misc/test/library_tour/html_test.dart \

  dart format -l 65 \
    $EXAMPLES/httpserver/bin/basic_writer_server.dart \
    $EXAMPLES/httpserver/bin/note_server.dart \
    $EXAMPLES/misc/bin/dcat.dart \
    $EXAMPLES/misc/lib/library_tour/core \
    $EXAMPLES/misc/lib/library_tour/async/future.dart \
    $EXAMPLES/misc/lib/library_tour/async/stream.dart \
    $EXAMPLES/misc/test/library_tour/core_test.dart \
    $EXAMPLES/misc/test/library_tour/io_test.dart
fi

# If any files were changed, then exit 1:
REFORMATTED_FILES=$(git status --short)
echo
echo $REFORMATTED_FILES
[[ -z $REFORMATTED_FILES ]];
