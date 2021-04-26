#!/usr/bin/env bash

set -e -o pipefail

readonly rootDir="$(cd "$(dirname "$0")/.." && pwd)"

[[ -z "$DART_SITE_ENV_DEFS" ]] && . $rootDir/tool/env-set.sh

while [[ $# -gt 0 ]]; do
  case "$1" in
    --null-safety)  NULL_SAFETY=1; shift;;
    -h|--help)      echo "Usage: $(basename $0) [--null-safety] [--help]"; exit 0;;
    *)              echo "ERROR: Unrecognized option: $1. Use --help for details."; exit 1;;
  esac
done

echo "::group::dart-format"
if [[ $NULL_SAFETY == 1 ]]; then
  # Pass null safety flag on to the format script so it will check the right
  # files.
  (set -x; $rootDir/tool/dartformat.sh --null-safety)
else
  (set -x; $rootDir/tool/dartformat.sh)
fi
echo "::endgroup::"

errorMessage="
Error: some code excerpts need to be refreshed.
Rerun '$rootDir/tool/refresh-code-excerpts.sh' locally.
"

echo "::group::refresh_code_excerpts"
  (
    set -x;
    $rootDir/tool/refresh-code-excerpts.sh --keep-dart-tool
  ) || (
    printf "$errorMessage" && git diff &&
    exit 1
  )
echo "::endgroup::"
