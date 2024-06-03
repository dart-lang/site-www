---
title: How to mock JavaScript interop objects
---

In this tutorial, you'll learn how to mock JS objects so that you can test
interop instance members without having to use a real implementation.

## Background and motivation

Mocking classes in Dart is usually done through overriding instance members.
However, since [extension types] are used to declare interop types, all
extension type members are dispatched statically and therefore overriding can't
be used. This [limitation is true for extension members] as well, and therefore
instance extension type or extension members can't be mocked.

While this applies to any non-`external` extension type member, `external`
interop members are special as they invoke members on a JS value.

```dart
extension type Date(JSObject _) implements JSObject {
  external int getDay();
}
```

As discussed in the [Usage] section, calling `getDay()` will result in calling
`getDay()` on the JS object. Therefore, by using a different `JSObject`, a
different *implementation* of `getDay` can be called.

In order to do this, there should be some mechanism of creating a JS object that
has a property `getDay` which when called, calls a Dart function. A simple way
is to create a JS object and set the property `getDay` to a converted callback
e.g.

```dart
final date = Date(JSObject());
date['getDay'] = (() => 0).toJS;
```

While this works, this is prone to error and doesn't scale well when you are
using many interop members. It also doesn't handle getters or setters properly.
Instead, you should use a combination of [`createJSInteropWrapper`] and
[`@JSExport`] to declare a type that provides an implementation for all the
`external` instance members.

## Mocking example

```dart
import 'dart:js_interop';

import 'package:expect/minitest.dart';

// The Dart class must have `@JSExport` on it or at least one of its instance
// members.
@JSExport()
class FakeCounter {
  int value = 0;
  @JSExport('increment')
  void renamedIncrement() {
    value++;
  }
  void decrement() {
    value--;
  }
}

extension type Counter(JSObject _) implements JSObject {
  external int value;
  external void increment();
  void decrement() {
    value -= 2;
  }
}

void main() {
  var fakeCounter = FakeCounter();
  // Returns a JS object whose properties call the relevant instance members in
  // `fakeCounter`.
  var counter = createJSInteropWrapper<FakeCounter>(fakeCounter) as Counter;
  // Calls `FakeCounter.value`.
  expect(counter.value, 0);
  // `FakeCounter.renamedIncrement` is renamed to `increment`, so it gets
  // called.
  counter.increment();
  expect(counter.value, 1);
  expect(fakeCounter.value, 1);
   // Changes in the fake affect the wrapper and vice-versa.
  fakeCounter.value = 0;
  expect(counter.value, 0);
  counter.decrement();
  // Because `Counter.decrement` is non-`external`, we never called
  // `FakeCounter.decrement`.
  expect(counter.value, -2);
}
```

## [`@JSExport`] and [`createJSInteropWrapper`]

`@JSExport` allows you to declare a class that can be used in
`createJSInteropWrapper`. `createJSInteropWrapper` will create an object literal
that maps each of the class' instance member names (or renames) to a JS callback
that triggers the instance member when called. In the above example, getting and
setting `counter.value` gets and sets `fakeCounter.value`.

You can specify only some members of a class to be exported by omitting the
annotation from the class and instead only annotate the specific members. You
can see more specifics on more specialized exporting (including inheritance) in
the documentation of [`@JSExport`].

Note that this mechanism isn't specific to testing only. You can use this to
provide a JS interface for an arbitrary Dart object, allowing you to essentially
*export* Dart objects to JS with a predefined interface.

{% comment %}
TODO: Should we add a section on general testing? We can't really mock
non-instance members unless the user explicitly replaces the real API in JS.
{% endcomment %}

[Usage]: /interop/js-interop/usage
[`createJSInteropWrapper`]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop/createJSInteropWrapper.html
[`@JSExport`]: {{site.dart-api}}/{{site.sdkInfo.channel}}/dart-js_interop/JSExport-class.html
[limitation is true for extension members]: {{site.repo.dart.org}}/mockito/blob/master/FAQ.md#how-do-i-mock-an-extension-method
[extension types]: /language/extension-types
