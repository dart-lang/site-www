---
title: Pub workspaces (monorepo support)
short-title: Workspaces
description: Learn more about pub workspaces, a way to manage package monorepos.
---

When working on a project, you might develop multiple Dart packages in the same
version control repository (a _monorepo_).

For example you might have a directory layout like: 

```console
/
  packages/
    shared/
      pubspec.yaml
      pubspec.lock
      .dart_tool/package_config.json
    client_package/
      pubspec.yaml
      pubspec.lock
      .dart_tool/package_config.json
    server_package/
      pubspec.yaml
      pubspec.lock
      .dart_tool/package_config.json
```

There are some downsides to this setup:

* You need to run `dart pub get` once for each package.
* You risk ending up with different versions of dependencies for each package
  leading to confusion when context switching between the packages.
* If you open the root folder in your IDE, the dart analyzer will have to have a
  separate analysis contexts for each package (increasing memory usage).

Pub allows you to organize your repository as a _workspace_ using a single
shared resolution for all your packages.

:::note
Using a single shared dependency resolution for all your packages increases
the risks of dependency conflicts. Because Dart does not allow multiple versions
of the same package.

If the packages are going to be used together (as is commonly the case),
this is often a feature, as it forces you to resolve incompatibilities between your
packages when they arise, rather then when you start using the packages.
:::

To create a workspace:

* Add a `pubspec.yaml` at the repository root directory with a `workspace` entry
  enummerating the paths to the packages of the respository (the workspace
  packages):

```yaml
name: _
publish_to: none
environment:
  sdk: ^3.6.0
workspace:
  - packages/helper
  - packages/client_package
  - packages/server_package
```

* For each of the existing `pubspec.yaml`s, make sure their SDK constraint is at
  least `^3.6.0` and add a `resolution` entry:

  ```yaml
  environment:
    sdk: ^3.6.0
  resolution: workspace
  ```

* Run `dart pub get` anywhere in the repository, and this will:
  * Create a single `pubspec.lock` next to the root `pubspec.yaml` that contains
    the a resolution of all the `dependencies` and `dev_dependencies` of all the
    workspace packages. 
  * Create a single shared `.dart_tool/package_config.json` that maps package
    names to file locations.
  * Delete any other existing `pubspec.lock` and
    `.dart_tool/package_config.json` files next to workspace packages.

Now the file structure looks like this:

```console
/
  packages/
    shared/
      pubspec.yaml
    client_package/
      pubspec.yaml
    server_package/
      pubspec.yaml
  pubspec.yaml
  pubspec.lock
  .dart_tool/package_config.json
```

:::version-note
Pub workspaces was introduced in Dart 3.6.0.

To use pub workspaces, all your workspace packages (but not your dependencies)
must have a SDK version constraint of `^3.6.0` or higher.
:::

## Interdependencies between workspace packages

If any of the workspace packages depend on each other, they will automatically
resolve to the one in the workspace, regardless of the source.

Eg. `packages/client_package/pubspec.yaml` might depend on `shared`:

```yaml
dependencies:
  shared: ^2.3.0
```

When resolved inside the workspace, the _local_ version of `shared` will be
used. 

The local version of `shared` would still have to match the constraint
(`^2.3.0`) though.

But when the package is consumed as a dependency without being part of the
workspace, the original source (here implicitly `hosted`) is used.

So if `client_package` is published to pub.dev and someone depends on it, they
will get the hosted version of `shared` as a transitive dependency.

## Dependency overrides in a workspace

All `dependency_overrides:` sections in the workspace packages are respected,
and you can also place a `pubspec_overrides.yaml` file next to any of the
workspace `pubspec.yaml` files.

You can only override a package once in the workspace. To keep overrides organized
it can be preferable to keep `dependency_overrides` in the root `pubspec.yaml`.

## Running a command in a specific workspace package

Some pub commands, such as `dart pub add`, and `dart pub publish` operate on a
"current" package. You can either change directory, or use `-C` to point pub at
a directory:

```console
$ dart pub -C packages/client_package publish
# Same as
$ cd packages/client_package ; dart pub publish ; cd -
```

## Temporarily resolving a package outside its workspace:

Sometimes you might want to resolve a workspace package on its own, for example
to validate its dependency constraints.

One way to do this is to create a `pubspec_overides.yaml` file that resets the
`resolution` setting, like so:

```yaml
# packages/client_package/pubspec_overrides.yaml
resolution:
```

Now running `dart pub get` inside `packages/client_package` will create an
independent resolution.

## Listing all workspace packages

You can run `dart pub workspace list` to list the packages of a workspace.

```console
$ dart pub workspace list
Package         Path                      
_               ./                        
client_package  packages/client_package/  
server_package  packages/server_package/  
shared          packages/shared/
```
