#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

# Build site
bundle exec jekyll build

# Check links
$rootDir/tool/shared/check-links.sh --fail-on-warnings
