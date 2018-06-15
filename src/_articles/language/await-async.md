---
title: "Dart Language Asynchrony Support: Phase 1"
description: "Async and await, two language features that support asynchronous programming, are now available in Dart."
written: 2014-10-24
category: language
obsolete: true
---

_Written by Gilad Bracha <br>
October 2014_

New language features to support asynchronous programming are coming to Dart.
These features are coming online gradually. In this article, we'll discuss
the most basic additions: `await` expressions and `async` methods.
These are the most commonly used features related to asynchrony.

<aside class="alert alert-info" markdown="1">
**Note:**
This article assumes that you are already familiar with asynchronous
programming in Dart.
</aside>

{% include async-await-2.0.html %}

{% comment %}
update-for-dart-2
{% endcomment %}

## Async functions

An **async** function is a function whose body is marked with an **async**
modifier.

{% prettify dart %}
foo() [!async!] => 42;
{% endprettify %}

When you call an **async** function, it immediately returns a Future;
the body of the function is scheduled for execution later.
When the body has executed, the Future that was returned by the call
is completed with the result&ndash;regardless of whether the body
ran successfully, or raised an exception. In the trivial example
provided, calling `foo()` results in a Future.
The Future eventually completes with the number 42.

You could have written a similar function without the async modifier:

{% prettify dart %}
foo() => new Future(() => 42);
{% endprettify %}

The modifier saves you some boilerplate, but the real point is that it
allows you to use **await** expressions inside the function, as we'll
see shortly. Later, we'll return to **async** functions to understand them
more fully.

## Await expressions

Await expressions let you write asynchronous code almost as if it were
synchronous. Suppose you have a variable `myFile` that refers to a
file. (For details on files, see the
[File]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/File-class.html) class in
[`dart:io`]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-io/dart-io-library.html).)
You decide to copy it to a new location `newPath`, declared as

{% prettify dart %}
String newPath = '/some/where/out/there';
{% endprettify %}

You'd expect the following to be true:

{% prettify dart %}
myFile.copy(newPath).path == newPath;
{% endprettify %}

