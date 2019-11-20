#!/usr/bin/env bash

: ${TMP:=tmp}
OUT_DIR="$TMP/dartpad_picker"

set -x

pub get
pub run build_runner build --output $OUT_DIR --define "build_web_compilers|entrypoint=compiler=dart2js"
cp $OUT_DIR/web/* ../../src/assets/dash/js
rm -rf $OUT_DIR
