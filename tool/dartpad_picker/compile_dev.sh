#!/usr/bin/env bash

: ${TMP:=tmp}
OUT_DIR="$TMP/dartpad_picker"
DEST_DIR=../../src/assets/dash/js

set -x

pub get
rm $DEST_DIR/dartpad_picker*.*
pub run build_runner build --output $OUT_DIR --define "build_web_compilers|entrypoint=compiler=dart2js"
cp $OUT_DIR/web/*  $DEST_DIR
rm -rf $OUT_DIR
