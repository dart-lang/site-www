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
import 'package:dart_dev_site/src/components/common/client/page_header_options.dart'
    as prefix6;
import 'package:dart_dev_site/src/components/dartpad/dartpad_injector.dart'
    as prefix7;
import 'package:dart_dev_site/src/components/layout/menu_toggle.dart'
    as prefix8;
import 'package:dart_dev_site/src/components/layout/site_switcher.dart'
    as prefix9;
import 'package:dart_dev_site/src/components/layout/theme_switcher.dart'
    as prefix10;
import 'package:dart_dev_site/src/components/pages/glossary_search_section.dart'
    as prefix11;
import 'package:dart_dev_site/src/components/pages/lint_filter_search_section.dart'
    as prefix12;
import 'package:jaspr_content/components/file_tree.dart' as prefix13;

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

    prefix6.PageHeaderOptions: ClientTarget<prefix6.PageHeaderOptions>(
      'src/components/common/client/page_header_options',
      params: _prefix6PageHeaderOptions,
    ),

    prefix7.DartPadInjector: ClientTarget<prefix7.DartPadInjector>(
      'src/components/dartpad/dartpad_injector',
      params: _prefix7DartPadInjector,
    ),

    prefix8.MenuToggle: ClientTarget<prefix8.MenuToggle>(
      'src/components/layout/menu_toggle',
    ),

    prefix9.SiteSwitcher: ClientTarget<prefix9.SiteSwitcher>(
      'src/components/layout/site_switcher',
    ),

    prefix10.ThemeSwitcher: ClientTarget<prefix10.ThemeSwitcher>(
      'src/components/layout/theme_switcher',
    ),

    prefix11.GlossarySearchSection:
        ClientTarget<prefix11.GlossarySearchSection>(
          'src/components/pages/glossary_search_section',
        ),

    prefix12.LintFilterSearchSection:
        ClientTarget<prefix12.LintFilterSearchSection>(
          'src/components/pages/lint_filter_search_section',
        ),
  },
  styles: () => [...prefix13.FileTree.styles],
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
Map<String, dynamic> _prefix6PageHeaderOptions(prefix6.PageHeaderOptions c) => {
  'title': c.title,
  'sourceUrl': c.sourceUrl,
  'issueUrl': c.issueUrl,
};
Map<String, dynamic> _prefix7DartPadInjector(prefix7.DartPadInjector c) => {
  'title': c.title,
  'theme': c.theme,
  'height': c.height,
  'runAutomatically': c.runAutomatically,
};
