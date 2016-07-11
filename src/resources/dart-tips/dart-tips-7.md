---
layout: default
permalink: /resources/dart-tips/dart-tips-ep-7
title: "Functions Are Fun, Pt 2 - Dart Tips, Ep 7"
description: "Functions are true objects in Dart. Watch this video to learn more about nested functions, functions as arguments, and lexical closures. Get ready for more FUNctional tips in Dart!"
toc: false
---

<iframe class="dart-tips-video" src="//www.youtube.com/embed/RJujzs2ts4s"
frameborder="0" allowfullscreen></iframe>

[Back to all Dart Tips episodes](/resources/dart-tips/).

<hr>

### Transcript

Hi, my name is Seth Ladd and welcome to this episode of Dart Tips. Today we continue our tour of the fundamentals of Functions by looking at functions as objects, nested functions, functions are arguments, and lexical closures. Get ready for more FUNctional tips about functions in Dart, right now. Let's get started.

Dart is a true object-oriented language, so even functions are objects. This means functions can be assigned to variables, passed as arguments to other functions, and more.

To start, check this out, Function is defined in the core library as an abstract class. This means there is a function type, and a function value is a subtype of the Function class.

Just like you can assign objects to variables, here's an example of assigning a fua function object to a variable.

{% prettify dart %}
loudPrint(String msg) {
  print(msg.toUpperCase());
}

var loudify = loudPrint;

loudify('Dart is fun');
  // DART IS FUN
{% endprettify %}

Notice how you can call the loudify variable just like a normal function.

You can also assign an anonymous function directly to a variable, like this:

{% prettify dart %}
var loudify = (msg) => print(msg.toUpperCase());
loudify('Dart is funtastic');
  // DART IS FUNTASTIC
{% endprettify %}

You might use this technique if you want to retain a handle on the function so that, for example, you can add or remove it from some collection.

Now that you know you can treat functions as objects, you can start to do some even more fun things. For example, here is an example of filtering a list of numbers down to only even numbers, and then printing them all out:

{% prettify dart %}
[0, 1, 2, 3].where((n) => n.isEven).forEach((n) => print(n));
{% endprettify %}

We can simplify this code, by simply passing print to forEach.

{% prettify dart %}
[0, 1, 2, 3].where((n) => n.isEven).forEach(print);
  // 0, 2
{% endprettify %}

This works because forEach() wants to be passed a single function that takes a single argument. The print function just so happens to be a function that takes a single argument. Ta da!

Building on this example, let's say you need to filter on a complicated condition. You could write the code this way:

{% prettify dart %}
[0, 1, 2, 3].where((n) {
  if (checkStockQuotes() > 500 && dayOfWeek != 'Thursday') {
    return true;
  } else if (llamasNotYetFed() && checkStockQuotes() < 500) {
    return false;
  } else {
    return new Random().nextBool();
  }
}).forEach(print);
{% endprettify %}

Yuck! That's a big complicated chunk of code in the middle of an otherwise pretty line. Surely, we can do better!

Thanks to Dart's support for nested functions, yes we can! Here is an example:

{% prettify dart %}
main() {
  complicatedCheck(n) {
    if (checkStockQuotes() > 500 && dayOfWeek != 'Thursday') {
      return true;
    } else if (llamasNotYetFed() && checkStockQuotes() < 500) {
      return false;
    } else {
      return new Random().nextBool();
    }
  }

  [0, 1, 2, 3].where(complicatedCheck).forEach(print);
}
{% endprettify %}

Ahh, much better. Notice how we created a new, named function inside of main(), which is itself a function. The complicatedCheck function is a nested function. The where-forEach chain is now much easier to read.

You can define your own functions that take functions as parameters. Here is an example:

{% prettify dart %}
filterAndPrint(List items, Function filter) {
  items.where(filter).forEach(print);
}

filterAndPrint([8,9,10], (n) => n.isEven);
  // 8, 10
{% endprettify %}

Notice how the second parameter is annotated as the type Function. This code works, but it doesn't tell you much about what the filter function should expect in terms of arguments or what it should return. All we know is that it's a Function.

We generally recommend that you use type annotations for the functions you expect as arguments. Here is an example:

{% prettify dart %}
filterAndPrint(List items, bool filter(int n)) {
  items.where(filter).forEach(print);
}

filterAndPrint([8,9,10], (n) => n.isEven);
  // 8, 10
{% endprettify %}

Notice how in this example, it's clear that filter should return a bool and should take a single parameter, ideally of type int. Now, with this extra type information, tools like Dart Editor can give better warnings if you try to pass in a filter that doesn't match the description.

Before we tackle our last topic, let's review Dart's scoping rules. Dart is a lexically scoped language, which means that the scope of variables is determined statically, simply by the layout of the code. I like to think of lexical scope as "follow the curly braces outwards".

Here is an example of nested functions with variables at each scope level:

{% prettify dart %}
var topLevel = true;

main() {
  var insideMain = true;
  myFunction() {
    var insideFunction = true;

    nestedFunction() {
      var insideNestedFunction = true;

      print(topLevel);
      print(insideMain);
      print(insideFunction);
      print(insideNestedFunction);
    }
  }
}
{% endprettify %}

Notice how nestedFunction can reach variables at every level, all the way up to the top level. Dart's scoping rules are very easy to reason about, it's very much  "what you see is what you get". Dart's lexical scope even works with "this", but we'll cover that more in an episode about classes.

Now that we've looked at lexical scope, let's take a look at functions as closures. A closure is a function object that has access to variables in its lexical scope, even when the function is used outside of its original scope. Closures are popular in other scripting languages, like JavaScript, and Dart is no stranger to lexical closures.

Here is an example of a function that "closes around" its variable.

{% prettify dart %}
makeAdder(int addBy) {
  adder(int a) {
    return a + addBy;
  }
  return adder;
}

var add2 = makeAdder(2);
var result = add2(1);
  // 3
{% endprettify %}

Notice how makeAdder has a nested function named adder that adds two numbers. makeAdder's parameter, addBy, is lexically visible to adder. Then, makeAdder returns the function object adder, which at that moment creates a closure. So far, so good.

[CLICK] Let's use makeAdder to create a new adder, in this case the function add2. Calling the add2 function with 1 returns, you guessed it, 3. This is lexical closures in action, because add2 closes around addBy, whose value was originally passed to makeAdder.

To really drill the point home, notice how you can create more adders with makeAdder, each one not affected by the other. Here is an example of making an adder that adds 100. Notice how add100 is independent of add2.

{% prettify dart %}
var add100 = makeAdder(100);
var newResult = add100(1);
 // 101

var five = add2(3);  // still works!
{% endprettify %}

Dart's support for lexical scope, and lexical closures, really helps you compose your functions and apps. The better the composure, encapsulation, and reusability, the better the code.

Thanks for watching this episode of Dart Tips. My name is Seth Ladd, and as we say here on Dart Tips, stay sharp! See you next time.

<hr>

<img src="{% asset_path 'dart-tips/marakana-logo.png' %}" alt="Marakana Logo">

Our thanks go out to Marakana for producing this video series.

[Back to all Dart Tips episodes](/resources/dart-tips/).
