#!/usr/bin/env bash
# Local development tool for checking formatting issues 
# then refreshing code, with cache.

set -eu -o pipefail
source $TOOL_DIR/utils.sh

# Validate formatting in files. This will exit if there are 
# any formatting fixes required in the examples directory.
$TOOL_DIR/check-formatting.sh

printf "\n$(blue "Refreshing code excerpts...")"
( set -x
  $TOOL_DIR/refresh-code-excerpts.sh --keep-dart-tool
) || (
  printf "\n$(red "+ Some code excerpts need to be refreshed")\n"
  exit 1
)
