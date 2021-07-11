#!/usr/bin/env bash

: ${TMP:=tmp}
OUT_DIR="$TMP/dartpad_picker"
DEST_DIR=../../src/assets/dash/js

set -x

dart pub get
rm $DEST_DIR/dartpad_picker*.*
dart run build_runner build --release --output $OUT_DIR
cp $OUT_DIR/web/dartpad_picker_main.dart.js $DEST_DIR
rm -rf $OUT_DIR
