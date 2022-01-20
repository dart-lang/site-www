#!/usr/bin/env bash
# Point out whether submitted files are correctly formatted

set -eu -o pipefail
source $TOOL_DIR/utils.sh


EXAMPLES="$BASE_DIR/examples"
FIX=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --fix)
      FIX=1
      shift
      ;;
    -h|--help)    
      echo "Usage: $(basename $0) [--fix]"
      exit 0
      ;;
    *)
      echo "Unsupported argument $1" >&2
      exit 1
      ;;
  esac
done

# Check formatting for all *.dart files in the examples 
# directory and report back any files that need to be fixed. 
function check_formatting() {
  IFS=" "
  read -a files <<< "$@"
  local file_count=${#files[@]}
  printf "\n$(blue "Checking formatting on $file_count files...")\n"

  local output="none"
  if [[ $FIX -eq 1 ]]; then
    output="write"
  fi
  
  IFS=$'\n' 
  local results=($(dart format --output=$output "$@"))
  unset results[-1] # Remove last line (summary) of format output
  local error_count=${#results[@]}
  if [[ $error_count -gt 0 ]]; then
    printf "$(red "Found $error_count files that require(d) fixing:")\n\n"
    IFS=' ' 
    for line in "${results[@]}"; do
      read -r _ filepath <<< "$line"
      printf "  $(yellow $filepath)\n"
    done
    if [[ $FIX -eq 1 ]]; then
      printf "\n$(red "These files have been fixed/written, please verify")\n\n";
    else
      printf "\n$(red "Please fix the above files and commit your changes")\n\n";
    fi
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
