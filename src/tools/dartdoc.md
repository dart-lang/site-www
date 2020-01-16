---
title: dartdoc
description: API reference generation tool.
toc: false
---

The `dartdoc` command creates API reference documentation
from Dart source code.
You can add descriptions to the generated documentation
by using [documentation comments][],
which can contain markdown formatting.
For guidance on writing doc comments,
see the [documentation part of Effective Dart][effective doc].

Run `dartdoc` from the root directory of your package. For example:

```terminal
$ cd my_app
$ dartdoc
Documenting my_app...
...
Success! Docs generated into /Users/me/projects/my_app/doc/api
```

By default, the documentation files are static HTML files,
placed in the `doc/api` directory.
To view the rendered documentation, you need an HTTP server.

Although `dartdoc` is in the Dart SDK,
it's also available in the [dartdoc package.][]
You might use the package when you need a programmatic interface
or when you want to try features that
aren't yet in the SDK's version of `dartdoc`.

For information on command-line options, use the `--help` flag:

```terminal
$ dartdoc --help
```

[documentation comments]: /guides/language/language-tour#documentation-comments
[effective doc]: /guides/language/effective-dart/documentation
[dartdoc package.]: {{site.pub-pkg}}/dartdoc

{% comment %}
[PENDING: Add more help, info on commonly used options, links to examples of use.]
{% endcomment %}
