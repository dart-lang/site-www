#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

echo ENVIRONMENT INFO
echo "::group::env_info.var"
  echo ENVIRONMENT VAR
  set
echo "::endgroup::"
echo "::group::env_info.path"
  echo Path:
  echo $PATH | tr : '\n'
  echo
echo "::endgroup::"
echo "::group::env_info.home"
  echo Home: $HOME
  ls -la ~
  echo
echo "::endgroup::"
echo "::group::env_info.pwd"
  echo Pwd: `pwd`
  ls -la
  echo
echo "::endgroup::"

echo ENVIRONMENT CONFIG CHECK:
if [[ -z "$DART_SITE_ENV_DEFS" ]]; then
  echo Environment variables are not being set. Aborting.
  exit 1;
else
  echo Environment variables successfully set.
fi
