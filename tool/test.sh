#!/usr/bin/env bash
# Run all tests for validating code examples

tool/check-formatting.sh
tool/refresh-code-excerpts.sh
tool/analyze-and-test-examples.sh

printf "\n-- Done --\n\n"
