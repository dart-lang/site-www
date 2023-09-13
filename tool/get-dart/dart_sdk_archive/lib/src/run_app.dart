import 'dart:async';
import 'dart:html';

import 'package:dart_sdk_archive/src/version_selector.dart';
import 'package:http/browser_client.dart';
import 'package:sdk_builds/sdk_builds.dart';

Future<void> runApp() async {
  final client = DartDownloads(client: BrowserClient());

  final stableSelector = VersionSelector(
    'stable',
    client,
    querySelector('#stable') as TableElement,
    querySelector('#stable-versions') as SelectElement,
    querySelector('#stable-os') as SelectElement,
  );

  final betaSelector = VersionSelector(
    'beta',
    client,
    querySelector('#beta') as TableElement,
    querySelector('#beta-versions') as SelectElement,
    querySelector('#beta-os') as SelectElement,
  );

  final devSelector = VersionSelector(
    'dev',
    client,
    querySelector('#dev') as TableElement,
    querySelector('#dev-versions') as SelectElement,
    querySelector('#dev-os') as SelectElement,
  );

  unawaited(stableSelector.init());
  unawaited(betaSelector.init());
  unawaited(devSelector.init());
}
