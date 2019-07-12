library sdk_builds.version_info;

import 'package:pub_semver/pub_semver.dart';

final _oldRevisionPostfix = new RegExp(r'(\d+\.\d+\.\d+)\.(\d+)_r(\d+)');

abstract class VersionInfo implements Comparable<VersionInfo> {
  final Version version;
  final DateTime date;
  final String channel;
  final String revisionPath;

  VersionInfo(this.version, this.date, this.channel, this.revisionPath);

  static VersionInfo parse(
      String channel, String revisionPath, Map<String, dynamic> json) {

    // Date parse magic
    var dateJson = json['date'];
    DateTime date;
    try {
      date = DateTime.parse(dateJson);
    } on FormatException {
      // dealing with weird format: 201401150424
      dateJson = '${dateJson.substring(0, 8)}T${dateJson.substring(8,12)}Z';
      date = DateTime.parse(dateJson);
    }

    // Version logic
    var jsonVersion = json['version'];

    var oldMatch = _oldRevisionPostfix.firstMatch(jsonVersion);
    if (oldMatch != null) {
      jsonVersion = "${oldMatch[1]}-rev.${oldMatch[2]}.${oldMatch[3]}";
    }

    var version = new Version.parse(jsonVersion);

    var revision = json['revision'];
    var svnRevision = int.tryParse(revision);
    if (svnRevision == null) {
      // assume git!
      assert(revision is String);
      assert(revision.length == 40);

      return new GitVersionInfo(version, date, channel, revisionPath, revision);
    }

    return new SvnVersionInfo(
        version, date, channel, revisionPath, svnRevision);
  }

  String toString() => version.toString();

  int compareTo(VersionInfo vi) => this.version.compareTo(vi.version);
}

class SvnVersionInfo extends VersionInfo {
  final int revision;

  SvnVersionInfo(Version version, DateTime date, String channel,
      String revisionPath, this.revision)
      : super(version, date, channel, revisionPath);
}

class GitVersionInfo extends VersionInfo {
  final String ref;

  GitVersionInfo(Version version, DateTime date, String channel,
      String revisionPath, this.ref)
      : super(version, date, channel, revisionPath);
}
