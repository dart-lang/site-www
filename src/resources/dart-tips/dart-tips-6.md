---
layout: default
permalink: /resources/dart-tips/dart-tips-ep-6
title: "Functions Are Fun, Pt 1 - Dart Tips, Ep 6"
description: "Functions are the basic building blocks for any app. Dart supports top-level functions, optional parameters, default parameter values, and more. Watch this episode to learn about the basics of functions in Dart."
toc: false
---

*Note:* This video mentions the `?` operator, which is deprecated. Ignore
the parts about `?` , and enjoy the rest of the video.

<iframe class="dart-tips-video" src="//www.youtube.com/embed/DWtvhdJkiRE"
frameborder="0" allowfullscreen></iframe>

[Back to all Dart Tips episodes](/resources/dart-tips/).

<hr>

### Transcript

Hi my name is Seth Ladd and welcome to this episode of Dart Tips. This is part
one in a series about Functions, the stalwart and trusty building blocks of any
app. Dart supports top-level functions, optional parameters, nested functions,
passing functions as arguments to other functions, and more. It's not uncommon
to build an entire app using only functions. If you think Dart is only classes
and libraries, you're in for a treat. This episode will focus on
defining and calling functions. Let's get started.

Functions are reusable bundles of logic. They can take zero or more
arguments, perform some work, and optionally return a value.

Here is a very simple function named meaningOfLife.

{% prettify dart %}
meaningOfLife() {
  return 42;
}
{% endprettify %}

The empty parentheses means this
function does not take any parameters. Use the return statement to return
a value, in this case 42. If no return statement is specified, the function
returns null.

Here is how you call this function:

{% prettify dart %}
var answer = meaningOfLife();
{% endprettify %}

So far, so good. But Dart likes to be a terse language, so we can simplify
the definition of the function into a single line.

{% prettify dart %}
meaningOfLife() => 42;
{% endprettify %}

This "fat arrow" syntax is "syntactic sugar" for a more terse way to return the
resulting value of the expression on right-hand side of the fat arrow.

Functions can of course accept parameters. Here is an example:

{% prettify dart %}
shout(msg) {
  return msg.toUpperCase();
}
{% endprettify %}

This code works just fine, but this is Dart! We have optional type annotations,
so we can annotate this method's parameters and return type.

{% prettify dart %}
String shout(String msg) {
  return msg.toUpperCase();
}
{% endprettify %}

We strongly recommend using type annotations on the "surface area" of your
code. Any code that another user will interact with, functions being a
perfect example, should annotate what types it expects and what type it
returns. Your fellow developers will thank you, and your tools will give you
even better feedback.

Functions can take multiple parameters. Here is an example:

{% prettify dart %}
String shout(String msg, int exclamations) {
  var louder = new StringBuilder(msg.toUpperCase());
  for (var i = 0; i < exclamations; i++) {
    louder.add("!");
  }
  return louder.toString();
}
{% endprettify %}

This function has two required parameters: a string for the message and an
integer for the number of exclamation points to add at the end.

Exclamation points are loud, no doubt about it, but sometimes you may not want
to shout so loud. Of course, one option is to pass zero as the second parameter
value, like this code shows.

{% prettify dart %}
var message = shout("Dart puts the FUN into functions", 0);
{% endprettify %}

This, however, is a hard to read line of code. A casual observer may not know
what that magic zero is. Also, wouldn't it be better to simply leave off the
second parameter if you don't want to use it? Luckily, Dart has a way to make
this better.

Wrap one or more parameters with square brackets to make them optional.

Here is an example:

{% prettify dart %}
String shout(String msg, [int exclamations]) {
  var louder = new StringBuilder(msg.toUpperCase());
  if (exclamations != null) {
    for (var i = 0; i < exclamations; i++) {
      louder.add("!");
    }
  }
  return louder.toString();
}
{% endprettify %}

Notice how the function now checks if exclamations is null, which is the value
of the parameter if it was not provided by the caller.