Unfortunately, that won't work. Since Dart's I/O API is asynchronous,
the copy operation returns a [Future]({{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Future-class.html),
and you can't call `path` on that. You must schedule a callback on the
Future returned from `copy()`, and that callback performs the
comparison with its incoming parameter `f`:

{% prettify dart %}
myFile.copy(newPath).then((f) => f.path == newPath);
{% endprettify %}

This is a tad tedious, but gets much worse the more involved your code is.
What you really want to do is to wait until the asynchronous file copy
operations completes, get the result, and resume execution.
An `await` expression lets you do exactly that:

{% prettify dart %}
([!await!] myFile.copy(newPath)).path == newPath;
{% endprettify %}

When the **await** expression runs, `myFile.copy()` is invoked, yielding
a Future. Execution then suspends, waiting for the Future to complete.
After the Future has completed to a file, execution resumes.
The value of the **await** expression is the completion of the
Future&ndash;the file we were waiting for. Now we can extract its path
and compare it to `newPath`.

In general, an **await** expression has the form:

<pre>
<b>await</b> <i>e</i>
</pre>

where _e_ is a unary expression. Typically, _e_ is an asynchronous
computation and is expected to evaluate to a Future. The **await**
expressions evaluates _e_, and then suspends the currently running
function until the result is ready&ndash;that is, until the
Future has completed. The result of the **await** expression is
the completion of the Future.

<aside class="alert alert-info" markdown="1">
**Note:**
After suspension, execution resumes in a later cycle of the event loop.
For a description of the Dart event loop, see
[The Event Loop and Dart]({{site.webdev}}/articles/performance/event-loop).
</aside>

If the Future completed with an error rather than with a value,
the **await** expression throws that same error when execution resumes,
which greatly simplifies the handling of exceptions in asynchronous code.

What if _e_ does not evaluate to a Future? Well, **await** waits anyway
(technically, it wraps the result in a Future and waits for it to
complete in the event loop cycle). This is one of the differences
between Dart and similar features in other languages. In Dart, **await**
always awaits. This makes the behavior more predictable. In particular,
if you have a loop with an unconditional **await** inside, you can
always be sure that you will suspend on each iteration.

What if _e_ itself throws an exception?
(Note that this is not the same as evaluating
to a Future that completes with an error.) The thrown exception is
wrapped in a Future and execution suspends. When we resume, the
exception is thrown. Again, suspension is predictable.

One last but crucial point: you can only use an **await** expression
inside an **async** function. If you try and use **await** in an ordinary
function, you'll get a compilation error. If you were to suspend an ordinary
function, it wouldn't be synchronous anymore.

## Async functions: the fine print

Now that we understand how **await** expressions work, let's revisit
**async** functions so we're clear on some important details.

First, notice that the modifier goes between the function signature and
its body. We could also have written `foo()` as

{% prettify dart %}
foo() [!async!] { return 42; }
{% endprettify %}

In short, the modifier comes before the => or the curly brace that opens
the function body.

The modifier is not part of the signature; it is just an implementation
detail of the function. From the caller's perspective, invoking an
**async** function is no different from invoking a traditional one.

The **async** modifier has no effect on the declared return type of the
function either, for the same reason. However, it does change what type
of object is actually returned. Notice that the return statement returns
an integer, but the function has already returned a Future to its caller!
Inside an **async** function, the return statement operates differently
than within a regular function. In an **async** function **return**
completes the Future that the function returned to the caller when it
was invoked. The Future gets completed with the value of the expression
being returned.

Likewise if you throw (or rethrow) an exception inside an **async** function,
the object being thrown is used to complete the Future with an error.

If the expression being returned has type `T`, the function should have
return type `Future<T>` (or a supertype thereof). Otherwise, a static
warning is issued. Our examples don't declare a return type, so
they have return type **dynamic**&ndash;therefore no warning is given.

If the expression inside the return statement is a `Future<T>`, the
function return type should remain as `Future<T>` not
`Future<Future<T>>`. There is not much you can do with a Future that
has completed to another Future except wait some more, so layers of
Futures are eliminated by the async library. The type discipline is
designed to recognize that fact.

Finally, notice that an **async** function in Dart is always
asynchronous. This is unlike **async** functions in other languages,
where the function may, in some cases, be completely synchronous.
In Dart, you know that _every_ part of an async function is
executing after the call that invoked it has returned to the caller.

## Putting it all together

Here is an example that incorporates what we've learned so far.
Suppose we are running a simple animation which updates the display
on every frame.

Without using **async** and **await**, the code might look something like
this:


{% prettify dart %}
import "dart:html";

main() {
  var context = querySelector("canvas").context2D;
  var running = true;    // Set false to stop.

  tick(time) {
    context.clearRect(0, 0, 500, 500);
    context.fillRect(time % 450, 20, 50, 50);

    if (running) window.animationFrame.then(tick);
  }

  window.animationFrame.then(tick);
}
{% endprettify %}

It's not too complicated, but not totally simple either. We produce a frame;
when the frame is done, we expect to invoke a callback function, `tick()`,
that produces the next frame (if the animation hasn't been stopped)
and passes itself as the callback recursively, perpetuating the process.
The function `tick()` represents the continuation of the computation, and we
all know how intuitive and easy continuations are.

Using our new language features, we can write the following instead:

{% prettify dart %}
import "dart:html";

main() async {
  var context = querySelector("canvas").context2D;
  var running = true;    // Set false to stop game.

  while (running) {
    var time = await window.animationFrame;
    context.clearRect(0, 0, 500, 500);
    context.fillRect(time % 450, 20, 50, 50);
  }
}
{% endprettify %}

Here the code is self explanatory. While the animation is running, we
compute a frame. The choice is yours; pick whichever version you find
easier to understand.

## More information

For information on more advanced asynchrony topics, such as **async\***,
**sync\***, **yield**, and **yield\***, see
[Dart Language Asynchrony Support: Phase 2](/articles/language/beyond-async).
