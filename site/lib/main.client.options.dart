// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:dart_dev_site/src/archive/archive_table.dart'
    deferred as _archive_table;
import 'package:dart_dev_site/src/components/blog/blog_list.dart'
    deferred as _blog_list;
import 'package:dart_dev_site/src/components/common/client/collapse_button.dart'
    deferred as _collapse_button;
import 'package:dart_dev_site/src/components/common/client/cookie_notice.dart'
    deferred as _cookie_notice;
import 'package:dart_dev_site/src/components/common/client/copy_button.dart'
    deferred as _copy_button;
import 'package:dart_dev_site/src/components/common/client/feedback.dart'
    deferred as _feedback;
import 'package:dart_dev_site/src/components/common/client/on_this_page_button.dart'
    deferred as _on_this_page_button;
import 'package:dart_dev_site/src/components/dartpad/dartpad_injector.dart'
    deferred as _dartpad_injector;
import 'package:dart_dev_site/src/components/layout/menu_toggle.dart'
    deferred as _menu_toggle;
import 'package:dart_dev_site/src/components/layout/site_switcher.dart'
    deferred as _site_switcher;
import 'package:dart_dev_site/src/components/layout/theme_switcher.dart'
    deferred as _theme_switcher;
import 'package:dart_dev_site/src/components/pages/glossary_search_section.dart'
    deferred as _glossary_search_section;
import 'package:dart_dev_site/src/components/pages/lint_filter_search_section.dart'
    deferred as _lint_filter_search_section;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'archive_table': ClientLoader(
      (p) => _archive_table.ArchiveTable(channel: p['channel'] as String),
      loader: _archive_table.loadLibrary,
    ),
    'blog_list': ClientLoader(
      (p) => _blog_list.BlogList(
        posts: (p['posts'] as List<Object?>)
            .map((i) => (i as Map<String, Object?>))
            .toList(),
      ),
      loader: _blog_list.loadLibrary,
    ),
    'collapse_button': ClientLoader(
      (p) => _collapse_button.CollapseButton(
        classes: (p['classes'] as List<Object?>).cast<String>(),
        title: p['title'] as String?,
      ),
      loader: _collapse_button.loadLibrary,
    ),
    'cookie_notice': ClientLoader(
      (p) => _cookie_notice.CookieNotice(),
      loader: _cookie_notice.loadLibrary,
    ),
    'copy_button': ClientLoader(
      (p) => _copy_button.CopyButton(
        buttonText: p['buttonText'] as String?,
        toCopy: p['toCopy'] as String?,
        classes: (p['classes'] as List<Object?>).cast<String>(),
        title: p['title'] as String?,
      ),
      loader: _copy_button.loadLibrary,
    ),
    'feedback': ClientLoader(
      (p) => _feedback.FeedbackComponent(issueUrl: p['issueUrl'] as String),
      loader: _feedback.loadLibrary,
    ),
    'on_this_page_button': ClientLoader(
      (p) => _on_this_page_button.OnThisPageButton(),
      loader: _on_this_page_button.loadLibrary,
    ),
    'dartpad_injector': ClientLoader(
      (p) => _dartpad_injector.DartPadInjector(
        title: p['title'] as String,
        theme: p['theme'] as String?,
        height: p['height'] as String?,
        runAutomatically: p['runAutomatically'] as bool,
      ),
      loader: _dartpad_injector.loadLibrary,
    ),
    'menu_toggle': ClientLoader(
      (p) => _menu_toggle.MenuToggle(),
      loader: _menu_toggle.loadLibrary,
    ),
    'site_switcher': ClientLoader(
      (p) => _site_switcher.SiteSwitcher(),
      loader: _site_switcher.loadLibrary,
    ),
    'theme_switcher': ClientLoader(
      (p) => _theme_switcher.ThemeSwitcher(),
      loader: _theme_switcher.loadLibrary,
    ),
    'glossary_search_section': ClientLoader(
      (p) => _glossary_search_section.GlossarySearchSection(),
      loader: _glossary_search_section.loadLibrary,
    ),
    'lint_filter_search_section': ClientLoader(
      (p) => _lint_filter_search_section.LintFilterSearchSection(),
      loader: _lint_filter_search_section.loadLibrary,
    ),
  },
);
