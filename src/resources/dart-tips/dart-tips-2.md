---
layout: default
permalink: /resources/dart-tips/dart-tips-ep-2
title: "Runtime Modes - Dart Tips, Ep 2"
description: "Dart runs fast in production mode, and runs with type assertions in checked mode. Learn about Dart's two runtime modes and when to use each of them for maximum developer feedback and speed."
toc: false
---

<iframe class="dart-tips-video" src="//www.youtube.com/embed/CfRFixQTJWA"
frameborder="0" allowfullscreen></iframe>

[Back to all Dart Tips episodes](/resources/dart-tips/).

<hr>

### Transcript

Hi, I'm Seth Ladd and this is Dart Tips. Today we're going to talk about the different runtime modes of Dart. Dart apps can run in a virtual machine, named not surprisingly the Dart VM, and Dart apps can be compiled to JavaScript to run in modern browsers. For this episode, I am going to focus on the Dart VM and its two runtime modes: a speed-obsessed production mode and a developer friendly checked mode. Let's get started!

To understand why there are two runtime modes, we first have to understand how static types work in Dart. Dart is an optionally typed and dynamic language, which means that variables can be annotated with static types, or variables can be untyped (also known as dynamic). The philosophy behind this design decision will be explored in a future episode, but for now it's important to understand that you as a developer have a choice of when and how to use static type annotations.

So, what are type annotations?

This is an example of an untyped dynamic variable:

{% prettify dart %}
var answer = 42;
{% endprettify %}

Notice how I used var to denote a dynamic variable. Obviously the object pointed to by the variable is an instance of a specific class (in this case, an int) but the variable itself simply has the dynamic type.

In contrast, this is the same variable with a static type annotation:

{% prettify dart %}
int answer = 42;
{% endprettify %}

Type annotations in Dart precede the variable name. In this case, the answer variable is of type int.

Now that I've shown examples of both untyped and typed code, we can see what the two runtime modes do with these type annotations.

In the default runtime mode of Dart, also known as production mode, these two lines have the exact same runtime semantics. This is because, in production mode, type annotations are ignored. That's right, in the default runtime mode of Dart, the program runs as if you used var everywhere.

This means that, in production mode, this line of code compiles and runs. I know it looks strange, and I don't recommend ever writing code like this.

{% prettify dart %}
String result = 1 + 2;
{% endprettify %}

In production mode, type annotations are ignored, and the compiler treats the code like this, which of course works just fine.

{% prettify dart %}
var result = 1 + 2;
{% endprettify %}

Remember, Dart is, at its core, a dynamic scripting language. Types are optional and thus the VM must, in production mode, execute the code as if all static type annotations did not exist. Production mode actually gets a speed boost by ignoring static types, because it can avoid many type checks.

Production mode gets its name because this is how we want you to deploy your Dart apps to production: using the fastest runtime mode in the VM.

Just because production mode ignores static types, doesn't mean you might as well use var for everything. Static types are great for inline documentation and the VM has another runtime mode that does perform type checks at runtime.

In this second mode, named checked mode, the VM inserts dynamic type assertions. If checked mode notices a case where types don't match up, it will throw an exception. Developing and testing in checked mode helps you catch potential bugs early based on type annotations. In other words, in checked mode the type annotations do affect how the program runs.

Going back to our line of code that looks so very strange, it's clear that the expression 1 + 2 evaluates into an integer and not a String.

{% prettify dart %}
String result = 1 + 2;
{% endprettify %}

Here the type of the variable does not match the type of the right-hand side expression. In checked mode, this mismatch is caught at runtime and surfaced as an exception.

In checked mode, when the program is compiled, type assertions are dynamically inserted into the code. The VM adds something like this approximation:

{% prettify dart %}
String result;
var tempResult = 1 + 2;
if (tempResult is! String) {
  throw "Type Mismatch!!";
} else {
  result = tempResult;
}
{% endprettify %}

Notice how the type of tempResult's value is compared to result's static type. If they don't match, an exception is thrown. Otherwise, result's value is set and the program continues. Getting this kind of feedback in the event of a type mismatch is really helpful when developing and debugging your app.

Understanding Dart's two runtime modes, and how they interact with static type annotations, is important to getting the most out of Dart. Use checked mode to catch type mismatches during development and testing. For the utmost in speed, use production mode when your app ships to production. Consult the documentation to learn how to toggle these modes in the command-line Dart VM and Dart Editor.

Thanks for watching. My name is Seth Ladd, and as we say here on Dart Tips, stay sharp.

<hr>

<img src="{% asset_path 'dart-tips/marakana-logo.png' %}" alt="Marakana Logo">

Our thanks go out to Marakana for producing this video series.

[Back to all Dart Tips episodes](/resources/dart-tips/).
