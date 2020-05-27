---
title: What not to commit
description: Your development tools generate a bunch of files. Not all of them should be committed.
---

When you put Dart source code in a repository—using the
[pub tool](/tools/pub/cmd), [GitHub,](https://github.com/)
or another source code management system—don't include most of the files
that your IDE or code editor, the pub tool, and other tools generate.

<aside class="alert alert-info" markdown="1">
**Note:**
Except where noted, this page discusses only source code repositories,
_not_ app deployment.
Some files that you wouldn't normally put in a repository
are useful or essential when you deploy an app.
</aside>

## The rules

**Don't commit** the following files and directories
created by pub:

{% prettify none tag=pre+code %}
.dart_tool/
.packages
build/
pubspec.lock  # Except for application packages
{% endprettify %}

<aside class="alert alert-info" markdown="1">
**Note:** The `.dart_tool` directory, which is new in Dart 2,
is used by pub and other tools. It replaces the `.pub` directory as of
the 2.0.0-dev.32.0 SDK release. The `.packages` file replaces the
`packages` directories that early Dart versions produced.
</aside>

**Don't commit** the API documentation directory created by dartdoc:

{% prettify none tag=pre+code %}
doc/api/
{% endprettify %}

**Don't commit** files and directories
created by other development environments.
For example, if your development environment creates
any of the following files,
consider putting them in a global ignore file:

{% prettify none tag=pre+code %}
# IntelliJ
*.iml
*.ipr
*.iws
.idea/

# Mac
.DS_Store
{% endprettify %}

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


### .packages

The `.packages` file contains a list of dependencies used by your application.
Users of your code should generate their own packages information
using [pub get](/guides/packages#getting-packages).

{% include packages-dir.html %}

### pubspec.lock

The `pubspec.lock` file is a special case,
similar to Ruby's `Gemfile.lock`.

**For library packages**, **don't commit** the `pubspec.lock` file.
Regenerating the `pubspec.lock` file lets you test your package
against the latest compatible versions of its dependencies.

**For application packages**, we recommend that you
**commit** the `pubspec.lock` file.
Saving `pubspec.lock` ensures that everyone working on the app
uses the exact same versions.
