#!/usr/bin/env bash
# Use this file locally to update checksum values in the Dockerfile

set -eou pipefail

VERSION="latest"
CHANNEL="stable"

while (( "$#" )); do
  case "$1" in
    --version)
      VERSION=$2
      shift 2
      ;;
    --channel)
      CHANNEL=$2
      shift 2
      ;;
    *)
      echo "Unsupported argument $1" >&2
      exit 1
      ;;
  esac
done

BASEURL="https://storage.googleapis.com/dart-archive/channels"
CHANNELS="stable beta dev"
ARCHS="amd64 arm64"

# Prints output similar to cases in Dockerfile for easy composition
for CHANNEL in $CHANNELS; do
  for ARCH in $ARCHS; do
    echo "${ARCH}_${CHANNEL}) \\"
    _arch=$ARCH
    if [[ "$_arch" == "amd64" ]]; then
      _arch='x64'
    fi
    FILENAME="dartsdk-linux-${_arch}-release.zip"
    URL="$BASEURL/$CHANNEL/release/$VERSION/sdk/$FILENAME"
    curl -fsSLO $URL
    echo "  DART_SHA256="$(shasum -a 256 $FILENAME)"; \\"
    echo "  SDK_ARCH="$_arch";; \\"
    rm $FILENAME
  done
done
