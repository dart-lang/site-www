#!/usr/bin/env bash

# tool/check-formatting.sh 2>&1
# tool/refresh-code-excerpts.sh 2>&1
# tool/analyze-and-test-examples.sh 2>&1

# Could inverse
# ! tool/check-formatting.sh; A=$?
# ! tool/refresh-code-excerpts.sh; B=$?
# ! tool/analyze-and-test-examples.sh; C=$?

# if [[ -n $A && -n $B && -n $C ]]; then
#   echo "All tests passed!"
# else
#   echo "One more more tests failed"
#   exit 1;
# fi

tool/check-formatting.sh
tool/refresh-code-excerpts.sh
tool/analyze-and-test-examples.sh

printf "\n-- Done --\n\n"