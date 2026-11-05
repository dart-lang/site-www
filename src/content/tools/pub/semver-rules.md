---
title: SemVer compatibility and breaking changes
breadcrumb: SemVer rules
description: >-
  A comprehensive guide to what changes are breaking major changes, non-breaking
  minor features, or patch bug fixes in Dart packages.
---

When developing and publishing Dart packages, adhering to [Semantic
Versioning][semver] helps create a healthy and predictable package ecosystem.

Any Dart package provides a set of features, and with that comes a
contract that the user can rely on this set of features to continue working.
Packages sometimes get changed, and there are two categories of changes: adding
or removing functionality. Some changes do one or the other, some do both. While
removing functionality may sometimes be necessary, doing so violates the
contract with the user. To accommodate this, Dart uses semantic versioning to
help users recognize whether a new version of a package adheres to the old
contract or presents a new one.

This guide provides an (incomplete) reference on which changes to your Dart
code affect the public API surface of your package and what version bump is
required.

:::tip
For a conceptual overview of how Dart's package manager `pub` handles semantic
versioning see the [Package versioning](/tools/pub/versioning) guide.
:::

## Semantic versioning and `package:pub_semver`

Dart's package manager, pub, follows [Semantic Versioning][semver] as
implemented by [`package:pub_semver`][pub_semver].

A standard version number is formatted as `MAJOR.MINOR.PATCH`, such as `1.2.3`.
The three numbers are hierarchical: `MINOR` versions are only comparable if they
have the same `MAJOR` version, and `PATCH` versions are only comparable if they
have the same `MAJOR` and `MINOR` versions. For example, `1.3.0` and `1.2.5`
have comparable `MINOR` versions, but `1.3.0` and `2.1.0` don't.

When comparing two versions, the first number that differs determines what kind
of change separates them. The version with the larger number in that position
contains:

* **`MAJOR`**: Incompatible breaking changes to the public API.
* **`MINOR`**: Backward-compatible new functionality or features.
* **`PATCH`**: Backward-compatible bug fixes.

