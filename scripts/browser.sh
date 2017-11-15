#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh > /dev/null

if [[ $TASK == *test* ]]; then
  set -x
  sh -e /etc/init.d/xvfb start
  #t=0; until (xdpyinfo -display :99 &> /dev/null || test $t -gt 10); do sleep 1; let t=$t+1; done
  # content_shell --run-layout-test --disable-gpu-early-init --disable-gpu
  sleep 3
  set +x
else
  echo "We don't launch chrome / content_shell for TASK $TASK"
fi
