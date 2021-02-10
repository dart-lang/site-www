#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh

while [[ "$1" == -* ]]; do
  case "$1" in
    --check-links) CHECK_LINKS=1; shift;
                   # Use remaining arguments for call to check-links
                   break;;
    -h|--help)     echo "Usage: $(basename $0) [--help] [--check-links ...check-link-options]";
                   exit 0;;
    *)             echo "ERROR: Unrecognized option: $1. Use --help for details.";
                   exit 1;;
  esac
done

echo "::group::build_site"

bundle exec jekyll --version;
set -x;
bundle exec jekyll build;

echo "::endgroup::"

[[ -z $CHECK_LINKS ]] && exit

echo "::group::check_links"

set -x;
./tool/shared/check-links.sh $*;

echo "::endgroup::"
