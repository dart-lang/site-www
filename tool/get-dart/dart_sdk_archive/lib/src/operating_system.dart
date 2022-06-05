import 'dart:html';

class OperatingSystem {
  static final OperatingSystem current =
      [_chrome, _mac, _windows, _linux, _unix].firstWhere(
    (system) => system._matchesNavigator(window.navigator),
    orElse: () => OperatingSystem('Unknown', (n) => false),
  );

  final String name;
  final bool Function(Navigator) _matchesNavigator;

  OperatingSystem(this.name, this._matchesNavigator);

  bool get isLinux => this == _linux;
  bool get isMac => this == _mac;
  bool get isUnix => this == _unix;
  bool get isWindows => this == _windows;
}

final _linux = OperatingSystem(
  'Linux',
  (Navigator navigator) => navigator.appVersion.contains('Linux'),
);

final _mac = OperatingSystem(
  'Mac',
  (Navigator navigator) => navigator.appVersion.contains('Mac'),
);

final _unix = OperatingSystem(
  'Unix',
  (Navigator navigator) => navigator.appVersion.contains('X11'),
);

final _windows = OperatingSystem(
  'Windows',
  (Navigator navigator) => navigator.appVersion.contains('Win'),
);

final _chrome = OperatingSystem(
  'ChromeOS',
  (Navigator navigator) => navigator.appVersion.contains('CrOS'),
);
