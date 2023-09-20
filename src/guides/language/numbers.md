---
title: Numbers in Dart
description: Learn how Dart numbers are slightly different on the web, when that might matter, and how you might adjust your code.
---

Dart apps often target multiple platforms.
For example, a Flutter app might target iOS, Android, and the web.
The code can be the same,
as long as the app doesn't rely on platform-specific libraries
or use numbers in a way that's platform dependent.

This page has details about the differences
between native and web number implementations,
and how to write code so that those differences don't matter.

{{site.alert.secondary}}
  **Number implementations in Dart and other languages**

  Dart has always allowed platform-specific representations
  and semantics for numbers, for reasons of 
  performance, code size, and platform interoperability.

  Similarly, in C/C++ the commonly used `int` type for integer values is
  platform-specific to best map to the native machine architecture
  (16-, 32-, or 64-bit).
  In Java, the `float` and `double` types for fractional values
  were originally designed to strictly follow IEEE 754 on all platforms,
  but this constraint was loosened almost immediately for efficiency reasons
  (`strictfp` is required for exact coherence).
{{site.alert.end}}


## Dart number representation

In Dart, all numbers are part of the common `Object` type hierarchy,
and there are two concrete, user-visible numeric types:
`int`, representing integer values, and `double`, representing fractional values.

<img 
  src="/assets/img/number-class-hierarchy.svg" 
  alt="Object is the parent of num, which is the parent of int and double">

Depending on the platform,
those numeric types have different, hidden implementations.
In particular, Dart has two very different types of targets it compiles to:

* **Native:** Most often, a 64-bit mobile or desktop processor.
* **Web:** JavaScript as the primary execution engine.

The following table shows how Dart numbers are usually implemented:

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Representation</th>
      <th>Native <code>int</code></th>
      <th>Native <code>double</code></th>
      <th>Web <code>int</code></th>
      <th>Web <code>double</code></th>
    </tr>
    <tr>
      <td><a href="https://en.wikipedia.org/wiki/Two%27s_complement">
        64-bit signed two's complement</a>
      </td>
      <td>✅</td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    <tr>
      <td>
        <a href="https://en.wikipedia.org/wiki/Double-precision_floating-point_format">64-bit floating point</a>
      </td>
      <td></td>
      <td>✅</td>
      <td>✅</td>
      <td>✅</td>
    </tr>
  </table>
</div>

For native targets, you can assume that
`int` maps to a signed 64-bit integer representation and
`double` maps to a 64-bit IEEE floating-point representation
that matches the underlying processor.

But on the web, where Dart compiles to and interoperates with JavaScript,
there is a single numeric representation:
a 64-bit double-precision floating-point value.
For efficiency, Dart maps both `int` and `double` to this single representation.
The visible type hierarchy remains the same,
but the underlying hidden implementation types are
different and intertwined.

The following figure illustrates the platform-specific types (in blue)
for native and web targets.
As the figure shows,
the concrete type for `int` on native implements only the `int` interface.
However, the concrete type for `int` on the web implements
both `int` and `double`.

<img 
  src="/assets/img/number-platform-specific.svg" 
  alt="Implementation classes vary by platform; for JavaScript, the class that implements int also implements double">


{{site.alert.note}}
  Dart represents `int` and `double` in
  a few different ways for efficiency,
  but these implementation classes (in blue, above) are hidden.
  In general, you can ignore the platform-specific types,
  and think of `int` and `double` as concrete types. 
{{site.alert.end}}

An `int` on the web is represented as
a double-precision floating-point value with no fractional part.
In practice, this works pretty well:
double-precision floating point provides 53 bits of integer precision.
However, `int` values are always also `double` values,
which can lead to some surprises.


## Differences in behavior

Most integer and double arithmetic
has essentially the same behavior.
There are, however, important differences—particularly 
when your code has strict expectations about
precision, string formatting, or underlying runtime types.

When arithmetic results differ, as described in this section,
the behavior is **platform specific**
and **subject to change**.

{{site.alert.note}}
  Any platform-specific behavior that this page describes might change to be
  less surprising, more consistent, or more performant.
{{site.alert.end}}


