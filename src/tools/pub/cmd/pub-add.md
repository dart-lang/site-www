---
title: dart pub add
description: Use dart pub add to add a dependency.
---

version note: Introduced in 2.19, this is the recommended method for add now, others will be deprecated (see old section)


_Add_ is one of the commands of the [pub tool](/tools/pub/cmd).

```nocode
$ dart pub add <package>[:<constraint>] [<package2>[:<constraint2>]... ] [options]
$ dart pub add [options] [dev:]<package>[:descriptor] [[dev:]<package>[:descriptor]
       ...]
```

This command adds the specified packages to the `pubspec.yaml` as dependencies, 
and then gets the dependencies. 

For example, the following command is equivalent to
editing `pubspec.yaml` to add the `http` package, 
and then calling `dart pub get`:

```terminal
$ dart pub add http
```

By default, `dart pub add` uses the
latest stable version of the package from the [pub.dev site]({{site.pub}}).
For example, if 0.13.3 is the latest stable version of the `http` package,
then `dart pub add http` adds
`http: ^0.13.3` under `dependencies` in the pubspec.

if `dart pub add foo:<constraint>` is an existing dependency, will update the constraint rather than fail.

It can add multiple packages from different sources, 
and have some packages be dev dependencies while others are not. 

[dev dependency]: /tools/pub/dependencies#dev-dependencies

## YAML syntax

`descriptor` is a yaml-formatted descriptor, as it would be written in pubspec.yaml in the dependencies section
foo:{<source>:<descriptor>,"version":"<constraint>"}


For example:
  * Add a hosted dependency at newest compatible stable version:
    `$topLevelProgram pub add foo`
  * Add a hosted dev dependency at newest compatible stable version:
    `$topLevelProgram pub add dev:foo`
  * Add a hosted dependency with the given constraint
    `$topLevelProgram pub add foo:^1.2.3`
  * Add multiple dependencies:
    `$topLevelProgram pub add foo dev:bar`
  * Add a path dependency:
    `$topLevelProgram pub add 'foo{"path":"../foo"}'`
  * Add a hosted dependency:
    `$topLevelProgram pub add 'foo{"hosted":"my-pub.dev"}'`
  * Add an sdk dependency:
    `$topLevelProgram pub add 'foo{"sdk":"flutter"}'`
  * Add a git dependency:
    `$topLevelProgram pub add 'foo{"git":"https://github.com/foo/foo"}'`
  * Add a git dependency with a path and ref specified:
    `$topLevelProgram pub add /
      'foo{"git":{"url":"../foo.git","ref":"branch","path":"subdir"}}'`



  /// Examples:
  /// ```
  /// retry
  /// retry:2.0.0
  /// dev:retry:^2.0.0
  /// retry:'>=2.0.0'
  /// retry:'>2.0.0 <3.0.1'
  /// 'retry:>2.0.0 <3.0.1'
  /// retry:any
  /// 'retry:{"path":"../foo"}'
  /// 'retry:{"git":{"url":"../foo","ref":"branchname"},"version":"^1.2.3"}'
  /// 'retry:{"sdk":"flutter"}'
  /// 'retry:{"hosted":"mypub.dev"}'
  /// ```

### `dev:`

To add a [dev dependency][], use the `dev:` prefix:

[dev dependency]: /tools/pub/dependencies#dev-dependencies

```terminal
$ dart pub add dev:test
```

### `hosted`

### `path`

### `sdk`

### `git`

### `git` 

#### `path`

#### `ref`

#### `url`


## Options

The `descriptor` used to be given with args like `--path`, `--sdk`,
`--git-<option>`.

We still support these arguments, but now the documented way to give the
descriptor is to give a yaml-descriptor as in pubspec.yaml.

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

{{site.alert.note}}
  Any specified options will apply to all the packages
  included in an invocation of the command.
  For example, `dart pub add test http --dev` 
  will add both the `test` and `http` packages 
  as dev dependencies.
{{site.alert.end}}

### `-d, --dev`

_See yaml section_

Adds the package as a dev dependency,
instead of as a regular dependency.

To add a [dev dependency][], use the `--dev` option:

[dev dependency]: /tools/pub/dependencies#dev-dependencies

```terminal
$ dart pub add --dev test
```

### `--git-url=`_`<git_repo_url>`_

_hidden/deprecated in favor of new syntax_

Depends on the package in the
[specified Git repository](/tools/pub/dependencies#git-packages).

```terminal
$ dart pub add http --git-url=https://github.com/my/http.git
```

### `--git-ref=`_`<branch_or_commit>`_

_hidden/deprecated in favor of new syntax_

With `--git-url`, depends on the specified branch or commit of a Git repo.

```terminal
$ dart pub add http --git-url=https://github.com/my/http.git --git-ref=tmpfixes
```

### `--git-path=`_`<directory_path>`_

_hidden/deprecated in favor of new syntax_

With `--git-url`, specifies the location of a package within a Git repo.

### `--hosted-url=`_`<package_server_url>`_

_hidden/deprecated in favor of new syntax_

Depends on the package server at the specified URL.

### `--path=`_`<directory_path>`_

_hidden/deprecated in favor of new syntax_

Depends on a locally stored package.

### `--sdk=`_`<sdk_name>`_

_hidden/deprecated in favor of new syntax_

Depends on a package that's shipped with the specified SDK
(example: `--sdk=flutter`).

### `--[no-]offline`

{% include tools/pub-option-no-offline.md %}

### `-n, --dry-run`

Reports which dependencies would change,
but doesn't change any.

### `--[no-]precompile`

By default, pub precompiles executables
in immediate dependencies (`--precompile`).
To prevent precompilation, use `--no-precompile`.

{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}
