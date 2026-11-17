// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:universal_web/web.dart' as web;

/// An operating system reported by the client's browser.
enum ClientOperatingSystem {
  macos,
  windows,
  linux;

  /// Returns the [ClientOperatingSystem] determined from the browser's user
  /// agent string, or [fallback] if undetermined.
  static ClientOperatingSystem fromUserAgent({
    ClientOperatingSystem fallback = ClientOperatingSystem.windows,
  }) {
    final userAgent = web.window.navigator.userAgent;
    if (userAgent.contains('Mac')) {
      // macOS, iOS, or iPadOS.
      return ClientOperatingSystem.macos;
    }

    if (userAgent.contains('Win')) {
      // Windows.
      return ClientOperatingSystem.windows;
    }

    if ((userAgent.contains('Linux') || userAgent.contains('X11')) &&
        !userAgent.contains('Android')) {
      // Linux, but not Android.
      return ClientOperatingSystem.linux;
    }

    if (userAgent.contains('CrOS')) {
      // ChromeOS, but fall back to Linux.
      return ClientOperatingSystem.linux;
    }

    return fallback;
  }
}
