---
title: Fixing type promotion failures
description: Solutions for cases where you know more about a field's type than Dart can determine.
---

[Type promotion][] occurs when flow anlaysis can soundly confirm the value of 
a [nullable type][] is *not null*, and that its value will not change from that point on.
Many circumstances can affect that certainty, causing type promotion to fail.

**Only local variables and parameters, and private, final fields can be promoted**.

This page lists reasons why type promotion failures occur,
with tips on how to fix them.
To learn more, check out the [Understanding null safety][] page.


## Only local variables can be promoted in this version {#property}

**The cause:** 
You're trying to promote a field,
but only local variables can be promoted in Dart 3.1 and earlier. 
In 3.2 and later, local variables *and* private, final fields can be promoted.

Even if you have upgraded past 3.1, your code might still be targeted for a
language version of 3.1 or earlier. This can happen either because:

* Your `pubspec.yaml` declares an SDK constraint with a lower bound below 3.2, or 
* You have a `//@dart=<version>` comment at the top of the file, where version is less than 3.2.

**Example:**

{:.bad}
```dart
// @dart=3.1

class C {
  final int? _i; // CONTEXT
  C(this._i);

  void f() {
    if (_i == null) return;
    print(_i.isEven); // ERROR
  }
}
```

The Dart compiler produces a message at `ERROR` that points to `CONTEXT` and
explains that `_i` can't be promoted to a non-nullable type because
it is a field:

SDK 3.2, language version 3.1:
```nocode
'_i' refers to a field. It couldn’t be promoted
because field promotion is only available in Dart 3.2 and above.
```


SDK and language version 3.1:
```nocode
'_i' refers to a property so it couldn't be promoted.
```

*// both error descriptions and messages might be overkill*

**Solution:**

If you are using Dart 3.1 or earlier, upgrade to 3.2.

If you still get the error after upgrading to 3.2, ensure your code isn't targeted
for a previous version of Dart.

Field promotion is language versioned, meaning even if you are using the Dart 3.2
SDK, your code might still be explicitly targeted for an earlier language version.

This could happen either because the user’s `pubspec.yaml`` file declares an SDK
constraint with a lower bound below 3.2, or because the user has a `// @dart=version`
comment at the top of the file, where version is a number less than 3.2.



The usual fix is either to use `i!`
or to create a local variable
of type `int` that holds the value of `i`.

Here's an example of using `i!`:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (property_bang)" replace="/!/[!!!]/g"?>
```dart
print(i[!!!].isEven);
```

And here's an example of creating a local variable
(which can be named `i`)
that holds the value of `i`:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (property_copy)" replace="/final.*/[!$&!]/g"?>
```dart
class C {
  int? i;
  void f() {
    final i = this.i;
    if (i == null) return;
    print(i.isEven);
  }
}
```

This example features an instance field,
but it could instead use an instance getter, a static field or getter,
a top-level variable or getter, or `this`.
(Although promoting `this` would be sound,
implementing it would be difficult and not very useful.)

{{site.alert.tip}}
  When creating a local variable to hold a field's value,
  **make the variable `final`**.
  That way, you can't accidentally update the local variable
  when you intend to update the field.
{{site.alert.end}}


## Other causes and workarounds

This section covers other common causes
of type promotion failure.
Some are related to field promotion failure, and some apply to both fields and variables.

The workarounds for many of these are
one or more of the following:

* Create a local variable that has the type you need.
* Add an explicit null check.
* Use `!` or `as` if you're sure an expression can't be null.

For almost all field promotion failures, the error message you'll see will be something like:

```nocode
Error: A value of type 'int?' can't be assigned to a variable
of type 'int' because 'int?' is nullable and 'int' isn't.
```

The context message that each error references is the information you're looking for to solve your promotion failure.
Each failure type links to a section on this page

It’s possible that a single instance of a failed field promotion might be caused by conflicts with multiple getters, non-final fields, or noSuchMethod forwarders. If that happens, there will be multiple context messages associated with the error, one for each conflicting declaration. Rationale: if the user decides to try to fix the conflicts (e.g. by renaming things, as described above), we want them to know ahead of time how much fixing they need to do.


