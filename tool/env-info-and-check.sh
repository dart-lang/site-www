#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

travis_fold start env_info
  echo ENVIRONMENT INFO
  travis_fold start env_info.var
    echo ENVIRONMENT VAR
    set
  travis_fold end env_info.var
  travis_fold start env_info.path
    echo Path:
    echo $PATH | tr : '\n'
    echo
  travis_fold end env_info.path
  travis_fold start env_info.home
    echo Home: $HOME
    ls -la ~
    echo
  travis_fold end env_info.home
  travis_fold start env_info.pwd
    echo Pwd: `pwd`
    ls -la
    echo
  travis_fold end env_info.pwd
travis_fold end env_info

echo ENVIRONMENT CONFIG CHECK:
if [[ -z "$DART_SITE_ENV_DEFS" ]]; then
  echo Environment variables are not being set. Aborting.
  exit 1;
else
  echo Environment variables successfully set.
fi
