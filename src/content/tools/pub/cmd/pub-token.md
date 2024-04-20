---
title: dart pub token
description: Manage authentication tokens for package repositories.
---

The `dart pub token` subcommand manages a store of secret tokens to
authenticate against third-party servers when [publishing](pub-lish) packages
and [retrieving](pub-get) dependencies.

It stores these tokens in a [user-wide config directory][config-dir].

This command has three subcommands: `add`, `list`, and `remove`.

Consider a scenario where you have a [dependency](/tools/pub/dependencies)
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

The server might include a message in the final line of the prompt
to help you obtain a token.
This message is displayed in the previous example.
Not all servers provide this message.

## Add a new credential

To add a new credential, run the command `dart pub token add`.

### Add a credential for the current session

At the prompt, type the credential on the command line.

```console
$ dart pub token add https://some-package-repo.com/my-org/my-repo
Enter secret token: <Type token on stdin>
 Requests to "https://some-package-repo.com/my-org/my-repo" will now be 
 authenticated using the secret token.
```

:::note
The token takes input over `stdin` rather than as a command line option
to keep the token out of the shell history.
:::

### Add a credential for all sessions

In a script, you can store the secret in an environment variable.

If you choose to store your token in an environment variable,
[find a way][zsh-post] to hide the token from your shell history.
If you add an environment variable, you need to restart any open
consoles to enable that new variable.

Most CI environments can inject tokens into an environment variable.
To learn how, consult documentation for [GitHub Actions][] or
[GitLab][] as examples.

[GitHub Actions]: https://docs.github.com/actions/security-guides/encrypted-secrets#using-encrypted-secrets-in-a-workflow
[GitLab]: https://docs.gitlab.com/ee/ci/secrets/
[zsh-post]: https://medium.com/@prasincs/hiding-secret-keys-from-shell-history-part-1-5875eb5556cc





## Return a list of credentials

To see a list of all active credentials, run the command `dart pub token list`:

```console
$ dart pub token list
You have secret tokens for 2 package repositories:
https://some-package-repo.com/my-org/my-repo
https://other-package-repo.com/
```

## Remove one or more credentials

To remove a single token, run the command `dart pub token remove`:

```console
$ dart pub token remove https://other-package-repo.com
Removed secret token for package repository: https://other-package-repo.com
```

To remove all tokens,
run the same command and append the `--all` option:

```console
$ dart pub token remove --all
pub-tokens.json is deleted.
Removed 1 secret tokens.
```

{% include 'pub-problems.md' %}

[config-dir]: {{site.repo.dart.org}}/cli_util/blob/71ba36e2554f7b7717f3f12b5ddd33751a4e3ddd/lib/cli_util.dart#L88-L118
