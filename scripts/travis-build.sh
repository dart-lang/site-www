#!/usr/bin/env bash

set -e -o pipefail

./scripts/write-ci-info.sh -v
bundle exec jekyll build
