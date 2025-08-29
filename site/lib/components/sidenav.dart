import 'package:jaspr/jaspr.dart';

sealed class NavEntry {
  const NavEntry();

  const factory NavEntry.header(String title) = _NavHeader;
  const factory NavEntry.divider() = _NavDivider;
  const factory NavEntry.link(String title, String permalink) = _NavLink;
  const factory NavEntry.section(
    String title,
    List<NavEntry> children, {
    bool expanded,
  }) = _NavSection;
}

final class _NavHeader extends NavEntry {
  final String title;

  const _NavHeader(this.title);
}

final class _NavDivider extends NavEntry {
  const _NavDivider();
}

final class _NavLink extends NavEntry {
  final String title;
  final String permalink;

  const _NavLink(this.title, this.permalink);
}

final class _NavSection extends NavEntry {
  final String title;
  final List<NavEntry> children;
  final bool expanded;

  const _NavSection(
    this.title,
    this.children, {
    this.expanded = false,
  });
}

final class SideNav extends StatelessComponent {
  SideNav({
    super.key,
    required this.navEntries,
    required this.currentPageUrl,
  });

  final List<NavEntry> navEntries;
  final String currentPageUrl;

  late final List<int> activeIndices = () {
    // TODO(parlough): This was directly converted from the JS implementation.
    //   When reworking sidenav, rewrite this or at least make functions pure.
    void visitPermalinks(
      List<NavEntry> entries,
      String targetUrl,
      List<int> currentPath,
      Map<String, List<int>> results,
    ) {
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        late final newPath = [...currentPath, i];

        switch (entry) {
          case _NavDivider() || _NavHeader():
            // Skip dividers and headers.
            continue;
          case _NavLink(:final permalink) when !permalink.contains('://'):
            // Add internal links to results.
            final normalizedPermalink = permalink.startsWith('/')
                ? permalink
                : '/$permalink';
            results[normalizedPermalink] = newPath;
          case _NavSection(:final children):
            visitPermalinks(children, targetUrl, newPath, results);
          case _NavLink():
            // Ignore non-internal links.
            continue;
        }
      }
    }

    final results = <String, List<int>>{};
    visitPermalinks(navEntries, currentPageUrl, [], results);

    // Find the best match (longest/most specific).
    ({String permalink, List<int> result})? bestMatch;
    for (final MapEntry(key: permalink, value: result) in results.entries) {
      if (currentPageUrl == permalink ||
          currentPageUrl.startsWith('$permalink/')) {
        if (bestMatch == null ||
            permalink.length > bestMatch.permalink.length) {
          bestMatch = (permalink: permalink, result: result);
        }
      }
    }

