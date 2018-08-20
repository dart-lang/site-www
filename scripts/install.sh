#!/usr/bin/env bash

set -e -o pipefail

cd `dirname $0`/..

if [[ "$(node --version)" < "v10" ]]; then
    echo "ERROR: bad version of node detected. If you have nvm installed, type:"
    echo "  nvm use"
    echo "Aborting installation."
    exit 1;
else
    echo "Node version: $(node --version)"
fi

travis_fold start install.bundle
(set -x; bundle install)
travis_fold end install.bundle
