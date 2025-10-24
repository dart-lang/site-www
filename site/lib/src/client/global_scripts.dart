// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

/// Global scripts converted from JS.
///
/// These are temporary until they can be integrated with their
/// relevant Jaspr components.
@client
final class GlobalScripts extends StatefulComponent {
  @override
  State<StatefulComponent> createState() => _GlobalScriptsState();
}

final class _GlobalScriptsState extends State<GlobalScripts> {
  @override
  void initState() {
    if (kIsWeb) {
      // Run setup if DOM is loaded, otherwise do it after it has loaded.
      if (web.document.readyState == 'loading') {
        web.document.addEventListener('DOMContentLoaded', _setUpSite.toJS);
      } else {
        _setUpSite();
      }
    }

    super.initState();
  }

  @override
  Component build(BuildContext context) => const Component.empty();
}

void _setUpSite() {
  _setUpSidenav();
  _setUpSearchKeybindings();
  _setUpTabs();
  _setUpGallery();
  _setUpExpandableCards();
  _setUpTableOfContents();
}

void _setUpSidenav() {
  final sidenav = web.document.getElementById('sidenav');
  if (sidenav == null) return;
  final activeEntries = sidenav.querySelectorAll('a.nav-link.active');

  if (activeEntries.length > 0) {
    // Scroll the last active entry into view.
    // This is usually the most specific active entry.
    final lastActiveEntry = activeEntries.item(activeEntries.length - 1);
    if (lastActiveEntry case final web.HTMLElement lastActiveEntry) {
      sidenav.scrollTo(
        web.ScrollToOptions(
          top: lastActiveEntry.offsetTop - (web.window.innerHeight / 3),
        ),
      );
    }
  }

  // Set up collapse and expand for sidenav buttons.
  final toggles = web.document.querySelectorAll('.nav-link.collapsible');
  for (var i = 0; i < toggles.length; i++) {
    final toggle = toggles.item(i) as web.HTMLElement;
    toggle.addEventListener(
      'click',
      (web.Event e) {
        toggle.classList.toggle('collapsed');
        e.preventDefault();
      }.toJS,
    );
  }
}

void _setUpSearchKeybindings() {
  web.document.addEventListener('keydown', _handleSearchShortcut.toJS);
}

void _handleSearchShortcut(web.Event event) {
  final keyboardEvent = event as web.KeyboardEvent;
  final activeElement = web.document.activeElement;

  // Don't intercept if typing in an input field or not pressing slash key.
  if (activeElement.isA<web.HTMLInputElement>() ||
      activeElement.isA<web.HTMLTextAreaElement>() ||
      keyboardEvent.code != 'Slash') {
    return;
  }

  final web.Element? parentElement;
  // If the sidebar is open, focus its search field.
  if (web.document.body!.classList.contains('open_menu')) {
    parentElement = web.document.getElementById('sidenav');
  } else {
    // If the page has a search field in the body, focus that.
    if (web.document.getElementById('in-content-search')
        case final bodySearch?) {
      parentElement = bodySearch;
    } else {
      // Otherwise, fallback to the top navbar search field.
      parentElement = web.document.getElementById('header-search');
    }
  }

  // If we found any search field, focus it.
  if (parentElement?.querySelector('.search-field')
      case final web.HTMLElement searchField) {
    searchField.focus();
    // Prevent the initial slash from showing up in the search field.
    event.preventDefault();
  }
}