    return bestMatch?.result ?? const [];
  }();

  /// Builds a navigation structure from YAML/JSON data.
  ///
  /// Expects data in the format used by `sidenav.yml`.
  static List<NavEntry> navEntriesFromData(List<Object?> data) => data
      .map(
        (item) => switch (item) {
          'divider' => const NavEntry.divider(),
          Map<String, Object?>() => _buildNavEntry(item),
          _ => throw ArgumentError('Invalid nav entry format: $item'),
        },
      )
      .toList(growable: false);

  static NavEntry _buildNavEntry(Map<String, Object?> item) {
    // Check for special entries that indicate a different entry type.
    if (item.containsKey('header')) {
      return NavEntry.header(item['header'] as String);
    }

    final title = item['title'] as String?;
    if (title == null) {
      throw ArgumentError(
        'Non-divider and non-header nav entries must '
        "have a 'title' specified.",
      );
    }

    final childrenData = item['children'] as List<Object?>?;

    if (childrenData != null) {
      // If specified, build children recursively.
      final children = navEntriesFromData(childrenData);
      if (children.isNotEmpty) {
        final expanded = item['expanded'] as bool? ?? false;
        return NavEntry.section(title, children, expanded: expanded);
      }
    } else {
      final permalink = item['permalink'] as String?;
      if (permalink != null) {
        return NavEntry.link(title, permalink);
      }
    }

    throw ArgumentError('Invalid nav entry format: $item');
  }

  @override
  Component build(BuildContext context) {
    return div(id: 'sidenav', [
      form(action: '/search/', classes: 'site-header-search form-inline', [
        input(
          classes: 'site-header-searchfield search-field',
          type: InputType.search,
          name: 'q',
          id: 'search-side',
          attributes: {
            'autocomplete': 'off',
            'placeholder': 'Search',
            'aria-label': 'Search',
          },
        ),
      ]),
      ul(classes: 'navbar-nav', [
        li(
          attributes: {'aria-hidden': 'true'},
          [div(classes: 'sidenav-divider', [])],
        ),
        li(classes: 'nav-item', [
          a(href: '/overview', classes: 'nav-link', [text('Overview')]),
        ]),
        li(classes: 'nav-item', [
          a(href: '/community', classes: 'nav-link', [text('Community')]),
        ]),
        li(classes: 'nav-item', [
          a(href: 'https://dartpad.dev', classes: 'nav-link', [
            text('Try Dart'),
          ]),
        ]),
        li(classes: 'nav-item', [
          a(href: '/get-dart', classes: 'nav-link', [text('Get Dart')]),
        ]),
        li(classes: 'nav-item', [
          a(href: '/docs', classes: 'nav-link', [text('Docs')]),
        ]),
        li(
          attributes: {'aria-hidden': 'true'},
          [div(classes: 'sidenav-divider', [])],
        ),
      ]),
      ul(
        classes: 'nav',
        _buildNavLevel(navEntries, 'docs', 0, possiblyActive: true),
      ),
    ]);
  }

  List<Component> _buildNavLevel(
    List<NavEntry> entries,
    String parentId,
    int currentLevel, {
    required bool possiblyActive,
  }) {
    final components = <Component>[];

    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      final id = '$parentId-${i + 1}';

      // Check if this entry is in the active path.
      final isInActivePath =
          possiblyActive &&
          currentLevel < activeIndices.length &&
          activeIndices[currentLevel] == i;

      // Check if this is the actual active page.
      final isActivePage =
          isInActivePath && currentLevel == activeIndices.length - 1;

      components.add(switch (entry) {
        _NavDivider() => _buildDivider(currentLevel),
        _NavHeader(:final title) => _buildHeader(title),
        _NavSection() => _buildCollapsibleSection(
          entry,
          id,
          isInActivePath,
          currentLevel,
        ),
        _NavLink() => _buildLink(entry, isActivePage),
      });
    }

    return components;
  }

  Component _buildDivider(int level) => level == 0
      ? li(
          attributes: {'aria-hidden': 'true'},
          [div(classes: 'sidenav-divider', [])],
        )
      : div(classes: 'sidenav-divider', []);

  Component _buildHeader(String title) =>
      li(classes: 'nav-header', [text(title)]);

  Component _buildCollapsibleSection(
    _NavSection section,
    String id,
    bool isInActivePath,
    int currentLevel,
  ) {
    // Expand if this section is in the active path or marked as expanded.
    final expanded = isInActivePath || section.expanded;
    final classes = [
      'nav-link',
      if (isInActivePath) 'active',
      'collapsible',
      if (!expanded) 'collapsed',
    ];

    return li(classes: 'nav-item', [
      button(
        classes: classes.join(' '),
        attributes: {
          'data-toggle': 'collapse',
          'data-target': '#$id',
          'role': 'button',
          'aria-expanded': expanded.toString(),
          'aria-controls': id,
        },
        [
          span([text(section.title)]),
          span(
            classes: 'material-symbols expander',
            attributes: {'aria-hidden': 'true'},
            [text('expand_more')],
          ),
        ],
      ),
      ul(
        classes: [
          'nav',
          'collapse',
          if (expanded) 'show',
        ].where((c) => c.isNotEmpty).join(' '),
        id: id,
        _buildNavLevel(
          section.children,
          id,
          currentLevel + 1,
          possiblyActive: isInActivePath,
        ),
      ),
    ]);
  }

  Component _buildLink(_NavLink link, bool isActive) {
    final isExternal = link.permalink.contains('://');
    final classes = ['nav-link', if (isActive) 'active'];

    return li(classes: 'nav-item', [
      a(
        classes: classes.join(' '),
        href: link.permalink,
        target: isExternal ? Target.blank : null,
        attributes: isExternal ? {'rel': 'noopener'} : null,
        [
          div([
            span([text(link.title)]),
            if (isExternal)
              span(
                classes: 'material-symbols',
                attributes: {'aria-hidden': 'true'},
                [text('open_in_new')],
              ),
          ]),
        ],
      ),
    ]);
  }
}
