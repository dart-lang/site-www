---
layout: default
permalink: /resources/dart-tips/dart-tips-ep-4
title: "Strings, Numbers, Booleans, Oh My! - Dart Tips, Ep 4"
description: "The trifecta of built-in types is strings, numbers, and booleans. Watch this episode to learn how to initialize them with literals, the difference between ints and doubles, and what is truthy and falsely in Dart."
toc: false
---

<iframe class="dart-tips-video" src="//www.youtube.com/embed/-LmD0hghGjo"
frameborder="0" allowfullscreen></iframe>

[Back to all Dart Tips episodes](/resources/dart-tips/).

<hr>

### Transcript

Hi, my name is Seth Ladd and welcome to this episode of Dart Tips. Today we sharpen our understanding of Dart's basic built-in types. The building blocks of any program, Dart has support for numbers, strings, and booleans. They are all objects, you can initialize them from literal values, and you can't get very far without them. Let's get started!

Numbers, strings, and booleans are easy to use because you can create them from literal values. Every object in Dart is an instance of a class, but these built-in types can be initialized without having to use a constructor with the new keyword. Let's see literals in action and start our tour with numbers.

 Dart has two types of numbers. Integers are arbitrary precision, which means they can grow to arbitrary size on the Dart VM. Doubles are 64-bit floating point numbers that conform to IEEE-754 standard.

 You can create instances of these classes using literals. For example, here are some integers. Notice how you create a new instance of a number simply by using its literal value.

A little warning, though. Very large integers will work in the Dart VM but not when compiled to JavaScript. This is a known issue, so stay tuned.

{% prettify dart %}
// doubles
var pi = 3.14159;
double astronomicalUnitInMiles = 92,955,807.273;
var result = 6.72e9; // 6720000000.0
{% endprettify %}

 Number literals with a decimal point are doubles. You can even declare a double literal with an exponent for scientific notation.

 Both integers and doubles are sub-classes of the num class.

{% prettify dart %}
var result = 22 + 11;  // 33
var formulaAnswer = (8 * 2) / 4 + 2 - 1;  // 5.0
{% endprettify %}

 The operators like plus, minus, multiply, and divide are actually special methods defined in the num class.

{% prettify dart %}
var division = 5 / 2; // 2.5
var truncatingDivision = 5 ~/ 2; // 2
{% endprettify %}

 Of special note is the difference between division and truncating division. Division, with just the forward slash, returns a double. Truncating division, with tilde forward slash, truncates the answer and returns the integer portion before the decimal point.

{% prettify dart %}
42.2.ceil(); // 43.0
42.2.floor(); // 42.0
42.7.round(); // 43.0
(-42).abs(); // 42
{% endprettify %}

 The num class also defines methods such as absolute, ceiling, floor, round, and more. This makes sense, because these are methods you can call on a specific instance of a number.

{% prettify dart %}
int.parse('1'); // 1
double.parse('1.1'); // 1.1

42.toString(); // '42'
{% endprettify %}

 Use the static method parse from the int and double classes to convert a string to a number. And go the other way, from number to string, using good old toString. Speaking of strings, let's move on to our next built-in type.

{% prettify dart %}
var message = "Bob's puppy is really cute.";
String html = '<button id="confirmation">Confirm?</button>';
{% endprettify %}

 Strings in Dart are sequences of UTF-16 code units. Notice how you can use either single quotes or double quotes when declaring a string literal. This is awesome, because this lets you choose the quotes that work for your string. Writing a bunch of HTML that uses double quotes? Great! You can wrap the entire string in single quotes. Does your string contain single quotes? Not a problem, just wrap the whole thing in double quotes.

{% prettify dart %}
var username = 'Alice';
var message = 'Hello, $username!'; // Hello, Alice!
{% endprettify %}

 Combining and building strings is easy with string interpolation. Notice the dollar sign username inside of message. This inserts the value from username into the string message. Dart does not have string concatenation with plus but you won't miss it thanks to string interpolation.

{% prettify dart %}
var longMessage = 'This is a long message '
                                'that is split over two lines';
// == This is a long message that is split over two lines.
{% endprettify %}

 Here's another reason you don't need plus to concatenate strings. Adjacent string literals, or two string literals next to each other, are concatenated for you. This example shows two string literals next to each other, even though that are on two lines. The compiler joins them together for you.

{% prettify dart %}
var evenLongerMessage = '''
You can create
multi-line strings like this one.
This is great for templates.''';
{% endprettify %}

 For even longer strings, you can use Dart's support for multi-line strings. Notice the use of the triple quotes, which works with both triple-single or triple-double quotes. All newlines after the first triple quotes are retained. This feature is very useful for small snippets of HTML, for example.

{% prettify dart %}
var raw = r"Raw strings \n are $left as is." // Raw strings \n are $left as is.
{% endprettify %}

 For the times when you need to use special characters like dollar sign or backslash inside your string, you can use raw strings. Prefix a string with the character r to turn off any interpretation of the string's contents. This is very handy for building regular expressions.

The String class is full of useful methods for searching, creating substrings, matching, and more. We'll cover Strings in more detail in a future episode. Let's move on to our next built-in type: booleans!

{% prettify dart %}
var dartIsFun = true;
bool dartIsHardToLearn = false;
{% endprettify %}

 Like everything in Dart, booleans are objects. Specifically, true and false are the only two instances of the bool class.

{% prettify dart %}
if (1) {
  // in JavaScript, this is true
} else {
  // in Dart, this is false
}
{% endprettify %}

 Dart differs from JavaScript in its treatment of truthy and falsey values. In JavaScript, the objects 1, non-empty string, and non-null objects are treated as true. In Dart, it's more simple. Only the boolean value true is treated as true. In Dart, all object instances other than true are treated as false.

{% prettify dart %}
var fullName = '';

if (fullName.isEmpty()) {
  validator.addMessage("Full name is empty");
}

var hitPoints = 0;

if (hitPoints == 0) {
  player.dead();
}
{% endprettify %}

 Instead of using many different objects for truthiness or falsiness, you can instead explicitly check for values or states. For example, instead of just checking "if hitpoints" you should instead explicitly check if hit points is equal to zero. I personally really like this, as the code is clearer and the developer doesn't need to learn a bunch of truthy or falsey rules.

The rule of three is a writing principle that suggests that things that come in threes are inherently funnier, more satisfying, or more effective than other numbers of things. The rule of thirds is a photography principle that creates more tension, energy and interest in the composition than simply centering the subject would. It's no coincidence, then, that you just learned how to create three foundational building blocks of any Dart program: numbers, strings, and booleans. These types are all real objects and can be initialized with literal values, making them easy to use. From here, we build up to collections!

Thanks for watching the show. My name is Seth Ladd, and as we say here on Dart Tips, stay sharp.

<hr>

<img src="{% asset_path 'dart-tips/marakana-logo.png' %}" alt="Marakana Logo">

Our thanks go out to Marakana for producing this video series.

[Back to all Dart Tips episodes](/resources/dart-tips/).
