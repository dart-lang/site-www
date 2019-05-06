---
title: Install shared packages
description: Packages are bundles of source code, tools, and resources that help you to organize and share code
---

### Borrow and share code.

<div class="mini-toc" markdown="1">
  <h4>What's the point?</h4>

  * The [Pub site]({{site.pub}}) is the primary public repository for Dart
    packages.
  * Following a few conventions, such as having a valid pubspec.yaml file,
    makes your app a package.
  * If you're developing a web or server-side app,
    use Stagehand to generate starting files.
  * If you're developing a web or server-side app,
    use `pub get` to download packages.
  * If you're developing a mobile app, use Flutter's tools.
</div>

Once you can create and run a Dart app,
you're ready to leverage code written by other programmers.
Many interesting and useful packages of reusable Dart code
are available at the [Pub site]({{site.pub}}) repository.

This tutorial shows how to use `pub`&mdash;a package manager
that comes with Dart&mdash;to
install one of the packages in the repository,
the vector_math package.
You can follow these same steps to install any package hosted at
the [Pub site]({{site.pub}};
just change the package name when you get to that step.
This tutorial also describes some of the resources you can expect to find
in a well-built package.

<aside class="alert alert-info" markdown="1">
  **Flutter note:**
  This page doesn't describe the tools you use with Flutter, but the
  concepts are the same, and you can share packages between
  your Flutter and web or server-side apps.
  For more information, see the
  [Flutter package documentation.]({{site.flutter}}/docs/development/packages-and-plugins/using-packages)
</aside>


## About the pubspec.yaml file

To use an external package,
your app must itself be a package.
Any app with a valid pubspec.yaml file in its top-level directory
is a package and can therefore use external packages.

You can use the Stagehand tool to generate packages
with valid pubspec.yaml files and directory structures.
Stagehand works either at the command line or (behind the scenes) in an IDE
such as IntelliJ or WebStorm.

Install or update Stagehand using
[pub global activate](/tools/pub/cmd/pub-global):

```terminal
> pub global activate stagehand
```

Now run the `stagehand` command to see what kinds of template files
it can generate:

```terminal
> stagehand
```

You'll see a list of generators, including various web and server-side apps.
One of the generators is named **console-full**.

In a new directory named `vector_victor`,
use Stagehand to generate a command-line app:

```terminal
> mkdir vector_victor
> cd vector_victor
> stagehand console-full
```

The pubspec.yaml file contains the package specification written in YAML.
(Visit <a href="/tools/pub/pubspec">Pubspec Format</a>
for in-depth coverage.)
The contents of your pubspec.yaml file should look something like this:

```yaml
name: vector_victor
description: A sample command-line application.

environment:
  sdk: '>=2.1.0 <3.0.0'

#dependencies:
#  path: ^1.4.1

dev_dependencies:
  test: ^1.0.0
```

## Name the package dependencies

To use an external library package,
you need to add the package to your
app's list of dependencies
in the pubspec.yaml file.
Each item in the dependencies list
specifies the name and version
of a package that your app uses.

Let's make the vector_victor app have a dependency
on the vector_math package,
which is available at the [Pub site]({{site.pub}}).

 1. Get the current installation details for the package:

    {: type="a"}
     1. Go to [vector_math's entry on the Package
        site.]({{site.pub}}/packages/vector_math)
     2. Click the **Installing** tab.
     3. Copy the **vector_math** line from the sample **dependencies** entry.
        The entry should look something like this:

        ```yaml
        dependencies:
          vector_math: ^2.0.7
        ```

 2. Edit `pubspec.yaml`.

 3. In the dependencies section, add the string you copied from the
    Pub site. Be careful to keep the indentation the same; YAML is
    picky! For example:

    ```yaml
    environment:
      sdk: '>=2.1.0 <3.0.0'

    dependencies:
      vector_math: ^2.0.7

    dev_dependencies:
      test: ^1.0.0
    ```

For details of what version numbers mean
and how you can format them,
see [Pub versioning philosophy](/tools/pub/versioning).

The [Pub site]({{site.pub}})
is the primary public repository for Dart packages.
`pub` automatically checks that
website when resolving package dependencies.
To use one of the packages from that site,
you can specify it by its simple name,
as we have done here.

## Install the package dependencies

If you're using an IDE or Dart-savvy editor to edit `pubspec.yaml`,
it might automatically install the packages your app depends on.

If not, do it yourself by running
[pub get](/tools/pub/cmd/pub-get):

```terminal
> pub get
Resolving dependencies...
+ vector_math 2.0.7
Changed 1 dependency!
Precompiling executables...
Precompiled vector_math:mesh_generator.
```

The `pub get` command installs the
packages in your app's dependencies list.
Each package can contain libraries and other assets.
Pub works recursively;
if an included package has dependencies, those packages are installed as well.
Pub caches the files for each package your app depends on,
pointing to them from a file named `.packages`.

{% comment %}
PENDING: Here only to make it easy to find the packages discussion: packages-dir.html
{% endcomment %}

Pub creates a file called `pubspec.lock`
that identifies the specific versions of the packages that were installed.
This helps to provide a stable development environment.
Later you can modify the version constraints and use `pub upgrade`
to update to new versions as needed.

## What did you get (and not get)?

Besides the Dart libraries,
the vector_math package has other resources that might be useful to you
that do not get installed into your app directory.
Let's take a step back for a moment to look at what
you got and where it came from.

To see the contents of the vector_math package,
visit the
<a href="https://github.com/johnmccutchan/vector_math" target="_blank">
Dart vector math repository
</a>
at GitHub.
Although many files and directories are in the repository,
only one, `lib`, was installed when you ran pub get.

<div>
  <hr>
  <div class="row">
    <div class="col-lg-3">
    <img class="scale-img-max" src="/tutorials/images/libraries-folder.png"
         alt="Dart libraries directory"/>
    </div>
    <div class="col-lg-7">
      <em>Dart libraries:</em>
      The lib directory contains one or more Dart libraries,
      which can be imported into your Dart programs.
    </div>
  </div>
  <hr>
  <div class="row">
    <div class="col-lg-3">
    <img class="scale-img-max" src="/tutorials/images/housekeeping-files.png"
         alt="Housekeeping files"/>
    </div>
    <div class="col-lg-7">
      <em>Housekeeping files:</em>
      When using a package written by someone else,
      the README file is a good place to start.
      It should contain important information about the package,
      such as its intent, contents, samples, and instructions.
      The LICENSE file provides copyright and rules-of-use information.
      These files can be found at the package repository.
      They are not installed when you install a package.
    </div>
  </div>
  <hr>
  <div class="row">
    <div class="col-lg-3">
    <img class="scale-img-max" src="/tutorials/images/other-folders.png"
         alt="Document, scripts, tests, and other resources"/>
    </div>
    <div class="col-lg-7">
      <em>Other resources:</em>
      Along with Dart libraries,
      a package might also contain other resources
      such as example code, tests, scripts, and documentation.
      If a package contains these resources,
      they should be in the directories as specified in the pub
<a href="/tools/pub/package-layout">conventions</a>.
    </div>
  </div>
  <hr>
</div>

## Import libraries from a package

Now that you've installed the package,
you can import its libraries and use them in your app.

As with the SDK libraries,
use the **import** directive to use code from an installed library.
The Dart SDK libraries are built in and
are identified with the special `dart:` prefix.
For external libraries installed by pub,
use the `package:` prefix.

1. Get the import details for the package's main library:

   {: type="a"}
   1. Go to [vector_math's entry on the Package
      site.]({{site.pub}}/packages/vector_math)
   2. Click the **Installing** tab.
   3. Copy the **import** line. It should look something like this:

      ```dart
      import 'package:vector_math/vector_math.dart';
      ```

2. In your vector_victor app, edit `lib/vector_victor.dart`,
   so that it imports the vector_math library and uses some of its API.
   For inspiration, look at the
   [vector_math API
   docs]({{site.pub}}/documentation/vector_math/latest),
   which you can find from the Pub site entry.

   <aside class="alert alert-info" markdown="1">
     **Note:** You specify a filename, not a library name,
     when you import a library from a package.
   </aside>


## Other resources

* Dart developers share packages at the [Pub site]({{site.pub}}).
  Look there for packages that might be useful to you,
  or share your own Dart packages.
* See the [pub package documentation](/guides/packages)
  for more information on using and sharing packages.

