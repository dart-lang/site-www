// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:dart_dev_site/src/archive/archive_table.dart'
    deferred as _archive_table;
import 'package:dart_dev_site/src/components/blog/client/blog_categories.dart'
    deferred as _blog_categories;
import 'package:dart_dev_site/src/components/blog/client/share_button.dart'
    deferred as _share_button;
import 'package:dart_dev_site/src/components/common/client/page_header_options.dart'
    deferred as _page_header_options;
import 'package:dart_dev_site/src/components/dartpad/dartpad_injector.dart'
    deferred as _dartpad_dartpad_injector;
import 'package:dart_dev_site/src/components/layout/site_switcher.dart'
    deferred as _layout_site_switcher;
import 'package:dart_dev_site/src/components/pages/changelog/changelog_filters.dart'
    deferred as _changelog_filters;
import 'package:dart_dev_site/src/components/pages/changelog/changelog_filters_sidebar.dart'
    deferred as _changelog_filters_sidebar;
import 'package:dart_dev_site/src/components/pages/glossary_search_section.dart'
    deferred as _glossary_search_section;
import 'package:dart_dev_site/src/components/pages/lint_filter_search_section.dart'
    deferred as _lint_filter_search_section;
import 'package:site_shared/components/common/client/collapse_button.dart'
    deferred as _collapse_button;
import 'package:site_shared/components/common/client/expandable.dart'
    deferred as _expandable;
import 'package:site_shared/components/common/client/feedback.dart'
    deferred as _feedback;
import 'package:site_shared/components/common/client/on_this_page_button.dart'
    deferred as _on_this_page_button;
import 'package:site_shared/components/common/client/simple_tooltip.dart'
    deferred as _simple_tooltip;
import 'package:site_shared/components/common/client/tabs.dart'
    deferred as _tabs;
import 'package:site_shared/components/common/client/trigger.dart'
    deferred as _trigger;
import 'package:site_shared/components/dartpad/dartpad_injector.dart'
    deferred as _dartpad_injector;
import 'package:site_shared/components/layout/menu_toggle.dart'
    deferred as _menu_toggle;
import 'package:site_shared/components/layout/site_switcher.dart'
    deferred as _site_switcher;
import 'package:site_shared/components/layout/theme_switcher.dart'
    deferred as _theme_switcher;
import 'package:site_shared/components/tutorial/client/quiz.dart'
    deferred as _quiz;
import 'package:site_shared/components/tutorial/client/stepper.dart'
    deferred as _stepper;
