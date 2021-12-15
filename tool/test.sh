#!/usr/bin/env bash
# Run all tests 
set -e -o pipefail

tool/check-formatting.sh
tool/refresh-code-excerpts.sh
tool/analyze-and-test-examples.sh
