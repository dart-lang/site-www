// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/jaspr.dart';
import 'package:dart_dev_site/src/archive/archive_table.dart' as prefix0;
import 'package:dart_dev_site/src/client/global_scripts.dart' as prefix1;
import 'package:dart_dev_site/src/components/common/client/cookie_notice.dart'
    as prefix2;
import 'package:dart_dev_site/src/components/common/client/copy_button.dart'
    as prefix3;
import 'package:dart_dev_site/src/components/common/client/feedback.dart'
    as prefix4;
import 'package:dart_dev_site/src/components/common/client/on_this_page_button.dart'
    as prefix5;
import 'package:dart_dev_site/src/components/dartpad/dartpad_injector.dart'
    as prefix6;
import 'package:dart_dev_site/src/components/layout/menu_toggle.dart'
    as prefix7;
import 'package:dart_dev_site/src/components/layout/site_switcher.dart'
    as prefix8;
import 'package:dart_dev_site/src/components/layout/theme_switcher.dart'
    as prefix9;
import 'package:dart_dev_site/src/components/pages/glossary_search_section.dart'
    as prefix10;
import 'package:dart_dev_site/src/components/pages/lint_filter_search_section.dart'
    as prefix11;

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

    prefix2.CookieNotice: ClientTarget<prefix2.CookieNotice>(
      'src/components/common/client/cookie_notice',
    ),

    prefix3.CopyButton: ClientTarget<prefix3.CopyButton>(
      'src/components/common/client/copy_button',
      params: _prefix3CopyButton,
    ),

    prefix4.FeedbackComponent: ClientTarget<prefix4.FeedbackComponent>(
      'src/components/common/client/feedback',
      params: _prefix4FeedbackComponent,
    ),

    prefix5.OnThisPageButton: ClientTarget<prefix5.OnThisPageButton>(
      'src/components/common/client/on_this_page_button',
    ),

    prefix6.DartPadInjector: ClientTarget<prefix6.DartPadInjector>(
      'src/components/dartpad/dartpad_injector',
      params: _prefix6DartPadInjector,
    ),

    prefix7.MenuToggle: ClientTarget<prefix7.MenuToggle>(
      'src/components/layout/menu_toggle',
    ),

    prefix8.SiteSwitcher: ClientTarget<prefix8.SiteSwitcher>(
      'src/components/layout/site_switcher',
    ),

    prefix9.ThemeSwitcher: ClientTarget<prefix9.ThemeSwitcher>(
      'src/components/layout/theme_switcher',
    ),

    prefix10.GlossarySearchSection:
        ClientTarget<prefix10.GlossarySearchSection>(
          'src/components/pages/glossary_search_section',
        ),

    prefix11.LintFilterSearchSection:
        ClientTarget<prefix11.LintFilterSearchSection>(
          'src/components/pages/lint_filter_search_section',
        ),
  },
  styles: () => [],
);

Map<String, dynamic> _prefix0ArchiveTable(prefix0.ArchiveTable c) => {
  'channel': c.channel,
};
Map<String, dynamic> _prefix3CopyButton(prefix3.CopyButton c) => {
  'toCopy': c.toCopy,
  'buttonText': c.buttonText,
  'classes': c.classes,
  'title': c.title,
};
Map<String, dynamic> _prefix4FeedbackComponent(prefix4.FeedbackComponent c) => {
  'issueUrl': c.issueUrl,
};
Map<String, dynamic> _prefix6DartPadInjector(prefix6.DartPadInjector c) => {
  'title': c.title,
  'theme': c.theme,
  'height': c.height,
  'runAutomatically': c.runAutomatically,
};
