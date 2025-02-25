import 'package:jaspr/jaspr.dart';

import '../version_selector.dart';

typedef VersionRow =
    ({
      String version,
      String? ref,
      String os,
      String arch,
      String date,
      List<({String label, String url, bool hasSha256})> archives,
    });

class ArchivesTable extends StatelessComponent {
  const ArchivesTable({required this.selector, super.key});

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

  final VersionSelector selector;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    yield ListenableBuilder(
      listenable: selector,
      builder: (context) sync* {
        final channel = selector.channel;

        yield form(classes: 'form-inline', [
          div(classes: 'form-group select', [
            label(htmlFor: '$channel-versions', [text('Version:')]),
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
                    [text(version)],
                  ),
              ],
            ),
          ]),
          div(classes: 'form-group select', [
            label(htmlFor: '$channel-os', [text('OS:')]),
            select(
              id: '$channel-os',
              value: selector.selectedOs,
              onChange: (values) {
                selector.selectedOs = values.first;
              },
              [
                option(value: 'all', selected: selector.selectedOs == 'all', [
                  text('All'),
                ]),
                option(
                  value: 'macos',
                  id: '$channel-macos',
                  classes: 'macos-option',
                  selected: selector.selectedOs == 'macos',
                  [text('macOS')],
                ),
                option(
                  value: 'linux',
                  id: '$channel-linux',
                  classes: 'linux-option',
                  selected: selector.selectedOs == 'linux',
                  [text('Linux')],
                ),
                option(
                  value: 'windows',
                  id: '$channel-windows',
                  classes: 'windows-option',
                  selected: selector.selectedOs == 'windows',
                  [text('Windows')],
                ),
              ],
            ),
          ]),
        ]);

        yield table(id: channel, classes: 'table', [
          thead([
            tr([
              th([text('Version')]),
              th([text('OS')]),
              th([text('Architecture')]),
              th([text('Release date')]),
              th([text('Downloads')]),
            ]),
          ]),
          tbody([
            for (final version in selector.versionRows)
              tr(
                classes: selector.isVersionVisible(version) ? null : 'hidden',
                attributes: {
                  'data-version': version.version,
                  'data-os': version.os.toLowerCase(),
                },
                [
                  td([
                    text(version.version),
                    if (version.ref != null) //
                      span(classes: 'muted', [text(' (${version.ref})')]),
                  ]),
                  td([text(version.os)]),
                  td([text(version.arch)]),
                  td([text(version.date)]),
                  td(classes: 'archives', [
                    for (final archive in version.archives) ...[
                      if (archive != version.archives.first) //
                        br(),
                      a(href: archive.url, [text(archive.label)]),
                      if (archive.hasSha256) //
                        a(href: '${archive.url}.sha256sum', [
                          text(' (SHA-256)'),
                        ]),
                    ],
                  ]),
                ],
              ),
          ]),
        ]);
      },
    );
  }
}
