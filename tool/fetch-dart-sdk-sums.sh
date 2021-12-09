#!/usr/bin/env bash
# Use this file locally to update checksum values in the Dockerfile

set -eou pipefail

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
ARCHS="x64 arm64"

for CHANNEL in $CHANNELS; do
  printf "\nFetching sums for the '$CHANNEL' channel...\n\n"
  for ARCH in $ARCHS; do
    FILENAME="dartsdk-linux-$ARCH-release.zip"
    URL="$BASEURL/$CHANNEL/release/$VERSION/sdk/$FILENAME"
    echo "Downloading $URL..."
    curl -fsSLO $URL
    echo "=> $CHANNEL :: $ARCH"
    shasum -a 256 $FILENAME
    rm $FILENAME
    echo ""
  done
done
