---
title: Fixing type promotion failures
description: Solutions for cases where you know more about a field's type than Dart can determine.
---

[Type promotion][] occurs when flow analysis can soundly confirm the value of 
a [nullable type][] is *not null*, and that its value will not change from that point on.
Many circumstances can weaken a type's soundness, causing type promotion to fail.

This page lists reasons why type promotion failures occur,
with tips on how to fix them.
To learn more, check out the [Understanding null safety][] page.


## Unsupported language version for field promotion {:#language-version}

**The cause:** 
You're trying to promote a field, but field promotion is language versioned,
and your code is set to a language version before 3.2.

If you're already using an SDK version >= Dart 3.2,
your code might still be explicitly targeted for an earlier [language version][].
This can happen either because:

* Your [`pubspec.yaml`][] declares an SDK constraint with a
  lower bound below 3.2, or 
* You have a `//@dart=version` comment at the top of the file,
  where `version` is lower than 3.2.

**Example:**

```dart tag=bad
// @dart=3.1

class C {
  final int? _i;
  C(this._i);

  void f() {
    if (_i != null) {
      int i = _i;  // ERROR
    }
  }
}
```

**Message:**

```plaintext
'_i' refers to a field. It couldn’t be promoted
because field promotion is only available in Dart 3.2 and above.
```

**Solution:**

Ensure your library isn't using a [language version][] earlier than 3.2.
Check the top of your file for an outdated `//@dart=version` comment,
or your `pubspec.yaml` for an outdated [SDK constraint lower-bound][].

[SDK constraint lower-bound]: /tools/pub/pubspec#sdk-constraints

## Only local variables can be promoted (before Dart 3.2) {:#property}

**The cause:**
You're trying to promote a property,
but only local variables can be promoted in Dart versions earlier than 3.2,
and you are using a version earlier than 3.2.

**Example:**

```dart tag=bad
class C {
  int? i;
  void f() {
    if (i == null) return;
    print(i.isEven);       // ERROR
  }
}
```

**Message:**

```plaintext
'i' refers to a property so it couldn't be promoted.
```

**Solution:**

If you are using Dart 3.1 or earlier, [upgrade to 3.2][upgrade].

