import 'dart:html';

import 'package:dart_sdk_archive/src/version_selector.dart';
import 'package:http/browser_client.dart';
import 'package:sdk_builds/sdk_builds.dart';

Future<void> runApp() async {
  var client = DartDownloads(client: BrowserClient());

  var stableSelector = VersionSelector(
    'stable',
    client,
    querySelector('#stable') as TableElement,
    querySelector('#stable-versions') as SelectElement,
    querySelector('#stable-os') as SelectElement,
  );

  var betaSelector = VersionSelector(
    'beta',
    client,
    querySelector('#beta') as TableElement,
    querySelector('#beta-versions') as SelectElement,
    querySelector('#beta-os') as SelectElement,
  );

  var devSelector = VersionSelector(
    'dev',
    client,
    querySelector('#dev') as TableElement,
    querySelector('#dev-versions') as SelectElement,
    querySelector('#dev-os') as SelectElement,
  );

  // ignore: unawaited_futures
  stableSelector.init();
  // ignore: unawaited_futures
  betaSelector.init();
  // ignore: unawaited_futures
  devSelector.init();
}
