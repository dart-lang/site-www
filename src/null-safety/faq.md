---
title: "Null safety: Frequently asked questions"
description: FAQs to help you migrate your Dart code to null safety
short-title: FAQ (null safety)
---

This page collects some common questions we've heard about [null safety](/null-safety)
based on the experience of migrating Google internal code.

## What runtime changes should I be aware of for users of migrated code?

Most of the effects of migration do not immediately affect users of migrated
code:

-   Static null safety checks for users first apply when they migrate their
    code.
-   Full null safety checks happen when all the code is migrated and sound mode
    is turned on.

Two exceptions to be aware of are:

-   The `!` operator is a runtime null check in all modes, for all users. So,
    when migrating, ensure that you only add `!` where it's an error for a
    `null` to flow to that location, even if the calling code has not migrated
    yet.
-   Runtime checks associated with the `late` keyword apply in all modes, for
    all users. Only mark a field `late` if you are sure it is always initialized
    before it is used.

## What if a value is only `null` in tests?

If a value is only ever `null` in tests, the code can be improved by marking it
non-nullable and making the tests pass non-null values.

## How does `@required` compare to the new `required` keyword?

The `@required` annotation marks named arguments that must be passed; if not,
the analyzer reports a hint.

With null safety, a named argument with a non-nullable type must either have a
default or be marked with the new `required` keyword. Otherwise, it wouldn't
make sense for it to be non-nullable, because it would default to `null` when
not passed.

When null safe code is called from legacy code the `required` keyword is treated
exactly like the `@required` annotation: failure to supply the argument will
cause an analyzer hint.

When null safe code is called from null safe code, failing to supply a
`required` argument is an error.

What does this mean for migration? Be careful if adding `required` where there
was no `@required` before. Any callers not passing the newly-required argument
will no longer compile. Instead, you could add a default or make the argument
type nullable.

## How should I migrate non-nullable fields that should be `final`, but aren't?

Some computations can be moved to the static initializer. Instead of:

{:.bad}
```dart
// Initialized without values
ListQueue _context;
Float32List _buffer;
dynamic _readObject;

Vec2D(Map<String, dynamic> object) {
  _buffer = Float32List.fromList([0.0, 0.0]);
  _readObject = object['container'];
  _context = ListQueue<dynamic>();
}
```

you can do:

{:.good}
```dart
// Initialized with values
final ListQueue _context = ListQueue<dynamic>();
final Float32List _buffer = Float32List.fromList([0.0, 0.0]);
final dynamic _readObject;

Vec2D(Map<String, dynamic> object) : _readObject = object['container'];
```

However, if a field is initialized by doing computation in the constructor, then
it can't be `final`. With null safety, you'll find this also makes it harder for
it to be non-nullable; if it's initialized too late, then it's `null` until it's
initialized, and must be nullable. Fortunately, you have options:

-   Turn the constructor into a factory, then make it delegate to an actual
    constructor that initializes all the fields directly. A common name for such
    a private constructor is just an underscore: `_`. Then, the field can be
    `final` and non-nullable. This refactoring can be done *before* the
    migration to null safety.
-   Or, mark the field `late final`. This enforces that it's initialized exactly
    once. It must be initialized before it can be read.

## How should I migrate a `built_value` class?

Getters that were annotated `@nullable` should instead have nullable types; then
remove all `@nullable` annotations. For example:

```dart
@nullable
int get count;
```

becomes

```dart
int? get count; //  Variable initialized with ?
```

Getters that were *not* marked `@nullable` should *not* have nullable types,
even if the migration tool suggests them. Add `!` hints as needed then rerun the
analysis.

## How should I migrate a factory that can return `null`?

_Prefer factories that do not return null._ We have seen code that meant to
throw an exception due to invalid input but instead ended up returning null.

Instead of:

{:.bad}
```dart
  factory StreamReader(dynamic data) {
    StreamReader reader;
    if (data is ByteData) {
      reader = BlockReader(data);
    } else if (data is Map) {
      reader = JSONBlockReader(data);
    }
    return reader;
  }
```

Do:

{:.good}
```dart
  factory StreamReader(dynamic data) {
    if (data is ByteData) {
      // Move the readIndex forward for the binary reader.
      return BlockReader(data);
    } else if (data is Map) {
      return JSONBlockReader(data);
    } else {
      throw ArgumentError('Unexpected type for data');
    }
  }
```


