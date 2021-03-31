---
title: Numbers in Dart
description: PENDING
---

Dart developers expect Dart programs to run identically on all platforms.
This is why a Flutter program written for iOS or Android
is expected to just work on the web.
Aside from platform-specific code — libraries, packages, and plugins
designed to interoperate with the underlying native platform —
there is one important caveat: numbers.
As Flutter matures on the web,
it’s important for developers targeting the web to be aware that
there are differences with number semantics.
For typical usage, most developers won’t need to think much about numbers,
but in cases where precision, string representation, and exact runtime types matter,
developers may see subtle differences.

When designing Dart, we made a pragmatic decision to
allow platform specific representations and semantics for numbers.
Our developers care about performance, code size, and platform interoperability,
and a one-size-fits-all approach to numbers wasn’t consistent with that.
Indeed, in C/C++, the commonly used `int` type for integer values is
platform specific to best map to the native machine architecture
(16-, 32-, or 64-bit).
In Java, the `float` and `double` types for fractional values
were originally designed to strictly follow IEEE 754 on all platforms,
but this constraint was loosened almost immediately for efficiency reasons
(`strictfp` is required for exact coherence).


## Dart number representation

In Dart, all numbers are part of the common `Object` type hierarchy,
and there are two concrete, user-visible numeric types:
`int`, representing integer values, and `double`, representing fractional values.

```
  Object
    |
   num
  /    \
int   double
```

However, depending on the platform,
those numeric types have different, hidden implementations.
In particular, Dart has two very different types of targets it compiles to:
(1) native, represented typically by 64-bit mobile and desktop processor, and
(2) web, where JavaScript is the primary execution engine.

<table>
  <tr>
   <td>Representation
   </td>
   <td>Native <code>int</code>
   </td>
   <td>Native <code>double</code>
   </td>
   <td>Web <code>int</code>
   </td>
   <td>Web <code>double</code>
   </td>
  </tr>
  <tr>
   <td><a href="https://en.wikipedia.org/wiki/Two%27s_complement">64-bit signed two’s complement</a>
   </td>
   <td>✅
   </td>
   <td>
   </td>
   <td>
   </td>
   <td>
   </td>
  </tr>
  <tr>
   <td><a href="https://en.wikipedia.org/wiki/Double-precision_floating-point_format">64-bit floating point</a>
   </td>
   <td>
   </td>
   <td>✅
   </td>
   <td>✅
   </td>
   <td>✅
   </td>
  </tr>
</table>

For native targets, a Dart developer may assume that
`int` maps to a signed 64-bit integer representation and
`double` maps to a 64-bit, IEEE floating point representation
matching the underlying processor.
In general, the developer may simply assume the above hierarchy,
with `int` and `double` as concrete implementation types.

```
  Object
     |
    num
   /    \
 int   double 
  |       |
native* native*
  int   double
```

In actuality, Dart will represent `int` and `double` in
a few different ways for efficiency,
but these are hidden from the user (marked `*` above) and
beyond the scope of discussion.

For the web, however, Dart compiles to and interoperates with JavaScript,
which has a single numeric representation:
a 64-bit, double-precision floating point value.
For efficiency, Dart maps both `int` and `double` to this single representation.
The visible type hierarchy remains the same,
but the underlying hidden implementation types (marked `*`) are
different and intertwined:

```
   Object
     |
    num
   /    \
 int   double 
  |   /   |
  |  /    |
  js*     js*
  int   double
```

Specifically, an `int` is represented as
a double-precision floating point value with no fractional part.
In practice, this works pretty well.
Double-precision floating point provides 53 bits of integer precision.
However, it means that `int` values are always also `double` values,
which can lead to some surprises.


## Differences in behavior

For most integer and double arithmetic,
developers will see essentially the same behavior.
There are, however, important differences,
particularly when there are stringent expectations on
precision, string formatting, and underlying runtime types.

In general, when results differ, as described below,
the behavior should be considered platform specific.
**In these cases, we may change behavior in the future
(e.g., to be less surprising, more consistent, or more performant).**


### Precision

The following table demonstrates how some numerical expressions
are handled differently due to precision.
Here, `math` represents the `dart:math` library,
and `math.pow(2, 53)` is 2<sup>53</sup>.
On the web, integers lose precision past 53 bits.
In particular, 2<sup>53</sup> and 2<sup>53</sup>+1
map to the same value due to truncation.
On native, these values can still be differentiated
as we have 64 bits — 63 bits for the value and 1 for the sign.
We can see the effect of overflow on native
when we compare 2<sup>63</sup>-1 to 2<sup>63</sup>.
The latter overflows to -2<sup>63</sup> as expected for two's-complement arithmetic.
On the web, these values do not overflow as they are represented differently,
but they are only approximations due to the loss of precision.

