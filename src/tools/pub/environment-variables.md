---
title: Configuring pub environment variables
short-title: Pub environment variables
description: How to configure your environment for Dart's package management tool, pub.
toc: false
---

Environment variables allow you to customize pub to suit your needs.

`PUB_CACHE`
: Some of pub's dependencies are downloaded to the pub cache.
  By default, this directory is located under
  `$HOME/.pub-cache` (on macOS and Linux),
  or in `%LOCALAPPDATA%\Pub\Cache` (on Windows). (The precise location of the
  cache may vary depending on the Windows version.)
  You can use the `PUB_CACHE` environment
  variable to specify another location. For more information, see
  [The system package cache](/tools/pub/cmd/pub-get#the-system-package-cache).

`PUB_HOSTED_URL`
: Pub downloads dependencies from the [pub.dev site.]({{site.pub}})
  To specify the location of a particular mirror server,
  use the `PUB_HOSTED_URL` environment variable. For example:

```conf
PUB_HOSTED_URL = https://pub.example.com
```

For more information about using a private package repository,
see [Overriding the default package repository][].

{{site.alert.note}}
  If you are attempting to use `pub get` behind a corporate firewall
  and it fails, 
  please see [`pub get` fails from behind a corporate firewall][]
  for information on how to set up the proxy environment variables
  for your platform.
{{site.alert.end}}

[`pub get` fails from behind a corporate firewall]: /tools/pub/troubleshoot#pub-get-fails-from-behind-a-corporate-firewall
[Overriding the default package repository]: /tools/pub/custom-package-repositories#default-override
