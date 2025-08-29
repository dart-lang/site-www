import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../components/cookie_notice.dart';
import '../components/footer.dart';
import '../components/header.dart';
import '../components/sidenav.dart';

abstract class DashLayout extends PageLayoutBase {
  const DashLayout();

  @override
  String get name;

  @override
  @mustCallSuper
  Iterable<Component> buildHead(Page page) sync* {
    final pageData = page.data.page;
    final siteData = page.data.site;
    final pageTitle = (pageData['title'] ?? siteData['title']) as String;

    yield* super.buildHead(page);

    if (pageData['noindex'] case final noIndex?
        when noIndex == true || noIndex == 'true') {
      yield meta(name: 'robots', content: 'noindex');
    }

    if (pageData['canonical'] case final String canonicalUrl
        when canonicalUrl.isNotEmpty) {
      yield link(rel: 'canonical', href: canonicalUrl);
    }

    if (pageData['redirectTo'] case final String redirectTo
        when redirectTo.isNotEmpty) {
      yield raw('<script>window.location.replace("$redirectTo");</script>');
    }

    yield link(
      rel: 'icon',
      href: '/assets/img/logo/dart-64.png',
      attributes: {'sizes': '64x64'},
    );
    yield link(
      rel: 'apple-touch-icon',
      href: '/assets/img/touch-icon-iphone.png',
    );
    yield link(
      rel: 'apple-touch-icon',
      href: '/assets/img/touch-icon-ipad.png',
      attributes: {'sizes': '152x152'},
    );
    yield link(
      rel: 'apple-touch-icon',
      href: '/assets/img/touch-icon-iphone-retina.png',
      attributes: {'sizes': '180x180'},
    );
    yield link(
      rel: 'apple-touch-icon',
      href: '/assets/img/touch-icon-ipad-retina.png',
      attributes: {'sizes': '167x167'},
    );

    yield meta(name: 'twitter:card', content: 'summary');
    yield meta(name: 'twitter:site', content: '@dart_lang');
    yield meta(name: 'twitter:title', content: pageTitle);
    yield meta(
      name: 'twitter:description',
      content: '${pageData['description']}',
    );

    yield meta(attributes: {'property': 'og:title', 'content': pageTitle});
    yield meta(
      attributes: {
        'property': 'og:description',
        'content': '${pageData['description']}',
      },
    );
    yield meta(attributes: {'property': 'og:url', 'content': page.path});
    yield meta(
      attributes: {
        'property': 'og:image',
        'content': '/assets/img/logo/dart-logo-for-shares.png',
      },
    );

    yield link(rel: 'preconnect', href: 'https://fonts.googleapis.com');
    yield link(
      rel: 'preconnect',
      href: 'https://fonts.gstatic.com',
      attributes: {'crossorigin': ''},
    );
    yield link(
      rel: 'stylesheet',
      href:
          'https://fonts.googleapis.com/css2?family=Google+Sans:wght@400;500;700&display=swap',
    );
    yield link(
      rel: 'stylesheet',
      href:
          'https://fonts.googleapis.com/css2?family=Google+Sans+Mono:wght@400;500;700&display=swap',
    );
    yield link(
      rel: 'stylesheet',
      href:
          'https://fonts.googleapis.com/css2?family=Google+Sans+Text:wght@400;500;700&display=swap',
    );
    yield link(
      rel: 'stylesheet',
      href:
          'https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@24,400,0..1,0',
    );
    yield link(rel: 'stylesheet', href: '/assets/css/main.css');

    yield script(src: '/assets/js/tabs.js');
    yield script(src: '/assets/js/main.js');

    if (pageData['js'] case final List<Object?> jsList) {
      for (final js in jsList) {
        if (js case {'url': final String jsUrl, 'defer': final Object? defer}) {
          yield script(
            src: jsUrl,
            attributes: {if (defer == 'true' || defer == true) 'defer': ''},
          );
        }
      }
    }

    yield script(
      src:
          'https://cdn.jsdelivr.net/npm/@justinribeiro/lite-youtube@1.8.2/lite-youtube.js',
      attributes: {
        'type': 'module',
        'integrity': 'sha256-Jy0j0fUMJ2T3WxSEs2WjHLrS+3DlO7S9DItQtP55FII=',
        'crossorigin': 'anonymous',
        'referrerpolicy': 'no-referrer',
      },
    );

    // Set up tag manager and analytics.
    yield raw('''
<script>
  window.dataLayer = window.dataLayer || [];
</script>
<script>(function(w,d,s,l,i){w[l]=w[l]||[];w[l].push({'gtm.start':
new Date().getTime(),event:'gtm.js'});var f=d.getElementsByTagName(s)[0],
j=d.createElement(s),dl=l!='dataLayer'?'&l='+l:'';j.async=true;j.src=
'https://www.googletagmanager.com/gtm.js?id='+i+dl;f.parentNode.insertBefore(j,f);
})(window,document,'script','dataLayer','GTM-5VSZM5J');</script>
''');

    yield raw('''
<script>
(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
})(window,document,'script','//www.google-analytics.com/analytics.js','ga');

ga('create', 'UA-26406144-4', 'auto');
ga('send', 'pageview');
</script>
''');
  }

  @override
  Component buildBody(Page page, Component child) {
    final pageData = page.data.page;
    final bodyClass = pageData['bodyClass'] as String?;
    final pageUrl = page.url.startsWith('/') ? page.url : '/${page.url}';
    final sideNavEntries = switch (page.data['sidenav']) {
      final List<Object?> sidenavData => SideNav.navEntriesFromData(
        sidenavData,
      ),
      _ => null,
    };

    return Fragment(
      children: [
        Document.body(attributes: {if (bodyClass != null) 'class': bodyClass}),
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
        const DashCookieNotice(),
        const DashHeader(),
        div(id: 'site-below-header', [
          div(id: 'site-main-row', [
            if (sideNavEntries != null)
              SideNav(
                navEntries: sideNavEntries,
                currentPageUrl: pageUrl,
              ),
            main_(
              id: 'page-content',
              classes: [
                if (pageData['focusedLayout'] == true) 'focused',
              ].join(' '),
              [child],
            ),
          ]),
          const DashFooter(),
        ]),
      ],
    );
  }
}