### Precision

The following table demonstrates how some numerical expressions
differ due to precision.
Here, `math` represents the `dart:math` library,
and `math.pow(2, 53)` is 2<sup>53</sup>.

On the web, integers lose precision past 53 bits.
In particular, 2<sup>53</sup> and 2<sup>53</sup>+1
map to the same value due to truncation.
On native, these values can still be differentiated
because native numbers have 64 bits—63 bits for the value and 1 for the sign.

The effect of overflow is visible
when comparing 2<sup>63</sup>-1 to 2<sup>63</sup>.
On native, the latter overflows to -2<sup>63</sup>,
as expected for two's-complement arithmetic.
On the web, these values do not overflow
because they are represented differently;
they're approximations due to the loss of precision.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native</th>
      <th>Web</th>
    </tr>
    <tr>
      <td><code>math.pow(2, 53) - 1</code></td>
      <td><code>9007199254740991</code></td>
      <td><code>9007199254740991</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 53)</code></td>
      <td><code>9007199254740992</code></td>
      <td><code>9007199254740992</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 53) + 1</code></td>
      <td><code>9007199254740993</code></td>
      <td><code>9007199254740992</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 62)</code></td>
      <td><code>4611686018427387904</code></td>
      <td><code>4611686018427388000</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 63) - 1</code></td>
      <td><code>9223372036854775807</code></td>
      <td><code>9223372036854776000</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 63)</code></td>
      <td><code>-9223372036854775808</code></td>
      <td><code>9223372036854776000</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 64)</code></td>
      <td><code>0</code></td>
      <td><code>18446744073709552000</code></td>
    </tr>
  </table>
</div>

### Identity

On native platforms, `double` and `int` are distinct types:
no value can be both a `double` and an `int` at the same time.
On the web, that isn't true.
Because of this difference,
identity can differ between platforms,
although equality (`==`) doesn't.

The following table shows some expressions that use equality and identity.
The equality expressions are the same on native and web;
the identity expressions are usually different.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native</th>
      <th>Web</th>
    </tr>
    <tr>
      <td><code>1.0 == 1</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>identical(1.0, 1)</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>0.0 == -0.0</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>identical(0.0, -0.0)</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>double.nan == double.nan</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>identical(double.nan, double.nan)</code></td>
      <td><code>true</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>double.infinity == double.infinity</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>identical(double.infinity, double.infinity)</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
  </table>
</div>

### Types and type checking

On the web, the underlying `int` type is like a subtype of `double`:
it's a double-precision value without a fractional part.
In fact, a type check on the web of the form `x is int`
returns true if `x` is a number (`double`) with
a zero-valued fractional part.

As a result, the following are true on the web:

* All Dart numbers (values of type `num`) are `double`.
* A Dart number can be both a `double` and an `int` at the same time.

These facts affect `is` checks and `runtimeType` properties.
A side effect is that `double.infinity` is interpreted as an `int`.
Because this is a platform-specific behavior,
it might change in the future.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native</th>
      <th>Web</th>
    </tr>
    <tr>
      <td><code>1 is int</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>1 is double</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>1.0 is int</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>1.0 is double</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>(0.5 + 0.5) is int</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>(0.5 + 0.5) is double</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>3.14 is int</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>3.14 is double</code></td>
      <td><code>true</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>double.infinity is int</code></td>
      <td><code>false</code></td>
      <td><code>true</code></td>
    </tr>
    <tr>
      <td><code>double.nan is int</code></td>
      <td><code>false</code></td>
      <td><code>false</code></td>
    </tr>
    <tr>
      <td><code>1.0.runtimeType</code></td>
      <td><code>double</code></td>
      <td><code>int</code></td>
    </tr>
    <tr>
      <td><code>1.runtimeType</code></td>
      <td><code>int</code></td>
      <td><code>int</code></td>
    </tr>
    <tr>
      <td><code>1.5.runtimeType</code></td>
      <td><code>double</code></td>
      <td><code>double</code></td>
    </tr>
  </table>
</div>

### Bitwise operations

