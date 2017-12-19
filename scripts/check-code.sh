#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

[[ -z "$NGIO_ENV_DEFS" ]] && . $rootDir/scripts/env-set.sh

travis_fold start dartfmt
(set -x; $rootDir/scripts/dartfmt.sh)
travis_fold end dartfmt

errorMessage="
Error: some code excerpts need to be refreshed.
Rerun '$rootDir/scripts/refresh-code-excerpts.sh' locally.
"

travis_fold start refresh_code_excerpts
(set -x; $rootDir/scripts/refresh-code-excerpts.sh) || (printf "$errorMessage" && exit 1)
travis_fold end refresh_code_excerpts
