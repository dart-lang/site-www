---
layout: default
permalink: /resources/dart-tips/dart-tips-ep-9
title: "Exceptions - Dart Tips, Ep 9"
description: "Learn how to gracefully handle exceptions and errors in Dart. Don't get caught off guard the next time you run into an error, learn more about try, catch, finally, and throw."
toc: false
---

<iframe class="dart-tips-video" src="//www.youtube.com/embed/J94I70uqr6w"
frameborder="0" allowfullscreen></iframe>

[Back to all Dart Tips episodes](/resources/dart-tips/).

<hr>

### Transcript

Hi, my name is Seth Ladd and today on Dart Tips we talk about Exceptions. You
know, those errors that bubble up from deep within the bowels of your program
and tell you where something went wrong. Watch this episode so you won't be
caught off guard the next time you run into a problem. Let's get started!

Dart uses exceptions when an error or other exceptional event occurs inside your
program. When a situation arises that cannot be handled by the program or
runtime (for example when the system runs out of memory or invalid input was
provided) normal program execution stops and an exception is created. This
exception object is then thrown down the call stack, looking for someone to
catch it. If no code handles the exception, the program exits.

Common error cases include:

* out of memory
* invalid input
* incorrect state transitions
* meaningless arguments
* and more

The Dart SDK classifies most problems as errors and thus most of the exception
class names in the SDK end with error. The name error is shorter than exception,
and generally there's nothing exceptional about many of the problems. They are
flat-out errors as in "don't do it". For this video, we'll use the name
exception to mean "errors or exceptions thrown by the program or runtime".

Normally, you know an exception or error has occurred when you encounter a stack
trace. They look something like this:

    Bad state: door already closed
    #0      Room.closeDoor (file:///Users/sethladd/Code/dart_tips/bin/episode09.dart:14:7)
    #1      example02 (file:///Users/sethladd/Code/dart_tips/bin/episode09.dart:48:17)
    #2      main (file:///Users/sethladd/Code/dart_tips/bin/episode09.dart:57:12)

This report has useful information to help you determine what happened and where
it happened. For example, we know:

* there was an unhandled exception
* the exception was "Bad state: door already closed"
* the problem occurred inside the closeDoor method
* at line 14
* in episode09.dart

I feel like it's a game of clue... "in the parlor, with the candlestick, on line
14".

We can also trace the execution of the program, from the main function to the
openDoor method. This is very useful information when diagnosing and debugging
exceptions.

OK, with that introduction, let's look at some code. There are four specific
concepts to explore: throw, try, catch, and finally. Each shows up as syntax
that you can use in your program.

In general, exceptions in Dart aren't that invasive. For example, you can throw
any non-null object. Dart methods and functions do not declare the exceptions
they can throw, and you aren't required to catch for exceptions a method might
throw.

To signal an error or exception has occurred, use throw. This is also known as
raising an exception. Here is an example:

{% prettify dart %}
openDoor() {
  if (doorLocked) {
    throw new StateError('door locked');
  }
{% endprettify %}

If the door is locked, you can't open it, so the program signals this problem by
throwing an instance of StateError.

Remember, you can throw any non-null object as an exception. The Dart SDK ships
classes for many common exceptions, and you can extend the Exception class to
create your own more specific exceptions.

For example, you may want to create a specific DoorLockedError class. Here is an
example:

{% prettify dart %}
class DoorLockedError extends StateError {
  DoorLockedError(String msg) : super(msg);
}
{% endprettify %}

We'll cover classes in a future episode, but for now it's enough to understand
that DoorLockedError is a specific type of StateError.

When an object is thrown, the current function or method does not continue, and
the exception object travel through the stack, looking for someone to handle it.
Normally, you should handle exceptions gracefully and provide some sort of
mitigation or feedback to the user. Use the catch clause to capture exceptions.

Here is an example:

{% prettify dart %}
try {
  room.openDoor();
  room.enter(person);
} catch(exception, stackTrace) {
  print(exception);
  print(stackTrace);
}
{% endprettify %}

Wrap any code that might throw an exception inside of a try block. Exceptions
thrown from within the try block are handled by the catch block. The exception
variable is the exception object itself. The stackTrace object is, no surprise
here, the stack trace.

It's important to note that if openDoor() throws an exception, then enter() is
never called. Control of the program jumps to the catch block on exception.

If an exception is caught, you will see the following output:

    Bad state: door locked
    #0      Room.openDoor (file:///Users/sethladd/Code/dart_tips/bin/episode09.dart:20:7)
    #1      example02 (file:///Users/sethladd/Code/dart_tips/bin/episode09.dart:70:16)
    #2      main (file:///Users/sethladd/Code/dart_tips/bin/episode09.dart:121:12)

The first line is the exception object, and the following lines are from the
stack trace object.

Here is a shorter example. You can of course name these variables however you
like. You can even omit the stack trace.

{% prettify dart %}
try {
  room.openDoor();
  room.enter(person);
} catch(e) {
  print(e);
}
{% endprettify %}

Some methods can throw different exceptions, based on different conditions. For
example, the enter() method can throw a StateError if the door is not open, or
it can throw an ArgumentError if the expected argument is null.

Here is how you catch different types of exceptions:

{% prettify dart %}
try {
  room.openDoor();
  room.enter(person);
} on StateError catch(e) {
  doubleCheckDoor();
} on ArgumentError catch(e) {
  reloadPerson();
} catch(e) {
  print(e);
}
{% endprettify %}

You can use on to specify what kind of exception you want to catch. You can
specify multiple on clauses, and you can specify a catch-all as the last catch
clause.

You can use on or catch or both. If you don't care about the actual exception
object, you can omit catch:

{% prettify dart %}
try {
  // …
} on StateError {
  // …
}
{% endprettify %}

Sometimes you need to ensure code runs no matter what, whether or not an
exception is thrown. Use the finally clause to make sure code is always run.
Here is an example:

{% prettify dart %}
try {
  room.openDoor();
  room.enter(person);
} catch(e) {
  // ...
} finally {
  room.reset();
}
{% endprettify %}

If no exception is thrown, finally runs. If an exception is thrown from within
the try clause, catch runs, and then finally runs. In this example, the room is
always reset.

To recap, Dart has familiar try / catch / finally clauses. You can throw any
non-null object as an exception, and many common error cases are found in the
Dart SDK. You can have many catch clauses for a try clause, each for a specific
exception type. The finally clause runs whether or not an exception was thrown.
Client code is not forced to catch for exceptions, so it's up to you to
determine when and how to handle potential errors.

Thanks for watching, I'm Seth Ladd, and as we say here on Dart Tips: stay sharp!

<hr>

<img src="{% asset_path 'dart-tips/marakana-logo.png' %}" alt="Marakana Logo">

Our thanks go out to Marakana for producing this video series.

[Back to all Dart Tips episodes](/resources/dart-tips/).
