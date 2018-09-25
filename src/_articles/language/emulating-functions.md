---
title: Emulating Functions in Dart
description: Learn how to define Dart classes that behave like functions.
original-date: 2012-01-01
date: 2018-09-20
category: language
---

_Written by Gilad Bracha <br>
January 2012 (updated September 2018)_

This document describes how to define Dart classes
that behave like functions.

## The call() method

The following example has an ordinary class, `WannabeFunction`, that
defines a method named `call()`.

<?code-excerpt "misc/lib/articles/emulating-functions/emulating-functions.dart (call-method)"?>
{% prettify dart %}
class WannabeFunction {
  int call(int a, int b) => a + b;
}
{% endprettify %}

The `call()` method is special, in that anyone who defines a `call()` method is
presumed to emulate a function. This allows us to use instances of
`WannabeFunction` as if they were functions that take two integer arguments
and return an integer:

<?code-excerpt "misc/lib/articles/emulating-functions/emulating-functions.dart (call-object-as-function)"?>
{% prettify dart %}
var wf = WannabeFunction();
assert(wf(3, 4) == 7);
{% endprettify %}

The example above is rather trivial, and we would be better off writing a
function directly. However, there are cases where this ability can be quite
useful.  It is also core to the design philosophy of the Dart language:

* What matters about an object is its behavior. If object _a_ has a procedural
interface that is compatible with that of another object _b_, _a_ may
substitute for _b_.
* The interface of any kind of object can always be emulated by another
suitably defined object.

### How does it work?

When <code>x(a<sub>1</sub>, .., a<sub>n</sub>)</code> is evaluated,
if it is a normal
function, it gets called in the normal way. If it isn't we just invoke `call()`
on it. If `x` supports a `call()` method with suitable arguments it gets called.
Otherwise, `noSuchMethod()` gets invoked. 

Assignment is different.
When an object that supports `call()` is assigned to a target that
has a function type, the object is converted to a function object.
More precisely, when `e`
(an expression that has a type with a `call` method)
is assigned to a variable
(or passed as a parameter, or returned,
or used to initialize something, etc.)
**and** the type of the target is a function type,
then `e` is implicitly transformed to `e.call` —
a tear-off operation that yields a function object.


## The apply() method

The class Function defines the static method `apply()`
with the following signature:

{% prettify dart %}
static apply(Function function,
                      List positionalArguments,
                      [Map<Symbol, dynamic> namedArguments]);
{% endprettify %}

The apply() function allows functions to be called in generic fashion. The
last argument is positional, and is only needed if the function we mean to
call takes named arguments.  These are provided via map from argument names to
their values. One thing to pay attention to is that names are described
via instances of class [Symbol]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Symbol-class.html).


## Symbols

You can create symbols from strings:

{% prettify dart %}
new Symbol('myFavoriteMethodName');
{% endprettify %}

If possible, create constant symbol objects:

{% prettify dart %}
const Symbol('myFavoriteMethodName');
{% endprettify %}

Using constant symbols helps dart2js minify your code.


## Interactions with mirrors and noSuchMethod()

In Dart, you can customize how objects react to methods that are not explicitly
defined in their class chain by overriding noSuchMethod(). Here's an example
showing how you could use function emulation inside noSuchMethod():

<?code-excerpt "misc/lib/articles/emulating-functions/emulating-functions.dart (no-such-method)"?>
{% prettify dart %}
@override
dynamic noSuchMethod(Invocation invocation) {
  return invocation.memberName == #foo
      ? Function.apply(
          baz, invocation.positionalArguments, invocation.namedArguments)
      : super.noSuchMethod(invocation);
}
{% endprettify %}

The first branch handles the case where you want to forward just the parameters to
another function. If you know `baz` doesn't take any named arguments,
then that code can instead be
`Function.apply(baz, invocation.positionalArguments)`. The second branch simply forwards
to the standard implementation of the noSuchMethod(), a common pattern.

The only argument to noSuchMethod() is an
[Invocation]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Invocation-class.html).
The boolean properties of Invocation identify the syntactic form of the
method invocation, as the following table shows.

<!-- TODO: move this to stylesheet -->
<style type="text/css">
  .property-table { margin-bottom: 20px;}
  .property-table td {border: 1px solid #bbb; text-align: center;}
  .property-table td.true {background: #d9f2db;}
  .property-table td.false {background: #ffbfbf;}
</style>

<table class="property-table">
<tr>
  <th>&nbsp;</th>
  <th colspan="3">Form of method invocation</th>
</tr>
<tr>
  <th>&nbsp;</th><th>x.y</th><th>x.y = e</th><th>x.y(...)</th>
</tr>
<tr>
  <th align="left">isMethod</th>
  <td class="false"> false </td> <!-- x.y -->
  <td class="false"> false </td> <!-- x.y = e -->
  <td class="true"> true </td>   <!-- x.y(...) -->
</tr>
<tr>
  <th align="left">isGetter</th>
  <td class="true"> true </td>   <!-- x.y -->
  <td class="false"> false </td> <!-- x.y = e -->
  <td class="false"> false </td> <!-- x.y(...) -->
</tr>
<tr>
  <th align="left">isSetter</th>
  <td class="false"> false </td> <!-- x.y -->
  <td class="true"> true </td>   <!-- x.y = e -->
  <td class="false"> false </td> <!-- x.y(...) -->
</tr>
<tr>
  <th align="left">isAccessor</th>
  <td class="true"> true </td>   <!-- x.y -->
  <td class="true"> true </td>   <!-- x.y = e -->
  <td class="false"> false </td> <!-- x.y(...) -->
</tr>
</table>

It is important not to assume that `isMethod` means that a non-accessor was
being looked up, since in fact, Dart semantics mean that we would have called
noSuchMethod() only if neither a normal method nor a getter were found.
Likewise, `isGetter` does not imply a getter was being looked up; if a method
was present, it would be closurized and returned.

## Summary

Here is what you need to know to
define a class that works similarly to a function in Dart:

1.  Define a class with a method named **call**.
1.  Implement the `call()` method to define
    what instances of your class do
    when invoked as functions via the **()** syntax.

{% comment %}
The tests for this article are at /src/tests/site/articles/emulating-functions.
{% endcomment %}
