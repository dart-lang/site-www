#!/usr/bin/env bash
# Analyze dart files
# Final exit code reflects whether errors were encountered during tests
# Ignore script errors, so don't exit on errors/pipefail
set -u
source $TOOL_DIR/utils.sh


export PUB_ALLOW_PRERELEASE_SDK=quiet

DART_VERSION=$(dart --version | perl -pe '($_)=/version: (\S+)/')
DART_CHANNEL=${DART_CHANNEL:-stable}
TMP=$BASE_DIR/tmp
EXAMPLES=$BASE_DIR/examples
PUB_ARG="upgrade"
LOG_FILE="$TMP/analyzer-output.txt"
EXIT_STATUS=0
SAVE_LOGS=0
QUICK=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --get)
      PUB_ARG="get"
      shift
      ;;
    --quick)
      QUICK=1
      shift
      ;;
    --save-logs)  
      SAVE_LOGS=1
      shift
      ;;
    --tmp)
      TMP=$2
      shift 2
      ;;
    -h|--help)    
      echo "Usage: $(basename $0) [--get] [--quick] [--save-logs] [--help]"
      exit 0
      ;;
    *)
      echo "Unsupported argument $1" >&2
      exit 1
      ;;
  esac
done

# Toggle analyzer comments in file via find/replace
# Usage: toggle_in_file_analyzer_flags [disable|reenable] [path]
function toggle_in_file_analyzer_flags() {
  local action="$1"
  local dir="$2"
  local mark="!"
  local toggle=" "
  if [[ $action == 'disable' ]]; then
    mark=" "
    toggle="!"
  fi
  printf "\n$(blue "Toggling in-file flags: '$action'")\n"
  find $dir -name "*.dart" ! -path "**/.*" -exec perl \
    -i -pe "s{//$mark(ignore(_for_file)?: .*?\b(stable|beta|dev)\b)}{//$toggle\$dir}g" {} \;
}

# Analyze and test code for arg $1
# Usage: analyze_and_test /path/to/dir
function analyze_and_test() {
  local project_dir="$1"

  printf "\n$(blue "--\nProcessing $project_dir...")\n"
  pushd $project_dir > /dev/null

  dart pub $PUB_ARG

  EXPECTED_FILE="$project_dir/analyzer-results-$DART_CHANNEL.txt"
  if [[ ! -e $EXPECTED_FILE ]]; then
    EXPECTED_FILE="$project_dir/analyzer-results.txt"
  fi

  toggle_in_file_analyzer_flags disable .

  dart analyze > $LOG_FILE || (
    echo -e "$(yellow "Ignoring analyzer exit code $?")"
  )

  if [[ -e $EXPECTED_FILE ]]; then
    if grep -ve '^#' $EXPECTED_FILE | diff - $LOG_FILE > /dev/null; then
      echo -e "$(blue "Analyzer output is as expected ($EXPECTED_FILE).")"
    else
      cat $LOG_FILE
      echo -e "$(yellow "Unexpected analyzer output ($EXPECTED_FILE); here's the diff:")"
      diff $LOG_FILE $EXPECTED_FILE || true
      EXIT_STATUS=1
      if [[ -n $SAVE_LOGS ]]; then 
        cp $LOG_FILE $EXPECTED_FILE
      fi
    fi
  elif grep -qvE '^Analyzing|^No issues found' $LOG_FILE; then
    cat $LOG_FILE
    
    printf "\n$(yellow "
    No analysis errors or warnings should be present in original source files.
    Ensure that these issues are disabled using appropriate markers like:
    // ignore_for_file: $DART_CHANNEL, some_analyzer_error_or_warning_id
    Or if the errors are expected, create an analyzer-results.txt file.
    ")\n"
    
    EXIT_STATUS=1
    if [[ -n $SAVE_LOGS ]]; then 
      cp $LOG_FILE $EXPECTED_FILE
    fi
  else
    cat $LOG_FILE
  fi

  toggle_in_file_analyzer_flags reenable .

  if [[ ! -d "test" ]]; then
    echo -e "$(blue "Nothing to test in this project.")"
    return
  fi

  printf "\n$(blue "Running VM tests (exclude browser) ...")\n"
  dart run test --exclude-tags=browser \
    | tee $LOG_FILE | $FILTER1 | $FILTER2 "$FILTER_ARG"

  PASSED=$(grep -E 'All tests passed!|^No tests ran' $LOG_FILE)
  if [[ -z "$PASSED" ]]; then 
    printf "\n$(red "Found VM test errors")\n"
    EXIT_STATUS=1
  fi

  # TODO(chalin): as of 2019/11/17, we don't need to select individual browser 
  # test files. Run browser tests over all files, since VM-only tests have 
  # been annotated as such.
  BROWSER_TESTS=$(find . -name "*browser_test.dart" -o -name "*html_test.dart")

  if [[ -z $BROWSER_TESTS ]]; then
    printf "\n$(blue "No browser-only tests - skipping")\n"
  else
    printf "\n$(blue "Running browser-only tests...")\n"
    dart run test \
      --tags browser \
      --platform chrome $BROWSER_TESTS 2>&1 | \
        tee $LOG_FILE | $FILTER1 | $FILTER2 "$FILTER_ARG"
    
    PASSED=$(grep 'All tests passed!' $LOG_FILE)
    if [[ -z "$PASSED" ]]; then 
      printf "\n$(red "Found browser-only test errors")\n\n"
      EXIT_STATUS=1
    fi
  fi

  popd > /dev/null
}


if [[ ! -e $TMP ]]; then 
  mkdir $TMP
fi

# If quick, fail quick
if [[ -n "$QUICK" ]]; then
  FILTER1="tr '\r' '\n'"
  FILTER2="grep -E"
  FILTER_ARG="(Some|All|No) tests"
else
  FILTER1="cat -"
  FILTER2="cat"
  FILTER_ARG="-"
fi


printf "\n$(blue "Begin test and analyze...
TMP:          $TMP
EXAMPLES:     $EXAMPLES
DART_VERSION: $DART_VERSION
DART_CHANNEL: $DART_CHANNEL
")\n"


for dir in $EXAMPLES/??*; do
  if [[ ! -d $dir || $dir == *util ]]; then 
    continue
  fi
  analyze_and_test $dir
done

if [[ $EXIT_STATUS == 0 ]]; then
  printf "\n$(blue "All tests passed for all suites!")\n\n"
else
  printf "\n$(red "
  Some packages have test failures and/or analysis errors. 
  Look at the full output from this script for details.
  ")\n"
fi

exit $EXIT_STATUS
