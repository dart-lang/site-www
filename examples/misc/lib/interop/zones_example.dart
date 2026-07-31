// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:js_interop';
import 'package:web/web.dart' as web;

void main() {
  final element = web.document.querySelector('#my-element')!;

  // #docregion before
  // Before: Callback lost zone context
  element.addEventListener(
    'click',
    (web.Event event) {
      // ... relies on zone-local values
    }.toJS,
  );
  // #enddocregion before

  // After: Manually bind to the current zone
  // #docregion after
  element.addEventListener(
    'click',
    Zone.current.bindUnaryCallback((web.Event event) {
      // ... zone-local values are preserved
    }).toJS,
  );
  // #enddocregion after
}
