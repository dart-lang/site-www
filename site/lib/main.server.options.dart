// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:dart_dev_site/src/archive/archive_table.dart' as _archive_table;
import 'package:dart_dev_site/src/components/blog/client/blog_categories.dart'
    as _blog_categories;
import 'package:dart_dev_site/src/components/blog/client/share_button.dart'
    as _share_button;
import 'package:dart_dev_site/src/components/common/client/collapse_button.dart'
    as _collapse_button;
import 'package:dart_dev_site/src/components/common/client/cookie_notice.dart'
    as _cookie_notice;
import 'package:dart_dev_site/src/components/common/client/copy_button.dart'
    as _copy_button;
import 'package:dart_dev_site/src/components/common/client/feedback.dart'
    as _feedback;
import 'package:dart_dev_site/src/components/common/client/on_this_page_button.dart'
    as _on_this_page_button;
import 'package:dart_dev_site/src/components/common/client/page_header_options.dart'
    as _page_header_options;
import 'package:dart_dev_site/src/components/dartpad/dartpad_injector.dart'
    as _dartpad_injector;
import 'package:dart_dev_site/src/components/layout/menu_toggle.dart'
    as _menu_toggle;
import 'package:dart_dev_site/src/components/layout/site_switcher.dart'
    as _site_switcher;
import 'package:dart_dev_site/src/components/layout/theme_switcher.dart'
    as _theme_switcher;
import 'package:dart_dev_site/src/components/pages/changelog/changelog_filters.dart'
    as _changelog_filters;
import 'package:dart_dev_site/src/components/pages/changelog/changelog_filters_sidebar.dart'
    as _changelog_filters_sidebar;
import 'package:dart_dev_site/src/components/pages/glossary_search_section.dart'
    as _glossary_search_section;
import 'package:dart_dev_site/src/components/pages/lint_filter_search_section.dart'
    as _lint_filter_search_section;
import 'package:dart_dev_site/src/components/tutorial/client/quiz.dart'
    as _quiz;
import 'package:jaspr_content/components/file_tree.dart' as _file_tree;
import 'package:jaspr_content/components/post_break.dart' as _post_break;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _archive_table.ArchiveTable: ClientTarget<_archive_table.ArchiveTable>(
      'archive_table',
      params: __archive_tableArchiveTable,
    ),
    _blog_categories.BlogCategories:
        ClientTarget<_blog_categories.BlogCategories>('blog_categories'),
    _share_button.ShareButton: ClientTarget<_share_button.ShareButton>(
      'share_button',
      params: __share_buttonShareButton,
    ),
    _collapse_button.CollapseButton:
        ClientTarget<_collapse_button.CollapseButton>(
          'collapse_button',
          params: __collapse_buttonCollapseButton,
        ),
    _cookie_notice.CookieNotice: ClientTarget<_cookie_notice.CookieNotice>(
      'cookie_notice',
      params: __cookie_noticeCookieNotice,
    ),
    _copy_button.CopyButton: ClientTarget<_copy_button.CopyButton>(
      'copy_button',
      params: __copy_buttonCopyButton,
    ),
    _feedback.FeedbackComponent: ClientTarget<_feedback.FeedbackComponent>(
      'feedback',
      params: __feedbackFeedbackComponent,
    ),
    _on_this_page_button.OnThisPageButton:
        ClientTarget<_on_this_page_button.OnThisPageButton>(
          'on_this_page_button',
        ),
    _page_header_options.PageHeaderOptions:
        ClientTarget<_page_header_options.PageHeaderOptions>(
          'page_header_options',
          params: __page_header_optionsPageHeaderOptions,
        ),
    _dartpad_injector.DartPadInjector:
        ClientTarget<_dartpad_injector.DartPadInjector>(
          'dartpad_injector',
          params: __dartpad_injectorDartPadInjector,
        ),
    _menu_toggle.MenuToggle: ClientTarget<_menu_toggle.MenuToggle>(
      'menu_toggle',
    ),
    _site_switcher.SiteSwitcher: ClientTarget<_site_switcher.SiteSwitcher>(
      'site_switcher',
    ),
    _theme_switcher.ThemeSwitcher: ClientTarget<_theme_switcher.ThemeSwitcher>(
      'theme_switcher',
    ),
    _changelog_filters.ChangelogFilters:
        ClientTarget<_changelog_filters.ChangelogFilters>('changelog_filters'),
    _changelog_filters_sidebar.ChangelogFiltersSidebar:
        ClientTarget<_changelog_filters_sidebar.ChangelogFiltersSidebar>(
          'changelog_filters_sidebar',
        ),
    _glossary_search_section.GlossarySearchSection:
        ClientTarget<_glossary_search_section.GlossarySearchSection>(
          'glossary_search_section',
        ),
    _lint_filter_search_section.LintFilterSearchSection:
        ClientTarget<_lint_filter_search_section.LintFilterSearchSection>(
          'lint_filter_search_section',
        ),
    _quiz.InteractiveQuiz: ClientTarget<_quiz.InteractiveQuiz>(
      'quiz',
      params: __quizInteractiveQuiz,
    ),
  },
  styles: () => [
    ..._file_tree.FileTree.styles,
    ..._post_break.PostBreak.styles,
  ],
);

Map<String, Object?> __archive_tableArchiveTable(
  _archive_table.ArchiveTable c,
) => {'channel': c.channel};
Map<String, Object?> __share_buttonShareButton(_share_button.ShareButton c) => {
  'url': c.url,
  'title': c.title,
};
Map<String, Object?> __collapse_buttonCollapseButton(
  _collapse_button.CollapseButton c,
) => {'classes': c.classes, 'title': c.title};
Map<String, Object?> __cookie_noticeCookieNotice(
  _cookie_notice.CookieNotice c,
) => {'alwaysDarkMode': c.alwaysDarkMode};
Map<String, Object?> __copy_buttonCopyButton(_copy_button.CopyButton c) => {
  'buttonText': c.buttonText,
  'toCopy': c.toCopy,
  'classes': c.classes,
  'title': c.title,
};
Map<String, Object?> __feedbackFeedbackComponent(
  _feedback.FeedbackComponent c,
) => {'issueUrl': c.issueUrl};
Map<String, Object?> __page_header_optionsPageHeaderOptions(
  _page_header_options.PageHeaderOptions c,
) => {'title': c.title, 'sourceUrl': c.sourceUrl, 'issueUrl': c.issueUrl};
Map<String, Object?> __dartpad_injectorDartPadInjector(
  _dartpad_injector.DartPadInjector c,
) => {
  'title': c.title,
  'theme': c.theme,
  'height': c.height,
  'runAutomatically': c.runAutomatically,
};
Map<String, Object?> __quizInteractiveQuiz(_quiz.InteractiveQuiz c) => {
  'title': c.title,
  'questions': c.questions.map((i) => i.toJson()).toList(),
};
