// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:universal_web/web.dart' as web;

import 'util.dart';

final class OperatingSystem {
  static final OperatingSystem current = debugIsTest
      ? _linux
      : [_chrome, _mac, _windows, _linux, _unix].firstWhere(
          (system) =>
              web.window.navigator.appVersion.contains(system._navigatorName),
          orElse: () => const OperatingSystem('Unknown', 'Unknown'),
        );

  final String name;
  final String _navigatorName;

  const OperatingSystem(this.name, this._navigatorName);

  bool get isLinux => this == _linux;
  bool get isMac => this == _mac;
  bool get isUnix => this == _unix;
  bool get isWindows => this == _windows;
}

const _linux = OperatingSystem('Linux', 'Linux');

const _mac = OperatingSystem('Mac', 'Mac');

const _unix = OperatingSystem('Unix', 'X11');

const _windows = OperatingSystem('Windows', 'Win');

const _chrome = OperatingSystem('ChromeOS', 'CrOS');
