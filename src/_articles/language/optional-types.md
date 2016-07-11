---
layout: article
title: "Optional Types in Dart"
description: "One of the Dart programming language's most innovative features is the use of optional types. This document seeks to explain how optional types work."
written: 2011-10-01
updated: 2012-09-01
category: language
---

_Written by Gilad Bracha<br>
October 2011 (updated September 2012)_


One of the Dart programming language's most innovative features
is the use of optional types.
This document seeks to explain how optional types work.

## Overview


The Dart language is dynamically typed. You can write programs that have no type
annotations whatsoever, and run them, much as you would in JavaScript.

You may choose to add type annotations to your program:

* Adding types will *not* prevent your program from
  compiling and running&mdash;even if
  your annotations are incomplete or plain wrong.
* Your program will have exactly the same semantics
  no matter what type annotations you add.

You can nevertheless profit from adding type annotations to your code.
Types provide the following benefits:

* Documentation for humans.
  It is much easier for people to read your code
  if it has judiciously placed type annotations.
* Documentation for machines.
  Tools can leverage type annotations in various ways.
  In particular, they can help provide nice features such as
  name completion and improved navigation in IDEs.
* Early error detection.
  Dart provides a static checker that can warn you about potential problems,
  without getting in your way.
  In addition, in developer mode,
  Dart automatically converts type annotations to runtime assertion checks
  as a debugging aid.
* Sometimes, types can help improve performance
  when compiling to JavaScript.
  We'll say more about this later.

## The static checker

The static checker acts a lot like lint in C.
It warns you about potential problems at compile-time.
Many of these warnings are related to types.
The static checker does *not* produce errors&mdash;you
can always compile and run your code, no matter what the checker says.

The checker does not scream about every possible type violation.
It is not a typechecker,
because Dart doesn't use types the way a classic type system does.
The checker complains about things that are very likely to be real problems,
rather than forcing you to jump through hoops
to satisfy a narrow-minded type system.

For example, consider the following code, which generates a
warning on the `p1 + p2` expression:

{% comment %}
gist: https://gist.github.com/Sfshaza/f046152d323ca12aadfa
dartpad: https://dartpad.dartlang.org/f046152d323ca12aadfa

class Point {
  final num x, y;
  Point(this.x, this.y);
  Point operator +(Point other) {
    return new Point(x+other.x, y+other.y);
  }
  String toString() {
    return "x: $x, y: $y";
  }
}

main() {
  Point p1 = new Point(0, 0);
  Point p2 = new Point(10, 10);

  int n = p1 + p2;

  print(n);
}
{% endcomment %}

<iframe
src="{{site.custom.dartpad.embed-dart-prefix}}?id=f046152d323ca12aadfa&horizontalRatio=99&verticalRatio=73"
    width="100%"
    height="500px"
    style="border: 1px solid #ccc;">
</iframe>

This is clearly a problem.

Click the **Run** button.
Note that the code still runs,
setting <code>n</code> to an instance of Point
and printing <code>x: 10, y: 10</code>.

However, unlike a classic mandatory type system, the following code
will not cause any complaints from the checker:

{% prettify dart %}
Object lookup(String key) { /* ... */ } // a lookup method in a heterogenous table
String s = lookup('Frankenstein');
{% endprettify %}

That's because there is a very good chance that the code is correct,
despite the lack of type information.
You, the programmer, often have semantic knowledge
that a typechecker does not.
You know that the value stored in the table under 'Frankenstein' is a string,
even though the lookup method is declared to return <code>Object</code>.

## Type dynamic

How does Dart avoid complaints when no types are provided?
The key to this is the type <code>dynamic</code>,
which is the default type given when no type
is explicitly given by the programmer.
Using type <code>dynamic</code> makes the checker shut up.

Occasionally, you may want to use <code>dynamic</code> explicitly.

{% prettify dart %}
Map<String, dynamic> m = {
    'one': new Partridge(),
    'two': new TurtleDove(),
    /* ..., */
    'twelve': new Drummer()};
{% endprettify %}

We could have used the type
<code>Map&lt;String, Object></code> for <code>m</code>,
but then, when we extracted the contents,
they would have static type <code>Object</code>,
about which very little is known.
Since the contents of the map have no common superinterface
other than <code>Object</code>,
we may prefer to use <code>dynamic</code>.
If we try to call methods on the map's values, for example,

{% prettify dart %}
pearTree = m['one'].container();
{% endprettify %}

we would get a warning if the contents were of type <code>Object</code>,
because <code>Object</code> does not support container.
If we use type <code>dynamic</code>, no warning is issued.

## Generics

Dart supports reified generics.
That is, objects of generic type carry
their type arguments with them at run time.
Passing type arguments to a constructor of a generic type
is a runtime operation.
How does this square with the claim that types are optional?

Well, if you don't want to ever think about types,
generics won't force you to.
You can create instances of generic classes without providing type parameters.
For example, the following code works just fine:

{% prettify dart %}
new List();
{% endprettify %}

Of course, you can write

{% prettify dart %}
new List<String>();
{% endprettify %}

if you want.

{% prettify dart %}
new List();
{% endprettify %}

is just a shorthand for

{% prettify dart %}
new List<dynamic>();
{% endprettify %}


In constructors, type parameters play a runtime role.
They are actually passed at run time,
so that you can use them when you do dynamic type tests.


