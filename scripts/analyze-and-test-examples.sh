#!/usr/bin/env bash
#
# Run dartfmt over the examples.

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

function analyze_and_text() {
  pushd "$1" > /dev/null
  travis_fold start analyzeAndTest.get
  pub get
  travis_fold end analyzeAndTest.get

  DIR=()
  for d in 'lib test'; do
    if [[ -d $d ]]; then DIR[${#DIR}]=$d; fi
  done

  if [[ ${#DIR} -gt 0 ]]; then
    echo
    travis_fold start analyzeAndTest.analyze
    $ANALYZE ${DIR[*]} | tee $LOG_FILE
    if grep -qvE '^Analyzing|^No issues found' $LOG_FILE ; then
      EXIT_STATUS=1
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
    echo "No browser only tests."
  else
    travis_fold start analyzeAndTest.tests.browser
    echo Running browser tests ...

    # Name the sole browser test file, otherwise all other files get compiled too:
    $TEST --tags browser --platform chromeheadless $TEST_FILES \
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
  analyze_and_text $d;
done

popd > /dev/null

exit $EXIT_STATUS