// TODO(parlough): Migrate interactivity of tabs to the Jaspr components.
/// Set up interactivity of tabs created with
/// the `<Tabs>` and `<Tab>` custom components.
void _setUpTabs() {
  _updateTabsFromQueryParameters();

  final tabsWrappers = web.document.querySelectorAll('.tabs-wrapper');

  for (
    var wrapperIndex = 0;
    wrapperIndex < tabsWrappers.length;
    wrapperIndex++
  ) {
    final element = tabsWrappers.item(wrapperIndex) as web.HTMLElement;
    final saveKey = element.dataset['tabSaveKey'];
    final localStorageKey = saveKey.isNotEmpty ? 'tab-save-$saveKey' : null;
    final tabs = element.querySelectorAll(':scope > .nav-tabs a.nav-link');
    web.HTMLElement? tabToChangeTo;

    for (var tabIndex = 0; tabIndex < tabs.length; tabIndex++) {
      final tabElement = tabs.item(tabIndex) as web.HTMLElement;
      final saveId = tabElement.dataset['tabSaveId'];

      void handleClick(web.Event event) {
        event.preventDefault();
        final currentSaveKey = element.dataset['tabSaveKey'];
        final currentSaveId = tabElement.dataset['tabSaveId'];
        if (currentSaveKey.isNotEmpty && currentSaveId.isNotEmpty) {
          // If the tab wrapper and this tab have a save key and ID defined,
          // switch other tabs to the tab with the same ID.
          _findAndActivateTabsWithSaveId(currentSaveKey, currentSaveId);
          web.window.localStorage.setItem(
            'tab-save-$currentSaveKey',
            currentSaveId,
          );
        } else {
          _clearActiveTabs(tabs);
          _setActiveTab(tabElement);
        }
      }

      tabElement.addEventListener('click', handleClick.toJS);

      // If a tab was previously specified as selected in local storage,
      // save a reference to it that can be switched to later.
      if (saveId.isNotEmpty &&
          localStorageKey != null &&
          web.window.localStorage.getItem(localStorageKey) == saveId) {
        tabToChangeTo = tabElement;
      }
    }

    if (tabToChangeTo != null) {
      tabToChangeTo.click();
    } else if (saveKey == 'dev-os') {
      // If this tab wrapper is for the archive page,
      // and no tab was retrieved from local storage,
      // switch to the tab for the current OS.
      final currentOperatingSystem = _ClientOperatingSystem.fromUserAgent();

      _activateTabWithSaveId(element, currentOperatingSystem.name);
    }
  }
}

/// Apply force overrides from query parameters to saved tabs.
void _updateTabsFromQueryParameters() {
  final currentUrl = Uri.parse(web.window.location.href);
  final originalQueryParameters = currentUrl.queryParameters;
  final updatedQueryParameters = {...originalQueryParameters};

  for (final MapEntry(:key, :value) in originalQueryParameters.entries) {
    if (key.startsWith('tab-save-')) {
      web.window.localStorage.setItem(key, value);
      updatedQueryParameters.remove(key);
    }
  }

  if (originalQueryParameters.length != updatedQueryParameters.length) {
    // If the query parameters were updated, update the user's URL.
    web.window.history.replaceState(
      null,
      '',
      currentUrl.replace(queryParameters: updatedQueryParameters).toString(),
    );
  }
}

void _clearActiveTabs(web.NodeList tabs) {
  for (var tabIndex = 0; tabIndex < tabs.length; tabIndex++) {
    final tabElement = tabs.item(tabIndex) as web.HTMLElement;
    tabElement.classList.remove('active');
    tabElement.ariaSelected = 'false';
    final panelId = '${tabElement.id}-panel';
    final panel = web.document.getElementById(panelId);
    panel?.classList.remove('active');
  }
}

void _setActiveTab(web.HTMLElement tab) {
  tab.classList.add('active');
  tab.ariaSelected = 'true';
  final panelId = '${tab.id}-panel';
  final panel = web.document.getElementById(panelId);
  panel?.classList.add('active');
}

void _findAndActivateTabsWithSaveId(String saveKey, String saveId) {
  final tabsWrappers = web.document.querySelectorAll(
    '.tabs-wrapper[data-tab-save-key="$saveKey"]',
  );

  for (
    var wrapperIndex = 0;
    wrapperIndex < tabsWrappers.length;
    wrapperIndex++
  ) {
    final wrapper = tabsWrappers.item(wrapperIndex) as web.HTMLElement;

    _activateTabWithSaveId(wrapper, saveId);
  }
}