import 'package:site_shared/components/tutorial/models/quiz_model.dart'
    as _quiz_model;

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
      (p) => _archive_table.ArchiveTable(channel: p.get<String>('channel')),
      loader: _archive_table.loadLibrary,
    ),
    'blog_categories': ClientLoader(
      (p) => _blog_categories.BlogCategories(),
      loader: _blog_categories.loadLibrary,
    ),
    'share_button': ClientLoader(
      (p) => _share_button.ShareButton(
        url: p.get<String>('url'),
        title: p.get<String>('title'),
      ),
      loader: _share_button.loadLibrary,
    ),
    'page_header_options': ClientLoader(
      (p) => _page_header_options.PageHeaderOptions(
        title: p.get<String>('title'),
        markdownUrl: p.get<String?>('markdownUrl'),
        sourceUrl: p.get<String?>('sourceUrl'),
        issueUrl: p.get<String?>('issueUrl'),
      ),
      loader: _page_header_options.loadLibrary,
    ),
    'dartpad/dartpad_injector': ClientLoader(
      (p) => _dartpad_dartpad_injector.DartPadInjector(
        title: p.get<String>('title'),
        height: p.get<String>('height'),
        theme: p.get<String?>('theme'),
        runAutomatically: p.get<bool>('runAutomatically'),
      ),
      loader: _dartpad_dartpad_injector.loadLibrary,
    ),
    'layout/site_switcher': ClientLoader(
      (p) => _layout_site_switcher.SiteSwitcher(),
      loader: _layout_site_switcher.loadLibrary,
    ),
    'changelog_filters': ClientLoader(
      (p) => _changelog_filters.ChangelogFilters(),
      loader: _changelog_filters.loadLibrary,
    ),
    'changelog_filters_sidebar': ClientLoader(
      (p) => _changelog_filters_sidebar.ChangelogFiltersSidebar(),
      loader: _changelog_filters_sidebar.loadLibrary,
    ),
    'glossary_search_section': ClientLoader(
      (p) => _glossary_search_section.GlossarySearchSection(),
      loader: _glossary_search_section.loadLibrary,
    ),
    'lint_filter_search_section': ClientLoader(
      (p) => _lint_filter_search_section.LintFilterSearchSection(),
      loader: _lint_filter_search_section.loadLibrary,
    ),
    'site_shared:collapse_button': ClientLoader(
      (p) => _collapse_button.CollapseButton(
        classes: p.get<List<Object?>>('classes').cast<String>(),
        title: p.get<String?>('title'),
      ),
      loader: _collapse_button.loadLibrary,
    ),
    'site_shared:expandable': ClientLoader(
      (p) => _expandable.Expandable(
        id: p.get<String?>('id'),
        initiallyExpanded: p.get<bool>('initiallyExpanded'),
        child: p.mount(p.get<String>('child')),
      ),
      loader: _expandable.loadLibrary,
    ),
    'site_shared:feedback': ClientLoader(
      (p) => _feedback.FeedbackComponent(issueUrl: p.get<String>('issueUrl')),
      loader: _feedback.loadLibrary,
    ),
    'site_shared:on_this_page_button': ClientLoader(
      (p) => _on_this_page_button.OnThisPageButton(),
      loader: _on_this_page_button.loadLibrary,
    ),
    'site_shared:simple_tooltip': ClientLoader(
      (p) => _simple_tooltip.SimpleTooltip(
        target: p.mount(p.get<String>('target')),
        content: p.mount(p.get<String>('content')),
      ),
      loader: _simple_tooltip.loadLibrary,
    ),
    'site_shared:tabs': ClientLoader(
      (p) => _tabs.InteractiveDashTabs(
        id: p.get<String>('id'),
        tabs: p
            .get<List<Object?>>('tabs')
            .cast<Map<String, Object?>>()
            .map((i) => _tabs.DashTab.decode(i, p.mount))
            .toList(),
        saveKey: p.get<String?>('saveKey'),
        wrapped: p.get<bool>('wrapped'),
      ),
      loader: _tabs.loadLibrary,
    ),
    'site_shared:trigger': ClientLoader(
      (p) => _trigger.Trigger(child: p.mount(p.get<String>('child'))),
      loader: _trigger.loadLibrary,
    ),
    'site_shared:dartpad_injector': ClientLoader(
      (p) => _dartpad_injector.DartPadInjector(
        title: p.get<String>('title'),
        theme: p.get<String?>('theme'),
        height: p.get<String?>('height'),
        runAutomatically: p.get<bool>('runAutomatically'),
      ),
      loader: _dartpad_injector.loadLibrary,
    ),
    'site_shared:menu_toggle': ClientLoader(
      (p) => _menu_toggle.MenuToggle(),
      loader: _menu_toggle.loadLibrary,
    ),
    'site_shared:site_switcher': ClientLoader(
      (p) => _site_switcher.SiteSwitcher(isFlutter: p.get<bool>('isFlutter')),
      loader: _site_switcher.loadLibrary,
    ),
    'site_shared:theme_switcher': ClientLoader(
      (p) => _theme_switcher.ThemeSwitcher(),
      loader: _theme_switcher.loadLibrary,
    ),
    'site_shared:quiz': ClientLoader(
      (p) => _quiz.InteractiveQuiz(
        title: p.get<String?>('title'),
        questions: p
            .get<List<Object?>>('questions')
            .cast<Map<Object?, Object?>>()
            .map((i) => _quiz_model.Question.fromMap(i))
            .toList(),
      ),
      loader: _quiz.loadLibrary,
    ),
    'site_shared:stepper': ClientLoader(
      (p) => _stepper.InteractiveStepper(
        steps: p
            .get<List<Object?>>('steps')
            .cast<Map<String, Object?>>()
            .map((i) => _stepper.Step.decode(i, p.mount))
            .toList(),
        collapsible: p.get<bool>('collapsible'),
        showActions: p.get<bool>('showActions'),
        showFinish: p.get<bool>('showFinish'),
      ),
      loader: _stepper.loadLibrary,
    ),
  },
);
