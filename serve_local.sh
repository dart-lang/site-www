#!/usr/bin/env bash

if [ $1 == "frontpage" ]; then
  jekyll build --watch --config _config.yml,scripts/frontpage_only_config.yml &
else
  jekyll build --watch &
fi
j_pid=$!
firebase serve --port 4000 &
f_pid=$!
echo "catched PIDs: $j_pid, $f_pid"
trap "{ kill $j_pid; kill $f_pid; exit 0;}" SIGINT
wait