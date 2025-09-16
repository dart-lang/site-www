// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:dart_dev_site/src/archive/archive_table.dart' as prefix0;
import 'package:dart_dev_site/src/components/cookie_notice.dart' as prefix1;
import 'package:dart_dev_site/src/components/copy_button.dart' as prefix2;
import 'package:dart_dev_site/src/components/feedback.dart' as prefix3;

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

    prefix2.CopyButton: ClientTarget<prefix2.CopyButton>(
      'src/components/copy_button',
      params: _prefix2CopyButton,
    ),

    prefix3.FeedbackComponent: ClientTarget<prefix3.FeedbackComponent>(
      'src/components/feedback',
      params: _prefix3FeedbackComponent,
    ),
  },
  styles: () => [],
);

Map<String, dynamic> _prefix0ArchiveTable(prefix0.ArchiveTable c) => {
  'channel': c.channel,
};
Map<String, dynamic> _prefix2CopyButton(prefix2.CopyButton c) => {
  'toCopy': c.toCopy,
  'buttonText': c.buttonText,
  'classes': c.classes,
  'title': c.title,
};
Map<String, dynamic> _prefix3FeedbackComponent(prefix3.FeedbackComponent c) => {
  'issueUrl': c.issueUrl,
};
