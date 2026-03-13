---
title: "Gradual null safety migration for large Dart projects"
description: "Dart null-safety migration is a 1-2 hour effort for a simple, small package but can be a months-long marathon for a large project. Ideally…"
publishDate: 2022-03-31
author: polina-c
image: images/16-SfhIoFLl1NPaNi8Ld8Og.png
category: other
tags:
  - null-safety
  - migration
  - dart
  - flutter
  - flutter-app-development
layout: blog
---


<DashImage src="images/16-SfhIoFLl1NPaNi8Ld8Og.png" />


[Dart null-safety migration](https://dart.dev/null-safety/migration-guide) is a 1-2 hour effort for a simple, small package but can be a months-long marathon for a large project. Ideally, you want to migrate your project gradually — during the marathon you want to keep your project growable, maintainable, and easy to release.

I’ve migrated a large project to null safety and decided to put together steps and tips on how to make the process reliable and efficient, with the hope that it saves you time.

## Step 1: Convert to unsound null-safety

First, migrate your project to [*unsound* null safety](https://dart.dev/null-safety/unsound-null-safety).

Start with upgrading your dependencies to null-safe versions. Unsound null safety doesn’t require having all dependencies to be null-safe. However, waiting until all of your upstream dependencies are migrated is strongly recommended since migrating a dependency might force you to revisit migration decisions in your own code. For packages that are mutually dependent, you might be forced to migrate out of order, or to migrate the packages concurrently (many packages that are mutually dependent mostly refer to each other only in tests). Follow [the guidance on dart.dev](https://dart.dev/null-safety/migration-guide#update-dependencies) to upgrade as many dependencies as you can before migrating your code.

Next, update the Dart SDK for your package and mark each non-migrated library as legacy using the following steps:

1. Make sure that your IDE (VSCode, IntelliJ / Android Studio) has the Dart plugin installed.

1. Open your package in the IDE and make sure there are no compilation errors.

1. Update the `dart_sdk` dependency in the `pubspec.yaml` file to require the version range: `‘>=2.12.0 <3.0.0’`.

1. The IDE will highlight null-safe related errors in libraries that are not yet null safe. Remove the errors by adding the comment `‘// @dart=2.9’` on the top of each affected file. Add the comment to your main.dart file even if it does not have errors, to keep the app running in unsound mode until you are ready to switch.

1. Verify that all tests pass, and submit the changes to your main branch. If your tests are already null-safe, you will need the command line flag `--no-sound-null-safety` to suppress null-safe errors.

Make sure that you see `Running with unsound null-safety` in the console when starting the application.

Now you are ready to migrate your project to sound null safety one library at a time.

## Step 2: Iterate towards sound null-safety

Choose a library or a set of libraries to migrate.
> **Pro tip**: If the library you selected is large, you might want to break it into smaller libraries before migrating.

Use `dart pub deps` to create a dependency graph of your project. It’s best to migrate packages from the bottom up; start with the leaves in the dependency tree and then iterate up to the root. However, if your project has dependency cycles, this might not be possible and it’s ok not to follow this order.

Migrate the library (or set of libraries) by [using the migration tool](https://dart.dev/null-safety/migration-guide):

1. Start the interactive migration tool by running `dart migrate --skip-import-check`. You may want to `cd` to the directory with the selected libraries to ease navigation in the tree.

1. Deselect everything by deselecting the roots of the file view tree in the left panel. (If interested, vote for a [**Deselect All** button](https://github.com/dart-lang/sdk/issues/48314).)

1. Use `Control+F` to find the file(s) that you want to migrate.

1. Select the file(s) and click **Apply Migration**. There are two options how you can make adjustments: (1) use comments to adjust the tools’s choices before applying migration or (2) use an IDE to evaluate the nullability of fields, parameters, and variables after applying migration.

1. Open the package in the IDE. Fix errors, and search the files for cases where the tool might be inaccurate (see a list of potential issues below). Make corrections and use lint warnings to interactively clean up upstream and downstream code.

You will not be able to fix two lint errors:

1. `import_of_legacy_library_into_null_safe` (in migrated libraries)

1. `avoid_redundant_argument_values` (in legacy libraries)

For now, disable these errors with comments. You’ll clean these up later, after migration is done.

What potential tool inaccuracies to watch for:

1. Added types `dynamic` or `num`. Most likely you know which specific type should be used instead.

1. In most cases, `bool?` can become `bool` with a default value.

1. Type casts (search for `‘ as ‘`) might mean that the tool didn’t add a generic type parameter. After adding it, a lint indicates that the cast has become unnecessary and can be removed.

1. In some cases, the tool makes the bound on a generic parameter nullable when it might be better to make it non-nullable (search for `?>` and `?,`).

1. The tool might make things nullable that could be better expressed using `late` or `late final`, or that could be refactored to allow initialization in the constructor’s initializer list. (If interested, vote for a [lint](https://github.com/dart-lang/linter/issues/3267).)

1. Using a null-assert operation `!` without first checking for a null value might mean that the variable or parameter should actually be non-nullable. (If interested, vote for a [lint](https://github.com/dart-lang/linter/issues/3266).)

1. The tool adds casting for collections in the form `collection as Iterable<TheType>`. Sometimes, this change just makes a cast explicit that was already implicit. However, in other cases, these casts might introduce [runtime errors](https://stackoverflow.com/questions/72252891) because of mismatches in the nullability of the generic arguments. If in doubt, consider replacing the cast with an explicit per element conversion (for example, `collection.cast<TheType>()`), or consider using [the `whereNotNull` extension method from `package:collection`](https://pub.dev/documentation/collection/latest/collection/IterableNullableExtension/whereNotNull.html).

1. If a variable, field, or parameter is nullable, but the nullability is used only in the tests, perhaps the code should be refactored to remove nullability for that identifier.

(Thanks to [Kenzie Davisson](https://github.com/kenzieschmoll), who helped me identify these cases.)

## Step 3: Cleanup

After migrating all of your libraries, do some final cleanup:

1. Clean up the disabling comments for the lints.

1. Upgrade the remaining dependencies to null safe versions.

1. Ensure that there are no ``//@dart = 2.9`` comments remaining in your app. At this point, you should see `Running with sound null-safety` in the console when starting the app. If you don’t see this, you either have libraries that aren’t yet migrated (search for ``// @dart = 2.9``), or a dependency that has not been migrated.

1. Ensure that the app still runs correctly and that the tests pass. Since sound mode enables stronger runtime guarantees, it’s possible (though unlikely) that you will see new runtime errors which you need to fix when you enable sound null safety. Usually this is the result of casting a nullable collection (like `List<int?>`) to a non-nullable collection type (like `List<int>`).

Have a happy migration!