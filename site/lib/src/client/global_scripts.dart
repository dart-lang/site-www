// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:site_shared/web_util.dart';
import 'package:universal_web/js_interop.dart';
import 'package:universal_web/web.dart' as web;

/// Global scripts converted from JS.
///
/// These are temporary until they can be integrated with their
/// relevant Jaspr components.
void setUpSite() {
  setUpCodeBlockCopyButtons();
  setUpHeadingLinkCopy();
  _setUpCopyButtons();
  _setUpSidenav();
  setUpSearchKeybindings();
  _setUpGallery();
  setUpPlatformKeys();
  _setUpTableOfContents();
  _setUpReleaseTags();
}

/// Sets up the buttons rendered by `StaticCopyButton`,
/// which copy the value of their `data-copy` attribute when clicked.
void _setUpCopyButtons() {
  // Buttons currently showing copy feedback,
  // along with their original label and the timer that restores it.
  final pendingResets = <web.Element, ({String label, Timer timer})>{};

  @awaitNotRequired
  Future<void> copyToClipboard(web.Element button, String text) async {
    final label = pendingResets[button]?.label ?? button.textContent ?? '';
    try {
      await web.window.navigator.clipboard.writeText(text).toDart;
      button.textContent = 'Copied!';
    } catch (_) {
      button.textContent = 'Failed to copy';
    }

    pendingResets.remove(button)?.timer.cancel();
    pendingResets[button] = (
      label: label,
      timer: Timer(const Duration(seconds: 2), () {
        pendingResets.remove(button);
        button.textContent = label;
      }),
    );
  }

  web.document.addEventListener(
    'click',
    ((web.Event event) {
      final target = event.target;
      if (!target.isA<web.Element>()) return;

      final button = (target as web.Element).closest('button[data-copy]');
      if (button == null) return;

      final toCopy = button.getAttribute('data-copy');
      if (toCopy == null || toCopy.isEmpty) return;

      copyToClipboard(button, toCopy);
    }).toJS,
  );
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
