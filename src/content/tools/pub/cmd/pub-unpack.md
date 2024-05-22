---
title: dart pub unpack
description: Downloads a package and unpacks its contents in place.
---

:::version-note
The `unpack` subcommand was introduced in Dart 3.4.
To download the archive of a package with an earlier SDK,
visit the **Versions** tab of a package on the [pub.dev site]({{site.pub}}).
:::

_Unpack_ is one of the commands of the [pub tool](/tools/pub/cmd).

```plaintext
$ dart pub unpack <package>[:descriptor] [--[no-]resolve] [--output=<output directory>] [--[no-]force] [other options]
```

This command downloads the specified `<package>` and
extracts its contents to a `<package>-<version>` directory.

For example, the following command downloads and extracts the
latest stable version of `package:http` from the [pub.dev site]({{site.pub}}),
to the current directory:

```console
$ dart pub unpack http
```

To change the source or version of the downloaded package,
add a source descriptor after the package name and a colon.
For example, the following command downloads the `1.2.0` release
of `package:http` from the pub.dev site:

```console
$ dart pub unpack http:1.2.0
```

The source descriptor supports more configuration
with the same syntax as `dart pub add`.
To learn more about source descriptors and their syntax, check out
the [source descriptor][] documentation for `dart pub add`.

[source descriptor]: /tools/pub/cmd/pub-add#source-descriptor

## Options

For options that apply to all pub commands, check out
[Global options](/tools/pub/cmd#global-options).

### `--force` or `-f` {:#force-option}

Overwrite existing folders that conflict
with the package folder or its contents during extraction.

### `--[no-]resolve` {:#resolve-option}

By default, `dart pub get` runs automatically to complete
package resolution after downloading and unpacking a package.
To disable automatic resolution,
specify the `--no-resolve` flag:

```console
$ dart pub unpack http --no-resolve
```

### `--output=<dir>` or `-o <dir>` {:#output-option}

By default, extract the package to the current directory (`.`).
To change the directory the package is extracted to,
specify the desired output directory with the `--output` option.

For example, the following commands unpacks the
`1.2.0` release of `package:http` to the `local_http_copies` directory.

```console
$ dart pub unpack http:1.2.0 -o local_http_copies
```


{% render 'pub-problems.md' %}
