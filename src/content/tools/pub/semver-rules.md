---
title: SemVer compatibility and breaking changes
breadcrumb: SemVer rules
description: >-
  A comprehensive guide to what changes are breaking major changes, non-breaking
  minor features, or patch bug fixes in Dart packages.
---

When developing and publishing Dart packages, adhering to [Semantic
Versioning][semver] helps creating a healthy and predictable package ecosystem.

Any Dart package provides a set of features - but with that comes also a
contract that the user can rely on this set of features to continue working.
Packages sometimes get changed, and there are two categories of changes: Adding
or removing functionality. Some changes do one or the other, some do both. While
removing functionality may sometimes be necessary, doing so violates the
contract with the user. To accomodate for this, Dart uses semantic versioning to
help a user in recognizing whether a new version of a package adheres to the old
or is presenting a new contract.

This guide provides a detailed reference on which changes to your Dart code
affect the public API surface of your package and what version bump is required.

:::tip
For a conceptual overview of pub's version solving algorithm and lockfiles, see
the [Package versioning](/tools/pub/versioning) guide.
:::

## Semantic versioning and `package:pub_semver`

Dart's package manager, pub, follows [Semantic Versioning 2.0.0][semver] as
implemented by [`package:pub_semver`][pub_semver].

A standard version number is formatted as `MAJOR.MINOR.PATCH`, such as `1.2.3`:

* **`MAJOR`**: Incompatible breaking changes to the public API.
* **`MINOR`**: Backward-compatible new functionality or features.
* **`PATCH`**: Backward-compatible bug fixes.

### Pre-1.0.0 versions

