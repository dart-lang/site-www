# This bash file is meant to be source'd, not executed.
#
# Until site-www has it's own setup, use the one from site-webdev

WEBDEV_REPO=../site-webdev

if [[ ! -d $WEBDEV_REPO ]]; then
  echo "ERROR: expected to find repo at $WEBDEV_REPO"
else
  source ../site-webdev/scripts/env-set.sh
fi
