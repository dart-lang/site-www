#!/usr/bin/env bash

: ${TMP:=tmp}
OUT_DIR="$TMP/dartpad_picker"

set -x

pub get
pub run build_runner build --release --output $OUT_DIR
cp $OUT_DIR/web/dartpad_picker_main.dart.js ../../src/assets/dash/js
rm -rf $OUT_DIR
