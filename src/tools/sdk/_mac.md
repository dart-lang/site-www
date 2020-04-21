[Install Homebrew](https://brew.sh), and then run:

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

### Upgrade

To upgrade when a new release of Dart is available run:

```terminal
$ brew upgrade dart
```

### Switch release

To switch between locally installed dart releases run
`brew switch dart <version>`. Examples:

```terminal
$ brew switch dart 2.
$ brew switch dart 2.1.0
```

If you aren't sure which versions of dart you have installed, then run:

```terminal
$ brew info dart
```

The command output lists the latest stable and dev versions at the top,
followed by your locally installed versions.
