#!/usr/bin/env bash

set -e -o pipefail

# cd `dirname $0`/..

if [[ "$1" == "--dev" && -e _config_dev.yml ]]; then
  CONFIG="--config _config.yml,_config_dev.yml"
fi

if [[ "$1" == "frontpage" ]]; then
  CONFIG="--config _config.yml,scripts/frontpage_only_config.yml"
fi

bundle exec jekyll build $CONFIG --incremental --watch &
j_pid=$!
firebase serve --port 4000 &
f_pid=$!
echo "catched PIDs: $j_pid, $f_pid"
trap "{ kill $j_pid; kill $f_pid; exit 0;}" SIGINT
wait
