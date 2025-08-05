import 'package:jaspr/jaspr.dart';
import 'package:pub_semver/pub_semver.dart';

import 'archive_table.dart';
import 'version_info.dart';

class VersionSelector with ChangeNotifier {
  final String channel;

  VersionSelector(this.channel);

  String? get selectedVersion => null;
  set selectedVersion(String? _) {}

  String? get selectedOs => null;
  set selectedOs(String? _) {}

  VersionInfo? get versionInfo => null;

  Iterable<Version>? get versions => [];

  Iterable<VersionRow> get versionRows => [];

  bool isVersionVisible(VersionRow version) {
    if (selectedOs case null || 'all') {
      return true;
    } else {
      return version.os.toLowerCase() == selectedOs || version.os == '---';
    }
  }
}