<table>
  <tr>
   <td>Expression
   </td>
   <td>Native
   </td>
   <td>Web
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 53) - 1</code>
   </td>
   <td><code>9007199254740991</code>
   </td>
   <td><code>9007199254740991</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 53)</code>
   </td>
   <td><code>9007199254740992</code>
   </td>
   <td><code>9007199254740992</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 53) + 1</code>
   </td>
   <td><code>9007199254740993</code>
   </td>
   <td><code>9007199254740992</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 62)</code>
   </td>
   <td><code>4611686018427387904</code>
   </td>
   <td><code>4611686018427388000</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 63) - 1</code>
   </td>
   <td><code>9223372036854775807</code>
   </td>
   <td><code>9223372036854776000</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 63)</code>
   </td>
   <td><code>-9223372036854775808</code>
   </td>
   <td><code>9223372036854776000</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 64)</code>
   </td>
   <td><code>0</code>
   </td>
   <td><code>18446744073709552000</code>
   </td>
  </tr>
</table>


### Identity

On native platforms, `double` and `int` are distinct types —
no value can be both a `double` and an `int` at the same time.
On the web, that is not true.
Because of this, identity may differ though equality (`==`) should not.

<table>
  <tr>
   <td>Expression
   </td>
   <td>Native
   </td>
   <td>Web
   </td>
  </tr>
  <tr>
   <td><code>1.0 == 1</code>
   </td>
   <td><code>true</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>identical(1.0, 1)</code>
   </td>
   <td><code>false</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>0.0 == -0.0</code>
   </td>
   <td><code>true</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>identical(0.0, -0.0)</code>
   </td>
   <td><code>false</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>double.nan == double.nan</code>
   </td>
   <td><code>false</code>
   </td>
   <td><code>false</code>
   </td>
  </tr>
  <tr>
   <td><code>identical(double.nan, double.nan)</code>
   </td>
   <td><code>true</code>
   </td>
   <td><code>false</code>
   </td>
  </tr>
  <tr>
   <td><code>double.infinity == double.infinity</code>
   </td>
   <td><code>true</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>identical(double.infinity, double.infinity)</code>
   </td>
   <td><code>true</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
</table>


### Types and type checking

On the web, the underlying `int` type can be thought of as a subtype of `double`:
it’s a double-precision value without a fractional part.
In fact, a type check on the web of the form `x is int` is exactly that:
it returns true if `x` is a number (double) with a zero-valued fractional part.

This means that, on the web,
(1) all Dart numbers (values of type `num`) are `double` and
(2) a Dart number may be both a `double` and an `int` at the same time.
This impacts both `is` checks and `runtimeType` properties.
Note that an odd quirk of the way we currently check for `int`
leads `double.infinity` to be interpreted as an `int`.
As mentioned above, we may change this in the future.

<table>
  <tr>
   <td>Expression
   </td>
   <td>Native
   </td>
   <td>Web
   </td>
  </tr>
  <tr>
   <td><code>1 is int</code>
   </td>
   <td><code>true</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>1 is double</code>
   </td>
   <td><code>false</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>1.0 is int</code>
   </td>
   <td><code>false</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>1.0 is double</code>
   </td>
   <td><code>true</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>(0.5 + 0.5) is int</code>
   </td>
   <td><code>false</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>(0.5 + 0.5) is double</code>
   </td>
   <td><code>true</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>3.14 is int</code>
   </td>
   <td><code>false</code>
   </td>
   <td><code>false</code>
   </td>
  </tr>
  <tr>
   <td><code>3.14 is double</code>
   </td>
   <td><code>true</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>double.infinity is int</code>
   </td>
   <td><code>false</code>
   </td>
   <td><code>true</code>
   </td>
  </tr>
  <tr>
   <td><code>double.nan is int</code>
   </td>
   <td><code>false</code>
   </td>
   <td><code>false</code>
   </td>
  </tr>
  <tr>
   <td><code>1.0.runtimeType</code>
   </td>
   <td><code>double</code>
   </td>
   <td><code>int</code>
   </td>
  </tr>
  <tr>
   <td><code>1.runtimeType</code>
   </td>
   <td><code>int</code>
   </td>
   <td><code>int</code>
   </td>
  </tr>
  <tr>
   <td><code>1.5.runtimeType</code>
   </td>
   <td><code>double</code>
   </td>
   <td><code>double</code>
   </td>
  </tr>
