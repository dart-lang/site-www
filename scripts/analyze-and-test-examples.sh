#!/usr/bin/env bash
#
# Run dartfmt over the examples.

# Don't exit on pipefail because we use `find`.
# set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

DART_MAJOR_VERS=$(dart --version 2>&1 | perl -pe '($_)=/version: (\d)\./')

PUB_ARGS="upgrade" # --no-precomiple

while [[ $# -gt 0 ]]; do
  case "$1" in
    --get)        PUB_ARGS="get"; shift;;
    --save-logs)  SAVE_LOGS=1; shift;;
    -h|--help)    echo "Usage: $(basename $0) [--get] [--save-logs] [--help]"; exit 0;;
    *)            echo "WARNING: Unrecognized option: $1"; shift;;
  esac
done

function analyze_and_test() {
  PROJECT_ROOT="$1"
  pushd "$PROJECT_ROOT" > /dev/null
  travis_fold start analyzeAndTest.get
  pub $PUB_ARGS
  travis_fold end analyzeAndTest.get

  DIR=()
  for d in bin lib test; do
    if [[ -d $d ]]; then DIR[${#DIR}]=$d; fi
  done

  if [[ ${#DIR} -le 0 ]]; then
    echo
    echo "NOTHING TO ANALYZE in this project."
  else
    echo
    EXPECTED_FILE=$PROJECT_ROOT/analyzer-$DART_MAJOR_VERS-results.txt
    travis_fold start analyzeAndTest.analyze
    $ANALYZE ${DIR[*]} | tee $LOG_FILE
    if [[ -e $EXPECTED_FILE ]]; then
      if diff $LOG_FILE $EXPECTED_FILE; then
        echo "Expected analyzer output ($EXPECTED_FILE) matched."
      else
        echo "Unexpected analyzer output ($EXPECTED_FILE):"
        diff $LOG_FILE $EXPECTED_FILE
        EXIT_STATUS=1
        if [[ -n $SAVE_LOGS ]]; then cp $LOG_FILE $EXPECTED_FILE; fi
      fi
    elif grep -qvE '^Analyzing|^No issues found' $LOG_FILE; then
      EXIT_STATUS=1
      if [[ -n $SAVE_LOGS ]]; then cp $LOG_FILE $EXPECTED_FILE; fi
    fi
    travis_fold end analyzeAndTest.analyze
  fi

  echo
  travis_fold start analyzeAndTest.tests.vm
  echo Running VM tests ...

  TEST="pub run test"

  $TEST --exclude-tags=browser | tee $LOG_FILE | $FILTER1 | $FILTER2 "$FILTER_ARG"
  LOG=$(grep -E 'All tests passed!|^No tests ran' $LOG_FILE)
  if [[ -z "$LOG" ]]; then EXIT_STATUS=1; fi
  travis_fold end analyzeAndTest.tests.vm

  #TEST_FILES=`find . -name "*browser_test.dart" -o -name "*html_test.dart"`
  TEST_FILES=`find . -name "*_test.dart" -exec grep -l "@TestOn('browser')" {} +`
  if [[ -z $TEST_FILES ]]; then
    echo "No browser-only tests."
  else
    travis_fold start analyzeAndTest.tests.browser
    echo Running browser tests ...
    PLATFORM=chrome
    if [[ -n $TRAVIS ]]; then PLATFORM=travischrome; fi
    # Name the sole browser test file, otherwise all other files get compiled too:
    $TEST --tags browser --platform $PLATFORM $TEST_FILES \
      | tee $LOG_FILE | $FILTER1 | $FILTER2 "$FILTER_ARG"
    LOG=$(grep 'All tests passed!' $LOG_FILE)
    if [[ -z "$LOG" ]]; then EXIT_STATUS=1; fi
    travis_fold end analyzeAndTest.tests.browser
  fi
  popd > /dev/null
}

EXIT_STATUS=0

cd `dirname $0`/..
ROOT=$(pwd)
EXAMPLES="$ROOT/examples"

ANALYZE="dartanalyzer --options $EXAMPLES/analysis_options.yaml"

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
