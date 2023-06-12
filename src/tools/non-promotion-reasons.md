---
title: Fixing type promotion failures
description: Solutions for cases where you know more about a field's type than Dart can determine.
---

This page has information to help you understand
why type promotion failures occur,
with tips on how to fix them.
To learn more, check out [Working with nullable fields][ns-fields],
a section in [Understanding null safety][].

[issue #2940]: https://github.com/dart-lang/site-www/issues/2940
[ns-fields]: /null-safety/understanding-null-safety#working-with-nullable-fields
[Understanding null safety]: /null-safety/understanding-null-safety


## Only local variables can be promoted {#property-or-this}

**The cause:**
You're trying to promote a property or `this`,
but only local variables can be promoted.

Example:

{:.bad}
{% prettify dart tag=pre+code %}
class C {
  int? i;                  // (1)
  void f() {
    if (i == null) return;
    print(i.isEven);       // (2) ERROR
  }
}
{% endprettify %}

The Dart compiler produces an error message for (2)
that points to (1) and explains that
`i` can't be promoted to a non-nullable type
because it's a field.

The usual fix is either to use `i!`
or to create a local variable
of type `int` that holds the value of `i`.

Here's an example of using `i!`:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (property_bang)" replace="/!/[!!!]/g"?>
{% prettify dart tag=pre+code %}
print(i[!!!].isEven);
{% endprettify %}

And here's an example of creating a local variable
(which can be named `i`)
that holds the value of `i`:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (property_copy)" replace="/final.*/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
class C {
  int? i;
  void f() {
    [!final i = this.i;!]
    if (i == null) return;
    print(i.isEven);
  }
}
{% endprettify %}

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
The workarounds for many of these are
one or more of the following:

* Create a local variable that has the type you need.
* Add an explicit null check.
* Use `!` or `as` if you're sure an expression can't be null.

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


### Possibly written after promotion {#write}

**The cause:**
Trying to promote a variable that might have been
written to since it was promoted.

Example:

{:.bad}
{% prettify dart tag=pre+code %}
void f(bool b, int? i, int? j) {
  if (i == null) return;
  if (b) {
    i = j;           // (1)
  }
  if (!b) {
    print(i.isEven); // (2) ERROR
  }
}
{% endprettify %}

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
{% prettify dart tag=pre+code %}
void f(bool b, int? i, int? j) {
  if (i == null) return;
  if (b) {
    i = j;
  } [!else!] {
    print(i.isEven);
  }
}
{% endprettify %}

In straight-line control flow cases like these (no loops),
flow analysis takes into account the right hand side of the assignment
when deciding whether to demote.
As a result, another way to fix this code is
to change the type of `j` to `int`.

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (write_change_type)" replace="/int j/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void f(bool b, int? i, [!int j!]) {
  if (i == null) return;
  if (b) {
    i = j;
  }
  if (!b) {
    print(i.isEven);
  }
}
{% endprettify %}


### Possibly written in a previous loop iteration {#loop-or-switch}

**The cause:**
You're trying to promote something that
might have been written to in a previous iteration of a loop,
and so the promotion was invalidated.

Example:

{:.bad}
{% prettify dart tag=pre+code %}
void f(Link? p) {
  if (p != null) return;
  while (true) {    // (1)
    print(p.value); // (2) ERROR
    var next = p.next;
    if (next == null) break;
    p = next;       // (3)
  }
}
{% endprettify %}

When flow analysis reaches (1),
it looks ahead and sees the write to `p` at (3).
But because it's looking ahead,
it hasn't yet figured out the type of the right-hand side of the assignment,
so it doesn't know whether it's safe to retain the promotion.
To be safe, it invalidates the promotion.

You might fix this problem by moving the null check to the top of the loop:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (loop)" replace="/p != null/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void f(Link? p) {
  while ([!p != null!]) {
    print(p.value);
    p = p.next;
  }
}
{% endprettify %}

This situation can also arise in `switch` statements if
a `case` block has a label,
because you can use labeled `switch` statements to construct loops:

{:.bad}
{% prettify dart tag=pre+code %}
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
{% endprettify %}

Again, you can fix the problem by moving the null check to the top of the loop:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (switch-loop)" replace="/if .*/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
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
{% endprettify %}



### In catch after possible write in try {#catch}

**The cause:**
The variable might have been written to in a `try` block,
and execution is now in a `catch` block.

Example:

{:.bad}
{% prettify dart tag=pre+code %}
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
{% endprettify %}

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
{% prettify dart tag=pre+code %}
// ···
} catch (e) {
  [!if (i != null) {!]
    print(i.isEven); // (3) OK due to the null check in the line above.
  [!} else {!]
  [!  // Handle the case where i is null.!]
  [!}!]
}
{% endprettify %}

Or, if you're sure that an exception can't occur while `i` is null,
just use the `!` operator:

<?code-excerpt "non_promotion/lib/non_promotion.dart (catch-bang)" replace="/i!/i[!!!]/g"?>
{% prettify dart tag=pre+code %}
// ···
} catch (e) {
  print(i[!!!].isEven); // (3) OK because of the `!`.
}
{% endprettify %}


### Subtype mismatch

**The cause:**
The type you're trying to promote to isn't a subtype of
the variable's current promoted type
(or wasn't a subtype at the time of the promotion attempt).

Example:

{:.bad}
{% prettify dart tag=pre+code %}
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is Pattern /* (2) */) {
      print(o.matchAsPrefix('foo')); // (3) ERROR
    }
  }
}
{% endprettify %}

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
{% prettify dart tag=pre+code %}
void f(Object o) {
  if (o is Comparable /* (1) */) {
    [!Object o2 = o;!]
    if ([!o2!] is Pattern /* (2) */) {
      print(
          [!o2!].matchAsPrefix('foo')); // (3) OK; o2 was promoted to `Pattern`.
    }
  }
}
{% endprettify %}

