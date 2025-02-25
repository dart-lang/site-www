import 'dart:async';

import 'package:http/browser_client.dart';
import 'package:jaspr/browser.dart' as jaspr;
import 'package:sdk_builds/sdk_builds.dart';

import 'components/archive_table.dart';
import 'version_selector.dart';

const List<String> _allChannels = ['stable', 'beta', 'dev'];

Future<void> runApp() async {
  final client = DartDownloads(client: BrowserClient());

  for (final channel in _allChannels) {
    final selector = VersionSelector(channel: channel, client: client);
    jaspr.runApp(
      ArchivesTable(selector: selector),
      attachTo: '.archive-table[data-channel="$channel"]',
    );
  }
}
