
### Install using Homebrew {:.no_toc}

To install the Dart SDK, use [Homebrew][].

1. Install Homebrew if needed.

1. Add the [official tap][tap].

   ```console
   $ brew tap dart-lang/dart
   ```

1. Install the Dart SDK.

   ```console
   $ brew install dart
   ```

### Verify PATH includes Homebrew {:.no_toc}

Verify that your `PATH` includes the **Homebrew `bin` directory**.
Setting up the correct path simplifies using Dart SDK commands
such as `dart run` and `dart format`.

To get help configuring your `PATH`, consult the [Homebrew FAQ][].

### Upgrade using Homebrew {:.no_toc}

To upgrade when a new release of Dart is available:

```console
$ brew upgrade dart
```

### Switch Dart versions {:.no_toc}

To switch between locally installed Dart releases:

1. Install the version to which you want to switch.

   For example, to install Dart 3.1:

   ```console
   $ brew install dart@3.1
   ```

1. To switch between versions,
   unlink the current version and link the desired version.

   ```console
   $ brew unlink dart@<old> \
     && brew unlink dart@<new> \
     && brew link dart@<new>
   ```

### List installed Dart versions {:.no_toc}

To see which versions of Dart you've installed:

```console
$ brew info dart
```

### Uninstall using Homebrew {:.no_toc}

To uninstall the Dart SDK, use [Homebrew][].

1. Uninstall the Dart SDK.

   ```console
   $ brew uninstall dart
   ```

1. Remove the Dart configuration files from your home directory.

   ```dart
   rm -rf  ~/.dart*
   ```

[Homebrew]: https://brew.sh
[tap]: {{site.repo.dart.org}}/homebrew-dart
[Homebrew FAQ]: https://docs.brew.sh/FAQ#my-mac-apps-dont-find-homebrew-utilities
