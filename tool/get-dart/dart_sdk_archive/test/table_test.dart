// ignore_for_file: lines_longer_than_80_chars

@TestOn('browser')
library;

import 'dart:convert';

import 'package:dart_sdk_archive/src/components/archive_table.dart';
import 'package:dart_sdk_archive/src/util.dart';
import 'package:dart_sdk_archive/src/version_selector.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:intl/intl.dart';
import 'package:jaspr_test/browser_test.dart';
import 'package:sdk_builds/sdk_builds.dart';
import 'package:web/web.dart' hide Response;

void main() {
  group('archive table', () {
    late DartDownloads dartDownloads;

    setUpAll(() {
      debugIsTest = true;
      Intl.systemLocale = 'en_US';
    });

    setUp(() {
      dartDownloads = DartDownloads(
        client: MockClient((r) async {
          final data = mockDataForUrl(r.url.toString());
          if (data == null) {
            throw Exception('No mock data for ${r.url}');
          }
          return Response(
            jsonEncode(data),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
      );
    });

    testBrowser('renders table with default os and version', (tester) async {
      final selector = VersionSelector(
        channel: 'stable',
        client: dartDownloads,
      );

      tester.pumpComponent(ArchivesTable(selector: selector));

      final versionSelect =
          tester.findNode(find.tag('select').at(0)) as HTMLSelectElement;
      expect(versionSelect, isNotNull);

      final osSelect =
          tester.findNode(find.tag('select').at(1)) as HTMLSelectElement;
      expect(osSelect, isNotNull);

      expect(selector.selectedVersion, null);
      expect(versionSelect.value, '');

      expect(selector.selectedOs, 'linux');
      expect(osSelect.value, 'linux');

      // Check the header and template rows.
      expect(find.tag('tr'), findsNComponents(2));

      // Await loading versions.
      await pumpEventQueue();

      expect(selector.selectedVersion, '4.0.0');
      expect(versionSelect.value, '4.0.0');

      // 3 mac, 4 linux, 2 windows, 1 docs
      expect(find.tag('tr'), findsNComponents(10));
    });

    testBrowser('updates rows on os change', (tester) async {
      final selector = VersionSelector(
        channel: 'stable',
        client: dartDownloads,
      );

      tester.pumpComponent(ArchivesTable(selector: selector));

      // Await loading versions.
      await pumpEventQueue();

      // 1 header, 2 mac, 4 linux, 2 windows, 1 docs
      expect(find.tag('tr'), findsNComponents(10));

      final table = tester.findNode(find.tag('tbody')) as HTMLElement;
      final nodes = table.childNodes;

      int countVisibleNodes() {
        var count = 0;
        for (var i = 0; i < nodes.length; i++) {
          if ((nodes.item(i) as HTMLElement).className.contains('hidden')) {
            continue;
          }
          count++;
        }
        return count;
      }

      selector.selectedOs = 'macos';
      await pumpEventQueue();
      expect(countVisibleNodes(), 3);

      selector.selectedOs = 'linux';
      await pumpEventQueue();
      expect(countVisibleNodes(), 5);

      selector.selectedOs = 'windows';
      await pumpEventQueue();
      expect(countVisibleNodes(), 3);

      selector.selectedOs = 'all';
      await pumpEventQueue();
      expect(countVisibleNodes(), 9);

      expect(table.outerHTML.toString(), equals(nodesHtmlV400));
    });

    testBrowser('loads rows on version change', (tester) async {
      final selector = VersionSelector(
        channel: 'stable',
        client: dartDownloads,
      );
      selector.selectedOs = 'all';

      tester.pumpComponent(ArchivesTable(selector: selector));

      // Await loading versions.
      await pumpEventQueue();

      expect(selector.selectedVersion, '4.0.0');

      // 3 mac, 4 linux, 2 windows, 1 docs
      expect(find.tag('tr'), findsNComponents(10));

      final table = tester.findNode(find.tag('tbody')) as HTMLElement;

      expect(table.outerHTML.toString(), equals(nodesHtmlV400));

      selector.selectedVersion = '1.2.3';

      // Await loading versions.
      await pumpEventQueue();

      expect(table.outerHTML.toString(), equals(nodesHtmlV123));
    });
  });
}

const nodesHtmlV400 =
    '<tbody><tr data-version="4.0.0" data-os="macos"><td>4.0.0<span class="muted"> (ref ae7ca51)</span></td><td>macOS</td><td>x64</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-macos-x64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-macos-x64-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="4.0.0" data-os="macos"><td>4.0.0<span class="muted"> (ref ae7ca51)</span></td><td>macOS</td><td>ARM64</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-macos-arm64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-macos-arm64-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="4.0.0" data-os="linux"><td>4.0.0<span class="muted"> (ref ae7ca51)</span></td><td>Linux</td><td>x64</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-linux-x64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-linux-x64-release.zip.sha256sum"> (SHA-256)</a><br><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/linux_packages/dart_4.0.0-1_amd64.deb">Debian package</a></td></tr>'
    '<tr data-version="4.0.0" data-os="linux"><td>4.0.0<span class="muted"> (ref ae7ca51)</span></td><td>Linux</td><td>ARMv8 (ARM64)</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-linux-arm64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-linux-arm64-release.zip.sha256sum"> (SHA-256)</a><br><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/linux_packages/dart_4.0.0-1_arm64.deb">Debian package</a></td></tr>'
    '<tr data-version="4.0.0" data-os="linux"><td>4.0.0<span class="muted"> (ref ae7ca51)</span></td><td>Linux</td><td>ARMv7</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-linux-arm-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-linux-arm-release.zip.sha256sum"> (SHA-256)</a><br><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/linux_packages/dart_4.0.0-1_armhf.deb">Debian package</a></td></tr>'
    '<tr data-version="4.0.0" data-os="linux"><td>4.0.0<span class="muted"> (ref ae7ca51)</span></td><td>Linux</td><td>RISC-V (RV64GC)</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-linux-riscv64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-linux-riscv64-release.zip.sha256sum"> (SHA-256)</a><br><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/linux_packages/dart_4.0.0-1_riscv64.deb">Debian package</a></td></tr>'
    '<tr data-version="4.0.0" data-os="windows"><td>4.0.0<span class="muted"> (ref ae7ca51)</span></td><td>Windows</td><td>x64</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-windows-x64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-windows-x64-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="4.0.0" data-os="windows"><td>4.0.0<span class="muted"> (ref ae7ca51)</span></td><td>Windows</td><td>ARM64</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-windows-arm64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/sdk/dartsdk-windows-arm64-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="4.0.0" data-os="---"><td>4.0.0<span class="muted"> (ref ae7ca51)</span></td><td>---</td><td>---</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/4.0.0/api-docs/dartdocs-gen-api.zip">API Docs</a></td></tr></tbody>';

const nodesHtmlV123 =
    '<tbody><tr data-version="1.2.3" data-os="macos"><td>1.2.3<span class="muted"> (ref ae7ca51)</span></td><td>macOS</td><td>x64</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-macos-x64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-macos-x64-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="1.2.3" data-os="macos"><td>1.2.3<span class="muted"> (ref ae7ca51)</span></td><td>macOS</td><td>IA32</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-macos-ia32-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-macos-ia32-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="1.2.3" data-os="linux"><td>1.2.3<span class="muted"> (ref ae7ca51)</span></td><td>Linux</td><td>x64</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-linux-x64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-linux-x64-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="1.2.3" data-os="linux"><td>1.2.3<span class="muted"> (ref ae7ca51)</span></td><td>Linux</td><td>IA32</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-linux-ia32-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-linux-ia32-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="1.2.3" data-os="linux"><td>1.2.3<span class="muted"> (ref ae7ca51)</span></td><td>Linux</td><td>ARMv8 (ARM64)</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-linux-arm64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-linux-arm64-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="1.2.3" data-os="linux"><td>1.2.3<span class="muted"> (ref ae7ca51)</span></td><td>Linux</td><td>ARMv7</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-linux-arm-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-linux-arm-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="1.2.3" data-os="windows"><td>1.2.3<span class="muted"> (ref ae7ca51)</span></td><td>Windows</td><td>x64</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-windows-x64-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-windows-x64-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="1.2.3" data-os="windows"><td>1.2.3<span class="muted"> (ref ae7ca51)</span></td><td>Windows</td><td>IA32</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-windows-ia32-release.zip">Dart SDK</a><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/sdk/dartsdk-windows-ia32-release.zip.sha256sum"> (SHA-256)</a></td></tr>'
    '<tr data-version="1.2.3" data-os="---"><td>1.2.3<span class="muted"> (ref ae7ca51)</span></td><td>---</td><td>---</td><td>Dec 11, 2024</td><td class="archives"><a href="https://storage.googleapis.com/dart-archive/channels/stable/release/1.2.3/api-docs/dartdocs-gen-api.zip">API Docs</a></td></tr></tbody>';

const versionListUrl =
    'https://storage.googleapis.com/storage/v1/b/dart-archive/'
    'o?delimiter=%2F&prefix=channels%2Fstable%2Frelease%2F&alt=json';
final versionInfoRegex = RegExp(
  r'https://storage\.googleapis\.com/storage/v1/b/dart-archive/'
  r'o/channels%2Fstable%2Frelease%2F(\d\.\d\.\d)%2FVERSION\?alt=(media|json)',
);

Map<String, Object>? mockDataForUrl(String url) {
  if (url == versionListUrl) {
    return {
      'kind': 'storage#objects',
      'prefixes': [
        'channels/stable/release/1.1.1/',
        'channels/stable/release/1.2.3/',
        'channels/stable/release/4.0.0/',
      ],
    };
  }

  if (versionInfoRegex.firstMatch(url) case final match?) {
    final v = match.group(1)!;
    final t = match.group(2)!;
    if (t == 'media') {
      return {
        'date': '2024-01-01',
        'version': v,
        'revision': 'ae7ca5199a0559db0ae60533e9cedd3ce0d6ab04',
      };
    }

    return {
      'kind': 'storage#object',
      'id': 'dart-archive/channels/stable/release/$v/VERSION/1733924366537130',
      'selfLink':
          'https://www.googleapis.com/storage/v1/b/dart-archive/o/channels%2Fstable%2Frelease%2F$v%2FVERSION',
      'mediaLink':
          'https://storage.googleapis.com/download/storage/v1/b/dart-archive/o/channels%2Fstable%2Frelease%2F$v%2FVERSION?generation=1733924366537130&alt=media',
      'name': 'channels/stable/release/$v/VERSION',
      'bucket': 'dart-archive',
      'generation': '1733924366537130',
      'metageneration': '1',
      'contentType': 'application/octet-stream',
      'storageClass': 'MULTI_REGIONAL',
      'size': '106',
      'md5Hash': 'LJdvyoa8HREN2YliMcmsLw==',
      'crc32c': 'QOr1VQ==',
      'etag': 'CKqjvc/rn4oDEAE=',
      'timeCreated': '2024-12-11T13:39:26.565Z',
      'updated': '2024-12-11T13:39:26.565Z',
      'timeStorageClassUpdated': '2024-12-11T13:39:26.565Z',
      'timeFinalized': '2024-12-11T13:39:26.565Z',
    };
  }

  return null;
}
