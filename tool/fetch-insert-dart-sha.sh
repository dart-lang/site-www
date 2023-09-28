#!/usr/bin/env bash
# Use this file locally to update Dart SDK checksum values in the Dockerfile
# Prints output similar to cases in Dockerfile for easy composition 
# when having to update checksum values for updates dart SDK.
set -eu -o pipefail
TOOL_DIR="${TOOL_DIR:=$(dirname "$0")}"
source $TOOL_DIR/utils.sh

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
ENDING='\\\n'
FILE='./new-dart-hashes.txt'

for CHANNEL in $CHANNELS; do
  for ARCH in $ARCHS; do
    printf "      ${ARCH}_${CHANNEL}) $ENDING" >> $FILE
    _arch=$ARCH
    if [[ "$_arch" == "amd64" ]]; then
      _arch='x64'
    fi
    _filename="dartsdk-linux-${_arch}-release.zip"
    _url="$BASEURL/$CHANNEL/release/$VERSION/sdk/$_filename"
    curl -fsSLO $_url
    _checksum=$(shasum -a 256 $_filename)
    read -a _fname_arr <<< "${_checksum}" # Read in string output as array
    _checkonly="${_fname_arr%:*}" # Remove filename portion of checksum output
    printf "        DART_SHA256=\"$_fname_arr\"; $ENDING" >> $FILE
    printf "        SDK_ARCH=\"$_arch\";; $ENDING" >> $FILE
    rm $_filename
  done
done

echo "Pulled latest Dart SHA hashes and saved to $FILE."