Versions before `1.0.0`, which have a `MAJOR` version of `0`, are interpreted
differently. For details, see [Pre-1.0.0 versions](#pre-1-0-0-versions).

## The public API boundary

In short, the public API is everything that users of your package can import
and use in the officially supported way, which excludes importing libraries
from its `lib/src/` directory.

More precisely, the **public API** of your package consists of the declarations
that are exported by each of its **public libraries**, and that aren't
explicitly marked as non-public:

* A library is public if its file is in `lib/`, but not inside `lib/src/`,
  such as `lib/my_package.dart` or `lib/foo/bar.dart`.
* A declaration is marked as non-public if it's annotated with `@internal` or
  `@visibleForTesting` from [`package:meta`]({{site.pub-pkg}}/meta), or if it's
  explicitly documented as only for internal use.

Anything else is private to the package and not intended for use by its
clients.

:::note
Nothing prevents a user from importing a library from inside another package's
`lib/src/` directory, such as `import 'package:example/src/secret.dart';`, or
from using an otherwise visible declaration that's marked `@internal`. However,
being non-public means that doing so is heavily discouraged. The package author
has made **no promises** that using such declarations is safe or will keep
working.
:::

### Declarations and capabilities

There are two kinds of things you can remove from a public API, and removing
either one is a breaking change:

* **Declarations**, such as functions, classes, members, getters, and setters.
  A declaration is either there or not, and it has a signature or interface,
  such as a function's parameter and return types. Across all declaration kinds:
  * Adding a new name to a library's export scope or to the `static` scope of an
    exported type is `MINOR`.
  * Removing or renaming a name from an exported or `static` scope is `MAJOR`
    (renaming a declaration or named parameter is equivalent to removing the
    original name and adding a new one).
* **Capabilities**, which are about *how* users can use a declaration. For
  example, whether a variable or constructor can be used in constant
  expressions, or whether a class can be used as a superclass, mixin, or
  superinterface, as controlled by its class modifiers.

### Guiding principles: Contracts and intended usage

All specific rules in this guide follow from three general principles:

1. **Require less, provide more:** A change is backward-compatible (`MINOR`)
   when a declaration requires less from callers (such as widening a parameter
   type or making a parameter optional) or provides more (such as narrowing a
   return type or adding a method to a `final` class). A change is breaking
   (`MAJOR`) when it requires more or provides less.
2. **Documented contracts and intended usage:** If a declaration explicitly
   documents restrictions on its use—for example, stating in doc comments that a
   class must not be implemented, or that an enum may gain new values in minor
   releases—then changes that only affect unsupported usage are non-breaking
   (`MINOR` or `PATCH`).
3. **Pragmatic ecosystem conventions:** In Dart, almost any addition can
   theoretically cause a static error in rare consumer patterns, such as
   imports without a prefix or `show` clause, local variable type inference
   (`var x = fn();`), method tear-offs, or extension resolution ambiguity. By
   convention, Dart package versioning treats these edge cases as non-breaking
   (`MINOR`) so that packages can evolve without constant major version bumps.
   Many of these cases come down to the same idea: a package's promises are
   only about its own API, not about how that API integrates into another
   program. For example, name conflicts with other packages are outside the
   scope of SemVer guarantees.

### Widening and narrowing types

Most type-related rules in this guide follow from two general rules:

* **Return types** can be narrowed to a subtype, such as from `num` to `int`
  (except when changing to `void` or away from `dynamic`). Changing a return
  type to a type that isn't a subtype of the original, such as widening it from
  `int` to `num`, is breaking, because callers might rely on the original type.
  For details, see [Return types](#return-types).
* **Parameter types** can be widened to a supertype, such as from `int` to
  `num`. Changing a parameter type to a type that isn't a supertype of the
  original, such as narrowing it from `num` to `int`, is breaking, because
  callers might pass values of the original type. For details, see
  [Parameters](#parameters).

These rules also apply to getters and setters, including the implicit getter
and setter of a variable. A getter's type is a return type, and a setter's type
is a parameter type. That's why you can narrow the type of a `const` or `final`
variable, which only has a getter, but can't change the type of a mutable
variable, which has both, in either direction.

These compatible signature changes (narrowing return types, widening parameter
types, and adding optional parameters) apply to all **non-overridable**
declarations: top-level functions, constructors, `static` members, `extension`
and `extension type` members, `enum` members, and instance members of `final`
classes. If users can override an instance member—such as on an unrestricted,
`interface`, or `base` class or `mixin`—changing its signature in *either*
direction is `MAJOR`, because the requirements for overriding a member are the
opposite of those for calling it.

---

## Top-level declarations

### MINOR: Add a new top-level declaration

Adding a new public top-level function, class, typedef, enum, extension, or
constant is backward-compatible. Existing consumer code will continue to compile
and function as before.

```dart tag=good
// Before (v1.0.0):
// lib/my_package.dart
void calculateTotal() {}

// After (v1.1.0 - MINOR):
// lib/my_package.dart
void calculateTotal() {}
void calculateTax() {} // Added: safe because existing callers are unaffected.
```

*Note:* While introducing a new top-level name can cause a naming conflict if a
consumer imports multiple libraries without prefixes, Dart versioning convention
treats top-level additions as non-breaking (`MINOR`).

### MAJOR: Remove or rename a public top-level declaration

Removing or renaming any public top-level declaration is a breaking change.
Renaming a public symbol is functionally equivalent to removing the original
name and introducing a new one; any downstream code referencing the original
name will fail to compile.

```dart tag=bad
// Before (v1.0.0):
void performTask() {}

// After (v2.0.0 - MAJOR):
void executeTask() {} // Removed or renamed: callers referencing `performTask` fail to compile.
```

### MAJOR: Stop exporting a declaration from a public library

Removing a declaration from the exports of a public library is a breaking
change, no matter what happens to the declaration elsewhere. Code that imports
the original library and refers to the declaration fails to compile. This is
true even if you move the declaration to another public library, because
existing imports still refer to the original library.

```dart tag=bad
// Before (v1.0.0):
// lib/my_package.dart
export 'src/engine.dart';

// After (v2.0.0 - MAJOR):
// lib/my_package.dart
// `src/engine.dart` is no longer exported here.

// lib/engine.dart
export 'src/engine.dart'; // Moved: code importing `package:my_package/my_package.dart` can no longer access engine symbols.
```

### MAJOR: Widen or change the type of a variable

Changing a variable to a broader type, such as changing `const int maxRetries`
to `const num maxRetries`, or to an unrelated type breaks callers expecting
members of the original type. This applies to all variables, whether they're
`const`, `final`, or mutable, because reading a variable calls its implicit
getter, and changing the return type of any function, including a getter, to a
type that isn't a subtype of the original is breaking. For more information,
see [Widening and narrowing types](#widening-and-narrowing-types).

```dart tag=bad
// Before (v1.0.0):
const int maxRetries = 3;

// After (v2.0.0 - MAJOR):
const num maxRetries = 3; // Widened: callers expecting `int` methods break.
```

### MINOR: Narrow the type of a `const` or `final` variable

Narrowing the static type of a read-only `const` or `final` variable to a more
specific subtype, such as changing `const num timeout` to `const int timeout` or
`const Object key` to `const String key`, is backward-compatible. Because
consumers only read the value, a more specific subtype satisfies all existing
type expectations while providing additional type safety.

```dart tag=good
// Before (v1.0.0):
const num timeout = 30;

// After (v1.1.0 - MINOR):
const int timeout = 30; // Narrowed: consumers only read the value, receiving a more specific subtype.
```

### MAJOR: Change the type of a mutable top-level variable

For mutable variables that can be both read from and written to, changing the
static type in either direction is a breaking change, because the variable has
both a getter and a setter (see [Widening and narrowing
types](#widening-and-narrowing-types)):
* Narrowing the type, such as `num` to `int`, narrows the setter's parameter
  type, which breaks callers assigning a `double` into the variable.
* Widening the type, such as `int` to `num`, widens the getter's return type,
  which breaks callers expecting `int` methods when reading the variable.

```dart tag=bad
// Before (v1.0.0):
num threshold = 10.5;

// After (v2.0.0 - MAJOR):
int threshold = 10; // Narrowed: callers assigning a double (e.g. `threshold = 1.5;`) fail to compile.
```

### MAJOR: Change a mutable variable to `final` or `const`

A mutable variable has an implicit setter. Making the variable `final` or
`const` removes that setter from your public API, and removing a declaration is
a breaking change: users assigning values to the variable fail to compile.

```dart tag=bad
// Before (v1.0.0):
String globalConfig = 'default';

// After (v2.0.0 - MAJOR):
final String globalConfig = 'default'; // Callers assigning `globalConfig = 'custom';` fail to compile.
```

### MAJOR: Change a `const` variable to non-`const`

Changing a `const` variable to `final` or to a mutable variable removes a
capability instead of a declaration: if users can use a declaration in a
constant expression, changing it so that they no longer can is a breaking
change. For example, a variable that's no longer `const` can't be used in
default parameter values, `const` collections, or `switch` cases. The same
applies to changing a `const` constructor to non-`const` (see
[Constructors](#constructors)).

Declaring a variable or constructor `const` is a promise that it can be used in
constant expressions, so only do so if you intend to keep that promise.

```dart tag=bad
// Before (v1.0.0):
const defaultTimeout = Duration(seconds: 30);

// Downstream package:
void connect({Duration timeout = defaultTimeout}) {}

// After (v2.0.0 - MAJOR):
final defaultTimeout = Duration(seconds: 30); // Breaks: `defaultTimeout` is no longer a constant, so it can't be a default value.
```

---

## Classes, mixins, and class modifiers

Dart 3 introduced class modifiers: `final`, `base`, `interface`, `sealed`, and
`mixin`. These allow package authors to explicitly define how classes can be
used by consumers. The SemVer impact of adding or modifying members depends on
these modifiers.

### Changing modifiers on existing classes

Changing the modifier on an already-published class alters what external
packages are permitted to do with it:

#### Change a concrete class to an abstract class

Changing a concrete class to `abstract class` prevents users from creating
instances by calling its generative constructors:

* **MAJOR** if the class has a public generative constructor, including the
  implicit default constructor, because calls such as `MyClass()` fail to
  compile.
* **PATCH** if the class has no public generative constructors. Any factory
  constructors still work on an abstract class, so the public API doesn't
  change.

```dart tag=bad
// Before (v1.0.0):
class Formatter {}

// Downstream package:
final formatter = Formatter();

// After (v2.0.0 - MAJOR):
abstract class Formatter {} // Breaks: `Formatter()` can no longer be directly instantiated.
```

#### MINOR: Change an abstract class to a concrete class

Making an abstract class concrete enables external instantiation without
breaking existing subclasses or implementers.

```dart tag=good
// Before (v1.0.0):
abstract class Formatter {}

// After (v1.1.0 - MINOR):
class Formatter {} // Safe: allows direct instantiation without breaking existing subtypes.
```

#### MAJOR: Add the `base` modifier to an existing class

Prevents users from implementing the class using `implements MyClass`, and
requires any external subclass using `extends MyClass` to also be marked
`base`, `final`, or `sealed`.

```dart tag=bad
// Before (v1.0.0):
class Worker {}

// Downstream package:
class CustomWorker implements Worker {}

// After (v2.0.0 - MAJOR):
base class Worker {} // Breaks: downstream implementers (`implements Worker`) and unmarked subclasses (`class Sub extends Worker`) fail to compile.
```

#### MAJOR: Add the `interface` modifier to an existing class

Prevents external consumers from extending the class using `extends MyClass`,
breaking all existing external subclasses.

```dart tag=bad
// Before (v1.0.0):
class Service {}

// Downstream package:
class CustomService extends Service {}

// After (v2.0.0 - MAJOR):
interface class Service {} // Breaks: downstream subclasses (`extends Service`) fail to compile.
```

#### MAJOR: Add the `final` or `sealed` modifier to an existing class

Prevents external consumers from extending, implementing, or mixing in the
class, breaking all existing external subtypes. In addition, `sealed` implicitly
makes the class `abstract`, breaking direct construction (`MyClass()`).

```dart tag=bad
// Before (v1.0.0):
class Database {}

// Downstream package:
class MockDatabase extends Database {}

// After (v2.0.0 - MAJOR):
final class Database {} // Breaks: downstream subclasses fail to compile.
```

#### MAJOR: Remove the `mixin` modifier from a `mixin class`

Prevents external consumers from using the class as a mixin using `with
MyClass`. (Conversely, adding `mixin` to turn a `class` into a `mixin class` is
**`MINOR`**.)

```dart tag=bad
// Before (v1.0.0):
mixin class TaskRunner {}

// Downstream package:
class Worker with TaskRunner {}

// After (v2.0.0 - MAJOR):
class TaskRunner {} // Breaks: downstream mixin uses (`with TaskRunner`) fail to compile.
```

#### MAJOR: Remove the `sealed` modifier from a class

Removing `sealed` from a class breaks downstream exhaustive `switch` statements
and expressions over its subtypes, because the compiler can no longer guarantee
that the known subtypes are exhaustive.

#### MINOR: Remove or loosen `base`, `interface`, or `final` on a class

Removing `base`, `interface`, or `final`—or loosening `final` to `base` or
`interface`—relaxes restrictions on consumers, granting new capabilities without
invalidating existing code. Note that removing `final` or `base` (or changing
`final` to `interface`) is a one-way door: once external libraries can implement
the class, adding new instance members in future releases becomes a `MAJOR`
change.

```dart tag=good
// Before (v1.0.0):
final class Database {}

// After (v1.1.0 - MINOR):
class Database {} // Safe: loosens restrictions and allows consumers to extend or implement.
```

---

### Changing instance members of unrestricted classes: `class` and `abstract class`

Unrestricted classes are `class` declarations with no `interface`, `base`,
`final`, or `sealed` modifier restricting their use. They can be `abstract` or
not. Other packages can construct them (unless they're `abstract`), extend them
using `extends`, and implement them using `implements`.

#### MAJOR: Add an instance member to an unrestricted class

Adding any instance method, getter, setter, or field to an unrestricted `class`
or `abstract class` is a breaking change unless the class explicitly documents
that it must not be implemented. Because external libraries are permitted to
write `class MyImpl implements Foo`, any new member in `Foo` breaks existing
implementers due to missing overrides. (To allow adding concrete members in
`MINOR` releases with compiler enforcement, declare the class as `base` or
`final`.)

```dart tag=bad
// Before (v1.0.0):
abstract class HttpClient {
  void get(String url);
}

// Downstream package (v1.0.0):
class MockHttpClient implements HttpClient {
  @override
  void get(String url) {}
}

// After (v2.0.0 - MAJOR, or broken if released as MINOR):
abstract class HttpClient {
  void get(String url);
  void post(String url, Object body); // Added: MockHttpClient fails to compile due to missing `post`.
}
```

#### MAJOR: Remove or rename an instance member

Removing or renaming an instance method, getter, setter, or field breaks all
callers, extenders, and implementers.

```dart tag=bad
// Before (v1.0.0):
class Account {
  void close() {}
}

// After (v2.0.0 - MAJOR):
class Account {
  // `close()` was removed or renamed: existing callers fail to compile.
}
```

#### MINOR: Add a static member to a class

Static members are namespaced to the declaring type, such as `Class.member`, and
do not affect subclasses or external implementations (this applies to all
classes regardless of modifiers, as well as mixins, enums, extensions, and
extension types).

```dart tag=good
// Before (v1.0.0):
class MathUtils {
  static double add(double a, double b) => a + b;
}

// After (v1.1.0 - MINOR):
class MathUtils {
  static double add(double a, double b) => a + b;
  static double multiply(double a, double b) => a * b; // Safe: namespaced static member addition.
}
```

#### MAJOR: Remove or rename a static member

Breaks call sites referencing `Class.staticMember`.

```dart tag=bad
// Before (v1.0.0):
class MathUtils {
  static double multiply(double a, double b) => a * b;
}

// After (v2.0.0 - MAJOR):
class MathUtils {
  // `multiply` was removed: call sites referencing `MathUtils.multiply` fail to compile.
}
```

---

### `final class` and `abstract final class`

A `final` class cannot be extended, implemented, or mixed in outside of the
defining library.

#### MINOR: Add an instance member to a final class

Since external code cannot extend or implement a `final class`, adding new
instance methods, getters, setters, or fields is completely backward-compatible.
Consumers only call existing members and cannot be broken by added members.

```dart tag=good
// Before (v1.0.0):
final class Config {
  final String host;
  final int port;
  Config(this.host, this.port);
}

// After (v1.1.0 - MINOR):
final class Config {
  final String host;
  final int port;
  Config(this.host, this.port);

  bool get isSecure => port == 443; // Added: safe because consumers cannot implement or extend Config.
}
```

#### MAJOR: Remove or rename an instance member of a final class

Existing callers referencing the removed member will fail to compile.

```dart tag=bad
// Before (v1.0.0):
final class Config {
  final String host;
  final int port;
  Config(this.host, this.port);
}

// After (v2.0.0 - MAJOR):
final class Config {
  final String host;
  // `port` removed: callers referencing `config.port` fail to compile.
  Config(this.host);
}
```

---

### `base class`

A `base` class can be extended outside the library, but cannot be implemented
using `implements`.

#### MINOR: Add a concrete instance member to a base class

Because external libraries can only extend rather than implement a `base class`,
subclasses automatically inherit the new default implementation without needing
to override it.

```dart tag=good
// Before (v1.0.0):
base class Controller {
  void start() {}
}

// Downstream package:
class AppController extends Controller {}

// After (v1.1.0 - MINOR):
base class Controller {
  void start() {}
  void stop() {} // Added: AppController automatically inherits the concrete implementation.
}
```

#### MAJOR: Add an abstract member to a base class

Subclasses in external libraries will fail to compile because they do not
provide an implementation for the new abstract member.

```dart tag=bad
// Before (v1.0.0):
abstract base class Controller {
  void start();
}

// Downstream package:
class AppController extends Controller {
  @override
  void start() {}
}

// After (v2.0.0 - MAJOR):
abstract base class Controller {
  void start();
  void stop(); // Added abstract: AppController fails to compile (missing `stop`).
}
```

#### MAJOR: Remove or rename an instance member of a base class

Breaks both callers and extending subclasses.

---

### `interface class` and `abstract interface class`

An `interface` class can be implemented outside the library, but cannot be
extended using `extends`.

#### MAJOR: Add an instance member to an interface class

External classes can implement an `interface class`. Adding any new instance
method, getter, setter, or field requires implementers to provide the new
member, breaking compilation. (Adding a `static` member is `MINOR`.)

```dart tag=bad
// Before (v1.0.0):
abstract interface class Repository {
  void fetch();
}

// Downstream package:
class CustomRepository implements Repository {
  @override
  void fetch() {}
}

// After (v2.0.0 - MAJOR):
abstract interface class Repository {
  void fetch();
  void save(); // Added: CustomRepository fails to compile due to missing `save()` implementation.
}
```

#### MAJOR: Remove or rename an instance member of an interface class

Breaks callers and implementers.

---

### `sealed class`

A `sealed` class is implicitly abstract and cannot be extended, implemented, or
mixed in outside the library. It is designed for exhaustive pattern matching.

#### MAJOR: Add a direct subtype to a sealed class family

Adding a new subclass to a `sealed` class is a breaking change because
exhaustive `switch` statements or pattern matches in consumer code that do not
have a wildcard `_` or `default` case will fail to compile.

```dart tag=bad
// Before (v1.0.0):
sealed class Result {}
class Success extends Result {}
class Failure extends Result {}

// Downstream package:
String describe(Result result) => switch (result) {
  Success() => 'Success',
  Failure() => 'Failure',
};

// After (v2.0.0 - MAJOR):
sealed class Result {}
class Success extends Result {}
class Failure extends Result {}
class Pending extends Result {} // Added: downstream `describe` switch is no longer exhaustive and fails to compile.
```

#### MINOR: Add a member to a sealed class

External code cannot directly implement or extend a `sealed` class, so adding
`static` members is always non-breaking.

Adding an instance member to a `sealed` class also adds that member to all of
its subtypes. Therefore, adding an instance member is `MINOR` only if the
addition is also non-breaking for every public subtype (for example, when all
public subtypes are `final`, or `base` and the added member has a concrete
implementation). If a public subtype is unrestricted or `interface`, adding an
instance member to the `sealed` superclass breaks external implementers of that
subtype and requires a `MAJOR` bump.

```dart tag=good
// Before (v1.0.0):
sealed class Result {}
final class Success extends Result {}
final class Failure extends Result {}

// After (v1.1.0 - MINOR):
sealed class Result {
  bool get isSuccess => this is Success; // Added: safe because `Result` and its public subtypes cannot be implemented externally.
}
final class Success extends Result {}
final class Failure extends Result {}
```

---

### `mixin` and `mixin class`

#### MINOR: Add a concrete member to a mixin

Classes using `with MyMixin` automatically receive the concrete implementation.

*Note:* Adding an instance member to a mixin can conflict with a member of an
incompatible signature in a consumer's superclass or change extension member
resolution. As described in [Guiding
principles](#guiding-principles-contracts-and-intended-usage), scope and
declaration clashes in downstream hierarchies are outside the package's control
and are not considered API breaks. However, if a mixin is not declared `base
mixin`, external consumers *can* implement its interface with `implements
MyMixin`; by convention, mixins are intended to be applied with `with` (use
`base mixin` to enforce this in the compiler).

```dart tag=good
// Before (v1.0.0):
mixin Logger {
  void log(String message) => print(message);
}

// After (v1.1.0 - MINOR):
mixin Logger {
  void log(String message) => print(message);
  void logError(String error) => log('ERROR: $error'); // Added: classes using `with Logger` inherit the method.
}
```

#### MAJOR: Add an abstract member to a mixin

Requires all classes applying the mixin to supply an implementation for the new
abstract member.

```dart tag=bad
// Before (v1.0.0):
mixin Serializer {
  String serialize();
}

// Downstream package:
class User with Serializer {
  @override
  String serialize() => '{}';
}

// After (v2.0.0 - MAJOR):
mixin Serializer {
  String serialize();
  void deserialize(String json); // Added abstract: User fails to compile due to missing `deserialize`.
}
```

#### MAJOR: Tighten the `on` constraint on a mixin

Restricting the superclass requirements, such as from `on Object` to `on
State`, prevents existing classes that do not meet the new requirement from
mixing it in.

```dart tag=bad
// Before (v1.0.0):
mixin Lifecycle on Object {}

// Downstream package:
class Service with Lifecycle {}

// After (v2.0.0 - MAJOR):
mixin Lifecycle on State {} // Breaks: Service does not extend State and fails to compile.
```

#### MAJOR: Add a new super-invocation to a mixin member

Adding a new `super` member invocation (such as `super.length`) inside a mixin
member introduces a requirement that the superclass at every mixin application
provide a concrete implementation of that member. If a consumer applied the
mixin to an abstract superclass that left that member abstract, the mixin
application fails to compile. (If the mixin already contained a
super-invocation of the same member, no new restriction is introduced.)

```dart tag=bad
// Before (v1.0.0):
mixin FixedLengthList<E> on List<E> {
  @override
  void clear() => throw UnsupportedError('Cannot clear a fixed-length list');
}

// Downstream package (`ListBase` leaves `length` abstract):
abstract class CustomList<E> extends ListBase<E> with FixedLengthList<E> {}

// After (v2.0.0 - MAJOR):
mixin FixedLengthList<E> on List<E> {
  @override
  void clear() {
    if (super.length > 0) { // Added `super.length`: `ListBase with FixedLengthList` fails to compile because `ListBase.length` is abstract.
      throw UnsupportedError('Cannot clear a fixed-length list');
    }
  }
}
```

---

## Type aliases: `typedef`

Type aliases define names for function types, records, or existing class types.

### MINOR: Add a new type alias

Adding a new public `typedef` exposes a new type name without affecting existing
code.

```dart tag=good
// Before (v1.0.0):
void process(void Function(int) callback) {}

// After (v1.1.0 - MINOR):
typedef NumberCallback = void Function(int);
void process(NumberCallback callback) {} // Safe: adds type alias without altering contract.
```

### MAJOR: Remove or rename a type alias

Any downstream code referencing the removed `typedef` name will fail to compile.

```dart tag=bad
// Before (v1.0.0):
typedef DataHandler = void Function(String);

// After (v2.0.0 - MAJOR):
// `DataHandler` was removed. Downstream code referencing `DataHandler` fails to compile.
```

### MAJOR: Change a type alias to an incompatible type

Changing the underlying type that a type alias references—such as changing
`typedef Callback = void Function(int);` to `typedef Callback = void
Function(String);`, or `typedef Items = List<int>;` to `typedef Items =
Set<int>;`—is a breaking change when the new type is incompatible with existing
uses of the alias or alters its subtype relationships with other public types.

(If the new aliased type has a backward-compatible API and preserves existing
subtype relationships and capabilities, changing the target of a `typedef` can
be `MINOR` or `PATCH`.)

```dart tag=bad
// Before (v1.0.0):
typedef Callback = void Function(int count);

// After (v2.0.0 - MAJOR):
typedef Callback = void Function(String message); // Incompatible type: downstream callbacks expecting `int` fail to compile.
```

### Replace a `typedef` with a class or vice versa

Whether replacing a `typedef` with a class of the same name (or vice versa) is
breaking depends on whether the replacement preserves all existing type
relationships and capabilities:

* **MINOR or PATCH when the types and capabilities are equivalent:**
  * **Promoting an alias of a private class to a public class:** Changing
    `typedef C<T> = _C<T>;` to a public `class C<T>` with the same API removes a
    layer of indirection without breaking existing uses.
  * **Aliasing a renamed class:** Renaming `class OldName` to `class NewName`
    while keeping `typedef OldName = NewName;` (typically annotated with
    `@Deprecated(...)`) is a standard `MINOR` pattern, because `OldName` and
    `NewName` refer to the exact same type.
* **MAJOR when the replacement is not type-compatible:**
  * **Function type alias -> callable class:** In Dart, function
    literals (closures) are function values, not instances of a class that
    defines a `call()` method. Replacing `typedef Callback = void Function();`
    with `class Callback { void call(); }` breaks callers assigning closures
    like `Callback cb = () => ...;`.
  * **Class type alias -> subclass:** Replacing `typedef A = B;` with
    `class A extends B {}` loses bidirectional assignability (`B` is no longer a
    subtype of `A`).

```dart tag=bad
// Before (v1.0.0):
typedef Callback = void Function();

// Downstream package:
Callback cb = () => print('done');

// After (v2.0.0 - MAJOR):
abstract class Callback {
  void call();
} // Function values are not instances of class Callback: downstream `cb = () => ...` fails to compile.
```

---

## Constructors

Constructor parameters follow the same compatibility rules as other
non-overridable functions (see [Parameters](#parameters)): adding an optional
parameter or widening a parameter type is `MINOR`, while adding a required
parameter, removing a parameter, or narrowing a parameter type is `MAJOR`.

### MINOR: Add a new public constructor or factory

Adding named constructors, such as `MyClass.named()`, or factories to a class
that already declares an explicit constructor provides new construction options
without affecting existing callers.

*Note:* Changing an existing generative constructor to a `factory` constructor
on an extendable class is **`MAJOR`**, because subclasses can no longer invoke
it in `super(...)`.

```dart tag=good
// Before (v1.0.0):
class Request {
  Request(String url);
}

// After (v1.1.0 - MINOR):
class Request {
  Request(String url);
  Request.json(String url); // Added: provides a new constructor while preserving `Request(String)`.
}
```

### MAJOR: Remove or rename a constructor

Removing or renaming a public constructor breaks call sites that invoked it
(and breaks subclasses that invoked it via `super(...)`).

You can also inadvertently remove the implicit default constructor `MyClass()`
by adding *any* explicit constructor declaration—even a named constructor, a
private constructor like `MyClass._()`, or a `factory`—to a class that
previously had no explicit constructors. Unless you also explicitly declare
`MyClass();`, callers and subclasses relying on the default constructor will
fail to compile.

```dart tag=bad
// Before (v1.0.0):
class AppUtils {
  // Implicit public default constructor `AppUtils()`
}

// After (v2.0.0 - MAJOR):
class AppUtils {
  AppUtils._(); // Removes the implicit `AppUtils()` constructor: callers using `AppUtils()` fail to compile.
}
```

### MAJOR: Change a `const` constructor to non-`const`

Breaks any call site using `const MyClass(...)`.

```dart tag=bad
// Before (v1.0.0):
class const Point(final int x);

// Downstream package:
const origin = Point(0);

// After (v2.0.0 - MAJOR):
class Point(final int x); // Removed `const`: `const Point(0)` fails to compile.
```

### MINOR: Change a non-`const` constructor to `const`

Adding `const` capability does not break existing non-const call sites using
`MyClass(...)`.

```dart tag=good
// Before (v1.0.0):
class Point(final int x);

// After (v1.1.0 - MINOR):
class const Point(final int x); // Safe: non-const invocations `Point(0)` remain valid.
```

---

## Functions, methods, and parameters

### Parameters

#### MAJOR: Add a required positional or named parameter

Existing call sites omitting the parameter will fail to compile.

```dart tag=bad
// Before (v1.0.0):
void logMessage(String message) {}

// After (v2.0.0 - MAJOR):
void logMessage(String message, {required String level}) {} // Callers using `logMessage('data')` fail to compile.
```

#### Add an optional parameter

* **MINOR** for non-overridable functions and methods—top-level functions,
  constructors, `static` methods, `extension` and `extension type` methods,
  `enum` methods, and instance methods on `final` classes (or `sealed` classes
  whose public subtypes cannot be implemented externally)—because existing call
  sites can omit the new optional parameter without issue.
* **MAJOR** for instance methods on classes or mixins that external consumers
  can `extend` or `implement`, because existing subclass overrides (such as
  `@override void logMessage(String message)`) will fail to compile due to an
  incompatible signature.

```dart tag=good
// Before (v1.0.0):
void logMessage(String message) {}

// After (v1.1.0 - MINOR for non-overridable functions and methods):
void logMessage(String message, [String level = 'INFO']) {} // Safe for callers: `logMessage('data')` continues to compile.
```

:::note Tear-offs and optional parameters
In Dart, tearing off a method like `final fn = obj.myMethod;` produces a
function whose static type reflects its exact signature. Adding an optional
parameter changes the static type of the tear-off, which can cause a type
mismatch if the consumer assigned it to a specific `typedef`. In practice,
adding optional parameters to non-overridable functions and methods is standard
for `MINOR` releases unless a package's primary contract relies on exact
function signatures.
:::

#### MAJOR: Remove any parameter

Call sites passing the removed argument will fail to compile.

```dart tag=bad
// Before (v1.0.0):
void connect(String host, int port) {}

// After (v2.0.0 - MAJOR):
void connect(String host) {} // Callers passing two arguments fail to compile.
```

#### MAJOR: Rename a named parameter

Renaming a named parameter is equivalent to removing the old parameter name and
adding a new one: call sites passing `func(paramName: value)` will fail to
compile when `paramName` is changed. (Renaming a positional parameter is
non-breaking, as callers cannot pass positional arguments by name.)

```dart tag=bad
// Before (v1.0.0):
void fetchData({int timeoutSeconds = 30}) {}

// After (v2.0.0 - MAJOR):
void fetchData({int timeout = 30}) {} // Callers passing `fetchData(timeoutSeconds: 10)` fail to compile.
```

#### MAJOR: Reorder positional parameters

Reordering positional parameters changes the expected argument positions at call
sites. Even if the parameter types are identical, it causes callers to pass
arguments to the wrong parameters, altering behavior or causing compile-time
type errors.

```dart tag=bad
// Before (v1.0.0):
void setDimensions(double width, double height) {}

// After (v2.0.0 - MAJOR):
void setDimensions(double height, double width) {} // Callers pass width as height and height as width.
```

#### MAJOR: Narrow a parameter type

Changing a parameter from `num` to `int` breaks callers that passed `double`.

```dart tag=bad
// Before (v1.0.0):
void setPadding(num padding) {}

// After (v2.0.0 - MAJOR):
void setPadding(int padding) {} // Callers passing a double (`setPadding(8.5)`) fail to compile.
```

#### Widen a parameter type

* **MINOR** for non-overridable functions and members (top-level functions,
  constructors, `static` members, `extension` and `extension type` members,
  `enum` members, and instance members of `final` classes), because callers can
  pass a wider variety of inputs, such as widening a parameter from `Future<T>`
  to `FutureOr<T>` or from `int` to `num`.
* **MAJOR** for instance members on an extendable or implementable class or
  mixin, because it changes the signature required for external overrides.

```dart tag=good
// Before (v1.0.0):
void setPadding(int padding) {}

// After (v1.1.0 - MINOR for non-overridable functions and members):
void setPadding(num padding) {} // Safe: callers can now pass int or double without breaking existing callers.
```

:::note Tear-offs and widened parameter types
Widening a parameter type changes the static type of a tear-off. Because
function parameters are contravariant, tearing off a function with a widened
parameter type (like `void Function(Object)`) can prevent assigning narrower
callbacks into an inferred variable (like `var callback = doStuff; callback =
(String s) {};`). In practice, such situations are rare, and widening parameter
types on non-overridable functions is treated as non-breaking.
:::

#### Change the default value of an optional parameter

Changing a default parameter value does not break compilation or static type
checks, but alters runtime behavior for callers omitting the argument:

* **MINOR or PATCH** if the new default preserves the documented behavioral
  contract (such as tuning a buffer size or default timeout).
* **MAJOR** if the new default alters the observable behavioral contract in an
  incompatible way for existing callers that omit the argument.

```dart tag=good
// Before (v1.0.0):
void connect([int timeoutSeconds = 10]) {}

// After (v1.1.0 - MINOR if contract-compatible):
void connect([int timeoutSeconds = 30]) {} // Compiles without error; changes default runtime value.
```

---

### Return types

Return types in Dart are **covariant**: callers expect a return value conforming
to at least the declared type, while subclasses overriding a method or getter
must return a subtype of the superclass member's return type.

#### Narrow a return type

Moving down the type lattice to a more specific subtype—such as `num` to `int`,
`Object?` to `String`, or any type to `Never`—or changing a return type from
`void` to a non-`void` type:

* **MINOR for callers of non-overridable functions and members** (top-level
  functions, `static` members, `extension` and `extension type` members, `enum`
  members, and instance members of `final` classes):
  * **Direct invocations:** Callers receive a more specific type with additional
    available members and tighter type safety.
  * **From `void` to a non-`void` type:** Changing a return type from `void` to
    any non-`void` type `T` (including `Object?`) is backward-compatible.
    Callers ignoring the return value continue to work, and callbacks passed to
    `void Function(...)` continue to compile because Dart treats `T
    Function(...)` as a subtype of `void Function(...)` for any type `T`.
  * **Bottom type (`Never`):** For functions that unconditionally throw or exit,
    narrowing the return type to `Never` is backward-compatible because `Never`
    is a universal subtype of all Dart types.
* **MAJOR if the member can be overridden in external subclasses or implementers:**
  * External subclasses that declared the previous wider return type, such as
    `@override num get scale` or `@override void method()`, will fail to compile
    with an override error, because the subclass's wider return type is not a
    valid subtype of the new narrower return type.
* **MAJOR when changing away from `dynamic` or changing to `void`:**
  * Even though `Object?`, `dynamic`, and `void` are all top types (mutual
    supertypes of all types), changing a return type **away from `dynamic`**
    (such as `dynamic` to `Object?` or `String`) is `MAJOR`, because callers
    relying on dynamic member access or implicit downcasts will fail to compile.
  * Changing a return type **from any non-`void` type to `void`** (including
    from `Object?` or `dynamic`) is `MAJOR`, because callers can no longer use
    the returned value.

```dart tag=good
// Before (v1.0.0):
num getScale() => 1;

// After (v1.1.0 - MINOR for non-overridable functions and members):
int getScale() => 1; // Safe: callers expecting `num` continue to work, while callers can access `int` methods.
```

#### MAJOR: Widen a return type or change to `void`

Moving up the type lattice to a broader supertype—such as `int` to `num` or
`Future<T>` to `FutureOr<T>`—or changing a non-`void` return type to `void`:

* **MAJOR for callers:**
  * Callers expecting specific members on the returned object, like `int`
    methods or `.then()` on a `Future<T>`, will fail to compile.
  * Changing a return type from a non-`void` type to `void` (even from another
    top type such as `Object?` or `dynamic`) breaks any callers attempting to
    read or use the returned value.
* Subclasses that already returned a narrower subtype remain valid overrides.

```dart tag=bad
// Before (v1.0.0):
int getCount() => 42;

// After (v2.0.0 - MAJOR):
num getCount() => 42.0; // Callers expecting `int` (e.g. `int count = getCount();`) fail to compile.
```

---

### Generics and type parameters

#### MAJOR: Add a bound to an unconstrained type parameter

Adding a type parameter constraint, such as changing `class Store<T>` to `class
Store<T extends State>`, breaks existing consumers using type arguments that do
not conform to the new bound, like `Store<String>`.

```dart tag=bad
// Before (v1.0.0):
class Store<T> {}

// After (v2.0.0 - MAJOR):
class Store<T extends State> {} // Existing uses like `Store<String>` fail to compile.
```

#### MAJOR: Tighten a type parameter bound

Changing `<T extends Object>` to `<T extends num>` breaks callers using
non-number type arguments.

```dart tag=bad
// Before (v1.0.0):
class NumericList<T extends Object> {}

// After (v2.0.0 - MAJOR):
class NumericList<T extends num> {} // Existing uses like `NumericList<String>` fail to compile.
```

#### Loosen or remove a type parameter bound

Changing `<T extends int>` to `<T extends num>` or removing a bound permits more
type arguments:

* **MINOR** for generic type declarations (classes, mixins, typedefs, enums,
  extensions, and extension types) and for direct calls to non-overridable
  generic functions and methods.
  * *Note:* In Dart's type system, generic function types are invariant in their
    type parameter bounds (`void Function<T extends num>(T)` is not a subtype of
    `void Function<T extends int>(T)`), so loosening a bound on a generic
    function can break typed tear-offs. As with optional parameters, this edge
    case is treated as `MINOR` unless the function is primarily intended to be
    torn off at a fixed function type.
* **MAJOR** for overridable generic instance methods (on unrestricted,
  `interface`, or `base` classes and mixins), because Dart requires overriding
  methods to declare equivalent type parameter bounds.

```dart tag=good
// Before (v1.0.0):
class NumericList<T extends int> {}

// After (v1.1.0 - MINOR):
class NumericList<T extends num> {} // Safe: existing `NumericList<int>` remains valid, and `NumericList<double>` is now supported.
```

#### MAJOR: Add or remove a type parameter

Dart does not support default type arguments. While raw type references (such as
`Store x`) use instantiation-to-bounds, adding or removing a type parameter on a
type or an already-generic function breaks any consumer code that passes
explicit type arguments (such as `Store<String>`).

*Note:* Adding a type parameter to a previously *non-generic*, non-overridable
function (such as changing `T? firstOrNull(List<Object?> items)` or `void
log(Object? value)` to `void log<T>(T value)`) does not break existing
invocations because no existing call site could pass explicit type arguments, so
type inference supplies them automatically.

```dart tag=bad
// Before (v1.0.0):
class Store<T> {}

// After (v2.0.0 - MAJOR):
class Store<T, M> {} // Breaks explicit type argument usages like `Store<String>` due to wrong type argument count.
```

---

## Enums

### MAJOR: Add a new enum value

Adding a value to an `enum` breaks exhaustive `switch` statements and pattern
matches in consumer code that do not include a `default` or wildcard `_` clause.

```dart tag=bad
// Before (v1.0.0):
enum Status {
  pending,
  success,
  failure,
}

// Downstream package:
String label(Status status) => switch (status) {
  Status.pending => 'Pending',
  Status.success => 'Success',
  Status.failure => 'Failure',
};

// After (v2.0.0 - MAJOR):
enum Status {
  pending,
  success,
  failure,
  cancelled, // Added: downstream `label` switch is no longer exhaustive and fails to compile.
}
```

### MAJOR: Remove or rename an enum value

Any code referencing `MyEnum.oldValue` will fail to compile.

```dart tag=bad
// Before (v1.0.0):
enum Status {
  pending,
  success,
  failure,
}

// After (v2.0.0 - MAJOR):
enum Status {
  pending,
  success, // `failure` was removed or renamed: callers referencing `Status.failure` fail to compile.
}
```

### MAJOR: Reorder enum values

Reordering enum declarations does not cause static compilation errors, but
alters each value's `.index` property at runtime. If your package or downstream
users serialize enums by index, like in databases or network protocols,
reordering values is a breaking runtime change.

```dart tag=bad
// Before (v1.0.0):
enum Priority {
  low,    // index: 0
  medium, // index: 1
  high,   // index: 2
}

// After (v2.0.0 - MAJOR runtime break for serialized indices):
enum Priority {
  high,   // index: 0 (changed!)
  medium, // index: 1
  low,    // index: 2 (changed!)
}
```

### MINOR: Add a member to an enum

Enums cannot be extended or implemented, and their constructors cannot be called
externally, so adding members (or constructor parameters) to an `enum` is safe
for consumers.

```dart tag=good
// Before (v1.0.0):
enum Status {
  pending,
  success;
}

// After (v1.1.0 - MINOR):
enum Status(final bool isDone) {
  pending(false),
  success(true); // Safe: consumers only access existing enum values/members and cannot instantiate or implement enums.
}
```

---

## Extension methods and extension types

### Extension methods: `extension on`

#### MINOR: Add an extension or extension member

Adding extension members is backward-compatible. Static ambiguity can
occasionally occur if consumer code already has another extension in scope with
the same member name.

```dart tag=good
// Before (v1.0.0):
extension StringUtils on String {
  bool get isBlank => trimRight().isEmpty;
}

// After (v1.1.0 - MINOR):
extension StringUtils on String {
  bool get isBlank => trimRight().isEmpty;
  bool get isNotBlank => !isBlank; // Added: backward-compatible new extension member.
}
```

#### MAJOR: Remove or rename an extension or extension member

Removing or renaming an extension member breaks call sites invoking that member.
Renaming a public `extension` itself is also breaking because it breaks explicit
extension invocations (such as `StringUtils(s).isBlank`) and `show`/`hide`
import combinators.

```dart tag=bad
// Before (v1.0.0):
extension StringUtils on String {
  bool get isBlank => trimRight().isEmpty;
}

// After (v2.0.0 - MAJOR):
extension StringUtils on String {
  // `isBlank` was removed: callers invoking `'text'.isBlank` fail to compile.
}
```

#### MAJOR: Narrow or change the extended type to a non-supertype

Changing the target (`on`) type of an extension to a type that is not a
supertype of the original—such as narrowing `extension Helpers on num` to
`extension Helpers on int`, or changing `on String` to `on StringBuffer`—removes
the extension members from instances of the original type, breaking existing
call sites.

```dart tag=bad
// Before (v1.0.0):
extension Formatter on String {
  String format() => trim();
}

// After (v2.0.0 - MAJOR):
extension Formatter on StringBuffer { // Changed from `on String` to `on StringBuffer`: existing `'text'.format()` calls fail to compile.
  String format() => toString().trim();
}
```

#### MINOR: Widen the extended type

Widening the extended type, such as from `on int` to `on num`, allows the
extension to be used on more types while preserving all existing call sites.

```dart tag=good
// Before (v1.0.0):
extension NumberUtils on int {
  num doubleValue() => this * 2;
}

// After (v1.1.0 - MINOR):
extension NumberUtils on num { // Widened from `on int` to `on num`: all existing `int` call sites continue to work.
  num doubleValue() => this * 2;
}
```

:::note Extension ambiguity and name collisions
Widening an extension's target type (or adding a new extension) can
occasionally introduce static ambiguity if a downstream consumer already has
another extension with the same member name in scope, because Dart's extension
resolution rules may now rank them with equal specificity.

By convention, potential naming collisions and resolution ambiguities in
downstream scopes are treated as non-breaking (`MINOR`), because consumers can
disambiguate them using explicit extension invocation syntax (such as
`NumberUtils(x).doubleValue()`) or `hide` directives.
:::

---

### Extension types: `extension type`

#### Change or rename the representation field

An extension type's primary constructor declaration `extension type Id(int
value)` defines both a representation getter (`int get value`, if the field is
public) and a primary constructor (`Id(int value)`, if the constructor is
public):

* **MAJOR** if both the representation field and primary constructor are public
  and you change the representation type in either direction (because widening
  breaks callers of the getter `id.value`, while narrowing breaks callers of the
  constructor `Id(...)`, just like a mutable variable).
* **MAJOR** if you rename a public representation field (such as changing
  `Id(int value)` to `Id(int id)`), because it removes the public getter
  `id.value`.
* **MINOR** if the representation field is private (such as `extension type
  Id(int _value)`) and you widen the representation type (such as `int` to
  `num`), provided it still satisfies any `implements` clauses, because it only
  widens the constructor parameter type.

```dart tag=bad
// Before (v1.0.0):
extension type Id(int value) {}

// After (v2.0.0 - MAJOR):
extension type Id(String value) {} // Breaks callers passing `int` to `Id(...)` or expecting `int` from `id.value`.
```

#### MINOR: Add a member to an extension type

Extension type members are resolved statically, and other extension types that
implement an extension type (`implements Id`) are allowed to redeclare members
without virtual override conflicts, making new member additions non-breaking.

*Note:* If the extension type implements superinterfaces (`implements ...`),
adding a member that redeclares (shadows) an already-exposed superinterface
member is only `MINOR` if the new member's signature is backward-compatible with
the superinterface member it replaces; otherwise, it breaks existing calls and
is `MAJOR`.

```dart tag=good
// Before (v1.0.0):
extension type Id(int value) {}

// After (v1.1.0 - MINOR):
extension type Id(int value) {
  bool get isValid => value > 0; // Added: safe for existing callers and implementing extension types.
}
```

#### MAJOR: Remove or rename a member of an extension type

Breaks call sites referencing the member.

```dart tag=bad
// Before (v1.0.0):
extension type Id(int value) {
  bool get isValid => value > 0;
}

// After (v2.0.0 - MAJOR):
extension type Id(int value) {
  // `isValid` removed: callers using `id.isValid` fail to compile.
}
```

---

## Errors and exceptions

In Dart, all errors and exceptions are unchecked at compile time, meaning
functions do not declare a `throws` clause in their signature. Determining the
SemVer impact of changing thrown errors or exceptions depends on the distinction
between [programmatic errors][effective_dart_errors] and [runtime
exceptions][effective_dart_errors], as well as your documented API contract.

### Documented exceptions

When a library explicitly documents that a function or method throws a specific
exception, such as `/// Throws [AuthException] on invalid credentials.`:

#### MAJOR: Change a documented exception to a non-subtype

Changing the thrown exception to a type that is not a subtype of the originally
documented exception, such as throwing `SecurityException` instead of
`AuthException`, breaks downstream code with `try ... on AuthException catch
(e)` handlers. The new exception will bypass the handler and crash at runtime.

```dart tag=bad
// Before (v1.0.0):
/// Throws [AuthException] on invalid credentials.
void authenticate(String token) {
  throw AuthException('Invalid token');
}

// Downstream package:
// try { authenticate(token); } on AuthException catch (e) { ... }

// After (v2.0.0 - MAJOR):
/// Throws [SecurityException] on invalid credentials.
void authenticate(String token) {
  throw SecurityException('Invalid token'); // Breaks: `on AuthException` no longer catches this error.
}
```

#### MINOR: Throw a subtype of the documented exception

Throwing a more specific subtype, such as throwing `ExpiredTokenException
extends AuthException`, is backward-compatible. Existing callers catching `on
AuthException` continue to catch the new subtype without changes.

```dart tag=good
// Before (v1.0.0):
/// Throws [AuthException] on invalid credentials.
void authenticate(String token) {
  throw AuthException('Invalid token');
}

// After (v1.1.0 - MINOR):
/// Throws [ExpiredTokenException] on invalid credentials.
void authenticate(String token) {
  throw ExpiredTokenException('Token expired'); // Safe: `ExpiredTokenException extends AuthException`, so `on AuthException` still catches it.
}
```

#### MAJOR: Throw an exception on previously succeeding inputs or states

Throwing a documented or undocumented exception in scenarios where the function
previously succeeded alters control flow and breaks working consumer code.
Switching an asynchronous function between throwing synchronously and returning
a failed `Future` is also `MAJOR`, as synchronous `try`/`catch` blocks without
`await` will fail to catch the error (in general, asynchronous functions should
always emit runtime exceptions through the returned `Future`).

#### MINOR: Stop throwing an exception by succeeding instead

Handling an edge case or providing a fallback so that a function succeeds
instead of throwing is backward-compatible. Existing `try-catch` blocks will
simply not be triggered.

---

### Programmatic errors: `Error` subclasses

Subclasses of `Error`, such as `ArgumentError`, `StateError`, `RangeError`, and
`AssertionError`, indicate a bug in the caller's code, representing contract
violations or invalid arguments. Consumers should not catch `Error` types in
application logic.

#### MAJOR: Throw an `Error` on previously valid inputs or states

Throwing an `Error` for inputs or states that were previously valid and
supported narrows the acceptable input domain, breaking existing callers.

#### PATCH: Add or refine `Error` checks for invalid arguments

Throwing a clear `ArgumentError` or `StateError` on invalid inputs that
previously caused undefined behavior, corrupted state, or internal unhandled
errors (such as `TypeError` or `NoSuchMethodError`), or changing which `Error`
subclass is thrown for an invalid call, is a `PATCH` bug fix or hardening
improvement.

#### MINOR: Support previously invalid arguments without throwing an `Error`

Expanding the acceptable input domain, such as accepting negative numbers or
null values where an `ArgumentError` was previously thrown, is a
backward-compatible feature addition.

---

## Dependencies and SDK constraints

### MINOR: Increase the Dart SDK constraint lower bound

Increasing the SDK constraint, such as from `sdk: ^3.5.0` to `sdk: ^3.6.0`, is
standard for minor releases to adopt new language features, provided consumers
on supported SDKs can resolve it.

*Note:* Bumping the minimum SDK constraint across a major Dart language version
(such as from `<3.0.0` to `>=3.0.0`) changes your package's default language
version, which can alter API semantics (for example, in Dart 3.0+, classes can
no longer be used as mixins unless marked `mixin class`, which is a `MAJOR`
break if downstream code mixed them in).

### MINOR: Export a new dependency

Re-exporting another package's library using `export 'package:foo/foo.dart';`
exposes new public API surface. Note that re-exporting a dependency (or using
its types in your public signatures) couples your package's public API to that
dependency: upgrading to a new major version of that dependency requires a
`MAJOR` version bump for your package as well.

### MAJOR: Remove an exported dependency

Consumers relying on your package re-exporting those symbols will fail to
compile.

### PATCH: Raise minimum dependency constraints or update internal dependencies

Raising the lower bound of a dependency constraint in `pubspec.yaml` (within the
existing major range) or updating dependencies used only internally does not
require a major or minor bump as long as your package's own public API surface
is unchanged.

---

## Pre-1.0.0 versions {:#pre-1-0-0-versions}

While standard SemVer allows any change before version `1.0.0`, pub and
[`pub_semver`][pub_semver] enforce a stricter convention so that consumers can
safely depend on pre-1.0.0 packages using [caret
syntax](/tools/pub/dependencies#caret-syntax):

* **`0.y.z` versions where `y > 0`, such as `0.2.0`:**
  * Bumping `y` from `0.2.0` to `0.3.0` is treated as a **breaking change**,
    which is equivalent to a major bump.
  * Bumping `z` from `0.2.0` to `0.2.1` is treated as a **backward-compatible
    change**, combining both minor and patch changes (pre-1.0.0 versions do not
    distinguish `MINOR` from `PATCH`, though [`+` build suffixes](/tools/pub/versioning)
    are occasionally used for tiny fixes prior to `1.0.0`).
  * Caret syntax `^0.2.0` allows `>=0.2.0 <0.3.0`.
* **`0.0.z` versions, such as `0.0.1`:**
  * Bumping `z` from `0.0.1` to `0.0.2` is treated as a **breaking change**.
  * Caret syntax `^0.0.1` allows only `>=0.0.1 <0.0.2`.

[effective_dart_errors]: /effective-dart/usage#error-handling
[pub_semver]: {{site.pub-pkg}}/pub_semver
[semver]: https://semver.org/spec/v2.0.0-rc.1.html
