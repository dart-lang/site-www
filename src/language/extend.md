---
title: Extend a class
description: Learn how to create subclasses from a superclass.
prevpage:
  url: /language/methods
  title: Methods
nextpage:
  url: /language/mixins
  title: Mixins
---

Use `extends` to create a subclass, and `super` to refer to the
superclass:

<?code-excerpt "misc/lib/language_tour/classes/extends.dart" replace="/extends|super/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }
  // ···
}

class SmartTelevision [!extends!] Television {
  void turnOn() {
    [!super!].turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
  // ···
}
{% endprettify %}

For another usage of `extends`, see the discussion of
[parameterized types][] on the Generics page.

## Overriding members

Subclasses can override instance methods (including [operators][]),
getters, and setters.
You can use the `@override` annotation to indicate that you are
intentionally overriding a member:

<?code-excerpt "misc/lib/language_tour/metadata/television.dart (override)" replace="/@override/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
class Television {
  // ···
  set contrast(int value) {...}
}

class SmartTelevision extends Television {
  [!@override!]
  set contrast(num value) {...}
  // ···
}
{% endprettify %}

An overriding method declaration must match
the method (or methods) that it overrides in several ways:

* The return type must be the same type as (or a subtype of)
  the overridden method's return type.
* Argument types must be the same type as (or a supertype of)
  the overridden method's argument types.
  In the preceding example, the `contrast` setter of `SmartTelevision`
  changes the argument type from `int` to a supertype, `num`.
* If the overridden method accepts _n_ positional parameters,
  then the overriding method must also accept _n_ positional parameters.
* A [generic method][] can't override a non-generic one,
  and a non-generic method can't override a generic one.

Sometimes you might want to narrow the type of
a method parameter or an instance variable.
This violates the normal rules, and
it's similar to a downcast in that it can cause a type error at runtime.
Still, narrowing the type is possible
if the code can guarantee that a type error won't occur.
In this case, you can use the 
[`covariant` keyword](/guides/language/sound-problems#the-covariant-keyword)
in a parameter declaration.
For details, see the 
[Dart language specification][].

{{site.alert.warning}}
  If you override `==`, you should also override Object's `hashCode` getter.
  For an example of overriding `==` and `hashCode`, see
  [Implementing map keys](/guides/libraries/library-tour#implementing-map-keys).
{{site.alert.end}}

## noSuchMethod()

To detect or react whenever code attempts to use a non-existent method or
instance variable, you can override `noSuchMethod()`:

<?code-excerpt "misc/lib/language_tour/classes/no_such_method.dart" replace="/noSuchMethod(?!,)/[!$&!]/g"?>
{% prettify dart tag=pre+code %}
class A {
  // Unless you override noSuchMethod, using a
  // non-existent member results in a NoSuchMethodError.
  @override
  void [!noSuchMethod!](Invocation invocation) {
    print('You tried to use a non-existent member: '
        '${invocation.memberName}');
  }
}
{% endprettify %}

You **can't invoke** an unimplemented method unless
**one** of the following is true:

* The receiver has the static type `dynamic`.

* The receiver has a static type that
defines the unimplemented method (abstract is OK),
and the dynamic type of the receiver has an implementation of `noSuchMethod()`
that's different from the one in class `Object`.

For more information, see the informal
[noSuchMethod forwarding specification.](https://github.com/dart-lang/language/blob/main/archive/feature-specifications/nosuchmethod-forwarding.md)

[parameterized types]: /language/generics#restricting-the-parameterized-type
[operators]: /language/methods#operators
[generic method]: /language/generics#using-generic-methods
[Dart language specification]: /guides/language/spec
