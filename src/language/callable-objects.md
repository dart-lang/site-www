---
title: Callable objects
description: Learn how to create and use callable objects in Dart.
js: [{url: 'https://dartpad.dev/inject_embed.dart.js', defer: true}]
toc: false
prevpage:
  url: /language/extension-methods
  title: Extension methods
nextpage:
  url: /language/class-modifiers
  title: Class modifiers
---

To allow an instance of your Dart class to be called like a function,
implement the `call()` method.

The `call()` method allows an instance of any class that defines it to emulate a function.
This method supports the same functionality as normal [functions][]
such as parameters and return types.

In the following example, the `WannabeFunction` class defines a `call()` function
that takes three strings and concatenates them, separating each with a space,
and appending an exclamation. Click **Run** to execute the code.

<?code-excerpt "misc/lib/language_tour/callable_objects.dart"?>
```dart:run-dartpad:height-350px:ga_id-callable_objects
class WannabeFunction {
  String call(String a, String b, String c) => '$a $b $c!';
}

var wf = WannabeFunction();
var out = wf('Hi', 'there,', 'gang');

void main() => print(out);
```

[functions]: /language/functions
