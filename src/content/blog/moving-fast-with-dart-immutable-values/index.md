---
title: "Moving Fast with Dart Immutable Values"
description: "Dart’s built_value provides powerful, convenient immutable values for Dart. The values might be immutable, but the package hasn’t been…"
publishDate: 2017-06-30
author: "davidmorgan"
category: other
tags:
  - programming
  - dart
  - dartlang
  - immutable
---


Dart’s [built_value](https://github.com/google/built_value.dart) provides powerful, convenient immutable values for Dart. The values might be immutable, but the package hasn’t been standing still! In the six months since I [last wrote about](https://medium.com/dartlang/darts-built-value-for-immutable-object-models-83e2497922d4) built_value there have been ten major improvements to the package.

I also spotted some interesting uses of built_value in the Dart community:

* The [built_redux](https://github.com/davidmarne/built_redux) package is a [redux](http://redux.js.org/)-inspired package using built_value. It comes with bindings and examples for [flutter](https://github.com/davidmarne/flutter_built_redux/tree/master/example), [angular2](https://github.com/davidmarne/angular_built_redux/tree/master/example) and [react-dart](https://github.com/davidmarne/react_built_redux).

* The [built_highcharts](https://github.com/vadimtsushko/built_highcharts) package is a [highcharts](https://www.highcharts.com/) wrapper using built_value. The [demo](https://vadimtsushko.github.io/built_highcharts/) is really rather nice.

* And, here’s [another way](https://github.com/toufikzitouni/Built-Value-Example) of using built_value with Flutter.

Anyway, without further ado, here are all the great new things in built_value.

## 1. Generic classes

Sophisticated object models use generics, so of course built_value needs [generics](https://github.com/google/built_value.dart/blob/master/example/lib/generics.dart). You can now declare your type using generics and the generated builder class will also support them:

```
abstract class GenericValue<T>
    implements Built<GenericValue<T>, GenericValueBuilder<T>> {
  T get value;
  ...
}

var value = new GenericValue<String>((b) => b..value = 'string');
```


Value types using generics are serializable, as usual.

## 2. Serializer plugins

A new `SerializerPlugin` API allows you to make cross-cutting modifications to serialization, by running arbitrary code before and after every object is serialized or deserialized.

You could, for example, use this to map between two wire-incompatible versions of a protocol. But a better example is the next improvement…

## 3. “Standard JSON” serializer plugin

By default, built_value serializes to and from its own list-based JSON format, for performance and flexibility.

But many people need to inter-operate with existing JSON data and APIs. What should they do?

Now, you can install `StandardJsonPlugin` and switch to a standard map-based JSON format.

```
final standardSerializers =
    (serializers.toBuilder()
        ..addPlugin(new StandardJsonPlugin())).build();
```


See the [example](https://github.com/google/built_value.dart/blob/master/example/lib/example.dart) (towards the end).

## 4. Getter memoization

Immutable classes are great — but what should you do about *derived* fields? If a derived field is expensive to compute, then immutable classes give two bad options: computing them upfront and always paying a possibly unnecessary penalty, or recomputing them on demand and potentially paying that same large cost many times.

Enter `@memoized` getters. Add this annotation to a built_value getter and it will be calculated lazily, but at most once; it’s then stored in a hidden field on the instance.

Since `1.1.2` built_value itself is a great example of `@memoized` getters. A built_value is used to wrap an `Element` from the analyzer, and computation is [done lazily in getters](https://github.com/google/built_value.dart/blob/master/built_value_generator/lib/src/value_source_class.dart):

```
abstract class ValueSourceClass
    implements Built<ValueSourceClass, ValueSourceClassBuilder> {
  ClassElement get element;

  @memoized
  BuiltList<String> get genericParameters =>
      new BuiltList<String>(element.typeParameters
          .map((element) => element.computeNode().toString()));

  @memoized
  BuiltList<ValueSourceField> get fields =>
      ValueSourceField.fromClassElements(element, builderElement);

  // And many more @memoized getters.
}
```


## 5. Faster code generation

…and as a result of moving to memoized getters, built_value is now significantly faster at generating code.

## 6. Simpler factories

Prior to `0.5.5` every built_value class had to have a factory method following a standard template. This requirement has been relaxed. Here are a few good ways to use this greater freedom.

For classes with one or two fields, just take exactly those fields in the constructor:

```
abstract class Value implements Built<Value, ValueBuilder> {
  ClassElement get element;

  factory Value(ClassElement element) =>
      new _$Value._(element: element);
}

void main() {
   var element = getElement();
   var value = new Value(element);
}
```


Or, where you want to set defaults for fields, you can now do this in the factory, instead of having to write your own builder class:

```
abstract class Value implements Built<Value, ValueBuilder> {
  int get x;
  int get y;
  bool get awesome;

  factory Value([updates(ValueBuilder b)]) =>
      new _$Value((b) => b
          ..awesome = True
          ..update(updates));
}

void main() {
  var value = new Value((b) => b
      ..x = 10
      ..y = 20);
}
```


Finally, if you like named arguments, you can expose the named-argument-based constructor instead of the builder-based constructor:

```
abstract class Value implements Built<Value, ValueBuilder> {
  int get x;
  int get y;

factory Value({int x, int y}) = _$Value._;

void main() {
  var value = new Value(x: 10, y: 20);
}
```


## 7. Prettier and customizable toString output

Before `1.0.0` built_value’s `toString` output was rather flat. Now, by default it’s indended, so it’s easy to read:

```
CompoundValue {
  simpleValue=SimpleValue {
    anInt=1,
  },
}
```


But, it’s also customizable, via a top-level global variable `newBuiltValueToStringHelper`. If you preferred the old format:

```
newBuiltValueToStringHelper =
    (className) => new FlatBuiltValueToStringHelper(className);
```


Then:

```
CompoundValue {simpleValue=SimpleValue {anInt=1}}
```


And if you want to write your own — of course you can. The `BuiltValueToStringHelper` class is very easy to implement:

```
abstract class BuiltValueToStringHelper {
  void add(String field, Object value);
  String toString();
}
```


## 8. Serializable DateTime and JsonObject

The SDK`DateTime` class is now serializable — provided you use UTC rather than local time zone. (Serializing with local time zone is a recipe for disaster!)

And, to help further with interop with existing JSON data and APIs, there is now a [`JsonObject`](https://github.com/google/built_value.dart/blob/master/built_value/lib/json_object.dart) class that wraps json values, lists and maps. Fields of type `JsonObject` serialize directly to and from raw JSON.

## 9. Custom matcher for tests

The generated `operator==` methods in built_value are already very handy for tests, but there’s one thing they don’t give you: easily readable error messages. Instead, when an ‘equals’ check in a test fails, you’ll get the full `toString` of the expected and actual values.

Not any more! You can now use `built_value_test`, a new pub package. If you [use it in a test](https://github.com/google/built_value.dart/blob/master/built_value_test/test/matcher_test.dart) you’ll now see errors like this:

```
was <3> instead of <5> at location ['simpleValue']['anInt']
```


If this looks a lot like the message you get when a map compare fails in a test, that’s because it’s the same: it’s implemented by converting the values to maps then comparing.

## 10. Implicit-dynamic and implicit-cast friendly code; better error messages

The code generated by built_value has been cleaned up significantly to make it pass two very strict lints: it no longer uses `dynamic` implicitly anywhere, and it no longer relies on implicit casts.

These two improvements may (or may not) lead to better code from the compiler.

And, better error messages were added for when you declare a serializer field with the wrong type.

That was it! Thanks for reading. If you have any ideas or feature requests for built_value, head on over to the [issue tracker](https://github.com/google/built_value.dart/issues).