However, someone who edits the code later might be tempted to change
`Object o2` to `var o2`.
That change gives `o2` a type of `Comparable`,
which brings back the problem of the object not being promotable to `Pattern`.

A redundant type check might be a better solution:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-redundant)" replace="/\(o as Pattern\)/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is Pattern /* (2) */) {
      print([!(o as Pattern)!].matchAsPrefix('foo')); // (3) OK
    }
  }
}
{% endprettify %}

Another solution that sometimes works is when you can use a more precise type.
If line 3 cares only about strings,
then you can use `String` in your type check.
Because `String` is a subtype of `Comparable`, the promotion works:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (subtype-String)" replace="/is String/is [!String!]/g"?>
{% prettify dart tag=pre+code %}
void f(Object o) {
  if (o is Comparable /* (1) */) {
    if (o is [!String!] /* (2) */) {
      print(o.matchAsPrefix('foo')); // (3) OK
    }
  }
}
{% endprettify %}


### Write captured by a local function {#captured-local}

**The cause:**
The variable has been write captured by
a local function or function expression.

Example:

{:.bad}
{% prettify dart tag=pre+code %}
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ... 
  if (i == null) return; // (1)
  // ... Additional code ...
  print(i.isEven);       // (2) ERROR
}
{% endprettify %}

Flow analysis reasons that as soon as the definition of `foo` is reached,
it might get called at any time,
therefore it's no longer safe to promote `i` at all.
As with loops, this demotion happens regardless of
the type of the right hand side of the assignment.

Sometimes it's possible to restructure the logic so that
the promotion is before the write capture:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-reorder)" replace="/(  )((var foo|  i = j|\}\;|\/\/ ... Use foo).*)/$1[!$2!]/g"?>
{% prettify dart tag=pre+code %}
void f(int? i, int? j) {
  if (i == null) return; // (1)
  // ... Additional code ...
  print(i.isEven); // (2) OK
  [!var foo = () {!]
  [!  i = j;!]
  [!};!]
  [!// ... Use foo ...!]
}
{% endprettify %}

Another option is to create a local variable, so it isn't write captured:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-copy)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!$1!]$2/g"?>
{% prettify dart tag=pre+code %}
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
{% endprettify %}

Or you can do a redundant check:

<?code-excerpt "non_promotion/lib/non_promotion.dart (local-write-capture-bang)" replace="/i!/i[!!!]/g"?>
{% prettify dart tag=pre+code %}
void f(int? i, int? j) {
  var foo = () {
    i = j;
  };
  // ... Use foo ...
  if (i == null) return; // (1)
  // ... Additional code ...
  print(i[!!!].isEven); // (2) OK due to `!` check.
}
{% endprettify %}


### Written outside of the current closure or function expression {#write-outer}

**The cause:**
The variable is written to outside of a closure or function expression,
and the type promotion location is
inside the closure or function expression.

Example:

{:.bad}
{% prettify dart tag=pre+code %}
void f(int? i, int? j) {
  if (i == null) return;
  var foo = () {
    print(i.isEven); // (1) ERROR
  };
  i = j;             // (2)
}
{% endprettify %}

Flow analysis reasons that there's no way to determine
when `foo` might get called,
so it might get called after the assignment at (2),
and thus the promotion might no longer be valid.
As with loops, this demotion happens regardless of the type of
the right hand side of the assignment.

A solution is to create a local variable:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var)" replace="/var i2.*/[!$&!]/g;/i2\./[!i2!]./g"?>
{% prettify dart tag=pre+code %}
void f(int? i, int? j) {
  if (i == null) return;
  [!var i2 = i;!]
  var foo = () {
    print([!i2!].isEven); // (1) OK because `i2` isn't changed later.
  };
  i = j; // (2)
}
{% endprettify %}

A particularly nasty case looks like this:

{:.bad}
{% prettify dart tag=pre+code %}
void f(int? i) {
  i ??= 0;
  var foo = () {
    print(i.isEven); // ERROR
  };
}
{% endprettify %}

In this case, a human can see that the promotion is safe because
the only write to `i` uses a non-null value and
happens before `foo` is ever created.
But [flow analysis isn't that smart][1536].

[1536]: https://github.com/dart-lang/language/issues/1536

Again, a solution is to create a local variable:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-new-var2)" replace="/var j.*/[!$&!]/g;/j\./[!j!]./g"?>
{% prettify dart tag=pre+code %}
void f(int? i) {
  [!var j = i ?? 0;!]
  var foo = () {
    print([!j!].isEven); // OK
  };
}
{% endprettify %}

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
{% prettify dart tag=pre+code %}
void f(int? i, int? j) {
  var foo = () {
    if (i == null) return;
    print(i.isEven); // ERROR
  };
  var bar = () {
    i = j;
  };
}
{% endprettify %}

Flow analysis reasons that there's no way of telling
what order `foo` and `bar` might be executed in;
in fact, `bar` might even get executed halfway through executing `foo`
(due to `foo` calling something that calls `bar`).
So it isn't safe to promote `i` at all inside `foo`.

The best solution is probably to create a local variable:

{:.good}
<?code-excerpt "non_promotion/lib/non_promotion.dart (closure-write-capture)" replace="/var i2.*/[!$&!]/g;/(i2)( ==|\.)/[!i2!]$2/g"?>
{% prettify dart tag=pre+code %}
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
{% endprettify %}
