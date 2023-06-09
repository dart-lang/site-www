---
title: dart pub token
description: Manage authentication tokens for package repositories.
---

_pub_ _token_ is one of the subcommands of the [pub command](/tools/pub/cmd).

It is used to manage a store of secret tokens for authenticating
against third-party servers when [publishing](pub-lish) packages and
[retrieving](pub-get) dependencies.

The tokens are stored in a
[user-wide config dir](https://github.com/dart-lang/cli_util/blob/71ba36e2554f7b7717f3f12b5ddd33751a4e3ddd/lib/cli_util.dart#L88-L118). 

It has three subcommands: `add`, `list` and `remove`.

If you try to `dart pub get` and have a [dependency](/tools/pub/dependencies) hosted
on a private repository you _may_ be asked to provide credentials:

```terminal
$ dart pub get
Resolving dependencies... 
https://some-package-repo.com/my-org/my-repo package repository requested authentication! You can provide credential using:
    pub token add https://some-package-repo.com/my-org/my-repo

Go to https://some-package-repo.com and log in to obtain your token. 
```

The last line is a message the server can provide to help you obtaining a token.
Some servers might not provide such a message.

## Adding credentials `dart pub token add`

To enter the credentials use `dart pub token add`, 
and type the credential on stdin.

```terminal
$ dart pub token add https://some-package-repo.com/my-org/my-repo
Enter secret token: <Type token on stdin>
 Requests to "https://some-package-repo.com/my-org/my-repo" will now be 
 authenticated using the secret token.
```

{{site.alert.note}}
  The token is input on stdin rather than as a command line option to avoid it
  ending up in the shell history such as `~/.bash_history`.
{{site.alert.end}}

In a scripting situation you can store the secret in an environment variable and
 use `dart pub token add <hosted-url> --env-var <ENV_VAR_NAME>`.

```terminal
$ dart pub token add https://other-package-repo.com/ --env-var TOKEN_VAR
Requests to "https://other-package-repo.com/" will now be authenticated using the secret token stored in the environment variable "TOKEN_VAR".
```

This will cause `dart pub get` to read whatever is stored in `$TOKEN_VAR` and
use that as the authentication token.

You can set the environment variable in Bash with `export TOKEN_VAR=...` but
that still doesn't prevent the command being logged.

Most CI environments has a way to inject secrets into an environment
variable:

* [GitHub Actions](https://docs.github.com/actions/security-guides/encrypted-secrets#using-encrypted-secrets-in-a-workflow).
* [GitLab](https://docs.gitlab.com/ee/ci/secrets/).

## Listing credentials `dart pub token list`

To see a list of all active credentials use `dart pub token list`:

```terminal
$ dart pub token list
You have secret tokens for 2 package repositories:
https://some-package-repo.com/my-org/my-repo
https://other-package-repo.com/
```

## Removing credentials `dart pub token remove`

You can remove a single token with `dart pub token remove`:

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
