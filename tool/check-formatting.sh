#!/usr/bin/env bash
# Point out whether submitted files are correctly formatted

set -eu -o pipefail
source $TOOL_DIR/utils.sh


EXAMPLES="$BASE_DIR/examples"

# Check formatting for all *.dart files in the examples 
# directory and report back any files that need to be fixed. 
function check_formatting() {
  IFS=" "
  read -a files <<< "$@"
  local file_count=${#files[@]}
  printf "\n$(blue "Checking formatting on $file_count files...")\n"
  IFS=$'\n' 
  local results=($(dart format --output=none "$@"))
  unset results[-1] # Remove last line (summary) of format output
  local error_count=${#results[@]}
  if [[ $error_count -gt 0 ]]; then
    printf "$(red "Found $error_count files that require fixing:")\n\n"
    IFS=' ' 
    for line in "${results[@]}"; do
      read -r _ filepath <<< "$line"
      printf "  $(yellow $filepath)\n"
    done
    printf "\n$(red "Please fix the above files and commit your changes")\n\n";
    exit 1;
  else
    printf "$(blue "0 files required formatting")\n\n"
  fi
}

dart_files=$(
  find $EXAMPLES -name "*.dart" \
  ! -path "**/.*" \
  ! -path "**/build/**"
)
check_formatting $dart_files