{{site.alert.note}}
  You can work around all of these non-promotion examples by adding
  a _redundant check_—code that confirms a
  condition that's already been checked.
  If the promotion that's failing is a null check, use `!`;
  if it's a type check, you can use `as`.

  Redundant checks are an easy but error-prone solution
  to type promotion failures.
  Because they overrule the compiler,
  they can lead to mistakes in a way that other solutions don't.

  It's up to you whether to do the extra work to get types to promote 
  (giving you confidence that the code is correct)
  or to do a redundant check
  (which might introduce a bug if your reasoning is wrong).
{{site.alert.end}}


### Trying to promote `this` {#this}

**The cause:**
You're trying to promote `this`,
but type promotion for `this` is not yet supported.

One common `this` promotion scenario is when writing [extension methods][].
If the [`on` type][] of the extension method is a nullable type,
you want to do a null test to see whether `this` is null:

**Example:**

{:.bad}
```dart
extension E on int? {
  int? get i {
    return this != null;
  }
}
```

**Message:**

```nocode
`this` can't be promoted. 
```

**Solution:**

Create a local variable.

{:.good}
```dart
extension E on int? {
  int? get i {
    final self = this;
    return self != null;
  }
}
```

### Trying to promote a getter, not a field {#not-field}

**The cause:** You're trying to promote a getter, but only instance *fields* can be
promoted. 

The compiler has no way to guarantee that a getter returns the same result every time.
Because their stability can't be confirmed, getters are not safe to promote.

**Example:**

```dart
abstract class Base {
  int? get _i; // CONTEXT
}

class Derived extends Base {
  @override
  final int? _i;
  Derived(this._i);
}

f(Base b) {
  if (b._i != null) {
    int i = b._i; // ERROR
  }
}

main() {}
```

**Message:**

```nocode
'getterName' refers to a getter so it couldn’t be promoted.
```

**Solution:**

*If the getter in question is not an abstract field, then the solution is...?*

#### Note about abstract fields

If the getter in question is [abstract][], you might be able to enable field
promotion and avoid the error by replacing the abstract getter with an [abstract field][].

For example, this code produces an error because the getter `_i` can't be promoted
and assigned to a non-nullable type:

```dart
abstract class Base {
  int? get _i; // CONTEXT
}

class Derived extends Base {
  @override
  final int? _i;
  Derived(this._i);
}

f(Base b) {
  if (b._i != null) {
    int i = b._i; // ERROR
  }
}
```

Changing the getter to an abstract field enables type promotion, removing the error:

```dart
abstract class Base {
  abstract final int? _i;
}

class Derived extends Base {
  @override
  final int? _i;
  Derived(this._i);
}

f(Base b) {
  if (b._i != null) {
    int i = b._i; // OK
  }
}
```

{{site.alert.note}}
Abstract fields are syntactically identical to abstract getters.
The only behavior difference is in field promotion. 
{{site.alert.end}}



### Field is not private {#private}

**The cause:**
You're trying to promote a field, but the field is not private.

