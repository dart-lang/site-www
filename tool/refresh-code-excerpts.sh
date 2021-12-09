#!/usr/bin/env bash
# Refresh all code excerpts

set -eou pipefail
source $TOOL_DIR/utils.sh

function usage() {
  printf "$1\n\n"
  echo "Usage: $(basename $0) [--help] [-k|--keep-dart-tool] [path-to-src-file-or-folder]"
  exit 1;
}


REFRESH_ARGS=""

while [[ "$1" == -* ]]; do
  case "$1" in
    --log-fine)           REFRESH_ARGS+="--log-fine "; shift;;
    -k|--keep-dart-tool)  KEEP_CACHE=1; shift;;
    -h|--help)            usage; exit;;
  esac
done

TARGET_SRC="${1:-$BASE_DIR/src}"
TMP="$BASE_DIR/tmp"
LOG_FILE="$TMP/refresh-code-excerpts.log"

if [[ ! -e "pubspec.lock" ]]; then 
  dart pub get
fi

# Build runner
FRAG="$TMP/_fragments"
if [[ -e "$FRAG" ]]; then 
  echo "Deleting old $FRAG..."
  rm -rf "$FRAG"
fi

dart run build_runner build \
  --delete-conflicting-outputs \
  --config excerpt \
  --output="$FRAG"

if [[ ! -e "$FRAG/examples" ]]; then
  printf "ERROR: examples fragments folder was not generated: '$FRAG/examples'"
fi

# NOTE assuming positional
SRC="$1"
: ${SRC:="$BASE_DIR/src"}
if [[ -e $SRC ]]; then
  echo  || usage "ERROR: source file/folder does not exist: '$SRC'"


ARGS+='--yaml '
ARGS+='--no-escape-ng-interpolation '
ARGS+='--replace='

# The replace expressions that follow must not contain (unencode/unescaped) spaces:
ARGS+='/\/\/!<br>//g;' # Use //!<br> to force a line break (against dart format)
ARGS+='/ellipsis(<\w+>)?(\(\))?;?/.../g;' # ellipses; --> ...
ARGS+='/\/\*(\s*\.\.\.\s*)\*\//$1/g;' # /*...*/ --> ...
ARGS+='/\{\/\*-(\s*\.\.\.\s*)-\*\/\}/$1/g;' # {/*-...-*/} --> ... (removed brackets too)

# Replace "//!analysis-issue" by, say, "Analysis issue" (although 
# once we can use embedded DPs this won't be needed)?
ARGS+='/\/\/!(analysis-issue|runtime-error)[^\n]*//g;' # Removed warning/error marker

printf "\n$(blue "
Running excerpt refresh..."
Source:     $TARGET_SRC
Fragments:  $FRAG/examples
Other args: $REFRESH_ARGS"
")\n"

# For reference this lives in:
./site-shared/packages/code_excerpt_updater
dart run code_excerpt_updater \
  --fragment-dir-path "$FRAG/examples" \
  --src-dir-path examples \
  --write-in-place \
  "$REFRESH_ARGS" \
  "$TARGET_SRC" 2>&1 | tee $LOG_FILE

if [[ -z "$KEEP_CACHE" ]]; then
  echo "Removing dart cache files..."
  rm -r "$BASE_DIR/.dart_tool/"
fi

# NOTE if this is the only use of the file, then we can achieve
# this in a different way than reading errors from it.
LOGS=$(cat $LOG_FILE)
if [[ $LOGS != *" 0 out of"* || $LOGS == *Error* ]]; then
  printf "\n$(red "Errors were encountered refrshing code excerpts")\n"
  exit 1
fi