</table>


### Bitwise operations

For performance reasons on the web,
bitwise (`&`, `|`, `^`, `~`) and shift (`&lt;<`,`>>`, `>>>`) operators on `int`
use the native JavaScript equivalents.
In JavaScript, the operands to these operations are truncated to 32-bit integers,
which we then treat as unsigned.
This can lead to surprising results on larger numbers.
In particular, if operands are negative or don't fit into 32 bits,
they will likely produce different results between native and web.

<table>
  <tr>
   <td>Expression
   </td>
   <td>Native
   </td>
   <td>Web
   </td>
  </tr>
  <tr>
   <td><code>-1 >> 0</code>
   </td>
   <td><code>-1</code>
   </td>
   <td><code>4294967295</code>
   </td>
  </tr>
  <tr>
   <td><code>-1 ^ 2</code>
   </td>
   <td><code>-3</code>
   </td>
   <td><code>4294967293</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 32).toInt()</code>
   </td>
   <td><code>4294967296</code>
   </td>
   <td><code>4294967296</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 32).toInt() >> 1</code>
   </td>
   <td><code>2147483648</code>
   </td>
   <td><code>0</code>
   </td>
  </tr>
  <tr>
   <td><code>(math.pow(2, 32).toInt()-1) >> 1</code>
   </td>
   <td><code>2147483647</code>
   </td>
   <td><code>2147483647</code>
   </td>
  </tr>
</table>


### String representation

On the web, Dart generally defers to JavaScript to convert a number to a string
(e.g., for a `print`).
The following table demonstrates how
converting the expressions in the first column can lead to different results.

<table>
  <tr>
   <td>Expression
   </td>
   <td>Native <code>toString()</code>
   </td>
   <td>Web <code>toString()</code>
   </td>
  </tr>
  <tr>
   <td><code>1</code>
   </td>
   <td><code>"1"</code>
   </td>
   <td><code>"1"</code>
   </td>
  </tr>
  <tr>
   <td><code>1.0</code>
   </td>
   <td><code>"1.0"</code>
   </td>
   <td><code>"1"</code>
   </td>
  </tr>
  <tr>
   <td><code>(0.5 + 0.5)</code>
   </td>
   <td><code>"1.0"</code>
   </td>
   <td><code>"1"</code>
   </td>
  </tr>
  <tr>
   <td><code>1.5</code>
   </td>
   <td><code>"1.5"</code>
   </td>
   <td><code>"1.5"</code>
   </td>
  </tr>
  <tr>
   <td><code>-0</code>
   </td>
   <td><code>"0"</code>
   </td>
   <td><code>"-0.0"</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 0)</code>
   </td>
   <td><code>"1"</code>
   </td>
   <td><code>"1"</code>
   </td>
  </tr>
  <tr>
   <td><code>math.pow(2, 80)</code>
   </td>
   <td><code>"0"</code>
   </td>
   <td><code>"1.2089258196146292e+24"</code>
   </td>
  </tr>
</table>


## What should you do?

In most cases, developers shouldn’t need to do anything.
Dart developers have been running the same programs
across native and web platforms for years,
and it has rarely been a problem.
Common, typical code behaves the same —
for example, iterating through a range of small integers and indexing a list.

For tests or assertions that compare string results,
it’s useful to write them in a platform resilient manner.
E.g., suppose you are testing the value of string expressions with numbers embedded:

```dart
void main() {
  var count = 10.0 * 2;
  var message = "$count cows";
  if (message != "20.0 cows") throw Exception("Unexpected: $message");
}
```

This test will pass on native platforms, but it will throw on the web.
Because it depends on how numbers are formatted,
`message` will be `"20 cows"` (no decimal) instead on the web.
As an alternative, the condition instead could be written as:

```dart
if (message != "${20.0} cows") throw ... 
```

to pass on the web as well.

For bit manipulation, consider explicitly operating on 32-bit chunks
as those will be consistent on all platforms.
Note, you can force a signed interpretation of the 32-bit chunk via `int.toSigned(32)`.

For other cases where precision matters,
you may consider other numeric types.
The [`BigInt`][] type
provides arbitrary precision integers on both native and web.
The [`fixnum`][] package
provides strict 64-bit signed numbers, even on the web.
Use these with care though,
as they often result in significantly bigger and slower code.

[`BigInt`]: https://api.dart.dev/dev/2.12.0-281.0.dev/dart-core/BigInt-class.html
[`fixnum`]: https://pub.dev/packages/fixnum
