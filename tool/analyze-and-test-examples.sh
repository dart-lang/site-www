#!/usr/bin/env bash
#
# Run dartfmt over the examples.

# `find` exit code reflects whether it encountered errors during the search.
# We ignore such errors, so don't exit on a pipefail.
# set -e -o pipefail

cd `dirname $0`/..
ROOT=$(pwd)

source ./tool/shared/env-set-check.sh

DART_VERS=$(dart --version 2>&1 | perl -pe '($_)=/version: (\S+)/')
DART_CHAN=stable
if [[ $DART_VERS == *beta* ]]; then
  DART_CHAN=beta
elif [[ $DART_VERS == *dev* ]]; then
  DART_CHAN=dev
fi
EXAMPLES="$ROOT/examples"
ANALYZE="dart analyze"
PUB_ARGS="upgrade" # --no-precomiple

while [[ $# -gt 0 ]]; do
  case "$1" in
    --get)          PUB_ARGS="get"; shift;;
    --quick)        QUICK=1; shift;;
    --save-logs)    SAVE_LOGS=1; shift;;
    --null-safety)  EXAMPLES="$ROOT/null_safety_examples"; shift;;
    -h|--help)      echo "Usage: $(basename $0) [--get] [--quick] [--save-logs] [--null-safety] [--help]"; exit 0;;
    *)              echo "ERROR: Unrecognized option: $1. Use --help for details."; exit 1;;
  esac
done

echo DART_VERS: $DART_VERS
echo DART_CHAN: $DART_CHAN

function toggleInFileAnalyzerFlags() {
  # Arguments: [disable|reenable] path path...
  local action=$1; shift;
  local mark='!'; local toggle=' '
  if [[ $action == 'disable' ]]; then
    mark=' '; toggle='!'
  fi

  find $* -name "*.dart" ! -path "**/.*" \
    -exec perl -i -pe "s{//$mark(ignore(_for_file)?: .*?\b(stable|dev)\b)}{//$toggle\$1}g" {} \;
}

function analyze_and_test() {
  PROJECT_ROOT="$1"
  pushd "$PROJECT_ROOT" > /dev/null
  travis_fold start analyzeAndTest.get
  dart pub $PUB_ARGS
  travis_fold end analyzeAndTest.get

  echo
  EXPECTED_FILE=$PROJECT_ROOT/analyzer-results-$DART_CHAN.txt
  if [[ ! -e $EXPECTED_FILE ]]; then
    EXPECTED_FILE=$PROJECT_ROOT/analyzer-results.txt
  fi
  travis_fold start analyzeAndTest.analyze
  toggleInFileAnalyzerFlags disable .
  echo "$ $ANALYZE"
  $ANALYZE > $LOG_FILE || {
    echo "WARNING: Ignoring analyzer exit code $?"
  }
  if [[ -e $EXPECTED_FILE ]]; then
    if grep -ve '^#' $EXPECTED_FILE | diff - $LOG_FILE > /dev/null; then
      echo "Analyzer output is as expected ($EXPECTED_FILE)."
    else
      cat $LOG_FILE
      echo "Unexpected analyzer output ($EXPECTED_FILE); here's the diff:"
      (set -x; diff $LOG_FILE $EXPECTED_FILE) || true
      EXIT_STATUS=1
      if [[ -n $SAVE_LOGS ]]; then cp $LOG_FILE $EXPECTED_FILE; fi
    fi
  elif grep -qvE '^Analyzing|^No issues found' $LOG_FILE; then
    cat $LOG_FILE
    echo "No analysis errors or warnings should be present in original source files."
    echo "Ensure that these issues are disabled using appropriate markers like: "
    echo "  // ignore_for_file: $DART_CHAN, some_analyzer_error_or_warning_id"
    echo "Or if the errors are expected, create an analyzer-results.txt file."
    EXIT_STATUS=1
    if [[ -n $SAVE_LOGS ]]; then cp $LOG_FILE $EXPECTED_FILE; fi
  else
    cat $LOG_FILE
  fi
  toggleInFileAnalyzerFlags reenable .
  travis_fold end analyzeAndTest.analyze

  if [[ ! -d test ]]; then
    echo
    echo "NOTHING TO TEST in this project."
    return
  fi

  echo
  travis_fold start analyzeAndTest.tests.vm
  echo Running VM tests ...

  TEST="pub run test"
  TEST_ARGS="--exclude-tags=browser"

  echo "$ $TEST $TEST_ARGS"
  $TEST $TEST_ARGS | tee $LOG_FILE | $FILTER1 | $FILTER2 "$FILTER_ARG"
  LOG=$(grep -E 'All tests passed!|^No tests ran' $LOG_FILE)
  if [[ -z "$LOG" ]]; then EXIT_STATUS=1; fi
  travis_fold end analyzeAndTest.tests.vm

  # TODO(chalin): as of 2019/11/17, we don't need to select individual browser test files. Run browser tests over all files, since VM-only tests have been annotated as such.
  TEST_FILES=`find . -name "*browser_test.dart" -o -name "*html_test.dart"`
  # Use the following to selectively remove some tests:
  # TEST_FILES=`find . -name "*_test.dart" -exec grep -l "@TestOn('browser')" {} + | grep -v pi_test`
  if [[ -z $TEST_FILES ]]; then
    echo "No browser-only tests."
  else
    travis_fold start analyzeAndTest.tests.browser
    echo Running browser tests ...
    PLATFORM=chrome
    if [[ -n $TRAVIS ]]; then PLATFORM=travischrome; fi
    # Name the sole browser test file, otherwise all other files get compiled too:
    TEST="pub run test"
    echo "$ $TEST --tags browser --platform $PLATFORM $TEST_FILES"
    $TEST --tags browser --platform $PLATFORM $TEST_FILES \
      | tee $LOG_FILE | $FILTER1 | $FILTER2 "$FILTER_ARG"
    LOG=$(grep 'All tests passed!' $LOG_FILE)
    if [[ -z "$LOG" ]]; then EXIT_STATUS=1; fi
    travis_fold end analyzeAndTest.tests.browser
  fi
  popd > /dev/null
}

EXIT_STATUS=0

FILTER1="cat -"
FILTER2="cat"
FILTER_ARG="-"
if [[ "$1" == "-q" ]]; then
  FILTER1="tr '\r' '\n'"
  FILTER2="grep -E"
  FILTER_ARG="(Some|All|No) tests"
  shift;
fi

if [[ ! -e $TMP ]]; then mkdir $TMP; fi
LOG_FILE=$TMP/analyzer-output.txt

pushd $EXAMPLES > /dev/null

export PUB_ALLOW_PRERELEASE_SDK=quiet

for d in $EXAMPLES/??*; do
  if [[ ! -d $d || $d == *util ]]; then continue; fi
  echo
  echo "PROCESSING $d"
  echo
  analyze_and_test $d;
done

popd > /dev/null

if [[ $EXIT_STATUS == 0 ]]; then
  echo "All tests passed for all suites!"
else
  echo "WARNING: some packages have test failures or analysis errors."
  echo "WARNING: Look at the full output from this script for details."
fi

exit $EXIT_STATUS
