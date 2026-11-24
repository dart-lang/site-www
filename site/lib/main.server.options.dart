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
import 'package:dart_dev_site/src/components/common/client/page_header_options.dart'
    as _page_header_options;
import 'package:dart_dev_site/src/components/dartpad/dartpad_injector.dart'
    as _dartpad_dartpad_injector;
import 'package:dart_dev_site/src/components/layout/site_switcher.dart'
    as _layout_site_switcher;
import 'package:dart_dev_site/src/components/pages/changelog/changelog_filters.dart'
    as _changelog_filters;
import 'package:dart_dev_site/src/components/pages/changelog/changelog_filters_sidebar.dart'
    as _changelog_filters_sidebar;
import 'package:dart_dev_site/src/components/pages/glossary_search_section.dart'
    as _glossary_search_section;
import 'package:dart_dev_site/src/components/pages/lint_filter_search_section.dart'
    as _lint_filter_search_section;
import 'package:jaspr_content/components/file_tree.dart' as _file_tree;
import 'package:jaspr_content/components/post_break.dart' as _post_break;
import 'package:site_shared/components/common/client/collapse_button.dart'
    as _collapse_button;
import 'package:site_shared/components/common/client/expandable.dart'
    as _expandable;
import 'package:site_shared/components/common/client/feedback.dart'
    as _feedback;
import 'package:site_shared/components/common/client/on_this_page_button.dart'
    as _on_this_page_button;
import 'package:site_shared/components/common/client/simple_tooltip.dart'
    as _simple_tooltip;
import 'package:site_shared/components/common/client/tabs.dart' as _tabs;
import 'package:site_shared/components/common/client/trigger.dart' as _trigger;
import 'package:site_shared/components/dartpad/dartpad_injector.dart'
    as _dartpad_injector;
import 'package:site_shared/components/layout/menu_toggle.dart' as _menu_toggle;
import 'package:site_shared/components/layout/site_switcher.dart'
    as _site_switcher;
import 'package:site_shared/components/layout/theme_switcher.dart'
    as _theme_switcher;
import 'package:site_shared/components/tutorial/client/quiz.dart' as _quiz;
import 'package:site_shared/components/tutorial/client/stepper.dart'
    as _stepper;

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
    _page_header_options.PageHeaderOptions:
        ClientTarget<_page_header_options.PageHeaderOptions>(
          'page_header_options',
          params: __page_header_optionsPageHeaderOptions,
        ),
    _dartpad_dartpad_injector.DartPadInjector:
        ClientTarget<_dartpad_dartpad_injector.DartPadInjector>(
          'dartpad/dartpad_injector',
          params: __dartpad_dartpad_injectorDartPadInjector,
        ),
    _layout_site_switcher.SiteSwitcher:
        ClientTarget<_layout_site_switcher.SiteSwitcher>(
          'layout/site_switcher',
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
    _collapse_button.CollapseButton:
        ClientTarget<_collapse_button.CollapseButton>(
          'site_shared:collapse_button',
          params: __collapse_buttonCollapseButton,
        ),
    _expandable.Expandable: ClientTarget<_expandable.Expandable>(
      'site_shared:expandable',
      params: __expandableExpandable,
    ),
    _feedback.FeedbackComponent: ClientTarget<_feedback.FeedbackComponent>(
      'site_shared:feedback',
      params: __feedbackFeedbackComponent,
    ),
    _on_this_page_button.OnThisPageButton:
        ClientTarget<_on_this_page_button.OnThisPageButton>(
          'site_shared:on_this_page_button',
        ),
    _simple_tooltip.SimpleTooltip: ClientTarget<_simple_tooltip.SimpleTooltip>(
      'site_shared:simple_tooltip',
      params: __simple_tooltipSimpleTooltip,
    ),
    _tabs.InteractiveDashTabs: ClientTarget<_tabs.InteractiveDashTabs>(
      'site_shared:tabs',
      params: __tabsInteractiveDashTabs,
    ),
    _trigger.Trigger: ClientTarget<_trigger.Trigger>(
      'site_shared:trigger',
      params: __triggerTrigger,
    ),
    _dartpad_injector.DartPadInjector:
        ClientTarget<_dartpad_injector.DartPadInjector>(
          'site_shared:dartpad_injector',
          params: __dartpad_injectorDartPadInjector,
        ),
    _menu_toggle.MenuToggle: ClientTarget<_menu_toggle.MenuToggle>(
      'site_shared:menu_toggle',
    ),
    _site_switcher.SiteSwitcher: ClientTarget<_site_switcher.SiteSwitcher>(
      'site_shared:site_switcher',
      params: __site_switcherSiteSwitcher,
    ),
    _theme_switcher.ThemeSwitcher: ClientTarget<_theme_switcher.ThemeSwitcher>(
      'site_shared:theme_switcher',
    ),
    _quiz.InteractiveQuiz: ClientTarget<_quiz.InteractiveQuiz>(
      'site_shared:quiz',
      params: __quizInteractiveQuiz,
    ),
    _stepper.InteractiveStepper: ClientTarget<_stepper.InteractiveStepper>(
      'site_shared:stepper',
      params: __stepperInteractiveStepper,
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
Map<String, Object?> __page_header_optionsPageHeaderOptions(
  _page_header_options.PageHeaderOptions c,
) => {
  'title': c.title,
  'markdownUrl': c.markdownUrl,
  'sourceUrl': c.sourceUrl,
  'issueUrl': c.issueUrl,
};
Map<String, Object?> __dartpad_dartpad_injectorDartPadInjector(
  _dartpad_dartpad_injector.DartPadInjector c,
) => {
  'title': c.title,
  'height': c.height,
  'theme': c.theme,
  'runAutomatically': c.runAutomatically,
};
Map<String, Object?> __collapse_buttonCollapseButton(
  _collapse_button.CollapseButton c,
) => {'classes': c.classes, 'title': c.title};
Map<String, Object?> __expandableExpandable(_expandable.Expandable c) => {
  'id': c.id,
  'initiallyExpanded': c.initiallyExpanded,
  'child': c.child,
};
Map<String, Object?> __feedbackFeedbackComponent(
  _feedback.FeedbackComponent c,
) => {'issueUrl': c.issueUrl};
Map<String, Object?> __simple_tooltipSimpleTooltip(
  _simple_tooltip.SimpleTooltip c,
) => {'target': c.target, 'content': c.content};
Map<String, Object?> __tabsInteractiveDashTabs(_tabs.InteractiveDashTabs c) => {
  'id': c.id,
  'tabs': c.tabs.map((i) => i.encode()).toList(),
  'saveKey': c.saveKey,
  'wrapped': c.wrapped,
};
Map<String, Object?> __triggerTrigger(_trigger.Trigger c) => {'child': c.child};
Map<String, Object?> __dartpad_injectorDartPadInjector(
  _dartpad_injector.DartPadInjector c,
) => {
  'title': c.title,
  'theme': c.theme,
  'height': c.height,
  'runAutomatically': c.runAutomatically,
};
Map<String, Object?> __site_switcherSiteSwitcher(
  _site_switcher.SiteSwitcher c,
) => {'isFlutter': c.isFlutter};
Map<String, Object?> __quizInteractiveQuiz(_quiz.InteractiveQuiz c) => {
  'title': c.title,
  'questions': c.questions.map((i) => i.toJson()).toList(),
};
Map<String, Object?> __stepperInteractiveStepper(
  _stepper.InteractiveStepper c,
) => {
  'steps': c.steps.map((i) => i.encode()).toList(),
  'collapsible': c.collapsible,
  'showActions': c.showActions,
  'showFinish': c.showFinish,
};
