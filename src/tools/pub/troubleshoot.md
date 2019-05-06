---
permalink: /tools/pub/troubleshoot
title: "Troubleshooting pub"
description: "Common gotchas you might run into when using pub."
---

## Getting a "403" error when publishing a package {#pub-publish-403}

You receive the following error when running `pub publish`:

{% prettify none %}
HTTP error 403: Forbidden
...
You aren't an uploader for package '<foo>'
{% endprettify %}

This problem can occur if one of your accounts was granted permission to
publish a package, but the pub client registers you with another account.

You can reset pub's authentication process by removing the credentials file:

{% prettify sh %}
rm ~/.pub-cache/credentials.json
{% endprettify %}

## Getting an "UnauthorizedAccess" error when publishing a package {#pub-publish-unauthorized}

You receive the following error when running `pub publish`:

{% prettify none %}
UnauthorizedAccess: Unauthorized user: <username> is not allowed to upload versions to package '<foo>'..
{% endprettify %}

You will see this message if you are not on the list of people
authorized to publish new versions of a package.
See [Authors versus uploaders](publishing#authors-versus-uploaders).

## Pub build fails with HttpException error {#pub-get-fails}

You receive an HttpException error similar to the following when
running `pub build`:

{% prettify none %}
Pub build failed, [1] IsolateSpawnException: 'HttpException: Connection closed while receiving data,
...
library handler failed
...
{% endprettify %}

This can happen as a result of some antivirus software, such as the
AVG 2013 Internet security suite. Check the manual for your security
suite to see how to temporarily
disable this feature. For example, see
[How to Disable AVG Components](https://support.avg.com/SupportArticleView?urlName=How-to-disable-AVG).

## Pub get fails from behind a corporate firewall

From the command line, pub honors the `http_proxy` and `https_proxy`
environment variables.
You can set the proxy server environment variable as follows.

On Linux/macOS:

{% prettify sh %}
$ export https_proxy=hostname:port
{% endprettify %}

On Windows:

{% prettify sh %}
> set https_proxy=hostname:port
{% endprettify %}

If the proxy requires credentials, you can set them as follows.

On Linux/macOS:

{% prettify sh %}
$ export https_proxy=username:password@hostname:port
{% endprettify %}

On Windows:

{% prettify sh %}
> set https_proxy=username:password@hostname:port
{% endprettify %}

