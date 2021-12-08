#!/usr/bin/env bash

set -eou pipefail
source $TOOL_DIR/utils.sh

# Validate formatting in files
$TOOL_DIR/format-examples.sh

printf "\n$(blue "+ Refreshing code excerpts...")"
(
  set -x
  $TOL_DIR/refresh-code-excerpts.sh --keep-dart-tool
) || (
  printf "\n$(red "+ Some code excerpts need to be refreshed")"
  exit 1
)
