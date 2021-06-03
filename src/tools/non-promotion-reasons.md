---
title: Fixing type promotion failures
description: Solutions for cases where you know more about a field's type than Dart can determine.
---

This page has information to help you understand
why type promotion failures occur,
with tips on how to fix them.
For background information,
see [Working with nullable fields][ns-fields],
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
{% prettify dart tag=pre+code %}
...
print(i[!!!].isEven);
...
{% endprettify %}

And here's an example of creating a local variable
(which can be named `i`)
that holds the value of `i`:

{:.good}
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

***[PENDING: make all good samples be tested]***

This section covers other common causes
of type promotion failure.
The workarounds for many of these are
similar to the workarounds shown in the previous section:
either use `!` or create a local variable that has the type you need.


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
      print(j.isEven);
      j = k;
      continue label;
  }
}
{% endprettify %}


### In catch after possible write in try

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
  } catch (...) {
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
these try/catch/finally situations don't take into account
the right-hand side of the assignment,
similar to what happens in loops.

***[PENDING: what's the fix?]***


### Subtype mismatch

**The cause:**
The type you're trying to promote to isn't a subtype of
the variable's current promoted type
(or wasn't a subtype at the time of the promotion attempt).

Example:

{:.bad}
{% prettify dart tag=pre+code %}
void f(Object o) {
  if (o is Comparable) {             // (1)
    if (o is Pattern) {              // (2)
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
`o` might have a type — like `String` —
that implements both `Comparable` and `Pattern`.

***[PENDING: what's the fix?]***


### Write captured by a local function

**The cause:**
The variable has been write captured by
a local function or function expression.

Example:

{:.bad}
{% prettify dart tag=pre+code %}
void f(int? i, int? j) {
  if (i == null) return;
  var foo = () {
    i = j;
  };
  print(i.isEven); // ERROR
}
{% endprettify %}

Flow analysis reasons that as soon as the definition of `foo` is reached,
it might get called at any time,
therefore it's no longer safe to promote `i` at all.
As with loops, this demotion happens regardless of
the type of the right hand side of the assignment.

***[PENDING: what's the fix?]***


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

***[PENDING: what's the fix?]***


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

***[PENDING: what's the fix?]***

