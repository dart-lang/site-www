---
layout: default
permalink: /resources/dart-tips/dart-tips-ep-11
title: "Classes: Constructors - Dart Tips, Ep 11"
description: "Dart offers many types of constructors, including an implementation of the factory pattern. Learn more about constructors, field initialization, named constructors, and factory constructors in Dart."
toc: false
---

<iframe class="dart-tips-video" src="//www.youtube.com/embed/k2R_HwZzogQ"
frameborder="0" allowfullscreen></iframe>

[Back to all Dart Tips episodes](/resources/dart-tips/).

<hr>

### Transcript

Hi, my name is Seth Ladd, and welcome to this episode of Dart Tips! Today we
talk about Constructors. Fun fact! You can build a constructor in Dart that
controls which object instance is returned. There's lots of cool features with
constructors in Dart, so let's get started!

Constructors are responsible for building and returning an instance of a
class. Let's start by looking at the constructors everyone is familiar with:
what we call generative constructors. Here is an example:

{% prettify dart %}
class FluffyBunny {
  String name;
  num fluffiness;

  FluffyBunny(String name, num fluffiness) {
    this.name = name;
    this.fluffiness;
  }
}
{% endprettify %}

Not a lot of surprises here. The name of the constructor matches the name of the
class. But whoa, that's a lot of repetition! The word name is repeated three
times in the constructor alone! Surely, we can do better! And indeed we can.

Check this out:

{% prettify dart %}
class FluffyBunny {
  String name;
  num fluffiness;

  FluffyBunny(this.name, this.fluffiness);
}
{% endprettify %}

If the constructor argument's name is the same as a field, you can prepend the
argument with this dot. This is just syntactic sugar for the longer form
`this.name = name` and `this.fluffiness = fluffiness`. Less typing is always a
good thing.

Use the new keyword to create a new instance of a class. Here is an example of
calling a constructor with arguments.

{% prettify dart %}
var floppy = new FluffyBunny('floppy', 0.72);
{% endprettify %}

A new instance of FluffyBunny is created, with both name and fluffiness set. Of
course, the last parameter, 0.72, isn't exactly obvious.  Luckily, constructors
can use optional parameters just like functions and method. Here is an example:

{% prettify dart %}
class FluffyBunny {
  String name;
  num fluffiness;

  FluffyBunny(this.name, {this.fluffiness});
}

var floppy = new FluffyBunny('floppy', fluffiness: 0.72);
{% endprettify %}

Now it's a bit easier to read and understand that last parameter.

If your class does not explicitly define a constructor, a default constructor is
provided for you. Here's an example of a Point class with two fields and no
explicit constructor.

{% prettify dart %}
class Point {
  num x;
  num y;

  // A default, no-arg constructor
  // is provided for you if
  // no other constructor is defined.
  // Point() : super();
}

var point = new Point();
{% endprettify %}

The default constructor has zero arguments and invokes the no-argument
constructor of its superclass.

I now want to show you one of my favorite features of Dart: named constructors.
First, some background. In traditional statically typed languages, you can
overload methods by the types of parameters passed to those methods. Because
Dart is optionally typed, you can't overload methods based on type. Which isn't
a big deal, because you can just create differently named methods.
Traditionally, though, you were stuck with a single name for the constructor
(the name of the class often had to match the name of the constructor) and thus
you wouldn't have been able to create multiple constructors. The designers of
the Dart language realized this and introduced named constructors as a way to
allow you to define multiple different constructors for a class.

Here is an example of named constructors at work:

{% prettify dart %}
class FluffyBunny {
  FluffyBunny.fromXml(String xml) {
    // …
  }

  FluffyBunny.fromJson(String json) {
    // ...
  }
}

var xml = "<bunny><name>floppy</name></bunny>";
var json = '{"bunny":{"name":"peter"}}';

var floppy = new FluffyBunny.fromXml(xml);
var peter = new FluffyBunny.fromJson(json);
{% endprettify %}

Notice how the new keyword is still used. I really like named constructors
because they provide an easy to read call site and they clearly state their
intention. In this case, both constructors take a string, and it's obvious how
those strings will be used.

One nice feature of the Dart language is that all final fields are fully
initialized before the this handle is available. In other words, final fields
must be set before the constructor body is run. To calculate and set the value
of final fields, you can use an initializer list. Here is an example:

{% prettify dart %}
import 'dart:math';

class Point {
  final num x;
  final num y;
  final num distanceFromOrigin;

