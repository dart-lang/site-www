---
layout: default
permalink: /resources/dart-tips/dart-tips-ep-8
title: "Control Flow Statements - Dart Tips, Ep 8"
description: "Take back control and learn more about Dart's control flow statements. All the greatest hits are here: if, while, for, and switch. Plus, this video shows you a helpful tweak that should make web developers quite happy."
toc: false
---

<iframe class="dart-tips-video" src="//www.youtube.com/embed/XdqZdsdzD2A"
frameborder="0" allowfullscreen></iframe>

[Back to all Dart Tips episodes](/resources/dart-tips/).

<hr>

### Transcript

Hi, my name is Seth Ladd, and welcome to this episode of Dart Tips. Today, we take back control and look at Dart's control flow statements. All the greatest hits are here: if, while, for, and switch. Plus, I'll show you a helpful tweak that should make web developers quite happy. Join us right now, on Dart Tips.

First up, if and else. No big surprises here. The conditional if statement can be followed by zero or more else-if statements, and can end with an _else_ statement. Here is an example:

{% prettify dart %}
if (isRaining()) {
  you.bringRainCoat();
} else if (isSnowing()) {
  you.wearJacket();
} else {
  car.putTopDown();
}
{% endprettify %}

However, I do want to point out that the condition must resolve to a boolean. In Dart, only the boolean value _true_ is true; all other values are treated as false. Consider this example:

{% prettify dart %}
String name = '';

if (name) {
  // will never be reached
} else {
  // a string is not a bool, so it is false
}
{% endprettify %}

Here, the variable _name_ is a string. Of course, a string is not a bool, and therefore the _else_ block is run.

Here is the correct way to write this code. You must be more explicit, but the advantage is that the rules for truthy and falsely values are very simple to remember.

{% prettify dart %}
// instead
if (name != null && !name.isEmpty) {
  congrats(name);
} else {
  tryAgain();
}
{% endprettify %}

For very simple conditions, you can write an if statement on one line of code. Here is an example:

{% prettify dart %}
recurse(List items) {
  if (items == null || items.isEmpty) return;
  // …
}
{% endprettify %}

You might use this pattern at the beginning of a function, when you need to check a simple condition and bail out early. Most of the time, Dart style prefers multi-line if statements with explicit curly braces.

For looping, pun definitely intended, Dart has for-loops. Like if statements, for loops look quite familiar. Here is an example:

{% prettify dart %}
var message = new StringBuffer("Dart is fun");
for (var i = 0; i < 5; i++) {
  message.add('!');
}
{% endprettify %}

Let's consider a more complex example. Here, callbacks are created inside of a for-loop, each closing around the loop variable i. After the loop, each callback is run, printing out its number.

{% prettify dart %}
var callbacks = [];
for (var i = 0; i < 2; i++) {
  callbacks.add(() => print(i));
}
callbacks.forEach((c) => c());
{% endprettify %}

The question is, what will print out? Or, a better question is, what would you expect to print out? Unlike traditional web programming languages, Dart will print 0 and then 1. Why is this?

{% prettify dart %}
callbacks.forEach((c) => c());
  // 0, 1
{% endprettify %}

Inside a for-loop, each iteration gets its own variable. This prevents common errors when using closures inside of loops.

If you want to iterate over a collection, or any iterable, and you don't care about the loop variable, you can use the for-in style loop.

Here is an example of a for-in loop.

{% prettify dart %}
var fruits = ['apples', 'pears', 'oranges'];
for (var fruit in fruits) {
  print(fruit);
}
{% endprettify %}

The for-in loop is just syntactic sugar for the longer iterator form:

{% prettify dart %}
var fruits = ['apples', 'pears', 'oranges'];

var iterator = fruits.iterator;
while (iterator.moveNext()) {
  var fruit = iterator.current;
  print(fruit);
}
{% endprettify %}

Either form works, but I'm partial to for-in as it's shorter. And shorter means less code. And less code means less chance for me to get it wrong.

