---
permalink: /tools/pub/troubleshoot
title: "Troubleshooting pub"
description: "Common gotchas you might run into when using pub."
---

## Getting a "403" error when publishing a package {#pub-publish-403}

You receive the following error when running `pub publish`:

```terminal
$ pub publish ...
HTTP error 403: Forbidden
...
You aren't an uploader for package '<foo>'
```

This problem can occur if one of your accounts was granted permission to
publish a package, but the pub client registers you with another account.

You can reset pub's authentication process by removing the credentials file:

```terminal
$ rm ~/.pub-cache/credentials.json
```

## Getting an "UnauthorizedAccess" error when publishing a package {#pub-publish-unauthorized}

You receive the following error when running `pub publish`:

```terminal
$ pub publish ...
UnauthorizedAccess: Unauthorized user: <username> is not allowed to upload versions to package '<foo>'.
```

You will see this message if you are not on the list of people
authorized to publish new versions of a package.
See [Authors versus uploaders](publishing#authors-versus-uploaders).

## Pub build fails with HttpException error {#pub-get-fails}

You receive an HttpException error similar to the following when
running `pub build`:

```terminal
$ pub build ...
Pub build failed, [1] IsolateSpawnException: 'HttpException: Connection closed while receiving data,
...
library handler failed
...
```

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

```terminal
$ export https_proxy=hostname:port
```

On Windows Command Prompt:

```terminal
$ set https_proxy=hostname:port
```

On Windows PowerShell:

```terminal
$ $Env:https_proxy="hostname:port"
```

If the proxy requires credentials, you can set them as follows.

On Linux/macOS:

```terminal
$ export https_proxy=username:password@hostname:port
```

On Windows Command Prompt:

```terminal
$ set https_proxy=username:password@hostname:port
```

On Windows PowerShell:

```terminal
$ $Env:https_proxy="username:password@hostname:port"
```

