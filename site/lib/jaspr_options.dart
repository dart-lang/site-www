// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:dart_dev_site/src/archive/archive_table.dart' as prefix0;
import 'package:dart_dev_site/src/components/cookie_notice.dart' as prefix1;

/// Default [JasprOptions] for use with your jaspr project.
///
/// Use this to initialize jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'jaspr_options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultJasprOptions,
///   );
///
///   runApp(...);
/// }
/// ```
JasprOptions get defaultJasprOptions => JasprOptions(
  clients: {
    prefix0.ArchiveTable: ClientTarget<prefix0.ArchiveTable>(
      'src/archive/archive_table',
      params: _prefix0ArchiveTable,
    ),

    prefix1.CookieNotice: ClientTarget<prefix1.CookieNotice>(
      'src/components/cookie_notice',
    ),
  },
  styles: () => [],
);

Map<String, dynamic> _prefix0ArchiveTable(prefix0.ArchiveTable c) => {
  'channel': c.channel,
};
