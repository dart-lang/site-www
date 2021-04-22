---
title: dart pub add
description: Use dart pub add to add a dependency.
toc: false
---

_Add_ is one of the commands of the [pub tool](/tools/pub/cmd).

```
$ dart pub add <package>[:<constraint>] [options]
```

This command adds the specified package to the pubspec as a dependency,
and then gets the dependency.
For example, the following command is equivalent to
editing `pubspec.yaml` to add the `http` package,
and then calling `dart pub get`:

```terminal
$ dart pub add http
```

By default, `dart pub add` uses the
latest stable version of the package from pub.dev.
For example, if 0.13.1 is the latest stable version of the `http` package,
then `dart pub add http` adds
`http: ^0.13.1` under `dependencies` in the pubspec.

To add a [dev dependency][], use the `--dev` option:

[dev dependency]: /tools/pub/dependencies#dev-dependencies

```terminal
$ dart pub add --dev test
```

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

<dl>
    <dt><code>-d, --dev</code></dt>
        <dd>Adds the package as a dev dependency,
        instead of as a regular dependency.</dd>
    <dt><code>--git-url=<var>git_repo_url</var></code></dt>
        <dd>Depends on the package in the
        <a href="/tools/pub/dependencies#git-packages">specified Git repo</a>.
        </dd>
        {% prettify nocode tag=pre+code %}
        $ dart pub add http --git-url=https://github.com/my/http.git
        {% endprettify %}
    <dt><code>--git-ref=<var>branch_or_commit</var></code></dt>
        <dd>With <code>--git-url</code>,
        depends on the specified branch or commit of a Git repo.</dd>
        {% prettify nocode tag=pre+code %}
        $ dart pub add http --git-url=https://github.com/my/http.git --git-ref=tmpfixes
        {% endprettify %}
    <dt><code>--git-path=<var>directory_path</var></code></dt>
    <dd>With <code>--git-url</code>,
    specifies the location of a package within a Git repo.</dd>
    <dt><code>--hosted-url=<var>package_server_url</var></code></dt>
    <dd>Depends on the package server at the specified URL.</dd>
    <dt><code>--path=<var>directory_path</var></code></dt>
    <dd>Depends on a locally stored package.</dd>
    <dt><code>--sdk=<var>sdk_name</var></code></dt>
    <dd>Depends on a package that's shipped with the specified SDK
    (example: <code>--sdk=flutter</code>).</dd>
    <dt><code>--[no-]offline</code></dt>
    <dd>Uses cached packages instead of the network.</dd>
    <dt><code>-n, --dry-run</code></dt>
    <dd>Reports which dependencies would change, but doesn't change any.</dd>
    <dt><code>--[no-]precompile</code></dt>
    <dd>Precompiles executables in immediate dependencies (true by default).</dd>

</dl>
