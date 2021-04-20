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
editing `pubspec.yaml` (adding `http: ^0.12.1` under `dependencies`)
and then calling `dart pub get`:

```terminal
$ dart pub add http:^0.12.1
```

By default, `dart pub add` gets the package from pub.dev.
You can use options to specify other
[dependency sources](/tools/pub/dependencies#dependency-sources) —
Git repos, the Flutter SDK, alternate package servers, or
a path within your local file system.


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
