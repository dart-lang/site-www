---
title: dart doc
description: API reference generation tool.
toc: false
---

The `dart doc` command (previously called `dartdoc`)
creates API reference documentation
from Dart source code.
You can add descriptions to the generated documentation
by using [documentation comments][],
which can contain [Markdown][] formatting.
For guidance on writing doc comments,
see the [documentation part of Effective Dart][effective doc].

{{site.alert.note}}
  To generate documentation, 
  you must first run [`dart pub get`](/tools/pub/cmd/pub-get)
  and your package must pass [`dart analyze`](/tools/dart-analyze)
  without errors.
{{site.alert.end}}

Run `dart doc` from the root directory of your package. 
For example:

```terminal
$ cd my_app
$ dart pub get
$ dart doc .
Documenting my_app...
...
Success! Docs generated into /Users/me/projects/my_app/doc/api
```

By default, 
the documentation files are static HTML files,
placed in the `doc/api` directory. 
You can create the files in a different directory
with the `--output` flag.

For information on command-line options, 
use the `help` command:

```terminal
$ dart help doc
```

[documentation comments]: /language/comments#documentation-comments
[effective doc]: /effective-dart/usage#do-use-strings-in-part-of-directives
[Markdown]: {{site.pub-pkg}}/markdown

{% comment %}
[PENDING: Add more help, info on commonly used options, links to examples of use.]
{% endcomment %}
