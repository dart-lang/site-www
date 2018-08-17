#!/usr/bin/env bash

set -e -o pipefail

[[ -z "$DART_SITE_ENV_DEFS" ]] && . ./scripts/env-set.sh

if [[ "$1" == --force ]]; then FORCE=1; fi

if [[ -n "$TRAVIS" ]]; then
  ./scripts/env-info-and-check.sh
  # travis_fold start before_install.update_apt_get
  #   (set -x; sudo apt-get update --yes)
  # travis_fold end before_install.update_apt_get
fi

# Jekyll needs Ruby and the Ruby bundler
travis_fold start before_install.ruby_bundler
  if [[ -n "$TRAVIS" || -n "$FORCE" || -z "$(type -t bundler)" ]]; then
    (set -x; gem install bundler)
  else
    echo "Bundler already installed. Use --force to reinstall/update."
  fi
travis_fold end before_install.ruby_bundler

./scripts/install-dart-sdk.sh

travis_fold start before_install.npm_install
  if [[ -n "$TRAVIS" || -n "$FORCE" || -z "$(type -t firebase)" || -z "$(type -t gulp)" || -z "$(type -t superstatic)" ]]; then
    (set -x; npm install --global firebase-tools@4.0.3 gulp-cli superstatic@5.0.2 --no-optional)
  else
    echo "Global NPM packages already installed. Use --force to reinstall/update."
  fi
travis_fold end before_install.npm_install

pub upgrade
