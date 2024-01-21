[Install Homebrew,](https://brew.sh)
and then run the following commands:

```console
$ brew tap dart-lang/dart
$ brew install dart
```

:::important
Make sure the **Homebrew `bin` directory is in your `PATH`**. 
Setting up the path correctly makes it easier to use Dart SDK commands
such as `dart run` and `dart format`. 
For help configuring your path, 
consult the [Homebrew FAQ.](https://docs.brew.sh/FAQ)
:::

To upgrade when a new release of Dart is available:

```console
$ brew upgrade dart
```

To switch between locally installed Dart releases, 
first install the version you want to switch to if you haven't.
For example, to install Dart 2.12:

```console
$ brew install dart@2.12
```

Then to switch between versions, 
unlink the current version and link the desired version.

```console
$ brew unlink dart@<old> && brew unlink dart@<new> && brew link dart@<new>
```

To see which versions of Dart you've installed:

```console
$ brew info dart
```