  Point(x, y)
      : x = x,
        y = y,
        distanceFromOrigin = sqrt(pow(x, 2) + pow(y, 2));

}
{% endprettify %}

The initializers after the colon are the initializer list. The this handle is
not available in the initializer list, because at this point the object is not
yet fully created.

Here, Point is immutable because all fields are final. Setting x and y is
straightforward. The distanceFromOrigin field must be calculated, but it is
final, so we can't calculate and set it in the constructor body.

Because this isn't available in the initializer list, you can't call instance
methods in the initializer list. However, top-level functions (like square root,
show here) and static methods are OK to use.

Speaking of initializer lists, we can now talk about calling superclass
constructors. As you see here, you can place the call to the superclass's
constructor in the initializer list.

{% prettify dart %}
class Bunny {
  String name;

  Bunny(this.name);
}

class FluffyBunny extends Bunny {
  num fluffiness;

  FluffyBunny(String name, this.fluffiness) : super(name);
}
{% endprettify %}

It's important to understand that all field initializers are run before
constructor bodies are run. This means that the constructor body of the
superclass isn't run until all fields from both the subclass and superclass are
initialized. We recommend you place the call to the super constructor at the end
of the initializer list to make the order more clear.

If you don't explicitly call a superconstructor, a constructor will call the
default, no-arg constructor of its superclass.

{% prettify dart %}
class Bunny {
  Bunny() {
    print('in bunny');
  }
}

class FluffyBunny extends Bunny {
  FluffyBunny() {
    print('in fluffy');
  }
}

main() {
  var floppy = new FluffyBunny();

  // in bunny
  // in fluffy
}
{% endprettify %}

In this case, when you create a new FluffyBunny, you'll see "in bunny" and then
"in fluffy". If the superclass does not have a default no-arg constructor, you
will need to explicitly call a constructor from the superclass.

We've so far seen many examples of what we call generative constructors. These
traditional constructors create a new instance of the surrounding class and
return it. While familiar, generative constructors are a bit limiting. Modular
and composable software applications require more flexible ways to build and
return objects, and entire suites of design patterns have popped up to
compensate for traditional constructor shortcomings.

One popular pattern is the Factory Pattern, with examples in many frameworks or
toolkits. However, without native language support for the factory pattern, most
implementations have to implement it with combinations of static methods and or
utility classes. While this works, it exposes the pattern to the consumer of the
code. Luckily, the designers of Dart added the factory pattern right into the
language. With Dart's factory constructors, you can natively use the factory
pattern and make it appear like a regular constructor.

One great use case for factory constructors is to return objects from a cache.
Here's the code:

{% prettify dart %}
class Symbol {
  final String name;
  static Map<String, Symbol> _cache = new Map<String, Symbol>();

  factory Symbol(String name) {
    if (_cache.containsKey(name)) {
      return _cache[name];
    } else {
      final symbol = new Symbol._internal(name);
      _cache[name] = symbol;
      return symbol;
    }
  }

  Symbol._internal(this.name);
}
{% endprettify %}

Notice how the constructor is declared as a factory constructor. Inside the
constructor body, the cache is checked and if the symbol exists, it is returned.
Else, a new symbol is created, added to the cache, and then returned.

Using this class is easy, because there's no special syntax to use a factory
constructor. Get an instance with 'new':

{% prettify dart %}
main() {
  var x = new Symbol('X');
  var alsoX = new Symbol('X');

  print(identical(x, alsoX));  // true
}
{% endprettify %}

Both `x` and `alsoX` point to the same object, so they are identical.

Because the user of the class doesn't know the constructor is really a factory,
the original author of the code is free to refactor regular constructors into
factory constructors without forcing clients to change their code. In other
words, start with a generative constructor and if you later change to a factory
constructor, no one needs to know.

Here's another cool fact about factory constructors: they can even return
instances that are subclasses of the surrounding class. What other constructors
can control what type of object is returned? I think this is very cool.

So remember kids, while Dart might look like your friendly, neighborhood
structured language, it has productive features like terse field initialization,
named constructors, and factory constructors.

Thanks for watching, my name is Seth Ladd, and as we say here on Dart Tips, stay
sharp!


<hr>

<img src="{% asset_path 'dart-tips/marakana-logo.png' %}" alt="Marakana Logo">

Our thanks go out to Marakana for producing this video series.

[Back to all Dart Tips episodes](/resources/dart-tips/).
