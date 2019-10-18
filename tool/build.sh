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

travis_fold start build_site
  (
    set -x;
    bundle exec jekyll build;
  )
travis_fold end build_site

[[ -z $CHECK_LINKS ]] && exit

travis_fold start check_links
  (
    set -x;
    ./tool/shared/check-links.sh $*;
  )
travis_fold end check_links
