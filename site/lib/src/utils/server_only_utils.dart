// Copyright (c) 2026, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io' show Platform;

import 'package:pub_semver/pub_semver.dart' show Version;

/// The Dart version running this application.
///
/// Can only be called on the server, not from the client.
final Version runningDartVersion = Version.parse(
  Platform.version.split(' ').first,
);
