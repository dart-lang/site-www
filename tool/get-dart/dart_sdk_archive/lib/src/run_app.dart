import 'dart:async';

import 'package:http/browser_client.dart';
import 'package:sdk_builds/sdk_builds.dart';
import 'package:web/web.dart';

import 'version_selector.dart';

Future<void> runApp() async {
  final client = DartDownloads(client: BrowserClient());

  final stableSelector = VersionSelector(
    'stable',
    client,
    document.getElementById('stable') as HTMLTableElement,
    document.getElementById('stable-versions') as HTMLSelectElement,
    document.getElementById('stable-os') as HTMLSelectElement,
  );

  final betaSelector = VersionSelector(
    'beta',
    client,
    document.getElementById('beta') as HTMLTableElement,
    document.getElementById('beta-versions') as HTMLSelectElement,
    document.getElementById('beta-os') as HTMLSelectElement,
  );

  final devSelector = VersionSelector(
    'dev',
    client,
    document.getElementById('dev') as HTMLTableElement,
    document.getElementById('dev-versions') as HTMLSelectElement,
    document.getElementById('dev-os') as HTMLSelectElement,
  );

  unawaited(stableSelector.init());
  unawaited(betaSelector.init());
  unawaited(devSelector.init());
}
