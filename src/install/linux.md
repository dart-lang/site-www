---
title: Installing Dart on Linux
short-title: Linux Install
description: Installing and updating the Dart SDK on Linux with apt-get, a Debian package, and compiling from source.
permalink: /install/linux
js:
- url: /install/archive/assets/install.js
  defer: true
---

If you're using Debian/Ubuntu on AMD64 (64-bit Intel), you can choose two options,
both of which can update the SDK automatically
when new versions are released.

* [Installing using apt-get](#using-apt-get)
* [Downloading the Debian package](#installing-a-debian-package)

Other options, which also support other architectures, are:

* [Downloading Dart manually](/install/archive)
* [Compiling Dart from source](#compiling-from-source)


## Using apt-get

To install the Dart SDK with apt-get, you first need to do some setup.

### Setting up for the stable channel

The following one-time commands set up the install for the stable channel.

- Enable HTTPS for apt.
  ```terminal
  $ sudo apt-get update
  $ sudo apt-get install apt-transport-https
  ```
- Get the Google Linux package signing key.
  ```terminal
  $ sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
  ```
- Set up the location of the stable repository.
  ```terminal
  $ sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
  $ sudo apt-get update
  ```

The following one-time command sets the correct PATH variable for the dart tools like pub.
The most common way is to put this line in your .bashrc file.

```terminal
$ export PATH=/usr/lib/dart/bin:$PATH
```

### Setting up for the dev channel

The following one-time command sets up the install for the dev channel.

<aside class="alert alert-warning" markdown="1">
Before running this command, follow the instructions in
[Setting up for the stable channel](#setting-up-for-the-stable-channel).
</aside>

```terminal
$ sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list'
```


### Installing the SDK

The following command installs the highest available version of the Dart SDK,
based on your setup.

```terminal
$ sudo apt-get install dart
```

If you have set up your environment for both the stable and dev channel
releases, the previous command always installs the dev channel, as that
has a higher version number.
If you want to install the stable channel instead of the dev channel,
or to install a specific version number, see the next section.


### Installing a specific version

The dev channel has a higher version number than the stable channel.
To force installation of the stable version, use the following command.

```terminal
$ sudo apt-get install dart/stable
```

To install a particular release, specify the version.
For example:

```terminal
$ sudo apt-get install dart=1.5.8-1
$ sudo apt-get install dart=1.6.*
$ sudo apt-get install dart=1.7.0-dev.0.1.*
```


## Installing a Debian package

Use one of the following buttons to install the stable or
dev channel release in the `.deb` package format.

{% include_relative _debian.html buttonclass="download-btn btn btn-primary btn-lg" %}

## Compiling from source

You can [build the SDK](https://github.com/dart-lang/sdk/wiki/Building) yourself.
