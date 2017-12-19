#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$NGIO_ENV_DEFS" ]] && . ./scripts/env-set.sh

cd $WEBDEV_REPO

# Minal configuration so that we can run the shredder

travis_fold start before_install.npm_install
  (set -x; npm install --global gulp-cli --no-optional)
travis_fold end before_install.npm_install

travis_fold start install.npm_install
(set -x; npm install --no-optional)
travis_fold end install.npm_install
