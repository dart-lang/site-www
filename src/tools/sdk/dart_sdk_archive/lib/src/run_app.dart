import 'dart:html';

import 'package:dart_sdk_archive/src/version_selector.dart';
import 'package:http/browser_client.dart';
import 'package:pedantic/pedantic.dart';
import 'package:sdk_builds/sdk_builds.dart';

Future runApp() async {
  var client = DartDownloads(client: BrowserClient());

  var stableSelector = VersionSelector(
      'stable',
      client,
      querySelector('#stable'),
      querySelector('#stable-versions'),
      querySelector('#stable-os'));

  var devSelector = VersionSelector(
    'dev',
    client,
    querySelector('#dev'),
    querySelector('#dev-versions'),
    querySelector('#dev-os'),
  );

  unawaited(stableSelector.init());
  unawaited(devSelector.init());
}