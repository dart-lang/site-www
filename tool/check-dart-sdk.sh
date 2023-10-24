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

echo -e "\nPulling latest Dart SHA hashes.\n\nThis will take a moment.\n"

BASEURL="https://storage.googleapis.com/dart-archive/channels"
CHANNELS="stable beta dev"
ARCHS="amd64 arm64"
ENDING='\\\n'
FILE=$TOOL_DIR/new-dart-hashes.txt

true > $FILE

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
    echo "Pulled ${ARCH}_${CHANNEL}: $_fname_arr"
    rm $_filename
  done
done

echo -e "\n\nPulled latest Dart SHA hashes and saved to $FILE.\n"

lead='# BEGIN dart-sha$'
tail='# END dart-sha$'
new_file='tool/new-dart-hashes.txt'
existing_file='Dockerfile'

new_hash=$(sed -n -e '/DART_SHA/ p' -e '/DART_SHA/ q' $new_file)
old_hash=$(sed -n -e '/DART_SHA/ p' -e '/DART_SHA/ q' $existing_file)

echo -e "Old $old_hash"
echo -e "New $new_hash"

# Compare the SHA hashes.
if [[ "$new_hash" == "$old_hash" ]]; then
  echo -e "Current SHA hashes are the latest hashes.\n"
  echo -e "No update needed.\n"
  rm $new_file
  echo -e "Removed $new_file.\n"
  echo -e "Re-run check-dart-sdk.sh to pull the current SHA hashes.\n"
else
  if [[ -f "$new_file" ]]; then
    echo -e "Retrieved replacement hashes and saved to $new_file.\n"
    if [[ -f "$existing_file" ]]; then
      echo -e "Found Dockerfile at $existing_file.\n"
      echo -e "Run tool/update-dart-sums.sh."
    else
      echo -e "No Dockerfile found."
    fi
  else
    echo -e "No replacement hashes found at this time.\n"
  fi
fi
