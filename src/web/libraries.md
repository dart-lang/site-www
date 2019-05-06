---
title: Web libraries and packages
short-title: Web libraries
description: Libraries and packages that can help you write Dart web apps.
---

The [Dart SDK][] contains [dart:html][] and other libraries
that provide low-level web APIs.
You can supplement or replace these APIs using
[web packages,][web packages]
such as those in the [AngularDart][] framework.

[Dart SDK]: /tools/sdk
[dart:html]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-html/dart-html-library.html
[web packages]: {{site.pub}}/web


## SDK libraries

The Dart SDK contains dart:html and other libraries
that provide low-level web APIs.

[Low-level web tutorials](/tutorials/web/low-level-html)
: An overview of DOM, CSS, and HTML concepts, with information on
  how to include a Dart script in an HTML page and
  how to add and remove elements from a web page.
  These tutorials feature interactive examples in
  [DartPad.]({{site.custom.dartpad.direct-link}})

[The dart:html section](/guides/libraries/library-tour) of the library tour
: An example-driven tour of using the dart:html library.
  Topics include manipulating the DOM programmatically,
  making HTTP requests, and using WebSockets.

[dart:html API reference][dart:html]
: Complete reference documentation for the dart:html library.


## Web packages

Many [packages](/guides/packages) support web development with Dart. Here
are a few:

|-----------------+---------------------------------+--------------------------|
| Library         | Packages                        | Notes                    |
|-----------------|---------------------------------|--------------------------|
| AngularDart     | angular*                        | Useful for complex apps that support features such as event handling and dependency injection. More info: [AngularDart documentation]({{site.angulardart}}), [AngularDart Components]({{site.angulardart}}/components) | 
| Material Design | [md_core,][] [m4d_components][] | Basic Material Design components. |
| React           | [react][]                       | Bindings for the ReactJS library. |
| Vue             | [vue][]                         | Bindings for the Vue.js library. |
{:.table .table-striped}

[md_core,]: {{site.pub-pkg}}/m4d_core
[m4d_components]: {{site.pub-pkg}}/m4d_components
[vue]: {{site.pub-pkg}}/vue
[react]: {{site.pub-pkg}}/react

To find more libraries that support writing web apps, search for
[web packages.][web packages]

{% comment %}
Check out these pages:

https://github.com/TheBosZ/dartins
https://medium.com/@thebosz/creating-a-dart-to-javascript-interop-library-c97da204c34a#.up26ibqyb
{% endcomment %}


---

Also see the [FAQ.](/faq)

[AngularDart]: {{site.angulardart}}
