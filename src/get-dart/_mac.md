
### Install using Homebrew
{: .no_toc}

To install the Dart SDK, use [Homebrew][].

Install Homebrew, then run the following commands.

```terminal
$ brew tap dart-lang/dart
$ brew install dart
```

### Verify PATH includes Homebrew
{: .no_toc}

Verify that your `PATH` includes the **Homebrew `bin` directory**.
Setting up the correct path simplifies using Dart SDK commands
such as `dart run` and `dart format`.
To get help configuring your `PATH`, consult the [Homebrew FAQ][].

### Upgrade using Homebrew
{: .no_toc}

To upgrade when a new release of Dart is available:

```terminal
$ brew upgrade dart
```

### Switch Dart versions
{: .no_toc}

To switch between locally installed Dart releases:

1. Install the version to which you want to switch.

   For example, to install Dart 3.1:

   ```terminal
   $ brew install dart@3.1
   ```

1. To switch between versions,
   unlink the current version and link the desired version.

   ```terminal
   $ brew unlink dart@<old> && brew unlink dart@<new> && brew link dart@<new>
   ```

### List installed Dart versions
{: .no_toc}

To see which versions of Dart you've installed:

```terminal
$ brew info dart
```

[Homebrew]: https://brew.sh
[Homebrew FAQ]: https://docs.brew.sh/FAQ
