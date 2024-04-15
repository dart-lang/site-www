---
title: Callable objects
description: Learn how to create and use callable objects in Dart.
js: [{url: '/assets/js/inject_dartpad.js', defer: true}]
toc: false
prevpage:
  url: /language/extension-types
  title: Extension types
nextpage:
  url: /language/class-modifiers
  title: Class modifiers
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /(^|\n) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1/g; /(\n[^\n]+) *\/\/\s+ignore: (stable|beta|dev)[^\n]+\n/$1\n/g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>

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
