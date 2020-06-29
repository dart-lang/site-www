[Install Homebrew,](https://brew.sh)
and then run the following commands:

```terminal
$ brew tap dart-lang/dart
$ brew install dart
```
{{site.alert.important}}
  Make sure the **Homebrew `bin` directory is in your `PATH`**. Setting up the
  path correctly makes it easier to use Dart SDK commands such as `dart` and
  `dartfmt`. For help setting up your path, consult the [Homebrew
  FAQ.](https://docs.brew.sh/FAQ)
{{site.alert.end}}

To upgrade when a new release of Dart is available:

```terminal
$ brew upgrade dart
```

To switch between locally installed Dart releases, use
`brew switch dart <version>`. Example:

```terminal
$ brew switch dart 2.1.0
```

To see which versions of Dart you've installed:

```terminal
$ brew info dart
```