Now that the second parameter is optional, you can optionally omit it when you
call the function. Here is an example:

{% prettify dart %}
var message = shout("Functions are fun");

// or, to really make a point

var message = shout("Functions are fun", 5);
{% endprettify %}

We made this function more flexible and easier to use. However, there is still
another problem here. The second parameter, if it is provided, still looks
a bit like a magic number. That is, the casual observer would not know what
the number five means.

Luckily, Dart has a solution for this, too. You can make methods even
easier to read by using optional named parameters.

Here is an example. I think adding a simple name to the parameter makes it
obvious what is going on.

{% prettify dart %}
var message = shout("Functions are fun", exclamations: 5);
{% endprettify %}

To define optional named parameters, wrap the parameters in curly braces , like
this:

{% prettify dart %}
String shout(String msg, {int exclamations}) {
  // same contents
}
{% endprettify %}

To briefly recap, there are two ways to define optional parameters.

* [ ] for optional positional parameters
* { } for optional named parameters

There's yet another benefit from the use of optional parameters. But first, the
setup: Sometimes, there's an obvious or default value for a parameter. Only on
occasion does it make sense to pass in something more unique.

For example, here is a function that opens an HTTP connection.

The first parameter, ipAddress, could be anything, so it's required. However,
almost all HTTP connections use port 80, so the second parameter can be optional.

{% prettify dart %}
openHttpConnection(String ipAddr, {int port}) {
  if (port == null) {
    port = 80;
  }
  // ...
}
{% endprettify %}

The function is easier to use now, because the user doesn't have to specify
the obvious. However, the code inside the function is a bit verbose. Plus,
there's no way to express to the user what the port's value will be if
it is not provided.

Luckily, Dart lets us specify a default value for a parameter if that parameter is
optional.

Here is an example:

{% prettify dart %}
openHttpConnection(String ipAddr, {int port: 80}) {
  // ...
}
{% endprettify %}

This code is simpler, the semantics are more clear, and it is self documenting.
You can use any compile-time constant, such as integer literals as shown here,
for default values.

Here are some examples of using this function:

{% prettify dart %}
openHttpConnection("127.0.0.1");       // port is 80
openHttpConnection("127.0.0.1", port: 3000); // port is 3000
{% endprettify %}

However, here is an example that might not be totally clear. Notice
how I am passing null as the second parameter.

{% prettify dart %}
openHttpConnection("127.0.0.1", port: null);
{% endprettify %}

null is a perfectly valid value, so in this case port will be set to null,
even though it has a default value. The lesson here is that default values
are only applied if the caller does not supply any value for the parameter.
This means, to really cover your bases, you should check for null even
when you use default values.

Like the optional named parameters, you can use default values
with optional positional parameters. There is a syntax difference, though.
You must use _equals_ with positional params, instead of _colon_.

Here is an example of defining an optional positional parameter with a default
value.

{% prettify dart %}
int indexOf(E element, [int startAt = 0]) {
  // ...
}
{% endprettify %}

Moving on, you can define functions simply at the top level of your code.
Here is an example:

{% prettify dart %}
String shout(String msg) {
  return msg.toUpperCase();
}

main() {
  print(shout("Functions are FUNdamental"));
}
{% endprettify %}

I love this, because it means I don't need to wrap functions inside
classes. Writing a simple script with Dart is easy, because of top-level
functions.

Now you know that functions can capitalize on type annotations, have both
optional positional and optional named parameters, have default values for their
optional parameters, and more. There's a lot more to functions in Dart, and
we'll cover nested functions, functions as objects, and more in a future
episode.

Thanks for watching, my name is Seth Ladd, and as we say here on Dart Tips, stay sharp!

<hr>

<img src="{% asset_path 'dart-tips/marakana-logo.png' %}" alt="Marakana Logo">

Our thanks go out to Marakana for producing this video series.

[Back to all Dart Tips episodes](/resources/dart-tips/).
