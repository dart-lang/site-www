#!/usr/bin/env bash
#
# Run dartfmt over the examples.

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

EXIT_STATUS=0

cd `dirname $0`/..
ROOT=$(pwd)
EXAMPLES="$ROOT/examples"

ANALYZE="dartanalyzer --options $EXAMPLES/analysis_options.yaml"

if [[ ! -e $TMP ]]; then mkdir $TMP; fi
LOG_FILE=$TMP/analyzer-output.txt

pushd $EXAMPLES
travis_fold start analyzeAndTest.get
pub get
travis_fold end analyzeAndTest.get

echo
travis_fold start analyzeAndTest.analyze
$ANALYZE lib test | tee $LOG_FILE
if grep -qvE '^Analyzing|^No issues found' $LOG_FILE ; then
  EXIT_STATUS=1
fi
travis_fold end analyzeAndTest.analyze

echo
travis_fold start analyzeAndTest.tests.vm
echo Running VM tests ...

TEST="pub run test"

$TEST --exclude-tags=browser | tee $LOG_FILE
LOG=$(grep 'All tests passed!' $LOG_FILE)
if [[ -z "$LOG" ]]; then EXIT_STATUS=1; fi
travis_fold end analyzeAndTest.tests.vm

echo
travis_fold start analyzeAndTest.tests.browser
echo Running browser tests ...

# Name the sole browser test file, otherwise all other files get compiled too:
$TEST --tags browser --platform chrome test/language_tour/browser_test.dart | tee $LOG_FILE
LOG=$(grep 'All tests passed!' $LOG_FILE)
if [[ -z "$LOG" ]]; then EXIT_STATUS=1; fi
travis_fold end analyzeAndTest.tests.browser

exit $EXIT_STATUS
