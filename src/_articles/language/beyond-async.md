---
title: "Dart Language Asynchrony Support: Phase 2"
description: "Async*, sync*, yield, and yield* are now available as part of Dart's asynchrony support."
written: 2015-03-24
category: language
obsolete: true
---

<h2>Async*, sync*, and all the rest</h2>

_Written by Gilad Bracha <br>
March 2015_

In a [previous article](/articles/language/await-async),
we discussed asynchronous methods and await expressions.
These features are part of a complete initiative to support asynchronous
programming and generators in Dart.

## Generators

Dart 1.9 introduced <em>generator functions</em>. These are functions that
lazily compute a sequence of results.  There are two
kinds of generators&mdash;synchronous and asynchronous. A synchronous generator
produces values on demand&mdash;consumers pull the values from the generator. An
asynchronous generator produces values at its own pace, and pushes them out
where consumers can find them.

### Why support generators in the language?

One can implement generators by hand, but that can be tricky and is certainly
tedious.

To implement a synchronous generator, you need to define your own iterable
class. You can subclass `IterableBase` but you'll still need to
declare the class and implement the `iterator` method which
will have to return a new iterator. To do that, you’ll have to
declare your own iterator class.  You’ll need to implement the members
`moveNext()` and `current` which track and update the
position of the iterator, detecting when the you’ve
reached the end of the underlying iterable (and whether it was empty to begin
with).  It’s no big deal&mdash;we know you love programming and this is a great
CS101 exercise. However, maybe, just maybe, you want to spend your time
programming something else. Synchronous generator functions are sugar for
implementing such iterables.

Asynchronous generators are even more fun to write by hand.  Instead of just
boilerplate, you get to write tricky boilerplate. You have to ensure that
everything works when your stream gets paused or canceled, for example.

Dart’s new built-in generator support makes  things much easier, as we'll see
below.

### Synchronous generators: sync\*

Marking a function body with the **sync\*** modifier identifies
the function as a synchronous generator, and relieves the
programmer of much of the boilerplate involved in defining an iterable
manually.

Suppose we want to produce the first <em>n</em> natural numbers.
It is quite easy to do this with a synchronous generator.

{% prettify dart %}
Iterable naturalsTo(n) [!sync*!] {
  int k = 0;
  [!while!] (k < n) [!yield!] k++;
}
{% endprettify %}

When called, `naturalsTo` immediately returns an iterable
(much like a function marked **async** immediately returns
a future), from which you can extract an iterator.
The body of the function won’t start running until one calls
`moveNext` on that iterator. It will run until it hits
the **yield** statement the first time.
The **yield** statement contains an expression,
which it evaluates.  Then, the function suspends,
and `moveNext` returns `true` to its caller.

The function will resume execution the next time `moveNext`
is called.  When the loop ends, the method implicitly executes a
**return**, which causes it to terminate. At that point,
`moveNext` returns `false` to its caller.

Using ordinary iterators, this can be surprisingly tedious,
as one has to define specialized iterator and iterable classes and
implement the complete `Iterable` API.

#### The devil’s details

You can separate the **sync** from the \*;
they are distinct tokens. If you have existing code that used
sync as an identifier, you can continue to do so.
The word **sync** is not a true reserved word.
Similar comments apply to **async**,
**await**, and **yield**.
They are only treated as reserved words inside asynchronous or generator
functions (i.e., those marked **async**, **sync\***
or **async\***).

Bear in mind that this adherence to strict compatibility comes at a cost.
Say you forget to use a modifier such as **sync\*** on a function,
and use a **yield** statement inside.
The parser may get very confused and give rather bewildering error messages.

### Asynchronous generators: async\*

To asynchronously produce a sequence, we use streams. One can
implement streams manually using `Stream` and allied classes.
Asynchronous generator functions are sugar for implementing such streams.
Marking a function body with the **async\*** modifier
identifies the function as an asynchronous generator.

Let’s try generating natural numbers again, asynchronously this time.


