---
layout: default
title: "Installing and Configuring Pub"
description: "How to install and configure your environment for Dart's package management tool, pub."
permalink: /tools/pub/installing
---

[Pub](/tools/pub/) is one of the tools in the
[Dart SDK](/tools/sdk).

You can use pub through an IDE, such as WebStorm, or through the
`pub` command-line app, which lives inside the `bin` directory of the Dart SDK.

## Get pub

{% include configure-path.html %}

## Optional environment variables

Environment variables allow you to customize pub to suit your needs.

`PUB_CACHE`:
Some of pub's dependencies are downloaded to the pub cache.
By default, this directory is located under `.pub_cache`
in your home directory (on Mac and Linux),
or in `AppData\Roaming\Pub\Cache` (on Windows).
You can use the `PUB_CACHE` environmant
variable to specify another location. For more information, see
[The system package cache](/tools/pub/cmd/pub-get.html).

`PUB_HOSTED_URL`:
Pub downloads dependencies from `pub.dartlang.org`. To specify the
location of a particular mirror server,
use the `PUB_HOSTED_URL` environment variable. For example:

{% prettify sh %}
PUB_HOSTED_URL = http://user:password@177.0.0.1:9999
{% endprettify %}

<aside class="alert alert-info" markdown="1">
**Note:**
If you are attempting to use `pub get` behind a corporate firewall
and it fails, please see
[`pub get` fails from behind a corporate firewall](/tools/pub/troubleshoot.html#pub-get-fails-from-behind-a-corporate-firewall)
for information on how to set up the proxy environment variables for
your platform.
</aside>
