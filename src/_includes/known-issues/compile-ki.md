No cross-compilation support ([issue 28617][])
: The compiler can create machine code only for
  the operating system on which you're compiling.
  To create executables for macOS, Windows, and Linux, you need to run
  the compiler three times.
  You can also use a continuous integration (CI) provider
  that supports all three operating systems.

No support for `dart:mirrors` and `dart:developer`
: For a complete list of the core libraries you can use,
  see the [Multi-platform][] and [Native platform][] library tables.

[Multi-platform]: /libraries#multi-platform-libraries
[Native platform]: /libraries#native-platform-libraries
[issue 28617]: {{site.repo.dart.sdk}}/issues/28617

:::tip
If one of these issues is important to you,
let the Dart team know by adding a "thumbs up" to the issue.
:::