When you want to loop while a condition is true, you can use the while and do-while loops. Unlike the for-loop, which counts up or down or moves through a collection, the while and do-while lists more simply run a block of code until a condition is false. Here is an example:

The while loop evaluates the condition before the loop, and repeats the loop as long as the condition is true.

{% prettify dart %}
while(peopleAreClapping()) {
  playSongs();
}
{% endprettify %}

The while loop is a good choice if you want to check a condition before entering the loop for the first time.

The do-while loop, however, evaluates the condition _after_ the loop. This means the loop block is run at least one time.

{% prettify dart %}
do {
  processRequest();
} while(stillRunning());
{% endprettify %}

You can control a loop's execution with break and continue. Use _break_ to stop looping. Here is an example:

{% prettify dart %}
while (true) {
  if (shutDownRequested()) break;
  processIncomingRequests();
}
{% endprettify %}

If shutDownRequested returns true, the program breaks out of the loop.

You can use _continue_ to skip to the next loop iteration. Here is an example:

{% prettify dart %}
for (var i = 0; i < bigNumber; i++) {
  if (i.isEven)
    continue;

  reticulateSplines(i);
  oddIsTheNewBlack(i);
  cleanUp(i);
}
{% endprettify %}

You can usually use if and else statements instead of continue, but sometimes it's a bit easier on the eyes to use continue. This example wants to work with only odd numbers, so the even numbers are skipped. I'd consider continue a "sometimes" statement, used sparingly.

Finally, in order to help with efforts to port old code over to Dart, there is the switch statement. While the syntax looks familiar, there are numerous caveats.

{% prettify dart %}
var command = 'OPEN';

switch (command) {
  case 'CLOSED':
    executeClosed();
    break;
  case 'OPEN':
    executeOpen();
    break;
  case 'APPROVED':
    executeApproved();
    break;
  default:
    executeUnknown();
}
{% endprettify %}

You can only compare integer, string, or compile-time constants. The compared objects must be instances of the same class (and not of any of its subtypes), and the class must not override ==.

One surprising aspect of switch in Dart is that non-empty case clauses must end with break, or less commonly, continue, throw, or return. That is, non-empty case clauses cannot fall through. You must explicitly end a non-empty case clause, usually with a break. You will get a static warning if you omit break, continue, throw, or return, and the code will error at that location at runtime.

{% prettify dart %}
var command = 'OPEN';
switch (command) {
  case 'OPEN':
    executeOpen();
    // ERROR: Missing break causes an exception to be thrown!!

  case 'CLOSED':
    executeClosed();
    break;
}
{% endprettify %}

I keep saying "non-empty" case clauses, why is that? It turns out that Dart supports empty case clauses, which do fall through. Here is an example:

{% prettify dart %}
var command = 'CLOSED';
switch (command) {
  case 'CLOSED':     // Empty case falls through.
  case 'LOCKED':
    // Runs for both CLOSED and LOCKED.
    denyEntry();
    break;
}
{% endprettify %}


The denyEntry() method runs for both CLOSED and LOCKED. The CLOSED case clause is empty, and thus does not require a break.

As with many other switch statements, you can end a switch statement with a _default_ clause. Here is an example:

{% prettify dart %}
var command = 'OPEN';
switch (command) {
  case 'CLOSED':
    executeClosed();
    break;
  case 'PENDING':
    executePending();
    break;
  default:
    executeUnknown();
}
{% endprettify %}


If no case clause matches, the default clause will run.

I hope you enjoyed this tour of Dart's control flow statements. Thanks for watching. I'm Seth Ladd, and as we say here on Dart Tips, stay sharp.

<hr>

<img src="{% asset_path 'dart-tips/marakana-logo.png' %}" alt="Marakana Logo">

Our thanks go out to Marakana for producing this video series.

[Back to all Dart Tips episodes](/resources/dart-tips/).
