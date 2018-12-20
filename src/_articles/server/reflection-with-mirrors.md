---
title: "Reflection in Dart with Mirrors: An Introduction"
description: "Use the dart:mirrors library for introspection: discovering and using your program's structure."
original-date: 2012-11-30
date: 2013-11-07
category: libraries
obsolete: true
---

_Written by Gilad Bracha <br />
November 2012 (updated November 2013)_

<aside class="alert alert-info" markdown="1">
**Note:** This article applies only to the standalone VM under the
1.x Dart SDK. We don't recommend using mirrors in web applications,
and the Flutter SDK does not support the dart:mirrors library.
</aside>

Reflection in Dart is based on the concept of _mirrors_,
which are simply objects that reflect other objects.
In a mirror-based API,
whenever one wants to reflect on an entity,
one must obtain a separate object called a mirror.

Mirror-based reflective APIs have substantial advantages
with respect to security, distribution, and deployment.
On the other hand,
using them is sometimes more verbose than older approaches.

For a thorough introduction to the rationale for mirror-based reflection,
see the references at the end of this document.
However, you don’t need to delve into all that if you don’t want to;
what you really need to know about Dart’s mirror API will be covered here.

<aside class="alert alert-warning" markdown="1">
<strong>Caveat 1:</strong>
Dart's mirror API is evolving; while most of the introspection API
is stable, there will be some additions and
adjustments going forward, even post 1.0.
</aside>

At this time, only part of the planned API has been realized.
The part that exists deals with _introspection_,
the ability of a program to discover and use its own structure.
The introspection API has been largely implemented on the Dart VM.

The introspection API is declared in the library named `dart:mirrors`.
If you wish to use introspection, import it:

{% prettify dart %}
import 'dart:mirrors';
{% endprettify %}

For the sake of illustration,
we’ll assume you’ve defined the following class:

{% prettify dart %}
class MyClass {
  int i, j;
  int sum() => i + j;

  MyClass(this.i, this.j);

  static noise() => 42;

  static var s;
}
{% endprettify %}


The easiest way to get a mirror is to call the top-level function
[reflect()]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/reflect.html).

<aside class="alert alert-warning" markdown="1">
<strong>Caveat 2:</strong>
Currently, reflection works only if the reflection code
and the object being reflected are running in the same isolate.
In the future, we expect to extend the API to support reflection
across isolates.
</aside>

The reflect() method takes an object and returns an
[InstanceMirror]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/InstanceMirror-class.html)
on it.

{% prettify dart %}
InstanceMirror myClassInstanceMirror = reflect(new MyClass(3, 4));
{% endprettify %}

InstanceMirror is a subclass of
[Mirror]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/Mirror-class.html),
the root of the mirror hierarchy.
An InstanceMirror allows one to invoke dynamically chosen code on an object.

{% prettify dart %}
InstanceMirror f = myClassInstanceMirror.invoke(#sum, []);
// Returns an InstanceMirror on 7.
{% endprettify %}

The invoke() method takes a symbol (in this case, #sum)
representing the method name,
a list of positional arguments,
and (optionally) a map describing named arguments.


Why doesn't invoke() take a string representing the method name?
Because of _minification_.
Minification is the process of mangling names in web programs in
order to reduced download size.

Symbols were introduced into Dart to help reflection work
in the presence of minification.
The big advantage of symbols is that when a Dart program is minified,
symbols get minified as well.
For this reason, the mirror API traffics in symbols rather than strings.
You can convert between symbols and strings;
typically, you will do that in order to
print out names of declarations as we'll see below.

Suppose you want to print out all the declarations in a class.
You’ll need a
[ClassMirror]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/ClassMirror-class.html),
which as you’d expect reflects a class.
One way to get a class mirror is from an instance mirror.

{% prettify dart %}
ClassMirror MyClassMirror = myClassInstanceMirror.type; // Reflects MyClass
{% endprettify %}

Another way is to use the top-level function
[reflectClass()]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/reflectClass.html).

{% prettify dart %}
ClassMirror cm = reflectClass(MyClass); // Reflects MyClass
{% endprettify %}

Once we've obtained a class mirror `cm` by whatever means,
we can print out the names of all declarations of the class
reflected by `cm`.

{% prettify dart %}
for (var m in cm.declarations.values) print(MirrorSystem.getName(m.simpleName));
{% endprettify %}

ClassMirror has a getter
[declarations]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/ClassMirror/declarations.html)
that returns a map from the names of the reflected class’ declarations
to mirrors on those declarations.
The map contains all declarations listed
explicitly in source code of the class:
its fields and methods (including getters,
setters and regular methods) be they static or not,
and constructors of all stripes.
The map will not contain any inherited members, nor any synthetic members,
such as the getters and setters generated automatically for fields.

We extract the values from the map;
each of these will be a mirror on one of the declarations of MyClass,
and will support the getter `simpleName` that returns
the name of the declaration.
The returned name is a Symbol,
so we must convert it to a string in order to print it.
The static method
[MirrorSystem.getName]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/MirrorSystem/getName.html)
does that for us.

Obviously, we know what the declarations in MyClass are in this case;
the point is that the `for` loop above works for any class mirror,
and therefore we can use it to print the declarations of any class.

{% prettify dart %}
printAllDeclarationsOf(ClassMirror cm) {
  for (var m in cm.declarations.values) print(MirrorSystem.getName(m.simpleName));
}
{% endprettify %}

A number of methods in the mirror API
return maps in a similar fashion.
The maps allow you to look up members by name,
to iterate over all the names, or to iterate over all the members.
In fact, there is a simpler way to accomplish what we just did.

