---
title: Pub workspaces (monorepo support)
shortTitle: Workspaces
description: Learn more about pub workspaces, a way to manage package monorepos.
---

When working on a project, you might develop multiple Dart packages in the same
version control repository (a _monorepo_).

For example you might have a directory layout like: 

```plaintext
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
* You risk ending up with different versions of dependencies for each package,
  leading to confusion when context switching between the packages.
* If you open the root folder in your IDE, the dart analyzer will create
  separate analysis contexts for each package, increasing memory usage.

Pub allows you to organize your repository as a _workspace_ using a single
shared resolution for all your packages. 
Using workspaces for large repositories reduces the amount of memory
required for analysis, hence improving performance.

:::note
Using a single shared dependency resolution for all your packages increases
the risks of dependency conflicts, because Dart doesn't allow multiple versions
of the same package.

If the packages are going to be used together (as is commonly the case),
this risk is a useful feature. It forces you to resolve incompatibilities between
your packages when they arise, rather than when you start using the packages.
:::

To create a workspace:

* Add a `pubspec.yaml` at the repository root directory with a `workspace` entry
  enumerating the paths to the packages of the repository (the workspace
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

* For each of the existing `pubspec.yaml` files, make sure their SDK constraint
  is at least `^3.6.0` and add a `resolution` entry:

  ```yaml
  environment:
    sdk: ^3.6.0
  resolution: workspace
  ```

* Run `dart pub get` anywhere in the repository. This will:
  * Create a single `pubspec.lock` next to the root `pubspec.yaml` that contains
    the resolution of all the `dependencies` and `dev_dependencies` of all the
    workspace packages. 
  * Create a single shared `.dart_tool/package_config.json` that maps package
    names to file locations.
  * Delete any other existing `pubspec.lock` and
    `.dart_tool/package_config.json` files next to workspace packages.

Now the file structure looks like this:

```plaintext
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
Support for pub workspaces was introduced in Dart 3.6.0.

To use pub workspaces, all your workspace packages (but not your dependencies)
must have an SDK version constraint of `^3.6.0` or higher.
:::

<a name='stray-files'></a>
## Stray files

When you migrate an existing monorepo to use Pub workspaces, there will
be existing "stray" `pubspec.lock` and `.dart_tool/package_config.json` files
adjacent to each pubspec. These shadow the `pubspec.lock` and
`.dart_tool/package_config.json` files placed next to the root.

Therefore, `pub get` will delete any `pubspec.lock` and
`.dart_tool/package_config.json` located in directories between the root and
(including) any workspace package.

```plaintext
/
  pubspec.yaml                       # Root
  packages/
    pubspec.lock                     # Deleted by `pub get`
    .dart_tool/package_config.json   # Deleted by `pub get`
    foo/
      pubspec.yaml                   # Workspace member
      pubspec.lock                   # Deleted by `pub get`
      .dart_tool/package_config.json # Deleted by `pub get`
```

If any directory between the workspace root and a workspace package contains a
"stray" `pubspec.yaml` file that is not member of the workspace, `pub get` will
report an error and fail to resolve. This is because resolving such a `pubspec.yaml` would
create a `.dart_tool/package_config.json` file that shadows the one at the root.

For example:

```plaintext
/
  pubspec.yaml                      # Root `workspace: ['foo/']`
  packages/
    pubspec.yaml                    # Not workspace member => error
    foo/
      pubspec.yaml                  # Workspace member
```


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

All `dependency_overrides` sections in the workspace packages are respected.
You can also place a `pubspec_overrides.yaml` file next to any of the
workspace `pubspec.yaml` files.

You can only override a package once in the workspace. To keep overrides organized,
it's preferable to keep `dependency_overrides` in the root `pubspec.yaml`.

## Running a command in a specific workspace package

Some pub commands, such as `dart pub add`, and `dart pub publish` operate on a
"current" package. You can either change the directory, or use `-C` to point pub at
a directory:

```console
$ dart pub -C packages/client_package publish
# Same as
$ cd packages/client_package ; dart pub publish ; cd -
```

## Temporarily resolving a package outside its workspace:

Sometimes you might want to resolve a workspace package on its own, for example
to validate its dependency constraints.

One way to do this is to create a `pubspec_overrides.yaml` file that resets the
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
