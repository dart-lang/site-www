#!/usr/bin/env bash
#
# Run `dart format` over the examples.

set -e -o pipefail

cd `dirname $0`/..

EXAMPLES=examples
DART_VERS=$(dart --version 2>&1 | perl -pe '($_)=/version: (\S+)/')

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help)      echo "Usage: $(basename $0) [--help]"; exit 0;;
    *)              echo "ERROR: Unrecognized option: $1. Use --help for details."; exit 1;;
  esac
done



echo "Formatting example files..."
dart format $* `find $EXAMPLES -name "*.dart" \
    ! -path "**/.*" \
    ! -path "**/build/**"`

dart format -l 60 \
  $EXAMPLES/misc/lib/language_tour/classes/immutable_point.dart \
  $EXAMPLES/misc/lib/language_tour/classes/logger.dart \
  $EXAMPLES/misc/lib/language_tour/classes/no_such_method.dart \
  $EXAMPLES/misc/lib/language_tour/classes/orchestra.dart \
  $EXAMPLES/misc/test/language_tour/built_in_types_test.dart \
  $EXAMPLES/misc/test/language_tour/functions_test.dart

dart format -l 65 \
  $EXAMPLES/misc/lib/language_tour/exceptions.dart \
  $EXAMPLES/misc/lib/effective_dart/style_lib_good.dart \
  $EXAMPLES/misc/lib/effective_dart/usage_good.dart \
  $EXAMPLES/misc/lib/library_tour/core \
  $EXAMPLES/misc/lib/library_tour/async/future.dart \
  $EXAMPLES/misc/lib/library_tour/async/stream.dart \
  $EXAMPLES/misc/lib/samples/spacecraft.dart \
  $EXAMPLES/misc/test/library_tour/core_test.dart \
  $EXAMPLES/misc/test/library_tour/io_test.dart

# If any files were changed, then exit 1:
REFORMATTED_FILES=$(git status --short)
echo
echo $REFORMATTED_FILES
[[ -z $REFORMATTED_FILES ]];
