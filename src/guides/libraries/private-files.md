---
title: What not to commit
description: Your development tools generate a bunch of files. Not all of them should be committed.
---

When you put Dart source code in a repository—using the
[pub tool](/tools/pub/cmd), [GitHub,](https://github.com/)
or another source code management system—don't include most of the files
that your IDE or code editor, the pub tool, and other tools generate.

{{site.alert.note}}
  Except where noted, this page discusses only source code repositories,
  _not_ app deployment.
  Some files that you wouldn't normally put in a repository
  are useful or essential when you deploy an app.
{{site.alert.end}}

## The rules

**Don't commit** the following files and directories
created by pub:

```gitignore
.dart_tool/
build/
pubspec.lock  # Except for application packages
```

**Don't commit** the API documentation directory
created by [`dart doc`](/tools/dart-doc):

```gitignore
doc/api/
```

**Don't commit** files and directories
created by other development environments.
For example, if your development environment creates
any of the following files,
consider putting them in a global ignore file:

```gitignore
# IntelliJ
*.iml
*.ipr
*.iws
.idea/

# Mac
.DS_Store
```

For more details, read on.

## Details

As a rule, commit only the files that people need
to use your package or source code repository.
Including additional files is unnecessary,
could be counterproductive,
and might have security implications
if you expose details about your machine's setup.
In many source code repositories,
the common practice is not to commit generated files, at all.

To avoid committing files that are
specific to your personal workflow or setup,
consider using a global ignore file
(for example, `.gitignore_global`).

When you use pub from within a Git repo,
pub ignores the same files that Git does.
For example, if you run `pub publish` from a Git repo
that has a `.gitignore` file containing `keys.txt`,
then your published package won't contain the `keys.txt` file.

For more information on `.gitignore` files,
see the GitHub help page
[Ignoring files.](https://help.github.com/articles/ignoring-files)

### .dart_tool/

The `.dart_tool/` directory contains files used by 
various Dart tools.


### pubspec.lock

The `pubspec.lock` file is a special case,
similar to Ruby's `Gemfile.lock`.

**For regular packages**, **don't commit** the `pubspec.lock` file.
Regenerating the `pubspec.lock` file lets you test your package
against the latest compatible versions of its dependencies.

**For application packages**, 
we recommend that you commit the `pubspec.lock` file.
Versioning the `pubspec.lock` file
ensures changes to transitive dependencies are explicit.
Each time the dependencies change due to `dart pub upgrade`
or a change in `pubspec.yaml` 
the difference will be apparent in the lock file.
