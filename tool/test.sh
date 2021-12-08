#!/usr/bin/env bash
# NOTE adapter from original pre-push.sh, whcich was 
# meant to be used as a full test before pushing code.

set -eou pipefail
source $TOOL_DIR/utils.sh

readonly DIR=$(get_base_dir)


# 
# FORMATTED=$($DIR/dartformat.sh | grep )

# if echo "$FOO" | grep -v Unchanged; then
#   echo ""
#   exit 1;
# fi


# readonly DIR="$(dirname -- $0)"
# echo "${BASH_SOURCE[0]}"

STATUS=0

# NOTE this does not live here - this is not a TEST
# TODO still not sure we need this for anything since it 
# is purely for generating the src/_guides
# pushd deploy/effective-dart-rules && dart pub get && popd

# ./tool/dartformat.sh | grep -v Unchanged && \


# ./tool/refresh-code-excerpts.sh && \
# ./tool/analyze-and-test-examples.sh $* && \
# dart run deploy/effective-dart-rules/bin/main.dart
