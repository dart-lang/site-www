---
title: dart pub add
description: Use dart pub add to add dependecies to pubspec.yaml.
toc: false
---

_Add_ is one of the commands of the [pub tool](/tools/pub/cmd).

```
$ dart pub add <package> [options]
```
Example:

```
$ dart pub add http:0.12.1
```

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

<dl>
    <dt><code>-h, --help</code></dt>
        <dd>Print this usage information.</dd>
    <dt><code>-d, --dev</code></dt>
        <dd>Adds package to the development dependencies instead.</dd>
    <dt><code>--git-url</code></dt>
        <dd>Git URL of the package.
        </dd>
        {% prettify nocode tag=pre+code %}
        $ dart pub add package-name --git-url package-git-url
        {% endprettify %} 
    <dt><code>--git-ref</code></dt>
        <dd>Git branch or commit to be retrieved</dd>
        {% prettify nocode tag=pre+code %}
        $ dart pub add package-name --git-url package-git-url --git-ref=branch-name
        {% endprettify %}
    <dt><code>--git-path</code></dt>
    <dd>Path of git package in repository</dd>
    <dt><code>--hosted-url </code></dt>
    <dd>URL of package host server</dd>
    <dt><code>--path</code></dt>
    <dd>Local path.</dd>
    <dt><code>--sdk</code></dt>
    <dd>SDK source for package.</dd>
    <dt><code>--[no-]offline</code></dt>
    <dd>Use cached packages instead of accessing the network.</dd>
    <dt><code>-n, --dry-run</code></dt>
    <dd>Report what dependencies would change but don't change any.</dd>
    <dt><code>--[no-]precompile</code></dt>
    <dd>Precompile executables in immediate dependencies.</dd>

</dl>
