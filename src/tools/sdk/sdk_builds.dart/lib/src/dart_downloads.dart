library sdk_builds.dart_downloads;

import 'dart:async';
import 'dart:convert';

import 'package:googleapis/storage/v1.dart' as storage;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'package:quiver/async.dart' as qa;

import 'version_info.dart';

const _dartChannel = 'dart-archive';
const _flavor = 'release';

String _revisionPath(String channel, String revision,
        [List<String> extra = const []]) =>
    p.joinAll([
      ['channels', channel, _flavor, revision],
      extra
    ].expand(((e) => e)));

class DartDownloads {
  final storage.StorageApi _api;
  final http.Client _client;

  DartDownloads._(http.Client client)
      : this._client = client,
        this._api = new storage.StorageApi(client);

  /// If [client] is provided, it will be closed with the call to [close].
  factory DartDownloads({http.Client client}) {
    if (client == null) {
      client = new http.Client();
    }
    return new DartDownloads._(client);
  }

  Future<Uri> getDownloadLink(
      String channel, String revision, String path) async {
    var prefix = _revisionPath(channel, revision, [path]);

    storage.Objects results =
        await _api.objects.list(_dartChannel, prefix: prefix);

    if (results.items == null || results.items.isEmpty) {
      throw 'no items found for path $path';
    } else if (results.items.length > 1) {
      throw 'too many items for path $path';
    }

    storage.Object obj = results.items.single;

    return Uri.parse(obj.mediaLink);
  }

  Future<List<VersionInfo>> getVersions(String channel) async {
    var versions = await getVersionPaths(channel).toList();

    versions.removeWhere((e) => e.contains('latest'));

    var versionMaps = <VersionInfo>[];

    await qa.forEachAsync(versions, (path) async {
      try {
        var revisionString = p.basename(path);

        var ver = await getVersion(channel, revisionString);

        versionMaps.add(ver);
      } catch (e) {
        // TODO: some kind of log?
        print("Error with $path - $e");
        return;
      }
    }, maxTasks: 6);

    versionMaps.sort();

    return versionMaps;
  }

  Stream<String> getVersionPaths(String channel) async* {
    var prefix = p.join('channels', channel, _flavor) + '/';

    var nextToken = null;

    do {
      storage.Objects objects = await _api.objects.list(_dartChannel,
          prefix: prefix, pageToken: nextToken, delimiter: '/');
      nextToken = objects.nextPageToken;

      if (objects.prefixes == null) {
        continue;
      }

      for (var item in objects.prefixes) {
        yield item;
      }
    } while (nextToken != null);
  }

  Future<VersionInfo> getVersion(String channel, String revision) async {
    var media = await _getFile(channel, revision, 'VERSION');

    var json = await _jsonAsciiDecoder.bind(media.stream).first;

    return VersionInfo.parse(channel, revision, json);
  }

  void close() => _client.close();

  Future<storage.Media> _getFile(
      String channel, String revision, String path) async {
    return await _api.objects.get(
        _dartChannel, _revisionPath(channel, revision, [path]),
        downloadOptions: storage.DownloadOptions.FullMedia);
  }
}

final _jsonAsciiDecoder = json.fuse(ascii).decoder;
