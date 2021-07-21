library sdk_builds.dart_downloads;

import 'dart:convert';

import 'package:googleapis/storage/v1.dart' as storage;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import 'version_info.dart';

const _dartChannel = 'dart-archive';
const _flavor = 'release';

String _revisionPath(String channel, String revision,
        [List<String> extra = const []]) =>
    p.joinAll(['channels', channel, _flavor, revision, ...extra]);

class DartDownloads {
  final storage.StorageApi _api;
  final http.Client _client;

  /// If [client] is provided, it will be closed with the call to [close].
  factory DartDownloads({http.Client? client}) =>
      DartDownloads._(client ?? http.Client());

  DartDownloads._(http.Client client)
      : _client = client,
        _api = storage.StorageApi(client);

  Future<Uri> createDownloadLink(
      String channel, String revision, String path) async {
    final prefix = _revisionPath(channel, revision, [path]);
    final results = await _api.objects.list(_dartChannel, prefix: prefix);
    final items = results.items;

    if (items == null || items.isEmpty) {
      throw Exception('No items found for path $path.');
    } else if (items.length > 1) {
      throw Exception('Too many items for path $path.');
    }

    final mediaLink = items.single.mediaLink;

    if (mediaLink == null) {
      throw Exception('No media link present for path $path.');
    } else {
      return Uri.parse(mediaLink);
    }
  }

  Future<List<VersionInfo>> fetchVersions(String channel) async {
    final versions = await fetchVersionPaths(channel)
        .where((event) => !event.contains('latest'))
        .toList();

    final versionMaps = <VersionInfo>[];

    await Future.forEach<String>(versions, (path) async {
      try {
        final revisionString = p.basename(path);
        final ver = await fetchVersion(channel, revisionString);

        versionMaps.add(ver);
      } catch (e) {
        // TODO: some kind of log?
        print('Error with $path - $e');
      }
    });

    versionMaps.sort();

    return versionMaps;
  }

  Stream<String> fetchVersionPaths(String channel) async* {
    final prefix = p.join('channels', channel, _flavor) + '/';

    String? nextToken;

    do {
      final objects = await _api.objects.list(_dartChannel,
          prefix: prefix, pageToken: nextToken, delimiter: '/');
      nextToken = objects.nextPageToken;

      final prefixes = objects.prefixes;

      if (prefixes == null) {
        continue;
      }

      for (var item in prefixes) {
        yield item;
      }
    } while (nextToken != null);
  }

  Future<VersionInfo> fetchVersion(String channel, String revision) async {
    final media = await _fetchFile(channel, revision, 'VERSION');

    final json = await _jsonAsciiDecoder
        .bind(media.stream)
        .cast<Map<String, dynamic>>()
        .first;

    return VersionInfo.parse(channel, revision, json);
  }

  void close() => _client.close();

  Future<storage.Media> _fetchFile(
      String channel, String revision, String path) async {
    return await _api.objects.get(
        _dartChannel, _revisionPath(channel, revision, [path]),
        downloadOptions: storage.DownloadOptions.fullMedia) as storage.Media;
  }
}

late final _jsonAsciiDecoder = json.fuse(ascii).decoder;
