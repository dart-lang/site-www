#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

function usage() {
  echo $1; echo
  echo "Usage: $(basename $0) [path-to-src-file-or-folder]"; echo
  exit 1;
}

if [[ $1 == '-h' || $1 == '--help' ]]; then usage; fi

[[ -z "$DART_SITE_ENV_DEFS" ]] && . $rootDir/scripts/env-set.sh

SRC="$1"
: ${SRC:="$rootDir/src"}
[[ -e $SRC ]] || usage "ERROR: source file/folder does not exist: '$SRC'"

FRAG="$rootDir/tmp/_fragments"

if [[ -e $FRAG ]]; then rm -Rf "$FRAG"; echo removing old frag; fi

$(npm bin)/code-excerpter examples "$FRAG"

[[ -e $FRAG ]] || usage "ERROR: fragments folder does not exist: '$FRAG'"

ARGS='--no-escape-ng-interpolation '
ARGS+='--replace='
# The replace expressions that follow must not contain (unencode/unescaped) spaces:
ARGS+='/\/\/!<br>//g;' # Use //!<br> to force a line break (against dartfmt)
ARGS+='/ellipsis(<\w+>)?(\(\))?;?/.../g;' # ellipses; --> ...
ARGS+='/\/\*(\s*\.\.\.\s*)\*\//$1/g;' # /*...*/ --> ...
ARGS+='/\{\/\*-(\s*\.\.\.\s*)-\*\/\}/$1/g;' # {/*-...-*/} --> ... (removed brackets too)
# Replace "//!analysis-issue" by, say, "Analysis issue" (although once we can use embedded DPs this won't be needed0)?
ARGS+='/\/\/!(analysis-issue|runtime-error)[^\n]*//g;' # Removed warning/error marker
ARGS+='/\x20*\/\/\s+ignore_for_file:[^\n]+\n//g;' # Remove warning/error marker

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
