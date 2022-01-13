#!/usr/bin/env bash

set -e -o pipefail

source ./tool/shared/env-set-check.sh
source ./tool/shared/_robots.sh

# Allow robots on release deploy
saveAndSetRobotsTxt "ok"
