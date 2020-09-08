#!/usr/bin/env bash
#
# Note: script arguments are passed directly to analyze-and-test-examples.sh.

set -eo pipefail

if [[ -n $(git status --short) ]]; then
  echo "You need to locally commit your changes first before running this pre-push script."
  exit 1;
fi

STATUS=0
set -x

./tool/dartformat.sh | grep -v Unchanged && \
./tool/refresh-code-excerpts.sh && \
./tool/analyze-and-test-examples.sh $* && \
pushd deploy/effective-dart-rules && pub get && \
popd && \
dart deploy/effective-dart-rules/bin/main.dart
STATUS=$?
set +x
if [[ $STATUS -eq 0 && -z $(git status --short) ]]; then
  printf "\nHURRAY! No issues detected.\n"
else
  printf "\nWARNING: an issue was detected or a file changed; see above for details.\n"
  git status --short
fi
