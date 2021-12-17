#!/usr/bin/env bash

# TODO I don't think we should be bypassing all errors
# tool/check-formatting.sh > /dev/null 2>&1
# tool/refresh-code-excerpts.sh > /dev/null 2>&1
# tool/analyze-and-test-examples.sh > /dev/null 2>&1


tool/check-formatting.sh
tool/refresh-code-excerpts.sh
tool/analyze-and-test-examples.sh
