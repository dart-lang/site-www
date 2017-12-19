#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

function runWebdevGulp() {
  pushd $rootDir > /dev/null
  # Until site-www has its own shredder, use the one from site-webdev
  if [[ -d $WEBDEV_REPO ]]; then
    cd $WEBDEV_REPO;
    gulp create-www-fragments;
  else
    echo "ERROR: you cannot run this script without $WEBDEV_REPO.";
    echo "See the README for setup instructions.";
    exit 1;
  fi
  popd > /dev/null
}

function usage() {
  echo $1; echo
  echo "Usage: $(basename $0) [path-to-src-file-or-folder]"; echo
  exit 1;
}

if [[ $1 == '-h' || $1 == '--help' ]]; then usage; fi

[[ -z "$NGIO_ENV_DEFS" ]] && . $rootDir/scripts/env-set.sh

runWebdevGulp;

ARGS='--no-escape-ng-interpolation '
ARGS+='--replace='
ARGS+='/\/\/!<br>//g;' # Use //!<br> to force a line break (against dartfmt)
ARGS+='/ellipsis;?/.../g;' # ellipses; --> ...
ARGS+='/\/\*(\s*\.\.\.\s*)\*\//$1/g;' # /*...*/ --> ...
ARGS+='/\{\/\*-(\s*\.\.\.\s*)-\*\/\}/$1/g;' # {/*-...-*/} --> ... (removed brackets too)

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
