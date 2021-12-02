---
title: dart pub token
description: Manage authentication tokens for package repositories.
---

_pub_ _token_ is one of the subcommands of the [pub command](/tools/pub/cmd).

It is used to update a store of credential tokens used for authenticating
against third-party servers when [publishing](pub-lish) a package and when
[retrieving](pub-get) dependencies.

It has three subcommands: `add`, `list` and `remove`.

If you try to `dart pub get` and have a [dependency](/tools/pub/dependencies) hosted
on a private repository you will be asked to provide credentials:

```terminal
$ dart pub get
Resolving dependencies... 
https://some-package-repo.com/my-org/my-repo package repository requested authentication! You can provide credential using:
    pub token add https://some-package-repo.com/my-org/my-repo

Go to https://some-package-repo.com and log in to obtain your token. 
```

The last line is a message the server can provide to help you obtaining a token.
Some servers might not provide such a message.

To enter the credentials use the `add` subcommand, 
and type the credential on stdin.

```terminal
$ dart pub token add https://some-package-repo.com/my-org/my-repo
Enter secret token: <Type token on stdin>
 Requests to "https://some-package-repo.com/my-org/my-repo" will now be 
 authenticated using the secret token.
```

In a scripting situation you can pipe the credential to `add`. This might leave
a trace in the command history if you are not careful.

```terminal
$ echo <credential> | dart pub token add https://other-package-repo.com/
```

To see a list of all active credentials use `list`:

```terminal
$ dart pub token list
You have secret tokens for 2 package repositories:
https://some-package-repo.com/my-org/my-repo
https://other-package-repo.com/
```

You can remove a single token with `remove`:

```terminal
$ dart pub token remove https://other-package-repo.com
Removed secret token for package repository: https://other-package-repo.com
```

Or remove all with `remove --all`:

```terminal
$ dart pub token remove --all
pub-tokens.json is deleted.
Removed 1 secret tokens.
```

{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}
