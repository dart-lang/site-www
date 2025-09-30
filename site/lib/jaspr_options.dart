// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:dart_dev_site/src/archive/archive_table.dart' as prefix0;
import 'package:dart_dev_site/src/client/global_scripts.dart' as prefix1;
import 'package:dart_dev_site/src/components/header/site_switcher.dart'
    as prefix2;
import 'package:dart_dev_site/src/components/header/theme_switcher.dart'
    as prefix3;
import 'package:dart_dev_site/src/components/cookie_notice.dart' as prefix4;
import 'package:dart_dev_site/src/components/copy_button.dart' as prefix5;
import 'package:dart_dev_site/src/components/feedback.dart' as prefix6;

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

    prefix1.GlobalScripts: ClientTarget<prefix1.GlobalScripts>(
      'src/client/global_scripts',
    ),

    prefix4.CookieNotice: ClientTarget<prefix4.CookieNotice>(
      'src/components/cookie_notice',
    ),

    prefix5.CopyButton: ClientTarget<prefix5.CopyButton>(
      'src/components/copy_button',
      params: _prefix5CopyButton,
    ),

    prefix6.FeedbackComponent: ClientTarget<prefix6.FeedbackComponent>(
      'src/components/feedback',
      params: _prefix6FeedbackComponent,
    ),

    prefix2.SiteSwitcher: ClientTarget<prefix2.SiteSwitcher>(
      'src/components/header/site_switcher',
    ),

    prefix3.ThemeSwitcher: ClientTarget<prefix3.ThemeSwitcher>(
      'src/components/header/theme_switcher',
    ),
  },
  styles: () => [],
);

Map<String, dynamic> _prefix0ArchiveTable(prefix0.ArchiveTable c) => {
  'channel': c.channel,
};
Map<String, dynamic> _prefix5CopyButton(prefix5.CopyButton c) => {
  'toCopy': c.toCopy,
  'buttonText': c.buttonText,
  'classes': c.classes,
  'title': c.title,
};
Map<String, dynamic> _prefix6FeedbackComponent(prefix6.FeedbackComponent c) => {
  'issueUrl': c.issueUrl,
};
