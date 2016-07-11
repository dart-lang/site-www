---
layout: default
permalink: /resources/dart-tips/dart-tips-ep-3
title: "Variables - Dart Tips, Ep 3"
description: "Dart is optionally typed, so variables can have type annotations. You can also mark variables as final to ensure they will point to one and only one object. Watch this episode to learn more about variables in Dart."
toc: false
---

<iframe class="dart-tips-video" src="//www.youtube.com/embed/_td6qXi_GmA"
frameborder="0" allowfullscreen></iframe>

[Back to all Dart Tips episodes](/resources/dart-tips/).

<hr>

### Transcript

Hi, my name is Seth Ladd and today on Dart Tips we continue our tour of the Dart language by taking a look at Variables. Think of a variable as a nickname you give to an object. Instead of referring to an object by some formal computer generated serial number, like A 3 2 6 C D 2 5 A, you can instead give it a meaningful name like "password" or "response code" or "home address". Once the object has a nickname, you can refer to it, ask it questions, or retrieve its data. Dart's variables are certainly familiar and easy to learn, but there are a few cool features like optional types to show off. Let's get started.

{% prettify dart %}
var answer = 42;
{% endprettify %}

 Here is a simple Dart variable, initialized with a value. There are three parts to this statement:  var which declares it as a dynamic variable,  answer which is the nickname or variable name for an object,  and 42 which is the object itself.

We say a variable is a reference to an object because a variable simply refers to some object living in the virtual machine. It helps to remember that Dart is a purely object oriented language, where everything is an object. Variables are how you get a handle to these objects.

I used var to declare the variable is dynamic, which means that the variable is perfectly happy to refer to any type of object. Using var is a terse way to write Dart code, especially when the variable is initialized with an obvious value. Tools such as Dart Editor can easily infer that this variable refers to an object of type integer.

However, sometimes it's beneficial to be more explicit with the types variables can refer to.

{% prettify dart %}
var result;
{% endprettify %}

 For example, here is a variable that is not initialized to a specific value. It's impossible for the tools, or your fellow developers, to know what you intend to do. What is result supposed to refer to? A number? A string?

Luckily, you can easily say "I expect this variable to refer to an integer" with Dart's type annotations.

{% prettify dart %}
int result;
{% endprettify %}

 Here is an example of a Dart variable annotated as an integer. Notice how var is replaced by int. It's clear that I'm saying "I expect result to refer to integers".

{% prettify dart %}
int age;
age = "hello"; // checked mode will throw an error!
{% endprettify %}

 If you accidentally assign an object that is not an integer to the variable, as this example shows, Dart's checked mode will throw an error, all thanks to the use of type annotations. You can learn more about checked mode in a previous video, but for now all you need to know is checked mode gives you feedback if an object's type does not match its variable's type.

So, type annotations are great when variables are declared but not initialized, but that leads to the question: What value is an uninitialized variable set to by default? That is, if you don't initialize a variable with a value, what value does it have?

{% prettify dart %}
int age;

// or

var age;
{% endprettify %}

 Specifically, what is the variable age set to in this example? Hint: it doesn't matter if a type annotation is used.

{% prettify dart %}
var age;
// is the same as
var age = null;
{% endprettify %}

 Any variable that is not initialized when it is declared has the default value of null. In other words, if you don't set an initial value when you declare a variable, it is set to null. This is a simple rule, and is not affected by the presence of a type annotation (because, remember, type annotations are optional).

 (to blank screen)

Finally, pun intended, as is the case in most programming languages, variables in Dart have the ability to be, well, fickle. They can refer to one object, and then another, without a care in the world.

{% prettify dart %}
var name = 'Bob';
// later
name = 'Alice';
{% endprettify %}

 Here in this example, the variable name refers first to the String 'Bob' and then later to the string 'Alice'. This is confusing, because code might have an assumption that a variable refers to one and only object object. In some cases, if a variable gets reassigned, subtle bugs crop up. What if you could catch those bugs earlier by saying "this variable should always refer to this object, and that's final"?

{% prettify dart %}
final name = 'Bob';
// later
name = 'Alice'; // COMPILE ERROR
                // can't reassign final variable
{% endprettify %}

 Luckily in Dart, you can mark a variable as final, which means the variable cannot be reassigned after it is initialized. In other words, a final variable is one that has been given an object "for the final time" and no more object assignments are allowed. If you do attempt to reassign the variable, as this example shows, the code will fail to compile.

{% prettify dart %}
final String name = 'Bob';
{% endprettify %}

 Using final with type annotations is similar. As shown in this example, you can use both the keyword final and a type annotation at the same time.

Using final is good practice to clearly mark variables that should not be reassigned. Many subtle bugs can occur when a variable is accidently assigned to a different object. The keyword final is another way to clearly express your intent to your tools and fellow developers.

We'll revisit final after we introduce classes and objects, and there's the whole const thing we haven't even talked about yet, so we're not completely done with variables. But we'll leave the rest to future episodes.

The short short version of today's show: variables in Dart can be dynamic or typed; variables are given a default value of null unless otherwise initialized; and variables can be marked as final to ensure they only ever point to one and only one object.

Thanks for watching. My name is Seth Ladd, and as we say here on Dart Tips, stay sharp.

<hr>

<img src="{% asset_path 'dart-tips/marakana-logo.png' %}" alt="Marakana Logo">

Our thanks go out to Marakana for producing this video series.

[Back to all Dart Tips episodes](/resources/dart-tips/).
