#!/usr/bin/env bash
# Refresh all code excerpts

set -eu -o pipefail
source $TOOL_DIR/utils.sh


EXAMPLES="$BASE_DIR/examples"
TMP="$BASE_DIR/tmp"
FRAG="$TMP/_fragments"
LOG_FILE="$TMP/refresh-code-excerpts.log"
KEEP_CACHE=0
ARGS=""

# Check only -|-- flags/args, save final optional positional (target source)
while [[ $# -gt 0 ]]; do
  case "$1" in
    -k|--keep-dart-tool)
      KEEP_CACHE=1
      shift
      ;;
    --log-fine)
      ARGS+="--log-fine "
      shift
      ;;
    -h|--help)    
      echo "Usage: $(basename $0) [-h|--help] [-k|--keep-dart-tool] [target-source]"
      exit
      ;;
    *)
      echo "Unsupported argument $1" >&2
      exit 1
      ;;
  esac
done

printf "\n$(blue "Preparing excerpt refresh...")\n"

# Final arg, if any, should be target or default to main /src
TARGET_SRC="${1:-$BASE_DIR/src}"

if [[ ! -e $TARGET_SRC ]]; then
  echo -e "$(red "Target source ($TARGET_SRC) does not exist")"
  exit 1
fi

if [[ -e "$FRAG" ]]; then
  echo -e "$(blue "Deleting existing fragments ($FRAG)")"
  rm -rf $FRAG
fi

if [[ ! -e "pubspec.lock" ]]; then 
  dart pub get
fi

( set -x
  dart run build_runner build \
    --delete-conflicting-outputs \
    --config excerpt \
    --output $FRAG)

if [[ ! -e "$FRAG/examples" ]]; then
  echo -e "$(red "Fragments directory ($FRAG/examples) was not generated")"
  exit 1
fi

ARGS+="--yaml --no-escape-ng-interpolation --write-in-place "
ARGS+="--fragment-dir-path=$FRAG/examples "
ARGS+="--src-dir-path=$EXAMPLES "
ARGS+="--replace="

# The replace expressions that follow must not contain (unencode/unescaped) spaces:
ARGS+='/\/\/!<br>//g;' # Use //!<br> to force a line break (against dart format)
ARGS+='/ellipsis(<\w+>)?(\(\))?;?/.../g;' # ellipses; --> ...
ARGS+='/\/\*(\s*\.\.\.\s*)\*\//$1/g;' # /*...*/ --> ...
ARGS+='/\{\/\*-(\s*\.\.\.\s*)-\*\/\}/$1/g;' # {/*-...-*/} --> ... (removed brackets too)

# Replace "//!analysis-issue" by, say, "Analysis issue" (although 
# once we can use embedded DPs this won't be needed)?
ARGS+="/\/\/!(analysis-issue|runtime-error)[^\n]*//g;" # Removed warning/error marker

printf "\n$(blue "Running excerpt refresh...")\n"
IFS=' '; read -a debug_args <<< $ARGS
for arg in "${debug_args[@]}" ; do
  echo -e "  $(yellow $arg)"
done
echo "--"

# Script lives in: site-shared/packages/code_excerpt_updater
dart run code_excerpt_updater $ARGS $TARGET_SRC 2>&1 | tee $LOG_FILE
  
if [[ -z "$KEEP_CACHE" ]]; then
  echo -e "$(blue "Removing dart cache files...")"
  rm -r "$BASE_DIR/.dart_tool/"
fi

if [[ ! -f $LOG_FILE ]]; then
  printf "\n$(red "Log file ($LOG_FILE) does not exist - something went wrong")\n\n"
fi

LOGS=$(cat $LOG_FILE)
if [[ $LOGS != *" 0 out of"* || $LOGS == *Error* ]]; then
  printf "\n$(red "Errors were encountered refreshing code excerpts")\n\n"
  exit 1
else
  printf "\n$(blue "Looking good!")\n\n"
fi
