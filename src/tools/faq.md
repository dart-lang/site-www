---
title: Tools FAQ
short-title: FAQ
description: FAQ and other tips for using Dart Tools.
permalink: /tools/faq
---

## General

#### Q. I am having trouble running the Linux distribution of Dart on my Linux platform.
Some flavors of Linux require that you manually build the Dart SDK.
This may require that you update to a more recent version of
the GCC library.
The following resources may be useful:

  * [Building Dart on CentOS, Red Hat, Fedora and Amazon Linux AMI](https://github.com/dart-lang/sdk/wiki/Building-Dart-on-CentOS,-Red-Hat,-Fedora-and-Amazon-Linux-AMI)
  * [Building Dart SDK on Ubuntu 10.04 Server](https://github.com/dart-lang/sdk/wiki/Building-Dart-SDK-on-Ubuntu-10.04-Server)


#### Q. Can all Dart files be put into a source code repository?
Dart tools generate some files that should be local only.
The [What Not to Commit](/guides/libraries/private-files) page
has some advice on what not to put into your source repo.

## Pub

Here are some frequently asked questions about [pub](/tools/pub).

#### Q. What are pub's system requirements?

Pub runs on any platform that supports the Dart VM. That basically means
relatively recent versions of Mac, Linux and Windows.

However, Windows has some limitations:

* Windows XP is not supported.
* FAT32 file systems are not supported.
* Packages cannot be stored on a different drive than your user directory.
* Packages cannot be stored on network shares.

Pub relies on junction points for core functionality, and those aren't
available on the above. We realize these limitations are painful and we're
hoping to address the root cause but it will take a while to get there.

#### Q. How can I make my client-server app work with **pub serve**?

When you have an app with your own Dart server, you can use the
[shelf_proxy](http://pub.dartlang.org/packages/shelf_proxy) package
to set up a proxy to route requests
to an external `pub serve` instance.

#### Q. I found a bug in pub. How do I report it?

We use the main [Dart bug tracker][]. Feel free to file a ticket. When you do,
please include:

[Dart bug tracker]: https://github.com/dart-lang/sdk/issues/new

* Your platform (Windows, Mac, Linux, etc.).
* The version you are running. (Run `pub version`.)
* If possible, include a log by running `pub --verbose <your command>`.

#### Q. How do I delete a package?

Once a package is published, you're strongly discouraged from deleting it.
After all, some user could already be depending on it! If, however, you really
want your package deleted, [file an issue][delete-request] and the Pub authors
will take down your package. You'll need to use a different version when you
re-upload it.

[delete-request]: https://github.com/dart-lang/pub-dartlang-dart/issues

#### Q. I get a timeout when I run pub. What do I do?

The [pub package server][] is hosted on [App Engine][]. We've seen a few times
where App Engine has run slowly for us and other users, leading to some
timeouts. If this happens, send us a note on the [mailing list][] and we'll
look into it. Usually it resolves itself in a few hours.

[pub package server]: https://pub.dartlang.org
[app engine]: https://appengine.google.com
[mailing list]: https://groups.google.com/a/dartlang.org/forum/?fromgroups#!forum/misc

### Why doesn't pub do ___?

Probably because we haven't implemented it yet. Pub is still under active
development. If you would like to see specific features, please
[file a ticket][Dart bug tracker] after searching to make sure it hasn't
already been requested yet. If it has, star it so we know what things are
important to users.

Also, patches are more than welcome!
[Pub](https://github.com/dart-lang/pub)
is open source, and we love outside
contributions. Both the client and server are well-tested,
well-documented, and, we hope, easy to contribute to.

### What is the roadmap for pub?

We don't generally make public roadmaps for pub. The Dart project is very fluid
and priorities and schedules change very frequently. If we make promises for
the future, we are likely to end up disappointing users when plans change.

### I still have questions. What should I do?

Send an email to the main Dart [mailing list][] and we'll see it.