{% prettify dart %}
new List<String>() is List<Object>  // true: every string is an object
new List<Object>() is List<String>  // false: not all objects are strings
{% endprettify %}


Generics in Dart conform to programmer intuition.
Here are some more interesting cases:


{% prettify dart %}
new List<String>() is List<int>     // false
new List<String>() is List          // true
new List<String>() is List<dynamic> // same as line above
new List() is List<dynamic>         // true, these are exactly the same
{% endprettify %}


In contrast, type annotations
(for example, types added to the declarations of variables,
or as return types of functions and methods)
play no runtime role and have no effect on program semantics.
One last case worth studying:


{% prettify dart %}
new List() is List<String>          // true as well!
{% endprettify %}


You may be writing your program without types,
but you will frequently be passing data into typed libraries.
To prevent types getting in your way,
generic types without type parameters are considered substitutable
(subtypes of) for any other version of that generic.


## Checked mode


Dart programs can be run in checked mode during development.
If you run a program in checked mode,
the system will automatically execute certain type checks
when passing in parameters,
when returning results,
and when executing assignments.
If the checks fail,
execution will stop at that point with a clear error message. So,


{% prettify dart %}
String s = new Object();
{% endprettify %}


will stop the code in its tracks,
because <code>Object</code> is not a subtype of <code>String</code>.
However


{% prettify dart %}
Object foo() {
  return "x";
}
String s = foo();
{% endprettify %}


works just fine,
because the actual object returned by foo at run time is a <code>String</code>,
even though the type signature says foo returns an <code>Object</code>.
When an object is assigned to a variable,
Dart checks that the runtime type of the object
is a subtype of the declared (static) type of the variable.



Essentially, checked mode is like running your program under the debugger
with watchpoints that run a subtype check on every assignment, return,
and so on.
Some more examples:


{% prettify dart %}
<int>[0,1, 1][2] = new Object(); // fails in checked mode

bar(int n) {
  return n *2;
}
...
bar(3.2); // returns 6.4 in production, but fails in checked mode
{% endprettify %}


In checked mode , every time an argument is passed to a function,
the runtime type of the argument is tested to see
if it is a subtype of the declared type of the formal parameter.
We can correct this easily:


{% prettify dart %}
bar(num n) {
  return n *2;
}

...

bar(3.2); // works fine

int i_bar(num n) {
  return n *2;
}

...

i_bar(3.2); // fails in checked mode
            // because returned value is not an int
{% endprettify %}


Notice the last line.
The check happens on returned values,
even if the result of the function is not assigned to anything.



Let's return to our old friend Frankenstein.


{% prettify dart %}
Object lookup(String key) { /* ... */ } // a lookup method in a heterogenous table
String s = lookup('Frankenstein');
{% endprettify %}


If we are correct in our assumption that the lookup returns a string,
checked mode will execute smoothly.
If we're wrong, it will catch our mistake for us.
In production mode, the code will run without complaint.
Assume the lookup actually returns an object that isn't a string,
say an instance of class <code>Frankenstein</code>.
The variable <code>s</code> will contain that instance.
In no case will Dart do a magical coercion into a string.
If it did, that would mean the type annotation
was modifying the behavior of our program,
and types would not be optional anymore.



Of course, if you don't use types at all,
checked mode won't get in your way.


{% prettify dart %}
my_add(s1, s2) {
  return s1 + s2;
}

my_add(3, 4); // 7
my_add(new Point(3, 3), new Point(4, 4)); // Point(7, 7)
{% endprettify %}


All these checks impose a considerable performance penalty,
so one cannot usually afford to run them in production.
The benefit of such checks is that they
can trap dynamic type errors at their source,
making it easier to debug problems.
Most such problems are detected during testing anyway,
but checked mode helps localize them.


## Using types


How you use types is up to you.
If you hate types, you need not use them at all.
You won't get any type warnings,
and you can develop in the style you feel comfortable with
in other dynamic languages.
You can still benefit from types,
because the Dart libraries have type signatures
that tell you what they expect and what they return.
If you run in checked mode, and pass bad arguments to the library,
checked mode will detect that at the point where you made the mistake.



If you love types, you may use them everywhere,
much like in a statically typed language.
However, even then you won't get the same level of static checking.
Dart's rules are much less rigid.
We anticipate providing additional tools
that might interpret type annotations more strictly
for those who like that sort of thing.



We don't recommend either of these extremes.
Use types where they make sense.
The most valuable thing you can do is add types
to the headers of public members of your libraries.
Next, do the same for the private ones.
Even if nobody else has to maintain the code,
you will find it helpful
if you leave the code and come back in a few weeks or months.
In both cases, you don't necessarily have to
add types to the bodies of methods or functions.
Users of the library get value from type signatures,
even if they are not 100% accurate.



Within the bodies of functions,
it may not always pay to annotate declarations.
Sometimes the code is simple enough that it doesn't really matter,
and types might just create clutter.



Usually, you should design your code
without letting type considerations influence your design.
In some cases, there are alternate designs,
one of which plays better with types than another.
For example, rather than passing around strings
denoting function names to be invoked,
if you can pass a function instead,
your code will be both more efficient and easier to typecheck.
Dart discourages gratuitous use of reflection by other means as well.
However, you should not hesitate to use reflection when it truly makes sense.

{% comment %}
The tests for this article are at /src/tests/site/articles/optional-types.
{% endcomment %}
