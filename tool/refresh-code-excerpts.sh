#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

function usage() {
  echo $1; echo
  echo "Usage: $(basename $0) [--help] [-k|--keep-dart-tool] [--legacy] [path-to-src-file-or-folder]"
  echo
  exit 1;
}

ARGS=''

while [[ "$1" == -* ]]; do
  case "$1" in
    --log-fine) ARGS+='--log-fine '; shift;;
    -k|--keep-dart-tool) KEEP_CACHE=1; shift;;
    --legacy)   LEGACY=get; shift;;
    -h|--help)  usage;;
  esac
done

[[ -z "$DART_SITE_ENV_DEFS" ]] && . $rootDir/tool/env-set.sh
[[ -z "$DART_SITE_ENV_DEFS" ]] && exit 1; # env-set failed, abort.

TMP="$rootDir/tmp"
FRAG="$TMP/_fragments"

if [[ -e "$FRAG" ]]; then echo Deleting old "$FRAG"; rm -Rf "$FRAG"; fi

if [[ -n "$LEGACY" ]]; then
  npx code-excerpter examples "$FRAG"
else
  ARGS+='--yaml '
  if [[ ! -e "pubspec.lock" ]]; then pub get; fi
  pub run build_runner build --delete-conflicting-outputs --config excerpt --output="$FRAG"
  FRAG+=/examples
fi

[[ -e "$FRAG" ]] || usage "ERROR: fragments folder was not generated: '$FRAG'"

SRC="$1"
: ${SRC:="$rootDir/src"}
[[ -e $SRC ]] || usage "ERROR: source file/folder does not exist: '$SRC'"

ARGS+='--no-escape-ng-interpolation '
# ARGS+='--plaster=none '
ARGS+='--replace='
# The replace expressions that follow must not contain (unencode/unescaped) spaces:
ARGS+='/\/\/!<br>//g;' # Use //!<br> to force a line break (against dartfmt)
ARGS+='/ellipsis(<\w+>)?(\(\))?;?/.../g;' # ellipses; --> ...
ARGS+='/\/\*(\s*\.\.\.\s*)\*\//$1/g;' # /*...*/ --> ...
ARGS+='/\{\/\*-(\s*\.\.\.\s*)-\*\/\}/$1/g;' # {/*-...-*/} --> ... (removed brackets too)
# Replace "//!analysis-issue" by, say, "Analysis issue" (although once we can use embedded DPs this won't be needed)?
ARGS+='/\/\/!(analysis-issue|runtime-error)[^\n]*//g;' # Removed warning/error marker

echo "Source:     $SRC"
echo "Fragments:  $FRAG"
echo "Other args: $ARGS"
echo
LOG_FILE="$TMP/refresh-code-excerpts-log.txt"
pub run code_excerpt_updater \
  --fragment-dir-path "$FRAG" \
  --src-dir-path examples \
  $ARGS \
  --write-in-place \
  "$SRC" 2>&1 | tee $LOG_FILE
LOG=$(cat $LOG_FILE)

if [[ -z "$KEEP_CACHE" ]]; then
  (set -x; rm -r "$rootDir/.dart_tool/")
fi

[[ $LOG == *" 0 out of"* && $LOG != *Error* ]]