It’s possible for other libraries in your program to override public fields with a getter.
Because [getters might not return a stable value](#trying-to-promote-a-getter-not-a-field),
non-private fields cannot be promoted.

**Example:**

{:.bad}
```dart
class C {
  final int? n; // CONTEXT
  C(this.n);
}

test(C c) {
  if (c.n != null) {
    // Error: Operator '+' cannot be called on 'int?' because it is
    // potentially null.
    print(c.n + 1); // ERROR
  }
}
```

And then elsewhere in your program: (*maybe don't include*)

{:.bad}
```dart
class WeirdC implements C {
  bool _first = true;

  int? get n {
    if (_first) {
      _first = false;
      return 123; // Not null.
    }

    return null;
  }
}
```

**Message:**

```nocode
'n' refers to a public field so it couldn’t be promoted.
```

**Solution:**

Make the field private. 

{:.good}
```dart
class C {
  final int? _n;
  C(this.n);
}

test(C c) {
  if (c.n != null) {
    print(c.n + 1); // OK
  }
}
```

### Field is external {#external}

**The cause:**
You're trying to promote a field, but the field is marked `external`.

External fields don't promote because they are the same as external getters:
Their implementation is just code from outside Dart,
so there’s no guarantee that it will return the same value each time it’s called.

**Example:**

{:.bad}
```dart
class Example {
  external final int? _externalField; // CONTEXT
  Example(this._externalField);

  f() {
    if (_externalField != null) {
      int i = _externalField; // ERROR
    }
  }
}
```

**Message:**

```nocode
'externalField' refers to an external field so it couldn’t be promoted.
```

**Solution:**

Assign the external field's value to a local variable.

{:.good}
```dart
```

### Field is not final {#final}

**The cause:**
You're trying to promote a field, but the field is not final.

Non-final fields could, in principle, be modified any time between the time
they’re tested and the time they’re used.

**Example:**

{:.bad}
```dart
class Example {
  int? _mutablePrivateField; // CONTEXT
  Example(this._mutablePrivateField);

  f() {
    if (_mutablePrivateField != null) {
      int i = _mutablePrivateField; // ERROR
    }
  }
}
```

**Message:**

```nocode
'mutablePrivateField' refers to a non-final field so it couldn’t be promoted.
```

**Solution:**

Make the field `final`

{:.good}
```dart
class Example {
  int? final _mutablePrivateField; 
  Example(this._mutablePrivateField);

  f() {
    if (_mutablePrivateField != null) {
      int i = _mutablePrivateField; // OK
    }
  }
}
```

### Conflict with getter elsewhere in library {#getter-name}

**The cause:**
You're trying to promote a field, but another class in the same library contains
a concrete getter with the same name.

**Example:**

{:.bad}
```dart
import 'dart:math';

class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? get _overridden => Random().nextBool() ? 1 : null; // CONTEXT
}

f(Example x) {
  if (x._overridden != null) {
    int i = x._overridden; // ERROR
  }
}
```

**Message:**

```nocode
'overriden' couldn’t be promoted because there is a conflicting getter in class 'Override'
```

**Solution:**

If the field and the conflicting getter are truly unrelated, the user can work around the problem by giving them different names.

{:.good}
```dart
class Example {
  final int? _i;
  Example(this._i);
}

class Unrelated {
  int? get _j => Random().nextBool() ? 1 : null;
}

f(Example x) {
  if (x._i != null) {
    int i = x._i; // OK
  }
}
```

#### Note about unrelated classes:

Note that in the above example it’s clear why it would be unsafe to promote the field _overridden, because there’s an override relationship between the field and the getter. However, a conflicting getter will prevent field promotion even if the classes are unrelated. For example:

{:.bad}
```dart
import 'dart:math';

class Example {
  final int? _i;
  Example(this._i);
}

class Unrelated {
  int? get _i => Random().nextBool() ? 1 : null; // CONTEXT
}

f(Example x) {
  if (x._i != null) {
    // Error: A value of type 'int?' can't be assigned to a variable
    // of type 'int' because 'int?' is nullable and 'int' isn't.
    int i = x._i; // ERROR
  }
}
```

{:.bad}
```dart
class Surprise extends Unrelated implements Example {}

main() {
  f(Surprise());
}
```

### Conflict with non-promotable field elsewhere in library {#field-name}

**The cause:**
You're trying to promote a field, but another class in the same library contains
a field with the same name that isn't promotable (for any reason).

**Example:**

{:.bad}
```dart
class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? _overridden; // CONTEXT
}

f(Example x) {
  if (x._overridden != null) {
    int i = x._overridden; // ERROR
  }
}
```

**Message:**

```nocode
'overridden' couldn’t be promoted because there is a conflicting non-promotable field in class 'Override'.
```

**Solution:**

If the conflicting fields are truly unrelated, the user could resolve the conflict by renaming one of them.

{:.good}
```dart

```

### Conflict with implicit `noSuchMethod` forwarder {#nosuchmethod}

**The cause:**
You are trying to promote a field that is private and final, but another class
in the same library contains an implicit `noSuchMethod` forwarder with the same
name as the field.

This is unsound because there’s no guarantee that `noSuchMethod` will return a
stable value from one invocation to the next.


As with getter conflicts and non-final field conflicts, the conflict could be either with a related or an unrelated class.

**Example:**

If the interface for a concrete class promises support for a getter, but the class doesn’t provide an implementation for the getter, then that’s usually a compile-time error. However, it’s allowed if the class contains or inherits a definition of noSuchMethod. This commonly happens with mocks, e.g.:

{:.bad}
```dart
import 'package:mockito/mockito.dart';

class Example {
  final int? _i;
  Example(this._i);
}

class MockExample extends Mock implements Example {} // CONTEXT

f(Example x) {
  if (x._i != null) {
    int i = x._i; // ERROR
  }
}
```

In the above example, since the declaration of the class MockExample contains the clause implements Example, it promises support for a getter called _i. But it doesn’t contain a declaration of _i. This works because the class Mock contains a definition of noSuchMethod, which is a special method that handles any invocations that don’t resolve to a declaration in the class. Most of the magic of mockito is implemented in Mock.noSuchMethod. The way this works behind the scenes is that the compiler generates an implicit implementation of _i inside MockExample that calls Mock.noSuchMethod. This   implicit implementation of _i is called a noSuchMethod forwarder.

**Message:**

```nocode
'i' couldn’t be promoted because there is a conflicting noSuchMethod forwarder in class 'MockExample'.
```

**Solution:**

{:.good}
```dart

```

{{site.alert.note}}
Note that although the example above uses mocks, we don’t expect problems like this to arise very often in practice with mocks, because usually mocks are declared in a different library than the class they are mocking. When the classes in question are declared in different libraries, private names aren’t forwarded to noSuchMethod (because that would violate privacy expectations), so it’s still safe to promote the field.
{{site.alert.end}}



### Possibly written after promotion {#write}

**The cause:**
Trying to promote a variable that might have been
written to since it was promoted.

Example:

{:.bad}
```dart
void f(bool b, int? i, int? j) {
  if (i == null) return;
  if (b) {
    i = j;           // (1)
  }
  if (!b) {
    print(i.isEven); // (2) ERROR
  }
}
```

In this example, when flow analysis hits (1),
it demotes `i` from non-nullable `int` back to nullable `int?`.
A human can tell that the access at (2) is safe
because there's no code path that includes both (1) and (2), but
flow analysis isn't smart enough to see that,
because it doesn't track correlations between
conditions in separate `if` statements.

You might fix the problem by combining the two `if` statements:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (write_combine_ifs)" replace="/else/[!$&!]/g"?>
```dart
void f(bool b, int? i, int? j) {
  if (i == null) return;
  if (b) {
    i = j;
  } [!else!] {
    print(i.isEven);
  }
}
```

In straight-line control flow cases like these (no loops),
flow analysis takes into account the right hand side of the assignment
when deciding whether to demote.
As a result, another way to fix this code is
to change the type of `j` to `int`.

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (write_change_type)" replace="/int j/[!$&!]/g"?>
```dart
void f(bool b, int? i, [!int j!]) {
  if (i == null) return;
  if (b) {
    i = j;
  }
  if (!b) {
    print(i.isEven);
  }
}
```

### Possibly written in a previous loop iteration {#loop-or-switch}

**The cause:**
You're trying to promote something that
might have been written to in a previous iteration of a loop,
and so the promotion was invalidated.

Example:

{:.bad}
```dart
void f(Link? p) {
  if (p != null) return;
  while (true) {    // (1)
    print(p.value); // (2) ERROR
    var next = p.next;
    if (next == null) break;
    p = next;       // (3)
  }
}
```

When flow analysis reaches (1),
it looks ahead and sees the write to `p` at (3).
But because it's looking ahead,
it hasn't yet figured out the type of the right-hand side of the assignment,
so it doesn't know whether it's safe to retain the promotion.
To be safe, it invalidates the promotion.

You might fix this problem by moving the null check to the top of the loop:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (loop)" replace="/p != null/[!$&!]/g"?>
```dart
void f(Link? p) {
  while ([!p != null!]) {
    print(p.value);
    p = p.next;
  }
}
```

This situation can also arise in `switch` statements if
a `case` block has a label,
because you can use labeled `switch` statements to construct loops:

{:.bad}
```dart
void f(int i, int? j, int? k) {
  if (j == null) return;
  switch (i) {
    label:
    case 0:
      print(j.isEven); // ERROR
      j = k;
      continue label;
  }
}
```

Again, you can fix the problem by moving the null check to the top of the loop:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (switch-loop)" replace="/if .*/[!$&!]/g"?>
```dart
void f(int i, int? j, int? k) {
  switch (i) {
    label:
    case 0:
      [!if (j == null) return;!]
      print(j.isEven);
      j = k;
      continue label;
  }
}
```

### In catch after possible write in try {#catch}

**The cause:**
The variable might have been written to in a `try` block,
and execution is now in a `catch` block.

Example:

{:.bad}
```dart
void f(int? i, int? j) {
  if (i == null) return;
  try {
    i = j;                 // (1)
    // ... Additional code ...
    if (i == null) return; // (2)
    // ... Additional code ...
  } catch (e) {
    print(i.isEven);       // (3) ERROR
  }
}
```

In this case, flow analysis doesn't consider `i.isEven` (3) safe,
because it has no way of knowing when in the `try` block
the exception might have occurred,
so it conservatively assumes that it might have happened between (1) and (2),
when `i` was potentially `null`.

Similar situations can occur between `try` and `finally` blocks, and
between `catch` and `finally` blocks.
Because of a historical artifact of how the implementation was done,
these `try`/`catch`/`finally` situations don't take into account
the right-hand side of the assignment,
similar to what happens in loops.

To fix the problem, make sure that the `catch` block doesn't rely on assumptions
about the state of variables that get changed inside the `try` block.
Remember, the exception might occur at any time during the `try` block,
possibly when `i` is null.

The safest solution is to add a null check inside the `catch` block:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (catch-null-check)" replace="/if.*/[!$&!]/g;/(} else {|  \/\/ H.*)/[!$&!]/g;/  }/  [!}!]/g"?>
```dart
// ···
} catch (e) {
  [!if (i != null) {!]
    print(i.isEven); // (3) OK due to the null check in the line above.
  [!} else {!]
  [!  // Handle the case where i is null.!]
  [!}!]
}
```

