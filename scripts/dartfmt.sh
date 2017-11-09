#!/usr/bin/env bash
#
# Run dartfmt over the examples.

set -e -o pipefail

DARTFMT="dartfmt -w"
EXAMPLES=examples

# Format all example source files using default settings:
$DARTFMT -w $EXAMPLES

# Re-run dartfmt with custom settings for the few files that need it:
$DARTFMT -l 60 \
  examples/language-tour/color/bin/main.dart \
  examples/language-tour/factory-constructor/bin/main.dart \
  examples/language-tour/mixins/bin/main.dart \
  examples/language-tour/no-such-method/bin/main.dart \
  examples/language-tour/optional-positional-parameter-default/bin/main.dart \
  examples/language-tour/reference/immutable_point.dart \
  examples/language-tour/string-interpolation/bin/main.dart

$DARTFMT -l 62 examples/language-tour/flow/exceptions/web/main.dart

$DARTFMT -l 75 examples/language-tour/flow/break-continue/web/main.dart

# If any files were changed, then exit 1:
[[ -z $(git status --short) ]];
