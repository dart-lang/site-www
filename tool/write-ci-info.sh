#!/usr/bin/env bash

if [[ $TASK != *build* ]]; then exit; fi

FILE=src/_data/ci.yaml

echo "# WARNING: the sample values in this file get regenerated at build time.
build-id: $TRAVIS_BUILD_ID
build-number: $TRAVIS_BUILD_NUMBER
build-time: $(date)
commit-sha: $TRAVIS_COMMIT
job-id: $TRAVIS_JOB_ID
repo-slug: $TRAVIS_REPO_SLUG" > $FILE

if [[ "$1" == '-v' ]]; then
  echo "$FILE:"
  cat $FILE
fi

# Sample values from a master build:
#
# TRAVIS_BUILD_ID=280419528
# TRAVIS_BUILD_NUMBER=2286
# TRAVIS_COMMIT=b197a41666c52d42234fe9261b2008620b0f6aaa
# TRAVIS_COMMIT_MESSAGE='chore: upgrade to latest stable jekyll (3.6.0) and ruby (2.4.2) (#1077)'
# TRAVIS_COMMIT_RANGE=ff3b5a372baa...b197a41666c5
# TRAVIS_EVENT_TYPE=push
# TRAVIS_FILTERED=redirect_io
# TRAVIS_JOB_ID=280419536
# TRAVIS_JOB_NUMBER=2286.1
# TRAVIS_LANGUAGE=node_js
# TRAVIS_NODE_VERSION=6
# TRAVIS_OS_NAME=linux
# TRAVIS_PRE_CHEF_BOOTSTRAP_TIME=2017-08-29T02:15:46
# TRAVIS_PULL_REQUEST=false
# TRAVIS_PULL_REQUEST_BRANCH=
# TRAVIS_PULL_REQUEST_SHA=
# TRAVIS_PULL_REQUEST_SLUG=
# TRAVIS_REPO_SLUG=dart-lang/site-foo

# Sample values from a PR:
#
# TRAVIS_BRANCH=master
# TRAVIS_BUILD_ID=280464741
# TRAVIS_BUILD_NUMBER=2291
# TRAVIS_COMMIT=00c076794bc7a4f80bac005220128f057c18b3ed
# TRAVIS_COMMIT_MESSAGE='Merge 4bbfbd729b507df32fe3b3beefc79b0ed40a67a7 into 30420326f124b963cc124359d5887f3a07fe4cc8'
# TRAVIS_COMMIT_RANGE=30420326f124b963cc124359d5887f3a07fe4cc8...4bbfbd729b507df32fe3b3beefc79b0ed40a67a7
# TRAVIS_EVENT_TYPE=pull_request
# TRAVIS_JOB_ID=280464746
# TRAVIS_JOB_NUMBER=2291.2
# TRAVIS_PULL_REQUEST=1078
# TRAVIS_PULL_REQUEST_BRANCH=chalin-chore-content-shell-0927
# TRAVIS_PULL_REQUEST_SHA=4bbfbd729b507df32fe3b3beefc79b0ed40a67a7
# TRAVIS_PULL_REQUEST_SLUG=chalin/site-foo
# TRAVIS_REPO_SLUG=dart-lang/site-foo
