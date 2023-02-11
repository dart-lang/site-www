---
title: Configuring apps with environment declarations
description: >
  Learn about using environment declarations to customize application behavior.
---

Dart supports specifying environment declarations when
building or running an application.
Environment declarations are used to specify
configuration values or options as key-value pairs
that are accessed and evaluated at compile time.

Your app can use the values of environment declarations
to change its functionality or behavior.
Dart compilers can take advantage of this to eliminate code
no longer reached due to the values specified through tree shaking.

Some potential use cases for defining environment declarations are:

* Adding functionality during debugging, such as enabling logging.
* Creating separate flavors of your application.
* Configuring application behavior, such as the port of an HTTP server.
* Enabling an experimental mode of your application for testing.
* Switching between testing and production backends.

To specify an environment declaration
to an application with the [`dart run`][] or [`dart compile`][] subcommands,
use the `-D` or `--define` options and specify `<NAME>=<VALUE>`:

```terminal
$ dart run --define=DEBUG=true -DFLAVOR=free
```

To learn more about specifying environment declarations,
including for other tools and compilers, see
[Specifying environment declarations][].

[`dart run`]: /tools/dart-run
[`dart compile`]: /tools/dart-compile
[Specifying environment declarations]: #specifying-environment-declarations

## Accessing environment declarations

To access specified environment declaration values,
use one of the `fromEnvironment` constructors
with `const` or within a constant context.
Use [`bool.fromEnvironment`][bool-from] for `true` or `false` values,
[`int.fromEnvironment`][int-from] for integer values,
and [`String.fromEnvironment`][string-from] for anything else.

{{site.alert.note}}
  The environment declaration constructors are only guaranteed
  to work when invoked as `const`.
  Most compilers must be able to evaluate their value at compile time.
{{site.alert.end}}

Each of the `fromEnvironment` constructors require the
name or key of the environment declaration key-value pair,
as well as an optional `defaultValue` override
that is used when a declaration wasn't defined.

For example, if you only want to log messages only
when the environment declaration `DEBUG` is set to `true`:

<?code-excerpt "misc/lib/development/environment_declarations.dart (debug-log)"?>
```dart
void log(String message) {
  // Log the debug message if the environment declaration 'DEBUG' is `true`.
  // If there was no value specified, do not log.
  if (const bool.fromEnvironment('DEBUG', defaultValue: false)) {
    print('Debug: $message');
  }
}
```

In this snippet, if `DEBUG` is set to `false`
during compilation or not specified at all,
production compilers can completely remove the condition and its body.

The `fromEnvironment` constructors always
have a default value when the declaration isn't specified.
Therefore, if you need to specifically check if
an environment declaration has been specified,
use the [`bool.hasEnvironment`][bool-has] constructor:

<?code-excerpt "misc/lib/development/environment_declarations.dart (has-debug)"?>
```dart
if (const bool.hasEnvironment('DEBUG')) {
  print('Debug behavior was configured!');
}
```

[string-from]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/String/String.fromEnvironment.html
[int-from]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/int/int.fromEnvironment.html
[bool-from]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/bool/bool.fromEnvironment.html
[bool-has]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/bool/bool.hasEnvironment.html

## Specifying environment declarations

{{site.alert.warning}}
  Dart tools and compilers currently do not
  consistently handle environment declarations
  with comma-separated values.
  For more details,
  see [SDK issue 44995][].
{{site.alert.end}}

[SDK issue 44995]: https://github.com/dart-lang/sdk/issues/4499

### Dart CLI

Both `dart run` and the `dart compile` subcommands accept
the `-D` or `--define` options
to specify environment declaration values.

```terminal
$ dart run --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile exe --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile js --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile aot-snapshot --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile jit-snapshot --define=DEBUG=true -DFLAVOR=free main.dart
$ dart compile kernel --define=DEBUG=true -DFLAVOR=free main.dart
```

To specify multiple declarations, 
you can use multiple define options:

```terminal
$ dart run --define=DEBUG=true -DFLAVOR=free
```

#### `webdev`

To learn about configuring `webdev` to pass environment declarations
to both the development and production web compilers,
see [the `webdev` configuration documentation][webdev-config].

[webdev-config]: {{site.pub-pkg}}/build_web_compilers#configuring--d-environment-variables

### Visual Studio Code

In your launch configuration (`launch.json`) under `configurations`,
add a new `toolArgs` key containing the your desired environment declarations:

```json
"configurations": [
    {
        "name": "Dart",
        "request": "launch",
        "type": "dart",
        "toolArgs": [
          "--define=DEBUG=true"
        ]
    }
]
```

For more information, see the documentation for
[VS Code launch configurations.][VSC instructions]

[VSC instructions]: https://code.visualstudio.com/docs/editor/debugging#_launch-configurations

### JetBrains IDEs

In the **Run/Debug Configurations** for your project,
add your desired environment declarations to **VM options**:

![Adding define option to Jetbrains IDE](/assets/img/env-decl-jetbrains.png){:width="500"}

For more information, see the JetBrains' documentation for
[Dart Run/Debug Configurations][jetbrains-run-debug].

[jetbrains-run-debug]: https://www.jetbrains.com/help/webstorm/run-debug-configuration-dart-command-line-application.html

### Flutter

To specify environment declarations to the Flutter tool,
use the `--dart-define` option instead:

```terminal
$ flutter run ---dart-define=DEBUG=true
```

{%- comment %}
  TODO: Once Flutter adds `--dart-define` documentation:
  To learn more, see Flutter's documentation on `--dart define`.
{% endcomment -%}
