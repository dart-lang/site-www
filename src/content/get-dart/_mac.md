
<<<<<<< HEAD
### Install using Homebrew  {:.no_toc}

=======
### System requirements
{: .no_toc}

Dart supports the following hardware architectures and platform versions
to develop and run Dart code on macOS.

#### Hardware architecture
{: .no_toc}

Dart supports the following CPU architectures.

| Platform | x86 | x64 | ARM | ARM64 | RISC-V |
|----------|-----|-----|-----|-------|--------|
| macOS    | No  | Yes | No  | Yes   | No     |
{:.table .table-striped}

#### Operating system
{: .no_toc}

Dart supports the latest three major versions of macOS.

| Platform | OS Versions                              |
|----------|------------------------------------------|
| macOS    | {% for version in site.data.macos %}{% if version.eol != false %}{% break %}{%- else -%}{{version.cycle}} ({{version.codename}}){% endif %}, {% endfor %} |
{:.table .table-striped}

### Install using Homebrew
{: .no_toc}

>>>>>>> a9d6c41c (Updated for 11ty)
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

<<<<<<< HEAD
### Verify PATH includes Homebrew  {:.no_toc}

Verify that your `PATH` includes the **Homebrew `bin`**.
=======

### Verify PATH includes Homebrew
{: .no_toc}

Verify that your `PATH` includes the **Homebrew `bin`.
>>>>>>> a9d6c41c (Updated for 11ty)
Setting up the path correctly makes it easier to use Dart SDK commands
such as `dart run` and `dart format`.
For help configuring your path,
consult the [Homebrew FAQ.](https://docs.brew.sh/FAQ)

<<<<<<< HEAD
### Upgrade using Homebrew  {:.no_toc}
=======
### Upgrade using Homebrew
{: .no_toc}
>>>>>>> a9d6c41c (Updated for 11ty)

To upgrade when a new release of Dart is available:

```console
$ brew upgrade dart
```

<<<<<<< HEAD
### Switch Dart versions  {:.no_toc}
=======
### Switch Dart versions
{: .no_toc}
>>>>>>> a9d6c41c (Updated for 11ty)

To switch between locally installed Dart releases:

1. Install the version to which you want to switch.

   For example, to install Dart 3.1:

   ```console
   $ brew install dart@3.1
   ```

1. To switch between versions,
   unlink the current version and link the desired version.

   ```console
   $ brew unlink dart@<old> && brew unlink dart@<new> && brew link dart@<new>
   ```

<<<<<<< HEAD
### List installed Dart versions  {:.no_toc}
=======
### List installed Dart versions
{: .no_toc}
>>>>>>> a9d6c41c (Updated for 11ty)

To see which versions of Dart you've installed:

```console
$ brew info dart
```

[Homebrew]: https://brew.sh
<<<<<<< HEAD
[tap]: {{site.gh-dart.org}}/homebrew-dart
=======
>>>>>>> a9d6c41c (Updated for 11ty)
