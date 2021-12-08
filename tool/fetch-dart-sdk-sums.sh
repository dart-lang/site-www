#!/bin/bash

set -euo pipefail


VERSION=2.14.4
BASEURL="https://storage.googleapis.com/dart-archive/channels"
CHANNEL="stable"
ARCHS="x64 arm64";
for ARCH in $ARCHS; do \
  echo "Checking $ARCH..."
  SDK="dartsdk-linux-$ARCH-release.zip"
  URL="$BASEURL/$CHANNEL/release/$VERSION/sdk/$SDK"
  echo "Downloading $URL"
  curl -fsSLO $URL
  shasum -a 256 $SDK
  rm $SDK
done
