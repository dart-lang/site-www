#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

function usage() {
  echo $1; echo
  echo "Usage: $(basename $0) [path-to-src-file-or-folder]"; echo
  exit 1;
}

if [[ $1 == '-h' || $1 == '--help' ]]; then usage; fi

[[ -z "$NGIO_ENV_DEFS" ]] && . $rootDir/scripts/env-set.sh

ARGS='--no-escape-ng-interpolation'

SRC="$1"
: ${SRC:="$rootDir/src"}
[[ -e $SRC ]] || usage "ERROR: source file/folder does not exist: '$SRC'"

FRAG="$rootDir/tmp/_fragments$API"
[[ -e $FRAG ]] || usage "ERROR: fragments folder does not exist: '$FRAG'"

echo "Source:     $SRC"
echo "Fragments:  $FRAG"
echo "Other args: $ARGS"
echo
LOG_FILE=$TMP/refresh-code-excerpts-log.txt
pub global run code_excerpt_updater \
  --fragment-dir-path "$FRAG" \
  --src-dir-path examples \
  $ARGS \
  --write-in-place \
  "$SRC" 2>&1 | tee $LOG_FILE
LOG=$(cat $LOG_FILE)

[[ $LOG == *" 0 out of"* && $LOG != *Error* ]]
