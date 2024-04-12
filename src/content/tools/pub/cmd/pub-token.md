---
title: dart pub token
description: Manage authentication tokens for package repositories.
---

The `dart pub token` subcommand manages a store of secret tokens to
authenticate against third-party servers when [publishing](pub-lish) packages
and [retrieving](pub-get) dependencies.

It stores these tokens in a [user-wide config directory][config-dir].

It has three subcommands: `add`, `list` and `remove`.

Consider a scenario when you have a [dependency](/tools/pub/dependencies)
hosted on a private repository.
When you invoke `dart pub get`, the command _might_ return a prompt
to provide credentials:

```console
$ dart pub get
Resolving dependencies... 
https://some-package-repo.com/my-org/my-repo package repository requested authentication! You can provide credential using:
    pub token add https://some-package-repo.com/my-org/my-repo

Go to https://some-package-repo.com and log in to obtain your token. 
```

In this last message, the final line gives you the server that can help you
obtain a token. Not all servers provide such this message.

## Add a new credential

To create a new credential, invoke `dart pub token add`.

### Add a credential for the current session

At the prompt, type the credential on the command line (`stdin`).

```console
$ dart pub token add https://some-package-repo.com/my-org/my-repo
Enter secret token: <Type token on stdin>
 Requests to "https://some-package-repo.com/my-org/my-repo" will now be 
 authenticated using the secret token.
```

:::note
The token takes input on `stdin` rather than as a command line option
to keep the token out of the shell history.
:::

### Add a credential for all sessions

In a script, you can store the secret in an environment variable.

If you choose to store your secret in an environment variable,
find a way to hide the secret from your shell history.
To explore one way of doing this, consult [this post on Medium][zsh-post].
If you add a local environment variable, you need to restart any open
consoles to enable that new variable.

Most CI environments can inject secrets into an environment variable.
To learn how, consult documentation for [GitHub Actions][]] or
[GitLab][] as examples.

[GitHub Actions]: https://docs.github.com/actions/security-guides/encrypted-secrets#using-encrypted-secrets-in-a-workflow
[GitLab]: https://docs.gitlab.com/ee/ci/secrets/
[zsh-post]: https://medium.com/@prasincs/hiding-secret-keys-from-shell-history-part-1-5875eb5556cc

To use an environment variable as a token, invoke:

```console
dart pub token add <hosted-url> --env-var <ENV_VAR_NAME>
```

This causes `dart pub get` to read the data stored in `$TOKEN_VAR` then
use it as the authentication token.

```console
$ dart pub token add https://other-package-repo.com/ --env-var TOKEN_VAR
Requests to "https://other-package-repo.com/" will now be authenticated using the secret token stored in the environment variable "TOKEN_VAR".
```

## Return a list of credentials

To see a list of all active credentials, invoke `dart pub token list`:

```console
$ dart pub token list
You have secret tokens for 2 package repositories:
https://some-package-repo.com/my-org/my-repo
https://other-package-repo.com/
```

## Remove one or more credentials

To remove a single token, invoke `dart pub token remove`:

```console
$ dart pub token remove https://other-package-repo.com
Removed secret token for package repository: https://other-package-repo.com
```

To remove all tokens, invoke the command with the `remove --all` option:

```console
$ dart pub token remove --all
pub-tokens.json is deleted.
Removed 1 secret tokens.
```

{% include 'pub-problems.md' %}

[config-dir]: {{site.repo.dart.org}}/cli_util/blob/71ba36e2554f7b7717f3f12b5ddd33751a4e3ddd/lib/cli_util.dart#L88-L118
