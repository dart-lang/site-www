// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'version_selector.dart'
    if (dart.library.js_interop) 'client_version_selector.dart';

typedef VersionRow = ({
  String version,
  String? ref,
  String os,
  String arch,
  String date,
  List<({String label, String url, bool hasSha256})> archives,
});

@client
final class ArchiveTable extends StatelessComponent {
  ArchiveTable({required this.channel, super.key});

  /// Creates an [ArchiveTable] from a set of attributes parsed from markdown.
  factory ArchiveTable.fromAttributes(Map<String, String> attributes) {
    final channel =
        attributes['channel'] ??
        (throw Exception(
          'ArchiveTable component requires a "channel" attribute.',
        ));
    return ArchiveTable(channel: channel);
  }

  static VersionRow templateRow(String channel) {
    return (
      version: switch (channel) {
        'stable' => '0.0.0',
        'beta' => '0.0.0-0.0.beta',
        'dev' => '0.0.0-0.0.dev',
        _ => '0.0.0',
      },
      ref: 'ref 00000',
      os: '---',
      arch: '---',
      date: '01/01/1970',
      archives: [],
    );
  }

  final String channel;
  late final VersionSelector selector = VersionSelector(channel);

  @override
  Component build(BuildContext context) => div(
    classes: 'archive-table',
    attributes: {'data-channel': channel},
    [
      ListenableBuilder(
        listenable: selector,
        builder: (context) {
          final channel = selector.channel;

          return Component.fragment(
            [
              form(classes: 'form-inline', [
                div(classes: 'form-group select', [
                  label(htmlFor: '$channel-versions', [
                    const .text('Version:'),
                  ]),
                  select(
                    id: '$channel-versions',
                    value: selector.selectedVersion,
                    onChange: (values) {
                      selector.selectedVersion = values.first;
                    },
                    [
                      for (final version
                          in selector.versions
                                  ?.map((v) => v.canonicalizedVersion)
                                  .toList() ??
                              <String>[]) //
                        option(
                          value: version,
                          selected: version == selector.selectedVersion,
                          [.text(version)],
                        ),
                    ],
                  ),
                ]),
                div(classes: 'form-group select', [
                  label(htmlFor: '$channel-os', [const .text('OS:')]),
                  select(
                    id: '$channel-os',
                    value: selector.selectedOs,
                    onChange: (values) {
                      selector.selectedOs = values.first;
                    },
                    [
                      option(
                        value: 'all',
                        selected: selector.selectedOs == 'all',
                        [
                          const .text('All'),
                        ],
                      ),
                      option(
                        value: 'macos',
                        id: '$channel-macos',
                        classes: 'macos-option',
                        selected: selector.selectedOs == 'macos',
                        [const .text('macOS')],
                      ),
                      option(
                        value: 'linux',
                        id: '$channel-linux',
                        classes: 'linux-option',
                        selected: selector.selectedOs == 'linux',
                        [const .text('Linux')],
                      ),
                      option(
                        value: 'windows',
                        id: '$channel-windows',
                        classes: 'windows-option',
                        selected: selector.selectedOs == 'windows',
                        [const .text('Windows')],
                      ),
                    ],
                  ),
                ]),
              ]),

              div(classes: 'table-wrapper', [
                table(id: channel, classes: 'table', [
                  const thead([
                    tr([
                      th([.text('Version')]),
                      th([.text('OS')]),
                      th([.text('Architecture')]),
                      th([.text('Release date')]),
                      th([.text('Downloads')]),
                    ]),
                  ]),
                  tbody([
                    for (final version in selector.versionRows)
                      tr(
                        classes: selector.isVersionVisible(version)
                            ? null
                            : 'hidden',
                        attributes: {
                          'data-version': version.version,
                          'data-os': version.os.toLowerCase(),
                        },
                        [
                          td([
                            .text(version.version),
                            if (version.ref != null) //
                              span(classes: 'muted', [
                                .text(' (${version.ref})'),
                              ]),
                          ]),
                          td([.text(version.os)]),
                          td([.text(version.arch)]),
                          td([.text(version.date)]),
                          td(classes: 'archives', [
                            for (final archive in version.archives) ...[
                              if (archive != version.archives.first) const br(),
                              a(href: archive.url, [.text(archive.label)]),
                              if (archive.hasSha256)
                                a(href: '${archive.url}.sha256sum', [
                                  const .text(' (SHA-256)'),
                                ]),
                            ],
                          ]),
                        ],
                      ),
                  ]),
                ]),
              ]),
            ],
          );
        },
      ),
    ],
  );
}
