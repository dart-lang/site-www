#!/usr/bin/env bash

set -e -o pipefail

if [[ -d $WEBDEV_REPO ]]; then
  echo "INFO: $WEBDEV_REPO exists"
else
  git clone https://github.com/dart-lang/site-webdev.git ./site-webdev
fi

source ./scripts/env-set.sh
./scripts/install-webdev.sh
./scripts/before-install.sh
./scripts/install.sh
