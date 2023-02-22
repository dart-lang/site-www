---
title: dart info
description: Command-line tool for outputting Dart tooling diagnostic information.
toc: false
---

The `dart info` command
outputs diagnostic information about installed `dart` tooling,
running Dart processes,
and project information if in a directory with a `pubspec.yaml`.
The output information can be used for debugging tooling issues
or reporting a bug.

{% include tools/dart-tool-note.md %}

{{site.alert.warning}}
  If you are including the `dart info` output in a bug report,
  please review the output to ensure it only
  contains details you're comfortable posting publicly.
{{site.alert.end}}

To output general information related to your system
and your Dart installation, including running Dart processes,
run `dart info` from any directory:

```terminal
$ dart info
```

For example, on macOS, 
the output looks similar to the following:

```nocode
#### General info

- Dart 2.19.2 (stable) (Tue Feb 7 18:37:17 2023 +0000) on "macos_arm64"
- on macos / Version 13.1 (Build 22C65)
- locale is en-US

#### Process info

| Memory |   CPU | Elapsed time | Command line                      |
| -----: | ----: | -----------: | ----------------------------------|
| 253 MB | 49.7% |        00:00 | analysis_server.dart.snapshot ... |
|  69 MB | 18.7% |        00:00 | dart analyze                      |   
```

To include project information in the output,
run `dart info` in a directory with a `pubspec.yaml` file.
The resulting output includes an additional **Project info** section:

```nocode
#### Project info

- sdk constraint: '>=2.19.2 <3.0.0'
- dependencies: path
- dev_dependencies: lints, test
```

To include file paths and path dependencies in
the displayed project and process info,
add the `--no-remove-file-paths` option:

```terminal
$ dart info --no-remove-file-paths
```
