---
title: Null safety
description: Watch this space for news about null safety
toc: false
---

Watch this page for updates about null safety.
In the meantime, check out these resources:

* [Null-safe playground: nullsafety.dartpad.dev][nullsafety.dartpad.dev]
* [Null safety tracking issue][110]
* [Dart announcements group][Dart announce]
* [Dart blog][]

Here's some background about null safety
from the [Dart 2.8 announcement:][Announcing Dart 2.8]

<blockquote markdown="1">
  A common source of app crashes is
  code that attempts to use a variable that happens to be null.
  Sir Tony Hoare, who introduced null references in the
  ALGOL programming language in 1965,
  famously called them his “billion-dollar mistake” in a QCon talk in 2009.
  In some cases null values are useful;
  the challenge is separating those from the cases where they aren’t.

  For the past year we’ve been busy building support for
  sound null safety in Dart.
  This support will extend the type system to
  express variables that are always non-nullable,
  but in addition the type system will be fully sound:
  the Dart compilers and runtimes will be able to trust those types,
  and be able to produce optimized code when
  the type system guarantees that a variable isn’t null.
</blockquote>

[110]: https://github.com/dart-lang/language/issues/110
[Announcing Dart 2.8]: https://medium.com/dartlang/announcing-dart-2-8-7750918db0a
[Dart announce]: {{site.group}}/d/forum/announce
[Dart blog]: https://medium.com/dartlang
[nullsafety.dartpad.dev]: https://nullsafety.dartpad.dev
