#!/usr/bin/env bash
# Point out whether submitted files are correctly formatted

set -eu -o pipefail
source $TOOL_DIR/utils.sh


EXAMPLES="$BASE_DIR/examples"

# TODO ignoring these until we decided on a consistent line length 
# that makes sense for code excerpts in docs:
IGNORE_THESE="/misc/"

# Check formatting for all *.dart files in the examples 
# directory and report back any files that need to be fixed. 
function check_formatting() {
  IFS=' '
  read -a files <<< "$@"
  local file_count=${#files[@]}
  printf "\n$(blue "Checking formatting on $file_count files...")\n"
  IFS=$'\n' 
  local results=($(dart format --output=none "$@" | grep -v $IGNORE_THESE))
  local error_count=${#results[@]} # If greater than 1, we have a file error
  if [[ $error_count -gt 1 ]]; then
    unset results[-1] # Remove last line (summary) of format output
    printf "$(red "Found $error_count files that require fixing:")\n\n"
    IFS=' ' 
    for line in "${results[@]}"; do
      read -r _ filepath <<< "$line"
      printf "  $(yellow $filepath)\n"
    done
    printf "\n$(red "Please fix the above files and commit your changes")\n\n";
    exit 1;
  fi
}

dart_files=$(
  find $EXAMPLES -name "*.dart" \
  ! -path "**/.*" \
  ! -path "**/build/**"
)
check_formatting $dart_files

# TODO see above, decide on global max line length for docs so 
# they are correctly formatted fow showing in a web page.
# LEGACY Assuming all dart files have passed, set these ones back to 60/65 char length
printf "\n$(blue "Reformatting line length on language and library tour...")\n"
dart format -l 60 \
  $EXAMPLES/misc/lib/language_tour/classes/immutable_point.dart \
  $EXAMPLES/misc/lib/language_tour/classes/logger.dart \
  $EXAMPLES/misc/lib/language_tour/classes/no_such_method.dart \
  $EXAMPLES/misc/lib/language_tour/classes/orchestra.dart \
  $EXAMPLES/misc/test/language_tour/built_in_types_test.dart \
  $EXAMPLES/misc/test/language_tour/functions_test.dart

dart format -l 65 \
  $EXAMPLES/misc/lib/language_tour/exceptions.dart \
  $EXAMPLES/misc/lib/effective_dart/style_lib_good.dart \
  $EXAMPLES/misc/lib/effective_dart/usage_good.dart \
  $EXAMPLES/misc/lib/library_tour/core \
  $EXAMPLES/misc/lib/library_tour/async/future.dart \
  $EXAMPLES/misc/lib/library_tour/async/stream.dart \
  $EXAMPLES/misc/lib/samples/spacecraft.dart \
  $EXAMPLES/misc/test/library_tour/core_test.dart \
  $EXAMPLES/misc/test/library_tour/io_test.dart