void _activateTabWithSaveId(web.HTMLElement tabWrapper, String saveId) {
  final tabsNav = tabWrapper.querySelector(':scope > .nav-tabs');
  if (tabsNav == null) return;

  if (tabsNav.querySelector('a.nav-link[data-tab-save-id="$saveId"]')
      case final web.HTMLElement tabToActivate) {
    final tabs = tabsNav.querySelectorAll('a.nav-link');
    _clearActiveTabs(tabs);
    _setActiveTab(tabToActivate);
  }
}

enum _ClientOperatingSystem {
  macos,
  windows,
  linux;

  static _ClientOperatingSystem fromUserAgent({
    _ClientOperatingSystem fallback = _ClientOperatingSystem.windows,
  }) {
    final userAgent = web.window.navigator.userAgent;
    if (userAgent.contains('Mac')) {
      // macOS, iOS, or iPadOS.
      return _ClientOperatingSystem.macos;
    }

    if (userAgent.contains('Win')) {
      // Windows.
      return _ClientOperatingSystem.windows;
    }

    if ((userAgent.contains('Linux') || userAgent.contains('X11')) &&
        !userAgent.contains('Android')) {
      // Linux, but not Android.
      return _ClientOperatingSystem.linux;
    }

    if (userAgent.contains('CrOS')) {
      // ChromeOS, but fall back to Linux.
      return _ClientOperatingSystem.linux;
    }

    return fallback;
  }
}

void _setUpGallery() {
  final galleries = [
    'galleryOne',
    'galleryTwo',
    'galleryThree',
    'galleryFour',
    'galleryFive',
    'gallerySix',
  ];

  void switchBanner(
    web.Element selector,
    web.NodeList selectors,
    String galleryName,
  ) {
    for (var i = 0; i < selectors.length; i++) {
      final selector = selectors.item(i) as web.Element;
      selector.classList.remove('highlight');
    }

    selector.classList.add('highlight');

    final imgSelector = web.document.querySelector('.$galleryName');
    imgSelector?.setAttribute(
      'src',
      selector.getAttribute('data-banner') ?? '',
    );
  }

  for (final galleryName in galleries) {
    final selectors = web.document.querySelectorAll(
      '#$galleryName .selector li',
    );

    for (var i = 0; i < selectors.length; i++) {
      final selector = selectors.item(i) as web.Element;

      selector.addEventListener(
        'mouseover',
        ((web.Event _) {
          switchBanner(selector, selectors, galleryName);
        }).toJS,
      );

      selector.addEventListener(
        'focus',
        ((web.Event _) {
          switchBanner(selector, selectors, galleryName);
        }).toJS,
      );
    }
  }
}

void _setUpExpandableCards() {
  var currentFragment = web.window.location.hash.trim().toLowerCase();
  if (currentFragment.startsWith('#')) {
    // Remove the leading '#' from the fragment.
    currentFragment = currentFragment.substring(1);
  }
  final expandableCards = web.document.querySelectorAll('.expandable-card');

  for (var i = 0; i < expandableCards.length; i++) {
    final card = expandableCards.item(i) as web.Element;
    final expandButton = card.querySelector('.expand-button');
    if (expandButton == null) continue;

    expandButton.addEventListener(
      'click',
      ((web.Event e) {
        if (card.classList.contains('collapsed')) {
          card.classList.remove('collapsed');
          expandButton.ariaExpanded = 'true';
        } else {
          card.classList.add('collapsed');
          expandButton.ariaExpanded = 'false';
        }
        e.preventDefault();
      }).toJS,
    );

    if (card.id != currentFragment) {
      card.classList.add('collapsed');
      expandButton.ariaExpanded = 'false';
    }
  }
}

