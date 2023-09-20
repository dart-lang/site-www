#!/usr/bin/env bash
# Enter the tool's directory as the working directory
# to avoid path conflicts under different environments.
cd -P -- "$(dirname -- "${BASH_SOURCE[0]}")"

: ${TMP:=tmp}
OUT_DIR="$TMP/download_archive"
DEST_DIR=../../../src/assets/js/get-dart

set -x

dart pub get
rm $DEST_DIR/download_archive*.*
dart run build_runner build --release --output $OUT_DIR
cp $OUT_DIR/web/download_archive.dart.js $DEST_DIR
rm -rf $OUT_DIR
