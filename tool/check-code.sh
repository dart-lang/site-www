#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

[[ -z "$DART_SITE_ENV_DEFS" ]] && . $rootDir/tool/env-set.sh

travis_fold start dartfmt
(set -x; $rootDir/tool/dartfmt.sh)
travis_fold end dartfmt

errorMessage="
Error: some code excerpts need to be refreshed.
Rerun '$rootDir/tool/refresh-code-excerpts.sh' locally.
"

travis_fold start refresh_code_excerpts
  (
    set -x;
    $rootDir/tool/refresh-code-excerpts.sh --keep-dart-tool
  ) || (
    printf "$errorMessage" && git diff &&
    exit 1
  )
travis_fold end refresh_code_excerpts
