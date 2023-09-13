import 'package:pub_semver/pub_semver.dart';

final _oldRevisionPostfix = RegExp(r'(\d+\.\d+\.\d+)\.(\d+)_r(\d+)');

abstract class VersionInfo implements Comparable<VersionInfo> {
  final Version version;
  final DateTime date;
  final String channel;
  final String revisionPath;
  final DateTime? creationTime;

  VersionInfo(
    this.version,
    this.date,
    this.channel,
    this.revisionPath, {
    this.creationTime,
  });

  static VersionInfo parse(
    String channel,
    String revisionPath,
    Map<String, Object?> json, {
    DateTime? creationTime,
  }) {
    // Date parse magic
    var dateJson = json['date'] as String;
    DateTime date;
    try {
      date = DateTime.parse(dateJson);
    } on FormatException {
      // dealing with weird format: 201401150424
      dateJson = '${dateJson.substring(0, 8)}T${dateJson.substring(8, 12)}Z';
      date = DateTime.parse(dateJson);
    }

    // Version logic
    var jsonVersion = json['version'] as String;

    final oldMatch = _oldRevisionPostfix.firstMatch(jsonVersion);
    if (oldMatch != null) {
      jsonVersion = '${oldMatch[1]}-rev.${oldMatch[2]}.${oldMatch[3]}';
    }

    final version = Version.parse(jsonVersion);

    final revision = json['revision'] as String;
    final svnRevision = int.tryParse(revision);
    if (svnRevision == null) {
      // assume git!
      assert(revision.length == 40);

      return GitVersionInfo(
        version,
        date,
        channel,
        revisionPath,
        revision,
        creationTime: creationTime,
      );
    }

    return SvnVersionInfo(
      version,
      date,
      channel,
      revisionPath,
      svnRevision,
      creationTime: creationTime,
    );
  }

  @override
  String toString() => version.toString();

  @override
  int compareTo(VersionInfo vi) => version.compareTo(vi.version);
}

class SvnVersionInfo extends VersionInfo {
  final int revision;

  SvnVersionInfo(
    super.version,
    super.date,
    super.channel,
    super.revisionPath,
    this.revision, {
    super.creationTime,
  });
}

class GitVersionInfo extends VersionInfo {
  final String ref;

  GitVersionInfo(
    super.version,
    super.date,
    super.channel,
    super.revisionPath,
    this.ref, {
    super.creationTime,
  });
}
