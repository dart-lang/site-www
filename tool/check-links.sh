#!/usr/bin/env bash
# Check for non-200 links in built Jekyll site using Firebase emulator
set -eu -o pipefail 
source $TOOL_DIR/utils.sh
trap clean_up SIGINT SIGTERM ERR EXIT

EMULATOR_PORT=5500 # airplay runs on :5000

# Catch error, stop running emulator process by port
clean_up() {
  trap - SIGINT SIGTERM ERR EXIT
  echo -e "$(blue "Shutting down emulator...")"
  lsof -t -i:$EMULATOR_PORT | xargs kill -9 > /dev/null 2>&1
  echo -e "$(blue "Done!")\n"
}

echo -e "$(blue "Starting Firebase emulator async...")"
npx firebase emulators:start \
  --only hosting \
  --project default > /dev/null 2>&1 &
emulator_status=$?

sleep 3

if [[ -z "$emulator_status" ]]; then
  echo -e "$(red "Emulator did not start...")"
  exit 1
else 
  echo -e "$(blue "Emulator is running")"
fi

SKIP_FILE="$TOOL_DIR/config/linkcheck-skip-list.txt"
dart run linkcheck :$EMULATOR_PORT --skip-file $SKIP_FILE
