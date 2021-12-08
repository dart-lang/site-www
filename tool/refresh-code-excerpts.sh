#!/usr/bin/env bash
# Refresh all code excerpts

set -eou pipefail

function usage() {
  echo $1; echo
  echo "Usage: $(basename $0) [--help] [-k|--keep-dart-tool] [path-to-src-file-or-folder]"
  echo
  exit 1;
}

ARGS=""

while [[ "$1" == -* ]]; do
  case "$1" in
    --log-fine)           ARGS+="--log-fine "; shift;;
    -k|--keep-dart-tool)  KEEP_CACHE=1; shift;;
    -h|--help)            usage;;
  esac
done

TMP="$BASE_DIR/tmp"
FRAG="$TMP/_fragments"
LOG_FILE="$TMP/refresh-code-excerpts.log"

if [[ -e "$FRAG" ]]; then 
  echo "Deleting old $FRAG..."
  rm -rf "$FRAG"
fi

ARGS+='--yaml '
if [[ ! -e "pubspec.lock" ]]; then 
  dart pub get
fi

dart run build_runner build --delete-conflicting-outputs --config excerpt --output="$FRAG"

if [[ ! -e "$FRAG/examples" ]]; then
  usage "ERROR: examples fragments folder was not generated: '$FRAG/examples'"
fi

SRC="$1"
: ${SRC:="$BASE_DIR/src"}
[[ -e $SRC ]] || usage "ERROR: source file/folder does not exist: '$SRC'"

ARGS+='--no-escape-ng-interpolation '
ARGS+='--replace='
# The replace expressions that follow must not contain (unencode/unescaped) spaces:
ARGS+='/\/\/!<br>//g;' # Use //!<br> to force a line break (against dart format)
ARGS+='/ellipsis(<\w+>)?(\(\))?;?/.../g;' # ellipses; --> ...
ARGS+='/\/\*(\s*\.\.\.\s*)\*\//$1/g;' # /*...*/ --> ...
ARGS+='/\{\/\*-(\s*\.\.\.\s*)-\*\/\}/$1/g;' # {/*-...-*/} --> ... (removed brackets too)
# Replace "//!analysis-issue" by, say, "Analysis issue" (although once we can use embedded DPs this won't be needed)?
ARGS+='/\/\/!(analysis-issue|runtime-error)[^\n]*//g;' # Removed warning/error marker

echo "Source:     $SRC"
echo "Fragments:  $FRAG/examples"
echo "Other args: $ARGS"
echo

dart run code_excerpt_updater \
  --fragment-dir-path "$FRAG/examples" \
  --src-dir-path examples \
  $ARGS \
  --write-in-place \
  "$SRC" 2>&1 | tee $LOG_FILE
LOG=$(cat $LOG_FILE)

if [[ -z "$KEEP_CACHE" ]]; then
  echo "Removing dart cache files..."
  (set -x; rm -r "$BASE_DIR/.dart_tool/")
fi

[[ $LOG == *" 0 out of"* && $LOG != *Error* ]]