void _setUpTableOfContents() {
  _setUpTocActiveObserver();
  _setUpInlineTocDropdown();
}

void _setUpInlineTocDropdown() {
  final inlineToc = web.document.getElementById('toc-top');
  if (inlineToc == null) return;

  final dropdownButton = inlineToc.querySelector('.dropdown-button');
  final dropdownMenu = inlineToc.querySelector('.dropdown-content');
  if (dropdownButton == null || dropdownMenu == null) return;

  void closeMenu() {
    inlineToc.setAttribute('data-expanded', 'false');
    dropdownButton.ariaExpanded = 'false';
  }

  dropdownButton.addEventListener(
    'click',
    ((web.Event _) {
      print(inlineToc.getAttribute('data-expanded'));
      if (inlineToc.getAttribute('data-expanded') == 'true') {
        closeMenu();
      } else {
        inlineToc.setAttribute('data-expanded', 'true');
        dropdownButton.ariaExpanded = 'true';
      }
    }).toJS,
  );

  web.document.addEventListener(
    'keydown',
    ((web.KeyboardEvent event) {
      if (event.key == 'Escape') {
        closeMenu();
      }
    }).toJS,
  );

  // Close the dropdown if any link in the TOC is navigated to.
  final inlineTocLinks = inlineToc.querySelectorAll('a');
  for (var i = 0; i < inlineTocLinks.length; i++) {
    final tocLink = inlineTocLinks.item(i) as web.Element;
    tocLink.addEventListener(
      'click',
      ((web.Event _) {
        closeMenu();
      }).toJS,
    );
  }

  // Close the dropdown if anywhere not in the inline TOC is clicked.
  web.document.addEventListener(
    'click',
    ((web.Event event) {
      if ((event.target as web.Element).closest('#toc-top') != null) {
        return;
      }
      closeMenu();
    }).toJS,
  );
}

void _setUpTocActiveObserver() {
  final headings = web.document.querySelectorAll(
    'article .header-wrapper, #site-content-title',
  );
  final currentHeaderText = web.document.getElementById('current-header');

  // No need to have toc scrollspy if there is only one non-title heading.
  if (headings.length < 2 || currentHeaderText == null) return;

  final visibleAnchors = <String>{};
  final initialHeaderText = currentHeaderText.textContent;

  final observer = web.IntersectionObserver(
    ((JSArray<web.IntersectionObserverEntry> entries) {
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final headingId = entry.target.querySelector('h1, h2, h3')?.id;
        if (headingId == null) return;

        if (entry.isIntersecting) {
          visibleAnchors.add(headingId);
        } else {
          visibleAnchors.remove(headingId);
        }
      }

      if (visibleAnchors.isNotEmpty) {
        var isFirst = true;

        // If the page title is visible, set the current header to its contents.
        if (visibleAnchors.contains('document-title')) {
          currentHeaderText.textContent = initialHeaderText;
          isFirst = false;
        }

        final tocLinks = web.document.querySelectorAll(
          '.site-toc .sidenav-item a',
        );
        for (var i = 0; i < tocLinks.length; i++) {
          final tocLink = tocLinks.item(i) as web.Element;
          final headingId = tocLink.getAttribute('href')?.substring(1);
          if (headingId == null) return;

          final sidenavItem = tocLink.closest('.sidenav-item');
          if (sidenavItem == null) return;

          if (visibleAnchors.contains(headingId)) {
            sidenavItem.classList.add('active');

            if (isFirst) {
              currentHeaderText.textContent = tocLink.textContent;
              isFirst = false;
            }
          } else {
            sidenavItem.classList.remove('active');
          }
        }
      }
    }).toJS,
    web.IntersectionObserverInit(rootMargin: '-80px 0px -25% 0px'),
  );

  for (var i = 0; i < headings.length; i++) {
    observer.observe(headings.item(i) as web.Element);
  }
}