{% prettify dart %}
printAllDeclarationsOf(ClassMirror cm) {
  for (var k in cm.declarations.keys) print(MirrorSystem.getName(k));
}
{% endprettify %}

What if we want to invoke static code reflectively?
We can call invoke() on a ClassMirror as well.

{% prettify dart %}
cm.invoke(#noise, []); // Returns an InstanceMirror on 42
{% endprettify %}

In fact, invoke() is defined in class
[ObjectMirror]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/ObjectMirror-class.html),
a common superclass for mirror classes
that reflect Dart entities that have state and executable code
such as regular instances, classes, libraries, and so on.

Here is a complete example incorporating what we’ve done so far:

{% prettify dart %}
import 'dart:mirrors';

class MyClass {
  int i, j;
  void my_method() {  }

  int sum() => i + j;

  MyClass(this.i, this.j);

  static noise() => 42;

  static var s;
}

main() {
  MyClass myClass = new MyClass(3, 4);
  InstanceMirror myClassInstanceMirror = reflect(myClass);

  ClassMirror MyClassMirror = myClassInstanceMirror.type;

  InstanceMirror res = myClassInstanceMirror.invoke(#sum, []);
  print('sum = ${res.reflectee}');

  var f = MyClassMirror.invoke(#noise, []);
  print('noise = $f');

  print('\nMethods:');
  Iterable<DeclarationMirror> decls =
      MyClassMirror.declarations.values.where(
        (dm) => dm is MethodMirror && dm.isRegularMethod);
  decls.forEach((MethodMirror mm) {
    print(MirrorSystem.getName(mm.simpleName));
  });

  print('\nAll declarations:');
  for (var k in MyClassMirror.declarations.keys) {
    print(MirrorSystem.getName(k));
  }

  MyClassMirror.setField(#s, 91);
  print(MyClass.s);
}
{% endprettify %}

And here’s the output:

{% prettify %}
sum = 7
noise = InstanceMirror on 42

Methods:
my_method

sum

noise

All declarations:
i
j
s
my_method

sum
noise
MyClass
91
{% endprettify %}

At this point we’ve shown you enough to get started.
Some more things you should be aware of follow.

<aside class="alert alert-warning" markdown="1">
<strong>Caveat 3:</strong>
What you deploy is often less than what you wrote.
This may interact with reflection in annoying ways.
</aside>

Because the size of web applications needs to be kept down,
deployed Dart applications may be subject to minification and tree shaking.
We discussed minification above;
_Tree shaking_ refers to the elimination of source code that isn’t called.
Both of these steps cannot generally detect reflective uses of code.

Such optimizations are a fact of life in Dart,
because of the need to deploy to JavaScript.
We need to avoid downloading the entire Dart platform
with every web page written in Dart.
Tree shaking does this by detecting
what method names are actually invoked in the source code.
However, code that is invoked based on dynamically computed symbols
cannot be detected this way, and is therefore subject to elimination.

The above means that the actual code that exists at runtime
may differ from the code you had during development.
Code you only used reflectively may not be deployed.
Runtime reflection is only aware of what actually exists at
runtime in the running program.
This can lead to surprises.
For example, one may attempt to reflectively invoke a method
that exists in the source code,
but has been optimized away because no non-reflective invocations exist.
Such an invocation will result in a call to
[noSuchMethod()]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object/noSuchMethod.html).
Tree shaking has implications for structural introspection as well.
Again, what members a library or type has at runtime
may be at variance with what the source code states.

In the presence of mirrors, one could choose to be more conservative.
Unfortunately, since one can obtain mirrors for any object in an application,
all code in the application would have to be preserved,
including the Dart platform itself.
Instead, we may choose to treat such invocations
as if the method never existed in the source.

We are experimenting with mechanisms
for programmers to specify that certain code
may not be eliminated by tree shaking.
Currently, you may use the
[MirrorsUsed]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/MirrorsUsed-class.html)
annotation for this purpose
but we expect the details to change significantly over time.

<aside class="alert alert-warning" markdown="1">
<strong>Caveat 4:</strong>
One thing we can promise you is that MirrorsUsed will change.
If you use it, be prepared for breaking changes.
</aside>

The above should be enough to get you started using mirrors.
There is a good deal more to the introspection API;
you can
[explore the API]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-mirrors/dart-mirrors-library.html)
to see what else is there.

We’d like to support more powerful reflective features in the future.
These would include _mirror builders_,
designed to allow programs to extend and modify themselves,
and a mirror-based debugging API as well.


## References

Gilad Bracha and David Ungar.
_[Mirrors: Design Principles for Meta-level Facilities of Object-Oriented
Programming Languages](http://www.bracha.org/mirrors.pdf)._
In  Proc. of the ACM Conf. on Object-Oriented Programming,
Systems, Languages and Applications, October 2004.

Gilad Bracha.
_[Linguistic Reflection via Mirrors](http://www.hpi.uni-potsdam.de/hirschfeld/events/past/media/100105_Bracha_2010_LinguisticReflectionViaMirrors_HPI.mp4)._
Screencast of a lecture at HPI Potsdam in January 2010.  57 minutes.

These blog posts on mirrors may also prove useful
(and less time consuming to digest):

* Gilad Bracha.
  [Through the Looking Glass Darkly](http://gbracha.blogspot.com/2010/03/through-looking-glass-darkly.html).
* Allen Wirfs-Brock.
  [Experimenting with Mirrors for JavaScript](http://www.wirfs-brock.com/allen/posts/228).
* Gilad Bracha.
  [Seeking Closure in the Mirror](http://gbracha.blogspot.com/2012/07/seeking-closure-in-mirror.html).

{% comment %}
The tests for this article are at /src/tests/site/articles/reflection-with-mirrors.
{% endcomment %}
