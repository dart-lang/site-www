---
title: dart pub token
description: Manage authentication tokens for package repositories.
---

The `dart pub token` subcommand manages a store of tokens.
When [publishing](pub-lish) packages and [retrieving](pub-get) dependencies,
the `dart pub` command uses tokens to authenticate against third-party servers.

It stores these tokens in a [user-wide config directory][config-dir].
The `dart pub token` subcommand has three subcommands:
[`add`][], [`list`][] and [`remove`][].

The `dart pub` command considers the terms _credential_, _token_, _secret_,
and _secret token_ to be interchangeable.

[`add`]: #add-a-new-credential
[`list`]: #return-a-list-of-credentials
[`remove`]: #remove-one-or-more-credentials

## Use case for credentials

Consider a scenario when you have a [dependency](/tools/pub/dependencies)
hosted on a private repository.
When you use the `dart pub get` command, it _might_ return a prompt
to provide credentials:

```console
$ dart pub get
Resolving dependencies... 
https://some-package-repo.com/my-org/my-repo package repository requested authentication!
You can provide credentials using:
    dart pub token add https://some-package-repo.com/my-org/my-repo
```

Some, but not all, servers also return a message with instructions as
to how you can obtain a token.

## Add a new credential

To create a new credential,
use the `dart pub token add` command.

### Add a credential for the current session

At the prompt, type the credential on the command line (`stdin`).

```console
$ dart pub token add https://some-package-repo.com/my-org/my-repo
Enter secret token: <Type token on stdin>
 Requests to "https://some-package-repo.com/my-org/my-repo" will now be 
 authenticated using the secret token.
```

:::note
To keep the token out of the shell history,
the `dart pub token` command takes input on `stdin` rather than
as a command line option.
:::

### Add a credential for all sessions

To use the same token for any and all terminal sessions and in scripts,
store the token in an environment variable.

1. Store your token in an environment variable.

   Make sure to hide the token from your shell history.
   To explore one way of doing this, consult [this post on Medium][zsh-post].

1. To enable any environment variables that you add,
   restart any open consoles.

1. To use an environment variable as a token,
   use the `dart pub token add` command:

   ```console
   $ dart pub token add <hosted-url> --env-var <TOKEN_VAR>
   ```

   This command reads the token stored in `$TOKEN_VAR`
   then uses it to authenticate with the `hosted-url`
   hosting the desired package.
   It should print the following response to the terminal.

   ```console
   $ dart pub token add https://other-package-repo.com/ --env-var TOKEN_VAR
   Requests to "https://other-package-repo.com/" will now be authenticated using the secret token stored in the environment variable "TOKEN_VAR".
   ```

Most CI environments can inject tokens into an environment variable.
To learn how, consult documentation for [GitHub Actions][] or
[GitLab][] as examples.

[GitHub Actions]: https://docs.github.com/actions/security-guides/encrypted-secrets#using-encrypted-secrets-in-a-workflow
[GitLab]: https://docs.gitlab.com/ee/ci/secrets/
[zsh-post]: https://medium.com/@prasincs/hiding-secret-keys-from-shell-history-part-1-5875eb5556cc

## Return a list of credentials

To see a list of all active credentials, use the `dart pub token list` command:

```console
$ dart pub token list
You have secret tokens for 2 package repositories:
https://some-package-repo.com/my-org/my-repo
https://other-package-repo.com/
```

## Remove one or more credentials

To remove a single token, use the `dart pub token remove` command:

```console
$ dart pub token remove https://other-package-repo.com
Removed secret token for package repository: https://other-package-repo.com
```

To remove all tokens, use the preceding command with the `remove --all` option:

```console
$ dart pub token remove --all
pub-tokens.json is deleted.
Removed 1 secret tokens.
```

{% render 'pub-problems.md' %}

[config-dir]: {{site.repo.dart.org}}/cli_util/blob/71ba36e2554f7b7717f3f12b5ddd33751a4e3ddd/lib/cli_util.dart#L88-L118