Or, if you're sure that an exception can't occur while `i` is null,
just use the `!` operator:

<?code-excerpt "non_promotion/lib/non_promotion.dart (catch-bang)" replace="/i!/i[!!!]/g"?>
```dart
// ···
} catch (e) {
  print(i[!!!].isEven); // (3) OK because of the `!`.
}
```


### Subtype mismatch

**The cause:**
The type you're trying to promote to isn't a subtype of
the variable's current promoted type
(or wasn't a subtype at the time of the promotion attempt).

Example:

{:.bad}
```dart
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is Pattern /* (2) */) {
      print(o.matchAsPrefix('foo')); // (3) ERROR
    }
  }
}
```

In this example, `o` is promoted to `Comparable` at (1), but
it isn't promoted to `Pattern` at (2),
because `Pattern` isn't a subtype of `Comparable`.
(The rationale is that if it did promote,
then you wouldn't be able to use methods on `Comparable`.)
Note that just because `Pattern` isn't a subtype of `Comparable`
doesn't mean the code at (3) is dead;
`o` might have a type—like `String`—that 
implements both `Comparable` and `Pattern`.

One possible solution is to create a new local variable so that
the original variable is promoted to `Comparable`, and
the new variable is promoted to `Pattern`:

<!-- code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var)" replace="/var o2.*/[!$&!]/g;/o2\./[!o2!]./g"?>-->

<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-variable)" replace="/Object o2.*/[!$&!]/g;/(o2)(\.| is)/[!$1!]$2/g"?>
```dart
void f(Object o) {
  if (o is Comparable /* (1) */) {
    [!Object o2 = o;!]
    if ([!o2!] is Pattern /* (2) */) {
      print(
          [!o2!].matchAsPrefix('foo')); // (3) OK; o2 was promoted to `Pattern`.
    }
  }
}
```

