#!/usr/bin/env bash

: ${TMP:=tmp}
OUT_DIR="$TMP/download_archive"
DEST_DIR=../../../src/get-dart/archive/assets

set -x

dart pub get
rm $DEST_DIR/download_archive*.*
dart run build_runner build --release --output $OUT_DIR
cp $OUT_DIR/web/download_archive.dart.js $DEST_DIR
rm -rf $OUT_DIR
