#!/usr/bin/env bash
# Use this file locally to update Dart SDK checksum values in the Dockerfile
# Prints output similar to cases in Dockerfile for easy composition 
# when having to update checksum values for updates dart SDK.
set -eu -o pipefail
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

printf "\n$(blue "Copy the following output and replace the existing code in the Dockerfile:")\n\n"

for CHANNEL in $CHANNELS; do
  for ARCH in $ARCHS; do
    echo -e "$(yellow "${ARCH}_${CHANNEL})") \\"
    _arch=$ARCH
    if [[ "$_arch" == "amd64" ]]; then
      _arch='x64'
    fi
    _filename="dartsdk-linux-${_arch}-release.zip"
    _url="$BASEURL/$CHANNEL/release/$VERSION/sdk/$_filename"
    curl -fsSLO $_url
    _checksum=$(shasum -a 256 $_filename)
    IFS=" " # Split checksum output by space delimiter 
    read -a _fname_arr <<< "$_checksum" # Read in string output as array
    unset _fname_arr[-1] # Remove filename portion of checksum output
    echo -e "$(yellow "  DART_SHA256=\"$_fname_arr\";") \\"
    echo -e "$(yellow "  SDK_ARCH=\"$_arch\";;") \\"
    rm $_filename
  done
done

echo ""