However, someone who edits the code later might be tempted to change
`Object o2` to `var o2`.
That change gives `o2` a type of `Comparable`,
which brings back the problem of the object not being promotable to `Pattern`.

A redundant type check might be a better solution:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-redundant)" replace="/\(o as Pattern\)/[!$&!]/g"?>
```dart
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is Pattern /* (2) */) {
      print([!(o as Pattern)!].matchAsPrefix('foo')); // (3) OK
    }
  }
}
```

Another solution that sometimes works is when you can use a more precise type.
If line 3 cares only about strings,
then you can use `String` in your type check.
Because `String` is a subtype of `Comparable`, the promotion works:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-String)" replace="/is String/is [!String!]/g"?>
```dart
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is [!String!] /* (2) */) {
      print(o.matchAsPrefix('foo')); // (3) OK
    }
  }
}
```


### Write captured by a local function {#captured-local}

**The cause:**
The variable has been write captured by
a local function or function expression.

Example:

{:.bad}
```dart
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ... 
  if (i == null) return; // (1)
  // ... Additional code ...
  print(i.isEven);       // (2) ERROR
}
```

Flow analysis reasons that as soon as the definition of `foo` is reached,
it might get called at any time,
therefore it's no longer safe to promote `i` at all.
As with loops, this demotion happens regardless of
the type of the right hand side of the assignment.

