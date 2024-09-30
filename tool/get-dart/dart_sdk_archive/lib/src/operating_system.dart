import 'package:web/web.dart';

final class OperatingSystem {
  static final OperatingSystem current =
      [_chrome, _mac, _windows, _linux, _unix].firstWhere(
    (system) => window.navigator.appVersion.contains(system._navigatorName),
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

const _linux = OperatingSystem(
  'Linux',
  'Linux',
);

const _mac = OperatingSystem(
  'Mac',
  'Mac',
);

const _unix = OperatingSystem(
  'Unix',
  'X11',
);

const _windows = OperatingSystem(
  'Windows',
  'Win',
);

const _chrome = OperatingSystem(
  'ChromeOS',
  'CrOS',
);