If you need to keep using an older version,
read [Other causes and workarounds](#other-causes-and-workarounds)

## Other causes and workarounds

The remaining examples on this page document reasons for promotion failures
unrelated to version inconsistencies,
for both field and local variable failures, with examples and workarounds.

In general, the usual fixes for promotion failures
are one or more of the following:

* Assign the property's value to a local variable of the non-nullable type you need.
* Add an explicit null check (for example, `i == null`).
* Use `!` or `as` as a [redundant check](#redundant-check)
  if you're sure an expression can't be null.

Here's an example of creating a local variable
(which can be named `i`)
that holds the value of `i`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (property-copy)" replace="/final.*/[!$&!]/g"?>
```dart tag=good
class C {
  int? i;
  void f() {
    [!final i = this.i;!]
    if (i == null) return;
    print(i.isEven);
  }
}
```

This example features an instance field,
but it could instead use an instance getter, a static field or getter,
a top-level variable or getter, or [`this`](#this).

:::tip
When creating a local variable to hold a field's value,
**make the variable `final`**.
That way, you can't accidentally update the local variable
when you intend to update the field.
:::

And here's an example of using `i!`:

<?code-excerpt "non_promotion/lib/non_promotion.dart (property-bang)" replace="/!/[!!!]/g"?>
```dart tag=good
print(i[!!!].isEven);
```


<a id="redundant-check"></a>
:::note
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
:::


### Can't promote `this` {:#this}

**The cause:**
You're trying to promote `this`,
but type promotion for `this` is not yet supported.

One common `this` promotion scenario is when writing [extension methods][].
If the [`on` type][] of the extension method is a nullable type,
you'd want to do a null check to see whether `this` is null:

**Example:**

```dart tag=bad
extension E on int? {
  int get valueOrZero {
    return this == null ? 0 : this; // ERROR
  }
}
```

**Message:**

```plaintext
`this` can't be promoted. 
```

**Solution:**

Create a local variable to hold the value of `this`, then perform the null check.

```dart tag=good
extension E on int? {
  int get valueOrZero {
    final self = this;
    return self == null ? 0 : self;
  }
}
```

### Only private fields can be promoted {:#private}

**The cause:**
You're trying to promote a field, but the field is not private.

It’s possible for other libraries in your program
to override public fields with a getter. Because
[getters might not return a stable value](#not-field),
and the compiler can't know what other libraries are doing,
non-private fields cannot be promoted.

**Example:**

```dart tag=bad
class C {
  final int? n;
  C(this.n);
}

test(C c) {
  if (c.n != null) {
    print(c.n + 1); // ERROR
  }
}
```

**Message:**

```plaintext
'n' refers to a public property so it couldn’t be promoted.
```

**Solution:**

Making the field private lets the compiler be sure that no outside libraries
could possibly override its value, so it's safe to promote.

```dart tag=good
class C {
  final int? _n;
  C(this._n);
}

test(C c) {
  if (c._n != null) {
    print(c._n + 1); // OK
  }
}
```

### Only final fields can be promoted {:#final}

**The cause:**
You're trying to promote a field, but the field is not final.

To the compiler, non-final fields could, in principle,
be modified any time between the time
they’re tested and the time they’re used.
So it's not safe for the compiler to promote a non-final nullable type
to a non-nullable type.

**Example:**

```dart tag=bad
class C {
  int? _mutablePrivateField;
  Example(this._mutablePrivateField);

  f() {
    if (_mutablePrivateField != null) {
      int i = _mutablePrivateField; // ERROR
    }
  }
}
```

**Message:**

```plaintext
'mutablePrivateField' refers to a non-final field so it couldn’t be promoted.
```

**Solution:**

Make the field `final`:

```dart tag=good
class Example {
  final int? _immutablePrivateField; 
  Example(this._immutablePrivateField);

  f() {
    if (_immutablePrivateField != null) {
      int i = _immutablePrivateField; // OK
    }
  }
}
```

### Getters can't be promoted {:#not-field}

**The cause:** You're trying to promote a getter,
but only instance *fields* can be promoted, not instance getters. 

The compiler has no way to guarantee that a getter returns the same result every time.
Because their stability can't be confirmed, getters are not safe to promote.

**Example:**

```dart tag=bad
import 'dart:math';

abstract class C {
  int? get _i => Random().nextBool() ? 123 : null;
}

f(C c) {
  if (c._i != null) {
    print(c._i.isEven); // ERROR
  }
}
```

**Message:**

```plaintext
'_i' refers to a getter so it couldn’t be promoted.
```

**Solution:**

Assign the getter to a local variable:

```dart tag=good
import 'dart:math';

abstract class C {
  int? get _i => Random().nextBool() ? 123 : null;
}

f(C c) {
  final i = c._i;
  if (i != null) {
    print(i.isEven); // OK
  }
}
```

:::note
Flow analysis considers `abstract` getters stable enough to allow type promotion,
as long as there are no conflicting declarations.
:::

[known bug]: {{site.repo.dart.lang}}/issues/3328#issuecomment-1792511446

### External fields can't be promoted {:#external}

**The cause:**
You're trying to promote a field, but the field is marked `external`.

External fields don't promote because they are essentially external getters;
their implementation is code from outside of Dart,
so there’s no guarantee for the compiler that an external field 
will return the same value each time it’s called.

**Example:**

```dart tag=bad
class C {
  external final int? _externalField;
  C(this._externalField);

  f() {
    if (_externalField != null) {
      print(_externalField.isEven); // ERROR
    }
  }
}
```

**Message:**

```plaintext
'externalField' refers to an external field so it couldn’t be promoted.
```

**Solution:**

Assign the external field's value to a local variable:

```dart tag=good
class C {
  external final int? _externalField;
  C(this._externalField);

  f() {
    final i = this._externalField;
    if (i != null) {
      print(i.isEven); // OK
    }
  }
}
```

### Conflict with getter elsewhere in library {:#getter-name}

**The cause:**
You're trying to promote a field,
but another class in the same library contains
a concrete getter with the same name.

**Example:**

```dart tag=bad
import 'dart:math';

class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? get _overridden => Random().nextBool() ? 1 : null;
}

f(Example x) {
  if (x._overridden != null) {
    print(x._overridden.isEven); // ERROR
  }
}
```

**Message:**

```plaintext
'overriden' couldn’t be promoted because there is a conflicting getter in class 'Override'
```

**Solution**:

If the getter and field are related and need to share their name 
(like when one of them overrides the other, as in the example above),
then you can enable type promotion by assigning the value to a local variable:

```dart tag=good
import 'dart:math';

class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? get _overridden => Random().nextBool() ? 1 : null;
}

f(Example x) {
  final i = x._overridden;
  if (i != null) {
    print(i.isEven); // OK
  }
}
```

#### Note about unrelated classes

Note that in the above example it’s clear
why it's unsafe to promote the field `_overridden`:
because there’s an override relationship between the field and the getter. 
However, a conflicting getter will prevent field promotion
even if the classes are unrelated. For example:

```dart tag=bad
import 'dart:math';

class Example {
  final int? _i;
  Example(this._i);
}

class Unrelated {
  int? get _i => Random().nextBool() ? 1 : null;
}

f(Example x) {
  if (x._i != null) {
    int i = x._i; // ERROR
  }
}
```

Another library might contain a class that combines the two unrelated
classes together into the same class hierarchy,
which would cause the reference in function `f` to `x._i` to
get dispatched to `Unrelated._i`. For example:

```dart tag=bad
class Surprise extends Unrelated implements Example {}

main() {
  f(Surprise());
}
```

**Solution:**

If the field and the conflicting entity are truly unrelated,
you can work around the problem by giving them different names:

```dart tag=good
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

### Conflict with non-promotable field elsewhere in library {:#field-name}

**The cause:**
You're trying to promote a field, but another class in the same library contains
a field with the same name that isn't promotable
(for any of the other reasons listed on this page).

**Example:**

```dart tag=bad
class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? _overridden;
}

f(Example x) {
  if (x._overridden != null) {
    print(x._overridden.isEven); // ERROR
  }
}
```

This example fails because at runtime, `x` might actually be an
instance of `Override`, so promotion would not be sound.

**Message:**

```plaintext
'overridden' couldn’t be promoted because there is a conflicting non-promotable field in class 'Override'.
```

**Solution:**

If the fields are actually related and need to share a name, then you can
enable type promotion by assigning the value to a final local variable to promote:

```dart tag=good
class Example {
  final int? _overridden;
  Example(this._overridden);
}

class Override implements Example {
  @override
  int? _overridden;
}

f(Example x) {
  final i = x._overridden;
  if (i != null) {
    print(i.isEven); // ERROR
  }
}
```

If the fields are unrelated, then simply rename one of the fields so they don't
conflict.
Read the [Note about unrelated classes](#note-about-unrelated-classes). 


### Conflict with implicit `noSuchMethod` forwarder {:#nosuchmethod}

**The cause:**
You're trying to promote a field that is private and final,
but another class in the same library contains an
[implicit `noSuchMethod` forwarder][nosuchmethod]
with the same name as the field.

This is unsound because there’s no guarantee that `noSuchMethod`
will return a stable value from one invocation to the next.

**Example:**

```dart tag=bad
import 'package:mockito/mockito.dart';

class Example {
  final int? _i;
  Example(this._i);
}

class MockExample extends Mock implements Example {}

f(Example x) {
  if (x._i != null) {
    int i = x._i; // ERROR
  }
}
```

In this example, `_i` can't be promoted because it could resolve to the unsound
implicit `noSuchMethod` forwarder (also named `_i`) that the compiler generates
inside `MockExample`. 

The compiler creates this implicit implementation of `_i` because
`MockExample` promises to support a getter for `_i` when it implements
`Example` in its declaration, but doesn't fulfill that promise. 
So, the undefined getter implementation is handled by [`Mock`'s `noSuchMethod`
definition]({{site.pub-api}}/mockito/latest/mockito/Mock/noSuchMethod.html),
which creates an implicit `noSuchMethod` forwarder of the same name.

The failure can also occur between fields in
[unrelated classes](#note-about-unrelated-classes).

**Message:**

```plaintext
'_i' couldn’t be promoted because there is a conflicting noSuchMethod forwarder in class 'MockExample'.
```

**Solution:**

Define the getter in question so that `noSuchMethod` doesn't have
to implicitly handle its implementation:

```dart tag=good
import 'package:mockito/mockito.dart';

class Example {
  final int? _i;
  Example(this._i);
}

class MockExample extends Mock implements Example {
  @override
  late final int? _i; // Add a definition for Example's _i getter.
}

f(Example x) {
  if (x._i != null) {
    int i = x._i; // OK
  }
}
```

The getter is declared `late` to be consistent with how mocks are generally used;
it's not necessary to declare the getter `late` to solve this type promotion
failure in scenarios not involving mocks.

:::note
The example above uses [mocks]({{site.pub-pkg}}/mockito) simply because
`Mock` already contains a `noSuchMethod` definition,
so we don't have to define an arbitrary one
and can keep the example code short. 

We don’t expect problems like this to arise very often in practice with mocks,
because usually mocks are declared
in a different library than the class they are mocking.
When the classes in question are declared in different libraries,
private names aren’t forwarded to `noSuchMethod`
(because that would violate privacy expectations),
so it’s still safe to promote the field.
:::


### Possibly written after promotion {:#write}

**The cause:**
You're trying to promote a variable that might have been
written to since it was promoted.

**Example:**

```dart tag=bad
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

**Solution**:

In this example, when flow analysis hits (1),
it demotes `i` from non-nullable `int` back to nullable `int?`.
A human can tell that the access at (2) is safe
because there's no code path that includes both (1) and (2), but
flow analysis isn't smart enough to see that,
because it doesn't track correlations between
conditions in separate `if` statements.

You might fix the problem by combining the two `if` statements:

<?code-excerpt "non_promotion/lib/non_promotion.dart (write-combine-ifs)" replace="/else/[!$&!]/g"?>
```dart tag=good
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

<?code-excerpt "non_promotion/lib/non_promotion.dart (write-change-type)" replace="/int j/[!$&!]/g"?>
```dart tag=good
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

### Possibly written in a previous loop iteration {:#loop-or-switch}

**The cause:**
You're trying to promote something that
might have been written to in a previous iteration of a loop,
and so the promotion was invalidated.

**Example:**

```dart tag=bad
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

**Solution**:

You can fix this problem by moving the null check to the top of the loop:

<?code-excerpt "non_promotion/lib/non_promotion.dart (loop)" replace="/p != null/[!$&!]/g"?>
```dart tag=good
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

```dart tag=bad
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

<?code-excerpt "non_promotion/lib/non_promotion.dart (switch-loop)" replace="/if .*/[!$&!]/g"?>
```dart tag=good
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

### In catch after possible write in try {:#catch}

**The cause:**
The variable might have been written to in a `try` block,
and execution is now in a `catch` block.

**Example:**

```dart tag=bad
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

**Solution**:

To fix the problem, make sure that the `catch` block doesn't rely on assumptions
about the state of variables that get changed inside the `try` block.
Remember, the exception might occur at any time during the `try` block,
possibly when `i` is null.

The safest solution is to add a null check inside the `catch` block:

<?code-excerpt "non_promotion/lib/non_promotion.dart (catch-null-check)" replace="/if.*/[!$&!]/g;/(} else {|  \/\/ H.*)/[!$&!]/g;/  }/  [!}!]/g"?>
```dart tag=good
try {
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
try {
  // ···
} catch (e) {
  print(i[!!!].isEven); // (3) OK because of the `!`.
}
```

### Subtype mismatch

**The cause:**
You're trying to promote to a type isn't a subtype of
the variable's current promoted type
(or wasn't a subtype at the time of the promotion attempt).

**Example:**

```dart tag=bad
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

**Solution**:

One possible solution is to create a new local variable so that
the original variable is promoted to `Comparable`, and
the new variable is promoted to `Pattern`:

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

<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-redundant)" replace="/\(o as Pattern\)/[!$&!]/g"?>
```dart tag=good
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

<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-string)" replace="/is String/is [!String!]/g"?>
```dart tag=good
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is [!String!] /* (2) */) {
      print(o.matchAsPrefix('foo')); // (3) OK
    }
  }
}
```


### Write captured by a local function {:#captured-local}

**The cause:**
The variable has been write captured by
a local function or function expression.

**Example:**

```dart tag=bad
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