Sometimes it's possible to restructure the logic so that
the promotion is before the write capture:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-reorder)" replace="/(  )((var foo|  i = j|\}\;|\/\/ ... Use foo).*)/$1[!$2!]/g"?>
```dart
void f(int? i, int? j) {
  if (i == null) return; // (1)
  // ... Additional code ...
  print(i.isEven); // (2) OK
  [!var foo = () {!]
  [!  i = j;!]
  [!};!]
  [!// ... Use foo ...!]
}
```

Another option is to create a local variable, so it isn't write captured:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-copy)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!$1!]$2/g"?>
```dart
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ...
  [!var i2 = i;!]
  if ([!i2!] == null) return; // (1)
  // ... Additional code ...
  print([!i2!].isEven); // (2) OK because `i2` isn't write captured.
}
```

Or you can do a redundant check:

<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-bang)" replace="/i!/i[!!!]/g"?>
```dart
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ...
  if (i == null) return; // (1)
  // ... Additional code ...
  print(i[!!!].isEven); // (2) OK due to `!` check.
}
```


### Written outside of the current closure or function expression {#write-outer}

**The cause:**
The variable is written to outside of a closure or function expression,
and the type promotion location is
inside the closure or function expression.

Example:

{:.bad}
```dart
void f(int? i, int? j) {
  if (i == null) return;
  var foo = () {
    print(i.isEven); // (1) ERROR
  };
  i = j;             // (2)
}
```

Flow analysis reasons that there's no way to determine
when `foo` might get called,
so it might get called after the assignment at (2),
and thus the promotion might no longer be valid.
As with loops, this demotion happens regardless of the type of
the right hand side of the assignment.

A solution is to create a local variable:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var)" replace="/var i2.*/[!$&!]/g;/i2\./[!i2!]./g"?>
```dart
void f(int? i, int? j) {
  if (i == null) return;
  [!var i2 = i;!]
  var foo = () {
    print([!i2!].isEven); // (1) OK because `i2` isn't changed later.
  };
  i = j; // (2)
}
```

A particularly nasty case looks like this:

{:.bad}
```dart
void f(int? i) {
  i ??= 0;
  var foo = () {
    print(i.isEven); // ERROR
  };
}
```

In this case, a human can see that the promotion is safe because
the only write to `i` uses a non-null value and
happens before `foo` is ever created.
But [flow analysis isn't that smart][1536].

[1536]: https://github.com/dart-lang/language/issues/1536

Again, a solution is to create a local variable:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var2)" replace="/var j.*/[!$&!]/g;/j\./[!j!]./g"?>
```dart
void f(int? i) {
  [!var j = i ?? 0;!]
  var foo = () {
    print([!j!].isEven); // OK
  };
}
```

This solution works because `j` is inferred to have a non-nullable type (`int`)
due to its initial value (`i ?? 0`).
Because `j` has a non-nullable type,
whether or not it's assigned later,
`j` can never have a non-null value.


### Write captured outside of the current closure or function expression {#captured-outer}

**The cause:**
The variable you're trying to promote is write captured
outside of a closure or function expression,
but this use of the variable is inside of the closure or function expression
that's trying to promote it.

Example:

{:.bad}
```dart
void f(int? i, int? j) {
  var foo = () {
    if (i == null) return;
    print(i.isEven); // ERROR
  };
  var bar = () {
    i = j;
  };
}
```

Flow analysis reasons that there's no way of telling
what order `foo` and `bar` might be executed in;
in fact, `bar` might even get executed halfway through executing `foo`
(due to `foo` calling something that calls `bar`).
So it isn't safe to promote `i` at all inside `foo`.

The best solution is probably to create a local variable:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-write-capture)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!i2!]$2/g"?>
```dart
void f(int? i, int? j) {
  var foo = () {
    [!var i2 = i;!]
    if ([!i2!] == null) return;
    print([!i2!].isEven); // OK because i2 is local to this closure.
  };
  var bar = () {
    i = j;
  };
}
```

[Type promotion]: /null-safety/understanding-null-safety#type-promotion-on-null-checks
[nullable type]: /null-safety/understanding-null-safety#non-nullable-and-nullable-types
[Understanding null safety]: /null-safety/understanding-null-safety
[extension methods]: /language/extension-methods
[`on` type]: /language/extension-methods#implementing-extension-methods
[abstract]: /language/methods#abstract-methods
[abstract field]: /null-safety/understanding-null-safety#abstract-fields