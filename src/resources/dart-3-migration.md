---
title: Dart 3 migration guide
description: How to migrate existing Dart code to be compatible with Dart 3.
---

Dart 3 is a major release that introduces new core capabilities to Dart: 
[records][], [patterns][], and [class modifiers][].

Alongside these new capabilities, Dart 3 contains a number of changes
that may break existing code. 

This guide will help you resolve any migration issues you might encounter
after [upgrading to Dart 3](/get-dart).

## Introduction

### Unversioned vs versioned changes

The potentially breaking changes listed below fall into one of two categories:

* **Unversioned changes**: These changes affect any Dart code
  after upgrading to a Dart 3.0 SDK or later. 
  There is no way to "turn off" these changes.

* **Versioned changes**: These changes only apply when the package or app's
  language version is set to >= Dart 3.0. 
  The [language version](/guides/language/evolution#language-version-numbers)
  is derived from the `sdk` lower-constraint in the
  [`pubspec.yaml` file](/guides/packages#creating-a-pubspec). 
  An SDK constraint like this does *not* apply the Dart 3 versioned changes:

  ```yaml
  environment:
    sdk: '>=2.14.0 <3.0.0'
  ```
  
  But an SDK constraint like this does:

  ```yaml
  environment:
    sdk: '>=3.0.0 <4.0.0'
  ```

To use the new Dart 3 features you have to
update the language version to 3.0. 
This gets you the Dart 3 versioned changes at the same time.

### Dart 3 backwards compatibility

Many packages and apps that used null safety with Dart 2.12 or
later are likely backwards compatible with Dart 3. 
This is possible for any package where 
the lower bound of the SDK constraint is 2.12.0 or higher. 

[Dart's pub tool](/guides/packages) allows resolution even when
the upper bound is limited to versions below 3.0.0. 
For example, a package with the following constraint
will be allowed to resolve with a Dart 3.x SDK, 
as pub will re-interpret the upper-constraint `<3.0.0` as `<4.0.0`
when the lower constraint is `2.12` or higher:

```yaml
environment:
  sdk: '>=2.14.0 <3.0.0'           # This is interpreted as '>=2.14.0 <4.0.0'
```

This allows developers to use Dart 3 sound null safety with packages
that already support 2.12 null safety
without needing a second migration, unless 
the code is affected by any other Dart 3 changes.

### Testing for impact

To understand if your source code is impacted by any Dart 3 changes, 
use these steps:

```terminal
$ dart --version    # Make sure this reports 3.0.0 or higher.
$ dart pub get      # This should resolve without issues.
$ dart analyze      # This should pass without errors.
```

If the `pub get` step fails, try to upgrade your dependencies
to see if more recent versions might support Dart 3:

```terminal
$ dart pub upgrade
$ dart analyze      # This should pass without errors.
```

Or, if needed, also include [major versions][] upgrades:

```terminal
$ dart pub upgrade --major-versions
$ dart analyze      # This should pass without errors.
```

[major versions]: /tools/pub/cmd/pub-upgrade#--major-versions

## Dart 3 language changes

### 100% sound null safety

Dart 2.12 introduced null safety more than two years ago. 
In Dart 2.12, users needed to enable null safety [with a pubspec setting][].
In Dart 3, null safety is built in; you cannot turn it off.

[with a pubspec setting]: /null-safety/#enable-null-safety

#### Scope

This is an [*unversioned* change](#unversioned-vs-versioned-changes), 
that applies to all Dart 3 code.

#### Symptom

Packages developed without null safety support will cause issues
when resolving dependencies with `pub get`:

```terminal
$ dart pub get

Because pkg1 doesn't support null safety, version solving failed.
The lower bound of "sdk: '>=2.9.0 <3.0.0'" must be 2.12.0 or higher to enable null safety.
```

Libraries that opt out of null safety with [language version comments][]
that select any language version below `2.12` will
cause analysis or compilation errors:

```terminal
$ dart analyze .
Analyzing ....                         0.6s

  error • lib/pkg1.dart:1:1 • The language version must be >=2.12.0. 
  Try removing the language version override and migrating the code.
  • illegal_language_version_override
```

```terminal
$ dart run bin/my_app.dart
../pkg1/lib/pkg1.dart:1:1: Error: Library doesn't support null safety.
// @dart=2.9
^^^^^^^^^^^^
```

[language version comments]: /guides/language/evolution#per-library-language-version-selection

#### Migration

Before beginning any migration to Dart 3, 
ensure your app or package has been 100% migrated to enable null safety. 
This requires a Dart `2.19` SDK, not a Dart 3 SDK. 
To learn how to first migrate your app or package to support null safety,
check out the [null safety migration guide][].

[null safety migration guide]: /null-safety/migration-guide

### Colon-syntax for default values

For historical reasons, named optional parameters could
specify their default value using either `:` or `=`. 
In Dart 3, only the `=` syntax is allowed.

#### Scope

This is a [*versioned* change](#unversioned-vs-versioned-changes), 
that only applies to language version 3.0 or later.

#### Symptom

Dart analysis produces errors like:

```nocode
line 2 • Using a colon as a separator before a default value is no longer supported.
```

#### Migration

Change from using colons:

```dart
int someInt({int x: 0}) => x;
```

To using equals:

```dart
int someInt({int x = 0}) => x;
```

This migration can be made manually, or automated with `dart fix`:

```terminal
$ dart fix --apply --code=obsolete_colon_for_default_value
```

### `mixin`

Pre-Dart 3, any `class` could be used as a `mixin`, as long as
it had no declared constructors and no superclass other than `Object`.

In Dart 3, classes declared in libraries at language version 3.0 or later
can't be used as mixins unless marked `mixin`.
This restriction applies to code in any library
attempting to use the class as a mixin, 
regardless of the latter library's language version.

#### Scope

This is a [*versioned* change](#unversioned-vs-versioned-changes), 
that only applies to language version 3.0 or later.

#### Symptom

An analysis error like:

```nocode
Mixin can only be applied to class.
```

The analyzer produces this diagnostic when a class that is neither a
`mixin class` nor a `mixin` is used in a `with` clause.

#### Migration

Determine if the class is intended to be used as a mixin.

If the class defines an interface, consider using `implements`.

### `switch`

Dart 3.0 interprets [switch](/language/branches#switch) cases
as [patterns][] instead of constant expressions. 

#### Scope

This is a [*versioned* change](#unversioned-vs-versioned-changes), 
that only applies to language version 3.0 or later.

#### Symptom

Most constant expressions found in switch cases are valid patterns
with the same meaning (named constants, literals, etc.).
These will behave the same and no symptoms will arise.

The few constant expressions that aren't valid patterns
will trigger the [`invalid_case_patterns` lint][].

[`invalid_case_patterns` lint]: /tools/linter-rules/invalid_case_patterns

#### Migration

You can revert back to the original behavior by prefixing
the case pattern with `const`, so it's no longer interpreted as a pattern:

```dart
case const [1, 2]:
case const {'k': 'v'}:
case const {1, 2}:
case const Point(1, 2):
```

You can run a quick fix for this breaking change, 
by using `dart fix` or from your IDE.

### `continue`

Dart 3 reports a compile-time error if a continue statement targets a label
that is not a loop (`for`, `do`, and `while` statements) or a switch member.

#### Scope

This is a [*versioned* change](#unversioned-vs-versioned-changes), 
that only applies to language version 3.0 or later.

#### Symptom

You will see an error like:

```nocode
The label used in a 'continue' statement must be defined on either a loop or a switch member.
```

#### Migration

If changing behavior is acceptable, 
change the `continue` to target a valid labeled statement,
which must be attached to a `for`, `do` or `while` statement.

If you want to preserve behavior, change the
`continue` statement to a `break` statement.
In previous versions of Dart, a `continue` statement 
that wasn't targeted at a loop or a switch member 
behaved like `break`.

## Dart 3 core library changes

### APIs removed

**Breaking change [#49529][]**: The core libraries have been cleaned up
to remove APIs that have been deprecated for several years. 
The following APIs no longer exist in the Dart core libraries.

[#49529]: https://github.com/dart-lang/sdk/issues/49529

#### Scope

This is an [*unversioned* change](#unversioned-vs-versioned-changes), 
that applies to all Dart 3 code.

#### `dart:core`

- Removed the deprecated `List` constructor, as it wasn't null safe.
  Use list literals (e.g. `[]` for an empty list or `<int>[]` for an empty
  typed list) or [`List.filled`][]. This only impacts non-null safe code,
  as null safe code already couldn't use this constructor.
- Removed the deprecated `onError` argument on [`int.parse`][], [`double.parse`][],
  and [`num.parse`][]. Use the [`tryParse`][] method instead.
- Removed the deprecated [`proxy`][] and [`Provisional`][] annotations.
  The original `proxy` annotation has no effect in Dart 2,
  and the `Provisional` type and [`provisional`][] constant
  were only used internally during the Dart 2.0 development process.
- Removed the deprecated [`Deprecated.expires`][] getter.
  Use [`Deprecated.message`][] instead.
- Removed the deprecated [`CastError`][] error.
  Use [`TypeError`][] instead.
- Removed the deprecated [`FallThroughError`][] error. The kind of
  fall-through previously throwing this error was made a compile-time
  error in Dart 2.0.
- Removed the deprecated [`NullThrownError`][] error. This error is never
  thrown from null safe code.
- Removed the deprecated [`AbstractClassInstantiationError`][] error. It was made
  a compile-time error to call the constructor of an abstract class in Dart 2.0.
- Removed the deprecated [`CyclicInitializationError`]. Cyclic dependencies are
  no longer detected at runtime in null safe code. Such code will fail in other
  ways instead, possibly with a StackOverflowError.
- Removed the deprecated [`NoSuchMethodError`][] default constructor.
  Use the [`NoSuchMethodError.withInvocation`][] named constructor instead.
- Removed the deprecated [`BidirectionalIterator`][] class.
  Existing bidirectional iterators can still work, they just don't have
  a shared supertype locking them to a specific name for moving backwards.

[`List.filled`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List/List.filled.html
[`int.parse`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/int/parse.html
[`double.parse`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/double/parse.html
[`num.parse`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/parse.html
[`tryParse`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/num/tryParse.html
[`Deprecated.expires`]: {{site.dart-api}}/stable/2.19.6/dart-core/Deprecated/expires.html
[`Deprecated.message`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Deprecated/message.html
[`AbstractClassInstantiationError`]: {{site.dart-api}}/stable/2.19.6/dart-core/AbstractClassInstantiationError-class.html
[`CastError`]: {{site.dart-api}}/stable/2.19.6/dart-core/CastError-class.html
[`FallThroughError`]: {{site.dart-api}}/stable/2.19.6/dart-core/FallThroughError-class.html
[`NoSuchMethodError`]: {{site.dart-api}}/stable/2.19.6/dart-core/NoSuchMethodError/NoSuchMethodError.html
[`NoSuchMethodError.withInvocation`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/NoSuchMethodError/NoSuchMethodError.withInvocation.html
[`CyclicInitializationError`]: {{site.dart-api}}/stable/2.19.6/dart-core/CyclicInitializationError-class.html
[`Provisional`]: {{site.dart-api}}/stable/2.19.6/dart-core/Provisional-class.html
[`provisional`]: {{site.dart-api}}/stable/2.19.6/dart-core/provisional-constant.html
[`proxy`]: {{site.dart-api}}/stable/2.19.6/dart-core/proxy-constant.html
[`CastError`]: {{site.dart-api}}/stable/2.19.6/dart-core/CastError-class.html
[`TypeError`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/TypeError-class.html
[`FallThroughError`]: {{site.dart-api}}/stable/2.19.6/dart-core/FallThroughError-class.html
[`NullThrownError`]: {{site.dart-api}}/stable/2.19.6/dart-core/NullThrownError-class.html
[`AbstractClassInstantiationError`]: {{site.dart-api}}/stable/2.19.6/dart-core/AbstractClassInstantiationError-class.html
[`CyclicInitializationError`]: {{site.dart-api}}/stable/2.19.6/dart-core/CyclicInitializationError-class.html
[`BidirectionalIterator`]: {{site.dart-api}}/stable/2.19.6/dart-core/BidirectionalIterator-class.html

#### `dart:async`

- Removed the deprecated [`DeferredLibrary`][] class.
  Use the [`deferred as`][] import syntax instead.

[`DeferredLibrary`]: {{site.dart-api}}/stable/2.19.6/dart-async/DeferredLibrary-class.html
[`deferred as`]: /language/libraries#lazily-loading-a-library

#### `dart:developer`

- Removed the deprecated [`MAX_USER_TAGS`][] constant.
  Use [`maxUserTags`][] instead.
- Removed the deprecated [`Metrics`][], [`Metric`][], [`Counter`][],
  and [`Gauge`][] classes as they have been broken since Dart 2.0.

[`MAX_USER_TAGS`]: {{site.dart-api}}/stable/2.19.6/dart-developer/UserTag/MAX_USER_TAGS-constant.html
[`maxUserTags`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-developer/UserTag/maxUserTags-constant.html
[`Metrics`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Metrics-class.html
[`Metric`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Metric-class.html
[`Counter`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Counter-class.html
[`Gauge`]: {{site.dart-api}}/stable/2.19.6/dart-developer/Gauge-class.html

#### `dart:html`

- As previously announced, the deprecated `registerElement`
  and `registerElement2` methods in `Document` and `HtmlDocument` have been
  removed.  See [#49536](https://github.com/dart-lang/sdk/issues/49536) for
  details.

#### `dart:math`

- The `Random` interface can only be implemented, not extended.

#### `dart:io`

- Update `NetworkProfiling` to accommodate new `String` ids
  that are introduced in vm_service:11.0.0

#### Symptom

Dart analysis (e.g. in your IDE, or in `dart analyze`/`flutter analyze`)
will fail with errors like:

```nocode
error line 2 • Undefined class 'CyclicInitializationError'.
```

#### Migration

Manually migrate away from using these APIs.

### Extends & implements

Dart 3 supports new [class modifiers][] that
can restrict the capabilities of a class.
They have been applied to a number of classes in the core libraries.

#### Scope

This is a [*versioned* change](#unversioned-vs-versioned-changes), 
that only applies to language version 3.0 or later.

#### `dart:async`

* The following declarations can only be implemented, not extended:

  - `StreamConsumer`
  - `StreamIterator`
  - `StreamTransformer`
  - `MultiStreamController`

  None of these declarations contained any implementation to inherit.
  They are marked as `interface` to signify that
  they are only intended as interfaces.

#### `dart:core`

* The `Function` type can no longer be implemented, extended or mixed in.
  Since Dart 2.0, writing `implements Function` has been allowed
  for backwards compatibility, but it has not had any effect.
  In Dart 3.0, the `Function` type is final and cannot be subtyped,
  preventing code from mistakenly assuming it works.

* The following declarations can only be implemented, not extended:

  - `Comparable`
  - `Exception`
  - `Iterator`
  - `Pattern`
  - `Match`
  - `RegExp`
  - `RegExpMatch`
  - `StackTrace`
  - `StringSink`

  None of these declarations contained any implementation to inherit.
  They are marked as `interface` to signify that
  they are only intended as interfaces.

* The following declarations can no longer be implemented or extended:

  - `MapEntry`
  - `OutOfMemoryError`
  - `StackOverflowError`
  - `Expando`
  - `WeakReference`
  - `Finalizer`

  The `MapEntry` value class is restricted to enable later optimizations.
  The remaining classes are tightly coupled to the platform and not
  intended to be subclassed or implemented.

#### `dart:collection`

* The following interface can no longer be extended, only implemented:

  - `Queue`

* The following implementation classes can no longer be implemented:

  - `LinkedList`
  - `LinkedListEntry`

* The following implementation classes can no longer be implemented
  or extended:

  - `HasNextIterator` (Also deprecated.)
  - `HashMap`
  - `LinkedHashMap`
  - `HashSet`
  - `LinkedHashSet`
  - `DoubleLinkedQueue`
  - `ListQueue`
  - `SplayTreeMap`
  - `SplayTreeSet`

## Dart 3 tools changes

### Removed tools

Historically the Dart team has offered a number of smaller developer tools for
things like formatting code (`dartfmt`), analyzing code (`dartanalyzer`), etc.
In Dart 2.10 (October 2020) we introduced a new unified Dart developer tool, the
[`dart` tool](/tools/dart-tool).

#### Scope

This is an [*unversioned* change](#unversioned-vs-versioned-changes), 
that applies to all Dart 3 code.

#### Symptom

In Dart 3 these smaller tools do not exist, and
have been replaced by the new combined `dart` tool.

#### Migration

Use new sub-commands available in the `dart` tool:

| Historical tool | `dart` replacement                            | Deprecation | Discontinuation |
|-----------------|-----------------------------------------------|-------------|-----------------|
| `stagehand`     | [`dart create`](/tools/dart-create)           | [2.14](https://github.com/dart-lang/stagehand/issues/671)        | 2.14*  |
| `dartfmt`       | [`dart format`](/tools/dart-format)           | [2.14](https://github.com/dart-lang/dart_style/issues/986)        | [2.15](https://github.com/dart-lang/dart_style/issues/986)            |
| `dart2native`   | [`dart compile exe`](/tools/dart-compile#exe) | [2.14](https://github.com/dart-lang/sdk/commit/cac00e9d956a6f7ef28628989912d971f6b908d4)        | [2.15](https://github.com/dart-lang/sdk/commit/6c5fb84716b1f257b170351efe8096fe2af2809b)            |
| `dart2js`       | [`dart compile js`](/tools/dart-compile)      | [2.17](https://github.com/dart-lang/sdk/commit/8415b70e75b1d5bbe8251fa6a9eab2d970cf9eec)         | [2.18](https://github.com/dart-lang/sdk/commit/69249df50bcc7a0489176efd3fd79fff018f1b91)             |
| `dartdevc`      | [`webdev`](/tools/webdev)                     | [2.17](https://github.com/dart-lang/sdk/commit/5173fd2d224f669fd8d0a1d21adbfd6187d10f53)         | [2.18](https://github.com/dart-lang/sdk/commit/69249df50bcc7a0489176efd3fd79fff018f1b91)             |
| `dartanalyzer`  | [`dart analyze`](/tools/dart-analyze)         | [2.16](https://github.com/dart-lang/sdk/commit/f7af5c5256ee6f3a167f380722b96e8af4360b46)         | [2.18](https://github.com/dart-lang/sdk/issues/48457)             |
| `dartdoc`       | [`dart doc`](/tools/dart-doc)                 | [2.16](https://github.com/dart-lang/sdk/issues/44610)         | [2.17](https://dart-review.googlesource.com/c/sdk/+/228647)             |
| `pub`           | [`dart pub`](/tools/dart-pub)                 | [2.15](https://github.com/dart-lang/pub/issues/2736)         | [2.17](https://dart-review.googlesource.com/c/sdk/+/234283)             |
{:.table .table-striped .nowrap}

### Null safety migration tools

The following null safety migration commands have been removed,
as Dart 3 [doesn't support code without null safety](#100-sound-null-safety):

- `dart migrate`
- `dart pub upgrade --null-safety`
- `dart pub outdated --mode=null-safety`

#### Scope

This is an [*unversioned* change](#unversioned-vs-versioned-changes), 
that applies to all Dart 3 code.

#### Symptom

These commands will fail.

#### Migration

Use Dart 2.19 to [migrate to null safety](/null-safety/migration-guide).

### Analyzer config

The [analyzer configuration options][] for 
enabling stricter checking have changed.

[analyzer configuration options]: /tools/analysis#enabling-additional-type-checks

#### Scope

This is an [*unversioned* change](#unversioned-vs-versioned-changes), 
that applies to all Dart 3 code.

#### Symptom

The former configuration options will fail with a warning like:

```nocode
The option 'implicit-casts' is no longer supported.
Try using the new 'strict-casts' option.
```

#### Migration

Replace this part of the analyzer config:

```yaml
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
```

with:

```yaml
analyzer:
  language:
    strict-casts: true
    strict-raw-types: true
```

### Other tools changes

* The deprecated Observatory has been hidden by default. 
  We recommend using [DevTools](/tools/dart-devtools).
* The command `dart format fix` has been replaced by `dart fix`
  [#1153](https://github.com/dart-lang/dart_style/issues/1153).
* The snapshot files bundled in the SDK for the Dart web compiler
  have been cleaned up [#50700](https://github.com/dart-lang/sdk/issues/50700).
* The output of `dart format` changed a bit for
  [some code](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#formatter).
* Ending backwards compatibility for the old location of pub-cache on Windows.
  Prior to Dart 3 `%APPDATA%\Pub\Cache` was a fallback location for pub-cache.
  Starting with Dart 3, the default pub-cache is located at
  `%LOCALAPPDATA%\Pub\Cache`.
  If you have added globally activated packages to your `PATH`, consider
  updating `PATH` to contain `%LOCALAPPDATA%\Pub\Cache\bin`.

#### Scope

This is an [*unversioned* change](#unversioned-vs-versioned-changes), 
that applies to all Dart 3 code.

[records]: /language/records
[patterns]: /language/patterns
[class modifiers]: /language/class-modifiers
