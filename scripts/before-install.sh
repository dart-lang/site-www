#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$DART_SITE_ENV_DEFS" ]] && . ./scripts/env-set.sh

if [[ -n "$TRAVIS" ]]; then
  ./scripts/env-info-and-check.sh
  # travis_fold start before_install.update_apt_get
  #   (set -x; sudo apt-get update --yes)
  # travis_fold end before_install.update_apt_get
fi

# Jekyll needs Ruby and the Ruby bundler
travis_fold start before_install.ruby_bundler
  (set -x; gem install bundler)
travis_fold end before_install.ruby_bundler

./scripts/install-dart-sdk.sh

travis_fold start before_install.npm_install
  (set -x; npm install --global firebase-tools gulp-cli superstatic --no-optional)
travis_fold end before_install.npm_install

travis_fold start before_install.linkcheck
  (set -x; pub global activate linkcheck)
travis_fold end before_install.linkcheck
