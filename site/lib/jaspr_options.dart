// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:dart_dev_site/src/archive/archive_table.dart' as prefix0;
import 'package:dart_dev_site/src/client/global_scripts.dart' as prefix1;
import 'package:dart_dev_site/src/components/client/dartpad_injector.dart'
    as prefix2;
import 'package:dart_dev_site/src/components/client/on_this_page_button.dart'
    as prefix3;
import 'package:dart_dev_site/src/components/header/menu_toggle.dart'
    as prefix4;
import 'package:dart_dev_site/src/components/header/site_switcher.dart'
    as prefix5;
import 'package:dart_dev_site/src/components/header/theme_switcher.dart'
    as prefix6;
import 'package:dart_dev_site/src/components/cookie_notice.dart' as prefix7;
import 'package:dart_dev_site/src/components/copy_button.dart' as prefix8;
import 'package:dart_dev_site/src/components/feedback.dart' as prefix9;

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

    prefix2.DartPadInjector: ClientTarget<prefix2.DartPadInjector>(
      'src/components/client/dartpad_injector',
      params: _prefix2DartPadInjector,
    ),

    prefix3.OnThisPageButton: ClientTarget<prefix3.OnThisPageButton>(
      'src/components/client/on_this_page_button',
    ),

    prefix7.CookieNotice: ClientTarget<prefix7.CookieNotice>(
      'src/components/cookie_notice',
    ),

    prefix8.CopyButton: ClientTarget<prefix8.CopyButton>(
      'src/components/copy_button',
      params: _prefix8CopyButton,
    ),

    prefix9.FeedbackComponent: ClientTarget<prefix9.FeedbackComponent>(
      'src/components/feedback',
      params: _prefix9FeedbackComponent,
    ),

    prefix4.MenuToggle: ClientTarget<prefix4.MenuToggle>(
      'src/components/header/menu_toggle',
    ),

    prefix5.SiteSwitcher: ClientTarget<prefix5.SiteSwitcher>(
      'src/components/header/site_switcher',
    ),

    prefix6.ThemeSwitcher: ClientTarget<prefix6.ThemeSwitcher>(
      'src/components/header/theme_switcher',
    ),
  },
  styles: () => [],
);

Map<String, dynamic> _prefix0ArchiveTable(prefix0.ArchiveTable c) => {
  'channel': c.channel,
};
Map<String, dynamic> _prefix2DartPadInjector(prefix2.DartPadInjector c) => {
  'title': c.title,
  'theme': c.theme,
  'height': c.height,
};
Map<String, dynamic> _prefix8CopyButton(prefix8.CopyButton c) => {
  'toCopy': c.toCopy,
  'buttonText': c.buttonText,
  'classes': c.classes,
  'title': c.title,
};
Map<String, dynamic> _prefix9FeedbackComponent(prefix9.FeedbackComponent c) => {
  'issueUrl': c.issueUrl,
};