**Solution**:

Sometimes it's possible to restructure the logic so that
the promotion is before the write capture:

<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-reorder)" replace="/(  )((var foo|  i = j|\}\;|\/\/ ... Use foo).*)/$1[!$2!]/g"?>
```dart tag=good
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

<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-copy)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!$1!]$2/g"?>
```dart tag=good
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


### Written outside of the current closure or function expression {:#write-outer}

**The cause:**
The variable is written to outside of a closure or function expression,
and the type promotion location is
inside the closure or function expression.

**Example:**

```dart tag=bad
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

**Solution**:

A solution is to create a local variable:

<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var)" replace="/var i2.*/[!$&!]/g;/i2\./[!i2!]./g"?>
```dart tag=good
void f(int? i, int? j) {
  if (i == null) return;
  [!var i2 = i;!]
  var foo = () {
    print([!i2!].isEven); // (1) OK because `i2` isn't changed later.
  };
  i = j; // (2)
}
```

**Example:**

A particularly nasty case looks like this:

```dart tag=bad
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

[1536]: {{site.repo.dart.lang}}/issues/1536

**Solution**:

Again, a solution is to create a local variable:

<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var2)" replace="/var j.*/[!$&!]/g;/j\./[!j!]./g"?>
```dart tag=good
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


### Write captured outside of the current closure or function expression {:#captured-outer}

**The cause:**
The variable you're trying to promote is write captured
outside of a closure or function expression,
but this use of the variable is inside of the closure or function expression
that's trying to promote it.

**Example:**

```dart tag=bad
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

**Solution**:

The best solution is probably to create a local variable:

<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-write-capture)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!i2!]$2/g"?>
```dart tag=good
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
[language version]: /guides/language/evolution#language-versioning
[`pubspec.yaml`]: /tools/pub/pubspec
[upgrade]: /get-dart
[extension methods]: /language/extension-methods
[`on` type]: /language/extension-methods#implementing-extension-methods
[abstract]: /language/methods#abstract-methods
[abstract field]: /null-safety/understanding-null-safety#abstract-fields
[nosuchmethod]: /language/extend#nosuchmethod
