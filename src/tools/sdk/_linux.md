#### Install using apt-get
{: style="margin-top: 0"}

Perform the following **one-time setup**:

```terminal
$ sudo apt-get update
$ sudo apt-get install apt-transport-https
$ sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
$ sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
```

Then **install** the Dart SDK:

```terminal
$ sudo apt-get update
$ sudo apt-get install dart
```

To setup for a **dev channel** release, run the one-time setup commands
followed by:

```terminal
$ sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list'
$ sudo apt-get update
$ sudo apt-get install dart
```

#### Install a Debian package

Alternatively, download Dart SDK as Debian package in the `.deb` package format.

{:.downloads}
- [Stable channel](#){:.download-link #debian-link-stable
  data-bits="64" data-os="debian" data-tool="sdk"}
- [Dev channel](#){:.download-link #debian-link-dev
  data-bits="64" data-os="debian" data-tool="sdk"}

#### Compiling from source

You can [build the SDK](https://github.com/dart-lang/sdk/wiki/Building) yourself.
