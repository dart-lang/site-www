// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../client/global_scripts.dart';
import '../components/cookie_notice.dart';
import '../components/footer.dart';
import '../components/header.dart';
import '../components/sidenav.dart';
import '../models/sidenav_model.dart';
import '../util.dart';

/// The base Jaspr Content layout for wrapping site content.
abstract class DashLayout extends PageLayoutBase {
  const DashLayout();

  @override
  String get name;

  @override
  @mustCallSuper
  Iterable<Component> buildHead(Page page) {
    final pageData = page.data.page;
    final siteData = page.data.site;
    final pageTitle = (pageData['title'] ?? siteData['title']) as String;

    return [
      ...super.buildHead(page),
      if (pageData['noindex'] case final noIndex?
          when noIndex == true || noIndex == 'true')
        meta(name: 'robots', content: 'noindex'),
      if (pageData['canonical'] case final String canonicalUrl
          when canonicalUrl.isNotEmpty)
        link(rel: 'canonical', href: canonicalUrl),
      if (pageData['redirectTo'] case final String redirectTo
          when redirectTo.isNotEmpty)
        raw('<script>window.location.replace("$redirectTo");</script>'),
      link(
        rel: 'icon',
        href: '/assets/img/logo/dart-64.png',
        attributes: {'sizes': '64x64'},
      ),
      link(
        rel: 'apple-touch-icon',
        href: '/assets/img/touch-icon-iphone.png',
      ),
      link(
        rel: 'apple-touch-icon',
        href: '/assets/img/touch-icon-ipad.png',
        attributes: {'sizes': '152x152'},
      ),
      link(
        rel: 'apple-touch-icon',
        href: '/assets/img/touch-icon-iphone-retina.png',
        attributes: {'sizes': '180x180'},
      ),
      link(
        rel: 'apple-touch-icon',
        href: '/assets/img/touch-icon-ipad-retina.png',
        attributes: {'sizes': '167x167'},
      ),
      meta(name: 'twitter:card', content: 'summary'),
      meta(name: 'twitter:site', content: '@dart_lang'),
      meta(name: 'twitter:title', content: pageTitle),
      meta(
        name: 'twitter:description',
        content: '${pageData['description']}',
      ),

      meta(attributes: {'property': 'og:title', 'content': pageTitle}),
      meta(
        attributes: {
          'property': 'og:description',
          'content': '${pageData['description']}',
        },
      ),
      meta(attributes: {'property': 'og:url', 'content': page.path}),
      meta(
        attributes: {
          'property': 'og:image',
          'content': '/assets/img/logo/dart-logo-for-shares.png',
        },
      ),

      link(rel: 'preconnect', href: 'https://fonts.googleapis.com'),
      link(
        rel: 'preconnect',
        href: 'https://fonts.gstatic.com',
        attributes: {'crossorigin': ''},
      ),
      link(
        rel: 'stylesheet',
        href:
            'https://fonts.googleapis.com/css2?family=Google+Sans:wght@400;500;700&display=swap',
      ),
      link(
        rel: 'stylesheet',
        href:
            'https://fonts.googleapis.com/css2?family=Google+Sans+Mono:wght@400;500;700&display=swap',
      ),
      link(
        rel: 'stylesheet',
        href:
            'https://fonts.googleapis.com/css2?family=Google+Sans+Text:wght@400;500;700&display=swap',
      ),
      link(
        rel: 'stylesheet',
        href:
            'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0..1,0',
      ),
      link(rel: 'stylesheet', href: '/assets/css/main.css?v=3'),

      script(src: '/assets/js/main.js?v=2'),
      if (pageData['js'] case final List<Object?> jsList)
        for (final js in jsList)
          if (js case {'url': final String jsUrl, 'defer': final Object? defer})
            script(
              src: jsUrl,
              attributes: {if (defer == 'true' || defer == true) 'defer': ''},
            ),
      script(
        src:
            'https://cdn.jsdelivr.net/npm/@justinribeiro/lite-youtube@1.8.2/lite-youtube.js',
        attributes: {
          'type': 'module',
          'integrity': 'sha256-Jy0j0fUMJ2T3WxSEs2WjHLrS+3DlO7S9DItQtP55FII=',
          'crossorigin': 'anonymous',
          'referrerpolicy': 'no-referrer',
        },
      ),

      // Set up tag manager and analytics.
      raw('''
<script>
  window.dataLayer = window.dataLayer || [];
</script>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-5VSZM5J');</script>
'''),
      raw('''
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-26406144-4', 'auto');
ga('send', 'pageview');
</script>
'''),
    ];
  }

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;
    final bodyClass = pageData['bodyClass'] as String?;
    final pageUrl = page.url.startsWith('/') ? page.url : '/${page.url}';
    final sideNavEntries = switch (page.data['sidenav']) {
      final List<Object?> sidenavData => navEntriesFromData(sidenavData),
      _ => null,
    };
    final obsolete = pageData['obsolete'] == true;

    return Component.fragment(
      [
        if (bodyClass != null) Document.body(attributes: {'class': bodyClass}),
        raw('''
<noscript><iframe src="https://www.googletagmanager.com/ns.html?id=GTM-5VSZM5J" height="0" width="0" style="display:none;visibility:hidden"></iframe></noscript>
'''),
        a(
          id: 'skip-to-main',
          classes: 'filled-button',
          href: '#site-content-title',
          attributes: {'tabindex': '1'},
          [text('Skip to main content')],
        ),
        const CookieNotice(),
        const DashHeader(),
        div(id: 'site-below-header', [
          div(id: 'site-main-row', [
            if (sideNavEntries != null)
              DashSideNav(
                navEntries: sideNavEntries,
                currentPageUrl: pageUrl,
              ),
            main_(
              id: 'page-content',
              classes: [
                if (pageData['focusedLayout'] == true) 'focused',
              ].toClasses,
              [child],
            ),
            if (obsolete)
              div(id: 'obsolete-banner', [
                div(classes: 'text-center', [
                  text('Some content on this page might be out of date.'),
                ]),
              ]),
          ]),
          const DashFooter(),
        ]),
        GlobalScripts(),
      ],
    );
  }
}
