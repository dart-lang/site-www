#!/usr/bin/env bash
# Check for non-200 links in built Jekyll site
set -eu -o pipefail 
trap clean_up SIGINT SIGTERM ERR EXIT

EMULATOR_PORT=5000

# Catch error, stop running emulator process by port
clean_up() {
  trap - SIGINT SIGTERM ERR EXIT
  echo "Shutting down emulator..."
  lsof -t -i:$EMULATOR_PORT | xargs kill -9 > /dev/null 2>&1
}

echo "Starting emulator async..."
npx firebase emulators:start \
  --only hosting \
  --project default > /dev/null 2>&1 &
emulator_status=$?

sleep 3

if [[ -z "$emulator_status" ]]; then
  echo "Emulator did not start..."
  exit 1
else 
  echo "Emulator is running"
fi

# Linkinate - using local linkinator.config.json
npx linkinator http://localhost:$EMULATOR_PORT
