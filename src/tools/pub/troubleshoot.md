---
permalink: /tools/pub/troubleshoot
title: Troubleshooting pub
description: Common gotchas you might run into when using pub.
---

## Getting a "403" error when publishing a package {#pub-publish-403}

You receive the following error when running `pub publish`:

{:.console-output}
```nocode
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

{:.console-output}
```nocode
UnauthorizedAccess: Unauthorized user: <username> is not allowed to upload versions to package '<foo>'.
```

You will see this message if you are not on the list of people
authorized to publish new versions of a package.
See [Uploaders](/tools/pub/publishing#uploaders).

## Pub build fails with HttpException error {#pub-get-fails}

You receive an HttpException error similar to the following when
running `pub build`:

{:.console-output}
```nocode
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
## Localhost unreachable after sign-in

When you run `dart pub publish` in a container or over an SSH session,
the `localhost` that `dart pub` is listening to might be different from
the `localhost` that's accessible in your browser.
Although you can sign in using the browser,
the browser then complains that `http://localhost:<port>?code=...`
is not reachable.

Try this workaround, which uses the command line to complete sign-in:

1. In a terminal window, run `dart pub publish`.
2. In the browser window that comes up, sign in. <br>
   The browser is redirected to a _new localhost URL_
   (`http://localhost:<port>?code=...`)
   but complains that the URL isn't reachable.
3. Copy the _new localhost URL_  from the browser.
4. In another terminal window in the same container or on the same host
   as the one where `dart pub publish` was called, use the `curl` command to
   complete sign-in using the _new localhost URL_:

   ```terminal
$ curl 'http://localhost:<port>?code=...'
```

## Getting a socket error trying to find a package {#pub-get-socket-error}

The following error might occur if
you have no internet access, your ISP is blocking `pub.dev`,
or security software is blocking internet access from `dart`.

{:.console-output}
```nocode
Got socket error trying to find package ... at https://pub.dartlang.org.
pub get failed (server unavailable) -- attempting retry 1 in 1 second...
```

Check your internet connection, and
verify that you don't have a firewall or other security software
that blocks internet access from `dart`.

<details markdown="1">
 <summary>
   <b>Detailed instructions for Kaspersky Internet Security</b>
  </summary>
   Even if _Kaspersky Internet Security_ protection is turned off in the menu bar,
   the VPN application filter `sysextctrld` still runs in the background,
   causing a failure to connect to the pub.dev server.
   The solution is to add `https://pub.dartlang.org` to the trusted zone:

   1. Open Kaspersky Internet Security, and click the **Privacy** icon.
   1. Under the **Block website tracking** section, click the **Preferences** button.
   1. In the top icon bar, select **Threats**.
   1. Under **Threats**, click **Trusted Zone**.
   1. Select the **Trusted web addresses** tab.
   1. Click the **+** button, and add the URL `https://pub.dartlang.org`.
   1. Click **OK**.
</details>