If the intent of the factory was indeed to return null, then you can turn it
into a static method so it is allowed to return `null`.

## How should I migrate an `assert(x != null)` that now shows as unnecessary?

The assert will be unnecessary when everything is fully migrated, but for now it
*is* needed if you actually want to keep the check. Options:

-   Decide that the assert is not really necessary, and remove it. This is a
    change in behavior when asserts are enabled.
-   Decide that the assert can be checked always, and turn it into
    `ArgumentError.checkNotNull`. This is a change in behavior when asserts are
    not enabled.
-   Keep the behavior exactly as is: add `// ignore:
    unnecessary_null_comparison` to bypass the warning.

## How should I migrate a runtime null check that now shows as unnecessary?

The compiler flags an explicit runtime null check as an unnecessary
comparison if you make `arg` non-nullable.

```dart
if (arg == null) throw ArgumentError(...)`
```

You must include this check if the program is a mixed-version one.
Until everything is fully migrated and the code switches to running
with sound null safety, `arg` might be set to `null`.

The simplest way to preserve behavior is change the check into
[`ArgumentError.checkNotNull`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/ArgumentError/checkNotNull.html).

The same applies to some runtime type checks. If `arg`
has static type `String`, then `if (arg is! String)` is actually checking
whether `arg` is `null`. It might look like migrating to null safety means `arg`
can never be `null`, but it could be `null` in unsound null safety. So, to preserve
behavior, the null check should remain.

## The `Iterable.firstWhere` method no longer accepts `orElse: () => null`.

Import `package:collection` and use the extension method `firstWhereOrNull`
instead of `firstWhere`.

## How do I deal with attributes that have setters?

Unlike the `late final` suggestion above, these attributes cannot be marked as
final. Often, settable attributes also do not have initial values since they are
expected to be set sometime later.

In such cases, you have two options:

-   Set it to an initial value. Often times, the omission of an initial value is
    by mistake rather than deliberate.
-   If you are _sure_ that the attribute needs to be set before accessed, mark
    it as `late`.

    WARNING: The `late` keyword adds a runtime check. If any user calls `get`
    before `set` they'll get an error at runtime.

## How do I signal that the return value from a Map is non-nullable?

The
[lookup operator]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Map/operator_get.html)
on Map (`[]`) by default returns a nullable type. There's no way to signal to
the language that the value is guaranteed to be there.

In this case, you should use the bang operator (`!`) to cast the value back to
V:

```dart
return blockTypes[key]!;
```

Which will throw if the map returns null. If you want explicit handling for that case:

```dart
var result = blockTypes[key];
if (result != null) return result;
// Handle the null case here, e.g. throw with explanation.
```

## Why is the generic type on my List/Map nullable?

It is typically a code smell to end up with nullable code like this:

{:.bad}
```dart
List<Foo?> fooList; // fooList can contain null values
```

This implies `fooList` might contain null values. This might happen if you are
initializing the list with length and filling it in via a loop.

If you are simply initializing the list with the same value, you should instead
use the 
[`filled`]({{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List/List.filled.html) 
constructor.

{:.bad}
```dart
_jellyCounts = List<int?>(jellyMax + 1);
for (var i = 0; i <= jellyMax; i++) {
  _jellyCounts[i] = 0; // List initialized with the same value
}
```

{:.good}
```dart
_jellyCounts = List<int>.filled(jellyMax + 1, 0); // List initialized with filled constructor
```

If you are setting the elements of the list via an index, or you are populating
each element of the list with a distinct value, you should instead use the
list literal syntax to build the list.

{:.bad}
```dart
_jellyPoints = List<Vec2D?>(jellyMax + 1);
for (var i = 0; i <= jellyMax; i++) {
  _jellyPoints[i] = Vec2D(); // Each list element is a distinct Vec2D
}
```

{:.good}
```dart
_jellyPoints = [
  for (var i = 0; i <= jellyMax; i++)
    Vec2D() // Each list element is a distinct Vec2D
];
```

To generate a fixed-length list,
use the [`List.generate`][] constructor
with the `growable` parameter set to `false`:

```dart
_jellyPoints = List.generate(jellyMax, (_) => Vec2D(), growable: false);
```

[`List.generate`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List/List.generate.html

{% comment %}
  Would preferably suggest a language syntax here,
  which is being suggested in https://github.com/dart-lang/language/issues/2477.
{% endcomment %}
 
## What happened to the default List constructor?

You may encounter this error:

```nocode
The default 'List' constructor isn't available when null safety is enabled. #default_list_constructor
```

The default list constructor fills the list with `null`, which is a problem.

Change it to `List.filled(length, default)` instead.

## I'm using `package:ffi` and get a failure with `Dart_CObject_kUnsupported` when I migrate. What happened?

Lists sent via ffi can only be `List<dynamic>`, not `List<Object>` or
`List<Object?>`. If you didn't change a list type explicitly in your migration,
a type might still have changed because of changes to type inference that happen
when you enable null safety.

The fix is to explicitly create such lists as `List<dynamic>`.

## Why does the migration tool add comments to my code? {#migration-comments}

The migration tool adds `/* == false */` or `/* == true */` comments when it
sees conditions that will always be false or true while running in sound mode.
Comments like these might indicate that the automatic migration is incorrect and
needs human intervention. For example:

```dart
if (registry.viewFactory(viewDescriptor.id) == null /* == false */)
```

In these cases, the migration tool can't distinguish defensive-coding situations
and situations where a null value is really expected. So the tool tells you what
it knows ("it looks like this condition will always be false!") and lets you
decide what to do.

## What should I know about compiling to JavaScript and null safety?

Null safety brings many benefits like reduced code size and improved
app performance. Such benefits surface more when compiled to native
targets like Flutter and AOT. Previous work on the production web
compiler had introduced optimizations similar to what null safety
later introduced. This may make resulting gains to production web apps
seem less than their native targets.

A few notes that are worth highlighting:

* The production JavaScript compiler generates `!` null assertions. You might
  not notice them when comparing the output of the compiler before and
  after adding null assertions. That's because the compiler already
  generated null checks in programs that weren't null safe.

* The compiler generates these null assertions regardless of the
  soundness of null safety or optimization level. In fact, the compiler
  doesn't remove `!` when using `-O3` or `--omit-implicit-checks`.

* The production JavaScript compiler might remove unnecessary null checks.
  This happens because the optimizations that the production web
  compiler made prior to null safety removed those checks when it
  knew the value was not null.

* By default, the compiler would generate parameter subtype checks.
  These runtime checks ensure covariant virtual calls have appropriate
  arguments. The compiler skips these checks with the
  `--omit-implicit-checks` option. Using this option can generate apps
  with unexpected behavior if the code includes invalid types.
  To avoid any surprises, continue provide strong test coverage for
  your code. In particular, the compiler optimizes code based
  on the fact that inputs should comply with the type declaration. If
  the code provides arguments of an invalid type, those optimizations
  would be wrong and the program could misbehave. This was true for
  inconsistent types before, and is true with inconsistent 
  nullabilities now with sound null-safety.

* You may notice that the development JavaScript compiler and the Dart 
  VM have special error messages for null checks, but to keep 
  applications small, the production JavaScript compiler does not.

* You may see errors indicating that `.toString` is not found on `null`.
  This is not a bug. The compiler has always encoded some null checks
  in this way. That is, the compiler represents some null checks
  compactly by making an unguarded access of a property of the
  receiver. So instead of `if (a == null) throw`, it generates
  `a.toString`. The `toString` method is defined in JavaScript Object
  and is a fast way to verify that an object is not null.

  If the very first action after a null check is an action that crashes
  when the value is null, the compiler can remove the null check and
  let the action cause the error.

  For example, a Dart expression `print(a!.foo());` could turn directly
  into:

  ```js
    P.print(a.foo$0());
  ```

  This is because the call `a.foo$()` will crash if `a` is null.
  If the compiler inlines `foo`, it will preserve the null check.
  So for example, if `foo` was `int foo() => 1;`  the compiler might 
  generate:

  ```js
    a.toString;
    P.print(1);
  ```

  If the inlined method first accessed a field on the receiver, like
  `int foo() => this.x + 1;`, then the production compiler can remove
  the redundant `a.toString` null check, as non-inlined calls, and
  generate:

  ```js
    P.print(a.x + 1);
  ```
    
## Resources

*   [DartPad with Null Safety]({{site.dartpad}})
*   [Sound null safety](/null-safety)
