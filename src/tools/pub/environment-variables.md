---
title: Configuring pub environment variables
short-title: Pub environment variables
description: How to configure your environment for Dart's package management tool, pub.
---

Environment variables allow you to customize pub to suit your needs.

`PUB_CACHE`
: Some of pub's dependencies are downloaded to the pub cache.
  By default, this directory is located under `.pub-cache`
  in your home directory (on Mac and Linux),
  or in `%APPDATA%\Pub\Cache` (on Windows). (The precise location of the
  cache may vary depending on the Windows version.)
  You can use the `PUB_CACHE` environment
  variable to specify another location. For more information, see
  [The system package cache](/tools/pub/cmd/pub-get#the-system-package-cache).

`PUB_HOSTED_URL`
: Pub downloads dependencies from the [Pub site.]({{site.pub}})
  To specify the location of a particular mirror server,
  use the `PUB_HOSTED_URL` environment variable. For example:

{% prettify sh %}
PUB_HOSTED_URL = http://user:password@177.0.0.1:9999
{% endprettify %}

<aside class="alert alert-info" markdown="1">
  **Note:**
  If you are attempting to use `pub get` behind a corporate firewall
  and it fails, please see
  [`pub get` fails from behind a corporate firewall](/tools/pub/troubleshoot#pub-get-fails-from-behind-a-corporate-firewall)
  for information on how to set up the proxy environment variables for
  your platform.
</aside>
