---
layout: default
permalink: /resources/dart-tips/dart-tips-ep-1
title: "A Simple Dart Script - Dart Tips, Ep 1"
description: "Welcome to Dart Tips, the video series that teaches you all about Dart. In our first episode, we show you a simple Dart script and get you comfortable with reading Dart code."
toc: false
---

<iframe class="dart-tips-video" src="//www.youtube.com/embed/g09UVKyYfIs"
frameborder="0" allowfullscreen></iframe>

[Back to all Dart Tips episodes](/resources/dart-tips/).

<hr>

### Transcript

Hi, I'm Seth Ladd, and welcome to our first episode of Dart Tips. Throughout this series, I'll teach you all about the Dart language and libraries in short, easy to watch videos. To kick things off, here is a quick orientation to a simple Dart script.

The designers of Dart built a scripting language that is generally free of ceremony, yet provides structure for larger apps and is analyzable by tools. Primarily a web development language, Dart must make it easy to write a few lines of code and then simply hit reload in your browser to see the changes. Those scripts must then be able to scale up to large, full-featured apps with potentially hundreds of thousands of lines of code. Therefore, Dart has to be terse, easy to read and write, structured with classes and libraries, and not force you into rituals or formalities.

This philosophy is evident in this very simple Dart program:

{% prettify dart %}
printNumber(num aNumber) {
  print('The number is $aNumber.');
}

main() {
  var answer = 42;          // The meaning of life.
  printNumber(answer);
}
{% endprettify %}

All Dart scripts starts with main(). Knowing exactly where the program starts is the first step to understanding the complete program structure, which in turn makes it easier for minimizers or other code-size reduction utilities to do a good job.

Dart is an optionally typed language, which means variables can be typed or untyped. Here we use var to declare that answer is an untyped variable with an initial value of 42 (an integer literal). The object that answer points is an int, but the variable itself is dynamic or untyped. Tools like Dart Editor can infer that the variable answer is an integer, but you can be even more clear by using type annotations.


{% prettify dart %}
main() {
  int answer = 42;
  printNumber(number);
}
{% endprettify %}

Here we have typed the answer variable as an int. Sometimes developers want to be more explicit, which is especially helpful when writing code that other developers will use. Dart's optional static types are an important topic, and we will cover them in more detail in a future episode. For now, just think of static types as inline documentation or type annotations that convey your intention to tools and fellow developers. Both versions of the script have the same runtime semantics, because type annotations are optional and the program runs as if you used var everywhere.

Everything in Dart is an object, and every object is an instance of a class. Even numbers and functions are objects.  So, yes, 42 is an object and not a primitive. Speaking of functions, let's look at the printNumber function.

Dart supports top-level functions, because again, sometimes you don't need full classes and it should be easy to start with the most simple thing that works. The printNumber function takes one parameter, which is typed as num and named aNumber. It is good Dart style to use type annotations in the "surface area" of your program, such as function signatures, because it makes it very easy to declare what the function expects.

Inside of printNumber, we use the built-in print() function to display "The number is 42" to the console. Notice the dollar sign followed by the name of a variable. This syntax, called string interpolation, includes a variable's value inside a string literal. This is a terse way to build strings.

Nothing new, but Dart uses the double-forward-slash as a one line comment. Dart also support the multi-line comment format made popular in other languages.

As you can see, Dart is unsurprising and familiar, which is exactly the point. We built a language that most developers can be productive with in a few hours or less. If you're have experience with C, C++, Java, ActionScript, C#, or JavaScript, you'll find Dart easy to learn. Don't let the familiar syntax fool you, though, for now that you know how to read Dart code, there are plenty of improvements and cool features to show off in future videos.

Thanks for watching. My name is Seth Ladd, and as we say here on Dart Tips, stay sharp.

<hr>

<img src="{% asset_path 'dart-tips/marakana-logo.png' %}" alt="Marakana Logo">

Our thanks go out to Marakana for producing this video series.

[Back to all Dart Tips episodes](/resources/dart-tips/).
