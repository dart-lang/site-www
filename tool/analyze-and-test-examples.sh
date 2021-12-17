#!/usr/bin/env bash
# Analyze dart files
# Final exit code reflects whether errors were encountered during tests
# Ignore script errors, so don't exit on errors/pipefail
set -u
source $TOOL_DIR/utils.sh


export PUB_ALLOW_PRERELEASE_SDK=quiet

TMP=$BASE_DIR/tmp
EXAMPLES=$BASE_DIR/examples
PUB_ARGS="upgrade"
LOG_FILE="$TMP/analyzer-output.txt"
EXIT_STATUS=0
QUICK=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --get)
      PUB_ARGS="get"
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
    --dart-version)
      DART_VERSION=$2
      shift 2
      ;;
    --dart-channel)
      DART_CHANNEL=$2
      shift 2
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


printf "\n$(blue "
TMP:          $TMP
EXAMPLES:     $EXAMPLES
DART_VERSION: $DART_VERSION
DART_CHANNEL: $DART_CHANNEL
")\n"


# Toggle analyzer comments in file via find/replace
# Arguments: [disable|reenable] path path...
function toggle_in_file_analyzer_flags() {
  local action="$1"
  local dir="$2"
  local mark="!"
  local toggle=" "
  if [[ $action == 'disable' ]]; then
    mark=" "
    toggle="!"
  fi
  find $dir -name "*.dart" ! -path "**/.*" -exec perl \
    -i -pe "s{//$mark(ignore(_for_file)?: .*?\b(stable|beta|dev)\b)}{//$toggle\$dir}g" {} \;
}

function analyze_and_test() {
  local project_dir="$1"

  pushd $project_dir > /dev/null
  dart pub $PUB_ARGS

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

  echo -e "$(blue "Reenabling flags in these files")"
  toggle_in_file_analyzer_flags reenable .

  if [[ ! -d test ]]; then
    echo -e "$(blue "Nothing to test in this project.")"
    return
  fi

  printf "\n$(blue "Running VM tests (no browser tests) ...")\n"
  dart pub run test --exclude-tags=browser \
    | tee $LOG_FILE | $FILTER1 | $FILTER2 "$FILTER_ARG"

  LOG=$(grep -E 'All tests passed!|^No tests ran' $LOG_FILE)
  if [[ -z "$LOG" ]]; then 
    printf "\n$(red "Found errors")\n"
    EXIT_STATUS=1
  fi

  # TODO(chalin): as of 2019/11/17, we don't need to select individual browser 
  # test files. Run browser tests over all files, since VM-only tests have 
  # been annotated as such.
  TEST_FILES=$(find . -name "*browser_test.dart" -o -name "*html_test.dart")
  BROWSER_PLATFORM="chrome"

  if [[ -z $TEST_FILES ]]; then
    printf "\n$(blue "No browser-only tests, skipping")\n"
  else
    printf "\n$(blue "Running browser-only tests...")\n"
    dart pub run test --tags=browser --platform=$BROWSER_PLATFORM $TEST_FILES 2>&1 \
      | tee $LOG_FILE | $FILTER1 | $FILTER2 "$FILTER_ARG"
    
    LOG=$(grep 'All tests passed!' $LOG_FILE)
    if [[ -z "$LOG" ]]; then 
      echo -e "$(yellow "Some browser-only tests failed")"
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

echo -e "$(blue "Entering examples ($EXAMPLES) and starting tests...")"
pushd $EXAMPLES > /dev/null

for d in $EXAMPLES/??*; do
  if [[ ! -d $d || $d == *util ]]; then 
    continue
  fi
  printf "\n$(blue "Processing directory ($d) ...")\n"
  analyze_and_test $d
done

popd > /dev/null

if [[ $EXIT_STATUS == 0 ]]; then
  echo -e "$(blue "All tests passed for all suites!")"
else
  printf "\n$(red "
  Some packages have test failures or analysis errors. 
  Look at the full output from this script for details.
  ")\n"
fi

exit $EXIT_STATUS
