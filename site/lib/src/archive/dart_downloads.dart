// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:google_cloud_protobuf/protobuf.dart' show TimestampExtension;
import 'package:google_cloud_storage/google_cloud_storage.dart' as storage;
import 'package:http/http.dart' as http;

import 'version_info.dart';

/// The host for SDK archive API requests and download links.
const String storageHost = 'storage.googleapis.com';

/// The Cloud Storage bucket containing published Dart SDK releases.
const String _archiveBucket = 'dart-archive';

/// A client for discovering and reading Dart SDK release information.
///
/// Uses the supplied HTTP client, or creates one if omitted.
/// The client is owned by this instance and closed by [close].
final class DartDownloads({http.Client? client}) {
  final http.Client _client = client ?? http.Client();

  /// The Cloud Storage client used to access the SDK archive.
  late final storage.Storage _api = storage.Storage(
    client: _client,
    projectId: storage.Storage.noProject,
    apiEndpoint: storageHost,
  );

  /// Returns the distinct release directory paths for [channel].
  ///
  /// Paths include the channel prefix and a trailing slash,
  /// such as `channels/stable/release/3.13.0/`.
  /// Includes `latest` if present.
  Future<Iterable<String>> fetchVersionPaths(String channel) async {
    // TODO: Use google_cloud_storage once it exposes the
    // prefixes of delimited listings.
    // Until then, call the API directly to list only the
    // release directories rather than every object in them.
    final versionPaths = <String>[];
    String? pageToken;

    do {
      final response = await _client.get(
        Uri.https(storageHost, 'storage/v1/b/$_archiveBucket/o', {
          'prefix': 'channels/$channel/release/',
          'delimiter': '/',
          'fields': 'nextPageToken,prefixes',
          'pageToken': ?pageToken,
        }),
      );

      if (response.statusCode != 200) {
        throw http.ClientException(
          'Listing $channel versions failed: ${response.statusCode}',
          response.request?.url,
        );
      }

      final page = jsonDecode(response.body) as Map<String, Object?>;
      if (page['prefixes'] case final List<Object?> prefixes) {
        versionPaths.addAll(prefixes.cast<String>());
      }
      pageToken = page['nextPageToken'] as String?;
    } while (pageToken != null);

    return versionPaths;
  }

  /// Fetches release information for [revision] in [channel].
  ///
  /// The [revision] is a version number, a legacy SVN revision, or `latest`.
  /// Includes the creation time of the `VERSION` object, if available.
  Future<VersionInfo> fetchVersion(String channel, String revision) async {
    final path = 'channels/$channel/release/$revision/VERSION';
    final (contents, metadata) = await (
      _api.downloadObject(_archiveBucket, path),
      _api.objectMetadata(_archiveBucket, path),
    ).wait;
    final versionJson =
        jsonDecode(ascii.decode(contents)) as Map<String, Object?>;

    return VersionInfo.parse(
      channel,
      revision,
      versionJson,
      creationTime: metadata.timeCreated?.toDateTime(),
    );
  }

  /// Closes the HTTP client, including one supplied at construction.
  ///
  /// Don't call other methods after closing this instance.
  void close() => _api.close();
}