For performance reasons on the web,
bitwise (`&`, `|`, `^`, `~`) and shift (`<<`,`>>`, `>>>`) operators on `int`
use the native JavaScript equivalents.
In JavaScript, the operands are truncated to 32-bit integers
that are treated as unsigned.
This treatment can lead to surprising results on larger numbers.
In particular, if operands are negative or don't fit into 32 bits,
they're likely to produce different results between native and web.

The following table shows how native and web platforms
treat bitwise and shift operators when the operands
are either negative or close to 32 bits:

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native</th>
      <th>Web</th>
    </tr>
    <tr>
      <td><code>-1 >> 0</code></td>
      <td><code>-1</code></td>
      <td><code>4294967295</code></td>
    </tr>
    <tr>
      <td><code>-1 ^ 2</code></td>
      <td><code>-3</code></td>
      <td><code>4294967293</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 32).toInt()</code></td>
      <td><code>4294967296</code></td>
      <td><code>4294967296</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 32).toInt() >> 1</code></td>
      <td><code>2147483648</code></td>
      <td><code>0</code></td>
    </tr>
    <tr>
      <td><code>(math.pow(2, 32).toInt()-1) >> 1</code></td>
      <td><code>2147483647</code></td>
      <td><code>2147483647</code></td>
    </tr>
  </table>
</div>

### String representation

On the web, Dart generally defers to JavaScript to convert a number to a string
(for example, for a `print`).
The following table demonstrates how
converting the expressions in the first column can lead to different results.

<div class="table-wrapper">
  <table class="table table-striped nowrap">
    <tr>
      <th>Expression</th>
      <th>Native <code>toString()</code></th>
      <th>Web <code>toString()</code></th>
    </tr>
    <tr>
      <td><code>1</code></td>
      <td><code>"1"</code></td>
      <td><code>"1"</code></td>
    </tr>
    <tr>
      <td><code>1.0</code></td>
      <td><code>"1.0"</code></td>
      <td><code>"1"</code></td>
    </tr>
    <tr>
      <td><code>(0.5 + 0.5)</code></td>
      <td><code>"1.0"</code></td>
      <td><code>"1"</code></td>
    </tr>
    <tr>
      <td><code>1.5</code></td>
      <td><code>"1.5"</code></td>
      <td><code>"1.5"</code></td>
    </tr>
    <tr>
      <td><code>-0</code></td>
      <td><code>"0"</code></td>
      <td><code>"-0.0"</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 0)</code></td>
      <td><code>"1"</code></td>
      <td><code>"1"</code></td>
    </tr>
    <tr>
      <td><code>math.pow(2, 80)</code></td>
      <td><code>"0"</code></td>
      <td><code>"1.2089258196146292e+24"</code></td>
    </tr>
  </table>
</div>

## What should you do?

Usually, you don't need to change your numeric code.
Dart code has been running on both native and web platforms for years,
and number implementation differences are rarely a problem.
Common, typical code—such as iterating through a range of small integers 
and indexing a list—behaves the same.

If you have tests or assertions that compare string results,
write them in a platform-resilient manner.
For example, suppose you're testing the value of string expressions
that have embedded numbers:

```dart
void main() {
  var count = 10.0 * 2;
  var message = "$count cows";
  if (message != "20.0 cows") throw Exception("Unexpected: $message");
}
```

The preceding code succeeds on native platforms but throws on the web
because `message` is `"20 cows"` (no decimal) on the web.
As an alternative, you might write the condition as follows,
so it passes on both native and web platforms:

```dart
if (message != "${20.0} cows") throw ... 
```

For bit manipulation, consider explicitly operating on 32-bit chunks,
which are consistent on all platforms.
To force a signed interpretation of a 32-bit chunk,
use `int.toSigned(32)`.

For other cases where precision matters,
consider other numeric types.
The [`BigInt`][] type
provides arbitrary-precision integers on both native and web.
The [`fixnum`][] package
provides strict 64-bit signed numbers, even on the web.
Use these types with care, though:
they often result in significantly bigger and slower code.

[`BigInt`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/BigInt-class.html
[`fixnum`]: {{site.pub-pkg}}/fixnum