While standard SemVer 2.0.0 allows any change before version `1.0.0`, pub and
[`pub_semver`][pub_semver] enforce a stricter convention so that consumers can
safely depend on pre-1.0.0 packages using [caret
syntax](/tools/pub/dependencies#caret-syntax):

* **`0.y.z` versions where $y > 0$, such as `0.2.0`:**
  * Bumping `y` from `0.2.0` to `0.3.0` is treated as a **breaking change**,
    which is equivalent to a major bump.
  * Bumping `z` from `0.2.0` to `0.2.1` is treated as a **backward-compatible
    change**, which is equivalent to a minor or patch bump.
  * Caret syntax `^0.2.0` allows `>=0.2.0 <0.3.0`.
* **`0.0.z` versions, such as `0.0.1`:**
  * Bumping `z` from `0.0.1` to `0.0.2` is treated as a **breaking change**.
  * Caret syntax `^0.0.1` allows only `>=0.0.1 <0.0.2`.

## The public API boundary

In Dart packages, the **public API** comprises all declarations accessible to
consumers of your package:

* **Public:** Any library directly inside `lib/`, such as `lib/my_package.dart`,
  and any declarations re-exported through `export` directives.
* **Private and internal:** Any file inside `lib/src/` that is **not**
  re-exported by a public library in `lib/`. Changes to unexported files in
  `lib/src/` are considered internal and do not affect the public SemVer
  contract.

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

*Note:* While introducing a new top-level name can theoretically create a naming
conflict with a wildcard import like `import 'package:foo/foo.dart';` in
downstream code, SemVer treats top-level additions as non-breaking.

### MAJOR: Remove a public top-level declaration

Removing any public top-level declaration is a breaking change. Any downstream
code referencing the removed symbol will fail to compile.

```dart tag=bad
// Before (v1.0.0):
void calculateTax() {}

// After (v2.0.0 - MAJOR):
// `calculateTax` was removed. Existing callers fail to compile.
```

### MAJOR: Rename a public top-level declaration

Renaming a public symbol is functionally equivalent to removing the original
name and introducing a new one. Downstream code referencing the original name
will break.

```dart tag=bad
// Before (v1.0.0):
void performTask() {}

// After (v2.0.0 - MAJOR):
void executeTask() {} // Renamed: callers referencing `performTask` fail to compile.
```

### MAJOR: Move a declaration to `lib/src/` without re-exporting

Moving a declaration from the public `lib/` root to `lib/src/`, without an
`export` in a public library file, makes it inaccessible to external packages,
breaking all existing consumers.

```dart tag=bad
// Before (v1.0.0):
// lib/my_package.dart
export 'src/engine.dart';

// After (v2.0.0 - MAJOR):
// lib/my_package.dart
// `src/engine.dart` is no longer exported: callers importing `package:my_package/my_package.dart` fail to access engine symbols.
```

### MAJOR: Widen or change the type of a `const` or `final` variable

Changing a `const` or `final` variable to a broader type, such as changing
`const int maxRetries` to `const num maxRetries`, or to an incompatible type
breaks callers expecting members of the more specific type.

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

For mutable `var` variables that can be both read from and written to, changing
the static type in either direction is a breaking change:
* Narrowing the type, such as `num` to `int`, breaks callers assigning a
  `double` into the variable.
* Widening the type, such as `int` to `num`, breaks callers expecting `int`
  methods when reading the variable.

```dart tag=bad
// Before (v1.0.0):
num threshold = 10.5;

// After (v2.0.0 - MAJOR):
int threshold = 10; // Narrowed: callers assigning a double (e.g. `threshold = 1.5;`) fail to compile.
```

### MAJOR: Change a top-level variable from `var` to `final`

Making a mutable variable `final` breaks any consumer assigning values to that
variable.

```dart tag=bad
// Before (v1.0.0):
String globalConfig = 'default';

// After (v2.0.0 - MAJOR):
final String globalConfig = 'default'; // Callers assigning `globalConfig = 'custom';` fail to compile.
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

#### MAJOR: Change a concrete class to an abstract class

Changing a concrete class to `abstract class` prevents external consumers from
instantiating the class directly using `new MyClass()`, causing compile errors.

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

Prevents external consumers from implementing the class using `implements
MyClass`, breaking all existing external implementers.

```dart tag=bad
// Before (v1.0.0):
class Worker {}

// Downstream package:
class CustomWorker implements Worker {}

// After (v2.0.0 - MAJOR):
base class Worker {} // Breaks: downstream implementers (`implements Worker`) fail to compile.
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
class, breaking all existing external subtypes.

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
MyClass`.

```dart tag=bad
// Before (v1.0.0):
mixin class TaskRunner {}

// Downstream package:
class Worker with TaskRunner {}

// After (v2.0.0 - MAJOR):
class TaskRunner {} // Breaks: downstream mixin uses (`with TaskRunner`) fail to compile.
```

#### MINOR: Remove `base`, `interface`, or `final` from a class

Loosens restrictions on consumers, granting new capabilities without
invalidating existing code.

```dart tag=good
// Before (v1.0.0):
final class Database {}

// After (v1.1.0 - MINOR):
class Database {} // Safe: loosens restrictions and allows consumers to extend or implement.
```

---

### Unmodified classes: `class` and `abstract class`

An unmodified class in Dart allows external packages to construct, extend using
`extends`, and implement using `implements`.

#### MAJOR: Add an instance member to an unmodified class

Adding any instance method, getter, setter, or field to an unmodified `class` or
`abstract class` is a breaking change. Because external libraries are permitted
to write `class MyImpl implements Foo`, any new member in `Foo` breaks existing
implementers due to missing overrides.

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

Static members are namespaced to the class, such as `Class.member`, and do not
affect subclasses or external implementations.

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

#### MAJOR: Add any member to an interface class

External classes can implement an `interface class`. Adding any new method,
getter, setter, or field requires implementers to provide the new member,
breaking compilation.

```dart tag=bad
// Before (v1.0.0):
interface class Repository {
  void fetch();
}

// Downstream package:
class CustomRepository implements Repository {
  @override
  void fetch() {}
}

// After (v2.0.0 - MAJOR):
interface class Repository {
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

External code cannot implement or extend a `sealed` class, so adding instance or
static members is non-breaking.

```dart tag=good
// Before (v1.0.0):
sealed class Result {}

// After (v1.1.0 - MINOR):
sealed class Result {
  bool get isSuccess => this is Success; // Added: safe because consumers cannot implement or extend sealed classes.
}
```

---

### `mixin` and `mixin class`

#### MINOR: Add a concrete member to a mixin

Classes using `with MyMixin` automatically receive the concrete implementation.

*Note:* Adding a member is technically breaking if an external consumer used
`implements MyMixin`, but the standard and intended usage of mixins is with the
`with` keyword.

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
Widget`, prevents existing classes that do not meet the new requirement from
mixing it in.

```dart tag=bad
// Before (v1.0.0):
mixin Lifecycle on Object {}

// Downstream package:
class Service with Lifecycle {}

// After (v2.0.0 - MAJOR):
mixin Lifecycle on State {} // Breaks: Service does not extend State and fails to compile.
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

### MAJOR: Change the aliased type in a type alias

Changing the underlying type that a type alias references, such as changing
`typedef Callback = void Function(int);` to `typedef Callback = void
Function(String);`, alters the expected type everywhere the alias is used,
breaking consumers.

```dart tag=bad
// Before (v1.0.0):
typedef Callback = void Function(int count);

// After (v2.0.0 - MAJOR):
typedef Callback = void Function(String message); // Changed type: downstream callbacks expecting `int` fail to compile.
```

### MAJOR: Replace a `typedef` with a class or vice versa

Replacing a type alias with a class, or a class with a type alias of the same
name, is a breaking change:

* **Function type alias $\rightarrow$ class:** In Dart, closure literals are
  function types, not class instances. Code assigning a closure like `Callback
  cb = (x) => ...;` will fail to compile against `class Callback`.
* **Class type alias $\rightarrow$ subclass:** If `typedef A = B;` is replaced
  with `class A extends B {}`, `B` is no longer assignable to `A`, and
  bidirectional type identity is lost.

```dart tag=bad
// Before (v1.0.0):
typedef Callback = void Function();

// Downstream package:
Callback cb = () => print('done');

// After (v2.0.0 - MAJOR):
abstract class Callback {
  void call();
} // Function literals are not instances of class Callback: downstream `cb = () => ...` fails to compile.
```

---

## Constructors

### MINOR: Add a new public constructor or factory

Adding named constructors, such as `MyClass.named()`, or factories to an
instantiable class provides new construction options without affecting existing
callers.

```dart tag=good
// Before (v1.0.0):
class Request {
  Request(String url);
}

// After (v1.1.0 - MINOR):
class Request {
  Request(String url);
  Request.json(String url); // Added: provides a new constructor without breaking existing callers.
}
```

### MAJOR: Remove or rename a constructor

Breaks call sites that invoked the removed constructor.

```dart tag=bad
// Before (v1.0.0):
class Request {
  Request.named(String url);
}

// After (v2.0.0 - MAJOR):
class Request {
  // `Request.named` was removed: callers using `Request.named(...)` fail to compile.
}
```

### MAJOR: Add a required parameter to a constructor

Existing constructor invocations that omit the new parameter will fail to
compile.

```dart tag=bad
// Before (v1.0.0):
class User {
  final String name;
  User(this.name);
}

// After (v2.0.0 - MAJOR):
class User {
  final String name;
  final String email;
  User(this.name, {required this.email}); // Existing `User('Alice')` calls fail to compile.
}
```

### MINOR: Add an optional parameter to a constructor

Call sites can omit optional parameters, both positional and named.

```dart tag=good
// Before (v1.0.0):
class User {
  final String name;
  User(this.name);
}

// After (v1.1.0 - MINOR):
class User {
  final String name;
  final String? email;
  User(this.name, {this.email}); // Safe: existing `User('Alice')` calls continue to compile.
}
```

### MAJOR: Change a `const` constructor to non-`const`

Breaks any call site using `const MyClass(...)`.

```dart tag=bad
// Before (v1.0.0):
class Point {
  final int x;
  const Point(this.x);
}

// Downstream package:
const origin = Point(0);

// After (v2.0.0 - MAJOR):
class Point {
  final int x;
  Point(this.x); // Removed `const`: `const Point(0)` fails to compile.
}
```

### MINOR: Change a non-`const` constructor to `const`

Adding `const` capability does not break existing non-const call sites using
`MyClass(...)`.

```dart tag=good
// Before (v1.0.0):
class Point {
  final int x;
  Point(this.x);
}

// After (v1.1.0 - MINOR):
class Point {
  final int x;
  const Point(this.x); // Safe: non-const invocations `Point(0)` remain valid.
}
```

### MAJOR: Add a private constructor to a class with only a default constructor

If a class previously had the default implicit constructor `MyClass()`, adding
`MyClass._()` removes the default public constructor and prevents external
instantiation or subclassing.

```dart tag=bad
// Before (v1.0.0):
class AppUtils {
  // Implicit public default constructor `AppUtils()`
}

// After (v2.0.0 - MAJOR):
class AppUtils {
  AppUtils._(); // Replaces public constructor: callers using `AppUtils()` fail to compile.
}
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

#### MINOR: Add an optional parameter

Existing call sites can omit the new optional parameter without issue.

```dart tag=good
// Before (v1.0.0):
void logMessage(String message) {}

// After (v1.1.0 - MINOR):
void logMessage(String message, [String level = 'INFO']) {} // Safe: existing calls `logMessage('data')` continue to compile.
```

:::note Tear-offs and optional parameters
In Dart, tearing off a method like `final fn = obj.myMethod;` produces a
function whose static type reflects its exact signature. Adding an optional
parameter changes the static type of the tear-off, which can cause a type
mismatch if the consumer assigned it to a specific `typedef`. In practice,
adding optional parameters is standard for `MINOR` releases unless a package's
primary contract relies on exact function signatures.
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

Call sites passing `func(paramName: value)` will fail to compile when
`paramName` is changed.

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

* **MINOR** for top-level functions and `final` class methods, because callers
  can pass a wider variety of inputs, such as widening a parameter from
  `Future<T>` to `FutureOr<T>` or from `int` to `num`.
* **MAJOR** for methods on an implementable class, because it changes the
  signature required for external overrides.

```dart tag=good
// Before (v1.0.0):
void setPadding(int padding) {}

// After (v1.1.0 - MINOR for top-level functions and final class methods):
void setPadding(num padding) {} // Safe: callers can now pass int or double without breaking existing callers.
```

:::note Tear-offs and widened parameter types
Widening a parameter type changes the static type of a tear-off. Because
function parameters are contravariant, tearing off a function with a widened
parameter type (like `void Function(Object)`) can prevent assigning narrower
callbacks into an inferred variable (like `var callback = doStuff; callback =
(String s) {};`). In practice, such situations are rare, and widening parameter
types on top-level functions is treated as non-breaking.
:::

#### MINOR: Change the default value of an optional parameter

Does not break compilation or static type checks, but alters runtime behavior
for callers omitting the argument.

```dart tag=good
// Before (v1.0.0):
void connect([int timeoutSeconds = 10]) {}

// After (v1.1.0 - MINOR):
void connect([int timeoutSeconds = 30]) {} // Compiles without error; changes default runtime behavior.
```

---

### Return types

Return types in Dart are **covariant**: callers expect a return value conforming
to at least the declared type, while subclasses overriding a method must return
a subtype of the superclass method's return type.

#### Narrow a return type

Moving down the type lattice to a more specific subtype, such as `num` to `int`,
`Object?` to `String`, `void` to a specific type, or any type to `Never`:

* **MINOR for callers of top-level functions and `final` class methods:**
  * **Direct invocations:** Callers receive a more specific type with additional
    available members and tighter type safety.
  * **Top types:** Changing a return type from `void` to a specific type `T` is
    a form of narrowing from the top type. Callers ignoring the return value
    continue to work, and callbacks passed to `void Function(...)` continue to
    compile because Dart treats `T Function(...)` as a subtype of `void
    Function(...)` for any type `T`.
  * **Bottom type:** For functions that unconditionally throw or exit, narrowing
    the return type to `Never` is backward-compatible because `Never` is a
    universal subtype of all Dart types.
* **MAJOR if the method is overridden in external subclasses or implementers:**
  * External subclasses that declared the previous wider return type, such as
    `@override num method()` or `@override void method()`, will fail to compile
    with an override error, because the subclass's wider return type is not a
    valid subtype of the new narrower return type.

```dart tag=good
// Before (v1.0.0):
num getScale() => 1;

// After (v1.1.0 - MINOR for top-level functions and final class methods):
int getScale() => 1; // Safe: callers expecting `num` continue to work, while callers can access `int` methods.
```

#### MAJOR: Widen a return type

Moving up the type lattice to a broader supertype, such as `int` to `num`,
`Future<T>` to `FutureOr<T>`, or a specific type `T` to `void`:

* **MAJOR for callers:**
  * Callers expecting specific members on the returned object, like `int`
    methods or `.then()` on a `Future<T>`, will fail to compile.
  * Changing a return type from a specific type `T` to `void` is a form of
    widening to the top type, breaking any callers attempting to read or use the
    returned value.
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

#### MINOR: Loosen or remove a type parameter bound

Changing `<T extends int>` to `<T extends num>` or removing a bound permits more
types while remaining compatible with existing valid usages.

```dart tag=good
// Before (v1.0.0):
class NumericList<T extends int> {}

// After (v1.1.0 - MINOR):
class NumericList<T extends num> {} // Safe: existing `NumericList<int>` remains valid, and `NumericList<double>` is now supported.
```

#### MAJOR: Add a type parameter without a default bound

Call sites or type annotations lacking the type argument may fail to compile or
change type inference behavior.

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

### MINOR: Add a member to an enhanced enum

Enums cannot be extended or implemented, so adding members to an enhanced enum
is safe for consumers.

```dart tag=good
// Before (v1.0.0):
enum Status {
  pending,
  success;
}

// After (v1.1.0 - MINOR):
enum Status {
  pending,
  success;

  bool get isDone => this == Status.success; // Safe: consumers only call existing members and cannot implement enums.
}
```

---

## Extension methods and extension types

### Extension methods: `extension on`

#### MINOR: Add an extension or extension method

Adding extension methods is backward-compatible. Static ambiguity can
occasionally occur if consumer code already has another extension in scope with
the same method name.

```dart tag=good
// Before (v1.0.0):
extension StringUtils on String {
  bool get isBlank => trim().isEmpty;
}

// After (v1.1.0 - MINOR):
extension StringUtils on String {
  bool get isBlank => trim().isEmpty;
  bool get isNotBlank => !isBlank; // Added: backward-compatible new extension member.
}
```

#### MAJOR: Remove or rename an extension method

Call sites invoking the extension member will fail to compile.

```dart tag=bad
// Before (v1.0.0):
extension StringUtils on String {
  bool get isBlank => trim().isEmpty;
}

// After (v2.0.0 - MAJOR):
extension StringUtils on String {
  // `isBlank` was removed: callers invoking `'text'.isBlank` fail to compile.
}
```

#### MAJOR: Change the extended type: the `on` clause

Changing the target type of an extension, such as changing `extension Helpers on
String` to `extension Helpers on int`, removes the extension members from
instances of the original type, breaking all existing call sites.

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

In SemVer, potential naming collisions and resolution ambiguities in downstream
wildcard scopes are treated as non-breaking (`MINOR`), because consumers can
disambiguate them using explicit extension invocation syntax (such as
`NumberUtils(x).doubleValue()`) or `hide` directives.
:::

---

### Extension types: `extension type`

#### MAJOR: Change the underlying representation type

Changes the underlying type contract and implicit constructors.

```dart tag=bad
// Before (v1.0.0):
extension type Id(int value) {}

// After (v2.0.0 - MAJOR):
extension type Id(String value) {} // Breaks callers passing `int` to `Id(...)`.
```

#### MINOR: Add a member to an extension type

Extension types cannot be implemented or extended with subtyping, so adding
members is non-breaking.

```dart tag=good
// Before (v1.0.0):
extension type Id(int value) {}

// After (v1.1.0 - MINOR):
extension type Id(int value) {
  bool get isValid => value > 0; // Added: safe because extension types cannot be subclassed or implemented.
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

#### MAJOR: Change or remove a documented exception type

Changing the thrown exception, such as throwing `SecurityException` instead of
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

Throwing an exception in scenarios where the function previously succeeded
alters control flow and breaks working consumer code.

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

#### MAJOR: Throw an `ArgumentError` or `StateError` on previously valid inputs

Throwing an error for inputs or states that were previously valid and supported
narrows the acceptable input domain, breaking existing callers.

#### PATCH: Add or refine `Error` checks for invalid arguments

Throwing a clear `ArgumentError` or `StateError` on invalid inputs that
previously caused undefined behavior, corrupted state, or internal unhandled
exceptions, such as `TypeError` or `NoSuchMethodError`, is a bug fix or
hardening improvement.

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

### MINOR: Export a new dependency

Re-exporting another package's library using `export 'package:foo/foo.dart';`
exposes new public API surface.

### MAJOR: Remove an exported dependency

Consumers relying on your package re-exporting those symbols will fail to
compile.

### PATCH: Update dependencies within existing constraint ranges

Normal maintenance as long as your package's own public API surface is
unchanged.

[effective_dart_errors]: /effective-dart/usage#error-handling
[pub_semver]: {{site.pub-pkg}}/pub_semver
[semver]: https://semver.org/spec/v2.0.0-rc.1.html
