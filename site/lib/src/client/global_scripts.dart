// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

import '../utils/client_operating_system.dart';

/// Global scripts converted from JS.
///
/// These are temporary until they can be integrated with their
/// relevant Jaspr components.
void setUpSite() {
  _setUpHeadingLinkCopy();
  _setUpSidenav();
  _setUpSearchKeybindings();
  _setUpGallery();
  _setUpPlatformKeys();
  _setUpTableOfContents();
  _setUpReleaseTags();
  _setUpTooltips();
}

void _setUpHeadingLinkCopy() {
  final anchors = web.document.querySelectorAll(
    'a.heading-link[href]',
  );

  for (var i = 0; i < anchors.length; i++) {
    final anchor = anchors.item(i) as web.HTMLAnchorElement;

    // Store the original text before any click handlers modify it.
    final originalText = anchor.textContent;

    @awaitNotRequired
    Future<void> copyAnchorToClipboard(String url) async {
      try {
        await web.window.navigator.clipboard.writeText(url).toDart;
        // TODO: Replace this with a tooltip of some sort.
        anchor.textContent = 'Link copied!';

        Future<void>.delayed(const Duration(milliseconds: 1200), () {
          anchor.textContent = originalText;
        });
      } catch (_) {
        anchor.textContent = 'Failed to copy';
      }
    }

    anchor.addEventListener(
      'click',
      ((web.Event event) {
        event.preventDefault();

        final fragment = anchor.hash;
        if (!fragment.startsWith('#')) return;

        final headingId = fragment.substring(1);
        if (headingId.isEmpty) return;

        final url = Uri.parse(
          web.window.location.href,
        ).replace(fragment: headingId).toString();

        // Update the URL hash without triggering a scroll jump.
        web.window.history.replaceState(null, '', '#$headingId');

        copyAnchorToClipboard(url);
      }).toJS,
    );
  }
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

void _setUpPlatformKeys() {
  final specialKey = switch (ClientOperatingSystem.fromUserAgent()) {
    .macos => 'Command',
    _ => 'Control',
  };
  final keys = web.document.querySelectorAll('kbd.special-key');
  for (var i = 0; i < keys.length; i += 1) {
    final element = keys.item(i) as web.Element;
    element.textContent = specialKey;
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

void _setUpReleaseTags() {
  void updatePlaceholders(String channel, String version) {
    final revisionElements = web.document.querySelectorAll(
      '.build-rev-$channel',
    );
    for (var i = 0; i < revisionElements.length; i++) {
      final revisionElement = revisionElements.item(i) as web.Element;
      revisionElement.textContent = version;
    }

    if (channel == 'stable') {
      final download =
          'https://storage.googleapis.com/dart-archive/channels/$channel/release/latest/linux_packages/dart_$version-1_amd64.deb';
      final targets = web.document.querySelectorAll('.debian-link-stable');
      for (var i = 0; i < targets.length; i++) {
        final target = targets.item(i) as web.Element;
        target.setAttribute('href', download);
      }
    }
  }

  void fetchVersion(String channel) async {
    final response = await http.get(
      Uri.https(
        'storage.googleapis.com',
        'dart-archive/channels/$channel/release/latest/VERSION',
      ),
    );
    final data = jsonDecode(response.body) as Map<String, Object?>;
    updatePlaceholders(channel, data['version'] as String);
  }

  fetchVersion('stable');
  fetchVersion('beta');
  fetchVersion('dev');
}

void _setUpTooltips() {
  final tooltipWrappers = web.document.querySelectorAll('.tooltip-wrapper');

  final isTouchscreen = web.window.matchMedia('(pointer: coarse)').matches;

  void setup({required bool setUpClickListener}) {
    for (var i = 0; i < tooltipWrappers.length; i++) {
      final linkWrapper = tooltipWrappers.item(i) as web.HTMLElement;
      final target = linkWrapper.querySelector('.tooltip-target');
      final tooltip = linkWrapper.querySelector('.tooltip') as web.HTMLElement?;

      if (target == null || tooltip == null) {
        continue;
      }
      _ensureVisible(tooltip);

      if (setUpClickListener && isTouchscreen) {
        // On touchscreen devices, toggle tooltip visibility on tap.
        target.addEventListener(
          'click',
          ((web.Event e) {
            final isVisible = tooltip.classList.contains('visible');
            if (isVisible) {
              tooltip.classList.remove('visible');
            } else {
              tooltip.classList.add('visible');
            }
            e.preventDefault();
          }).toJS,
        );
      }
    }
  }

  void closeAll() {
    final visibleTooltips = web.document.querySelectorAll(
      '.tooltip.visible',
    );
    for (var i = 0; i < visibleTooltips.length; i++) {
      final tooltip = visibleTooltips.item(i) as web.HTMLElement;
      tooltip.classList.remove('visible');
    }
  }

  setup(setUpClickListener: true);

  // Reposition tooltips on window resize.
  web.EventStreamProviders.resizeEvent.forTarget(web.window).listen((_) {
    setup(setUpClickListener: false);
  });

  // Close tooltips when clicking outside of any tooltip wrapper.
  web.EventStreamProviders.clickEvent.forTarget(web.document).listen((e) {
    if ((e.target as web.Element).closest('.tooltip-wrapper') == null) {
      closeAll();
    }
  });

  // On touchscreen devices, close tooltips when scrolling.
  if (isTouchscreen) {
    web.EventStreamProviders.scrollEvent.forTarget(web.window).listen((_) {
      closeAll();
    });
  }
}

/// Adjust the tooltip position to ensure it is fully inside the
/// ancestor .content element.
void _ensureVisible(web.HTMLElement tooltip) {
  final containerRect = tooltip.closest('.content')!.getBoundingClientRect();
  final tooltipRect = tooltip.getBoundingClientRect();
  final offset = double.parse(tooltip.getAttribute('data-adjusted') ?? '0');

  final tooltipLeft = tooltipRect.left - offset;
  final tooltipRight = tooltipRect.right - offset;

  if (tooltipLeft < containerRect.left) {
    final offset = containerRect.left - tooltipLeft;
    tooltip.style.left = 'calc(50% + ${offset}px)';
    tooltip.dataset['adjusted'] = offset.toString();
  } else if (tooltipRight > containerRect.right) {
    final offset = tooltipRight - containerRect.right;
    tooltip.style.left = 'calc(50% - ${offset}px)';
    tooltip.dataset['adjusted'] = (-offset).toString();
  } else {
    tooltip.style.left = '50%';
    tooltip.dataset['adjusted'] = '0';
  }
}