{% prettify dart %}
Stream asynchronousNaturalsTo(n) [!async*!] {
  int k = 0;
  [!while!] (k < n) [!yield!] k++;
}
{% endprettify %}

Invoking this function immediately returns a stream&mdash;just as invoking a
**sync\*** function immediately returns an iterable,
and invoking an **async** function immediately returns a
future (perhaps you discern a pattern here).

Once you listen to the stream, execution of the body begins.
When the **yield** statement executes,
it adds the result of evaluating its expression to the stream. It doesn’t
necessarily suspend (though in the current implementations it does).

In any event, whatever function is listening on the stream will get called with
each new value at some point. The initiative is not the consumer’s, however;
the stream pushes the value to the listener function at its pleasure.

#### Fine print

As a variant, consider

{% prettify dart %}
Stream [!get!] naturals [!async*!] {
  int k = 0; [!while!] ([!true!]) { [!yield await!] k++; }
}
{% endprettify %}

This example raises an interesting question: since the code runs in a tight,
infinite loop and **yield** doesn’t suspend,
when is any listener going to get to run to look at the results?
We could require that **yield** always suspend,
but that can hurt performance.
The only requirement is that the function does suspend eventually so that some
other code can run and pull values out of the stream.

The stream associated with an **async\*** function could get
paused or canceled.
If an **async\*** function executes a **yield**
and its stream has been canceled, control transfers to the nearest enclosing
finally clause. If the stream has been paused,
execution suspends before the **yield**,
until the stream is resumed.
Refer to the [Dart language spec](/guides/language/spec) for all the gory details.

## await-for

As every Dart programmer knows, the **for-in**
loop plays well with iterables. Similarly, the **await-for**
loop is designed to play well with streams.

Given a stream, one can loop over its values:

{% prettify dart %}
[!await for!] (int i [!in!] naturals) { print(‘event loop $i’); }
{% endprettify %}

Every time an element is added to the stream, the loop body is run. After each
iteration, the function enclosing the loop suspends until the next element is
available or the stream is done. Just like **await** expressions,
**await-for** loops can only appear inside asynchronous functions.

## yield\*

While the use of **yield** is attractive, you can run into problems.
If you are writing a recursive function, you can get quadratic behavior.
Consider the following function,
designed to count backwards from <em>n</em> to 1.

{% prettify dart %}
Iterable naturalsDownFrom(n) [!sync*!] {
  [!if!] (n > 0) {
     [!yield!] n;
     [!for!] (int i in naturalsDownFrom(n-1)) { [!yield!] i; }
  }
}
{% endprettify %}

The code above is functionally correct, but runs in quadratic time.
Notice that `yield i;` is executed _n − 1_ times for the
_nth_ element in the sequence:
once at each level of recursion; the first element, 3,
is only yielded by the `yield n;` statement;
the second element, 2, is yielded once by `yield n;` and once by `yield i;`
The third element is 1, which is yielded once by
`yield n;` and twice by `yield i;`.
Altogether we have _n(n − 1)_ executions of
`yield i;`, which is _O(n<sup>2</sup>)_.

The **yield\*** (pronounced yield-each) statement is designed to get
around this problem.  The expression following `yield*` must denote
another (sub)sequence.  What `yield*` does is to insert all the elements
of the subsequence into the sequence currently being constructed,
as if we had an individual `yield` for each element.
We can rewrite our code using yield-each as follows:


{% prettify dart %}
Iterable naturalsDownFrom(n) [!sync*!] {
  [!if!] ( n > 0) {
    [!yield!] n;
    [!yield*!] naturalsDownFrom(n-1);
 }
}
{% endprettify %}

The latter version runs in linear time.

#### Fine print

In a **sync\*** function, the subsequence must be an iterable;
in an **async\*** method, the subsequence must be a stream.
It is a runtime error if they are not.
Of course, you will also get a static warning in such a case.

The subsequence can be empty.
In that case, **yield\*** skips over it without suspending.

