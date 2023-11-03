---
title: Functions
description: Everything about functions in Dart.
js: [{url: 'https://dartpad.dev/inject_embed.dart.js', defer: true}]
prevpage:
  url: /language/pattern-types
  title: Pattern types
nextpage:
  url: /language/loops
  title: Loops
---

Dart is a true object-oriented language, so even functions are objects
and have a type, [Function.][Function API reference]
This means that functions can be assigned to variables or passed as arguments
to other functions. You can also call an instance of a Dart class as if
it were a function. For details, see [Callable objects][].

Here's an example of implementing a function:

<?code-excerpt "misc/lib/language_tour/functions.dart (function)"?>
```dart
bool isNoble(int atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

Although Effective Dart recommends
[type annotations for public APIs][],
the function still works if you omit the types:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-omitting-types)"?>
```dart
isNoble(atomicNumber) {
  return _nobleGases[atomicNumber] != null;
}
```

For functions that contain just one expression, you can use a shorthand
syntax:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-shorthand)"?>
```dart
bool isNoble(int atomicNumber) => _nobleGases[atomicNumber] != null;
```

The <code>=> <em>expr</em></code> syntax is a shorthand for
<code>{ return <em>expr</em>; }</code>. The `=>` notation
is sometimes referred to as _arrow_ syntax.

{{site.alert.note}}
  Only an *expression*—not a *statement*—can appear between the arrow (=\>) and
  the semicolon (;). For example, you can't put an [if statement][]
  there, but you can use a [conditional expression][].
{{site.alert.end}}

## Parameters

A function can have any number of *required positional* parameters. These can be
followed either by *named* parameters or by *optional positional* parameters
(but not both).

{{site.alert.note}}
  Some APIs—notably [Flutter][] widget constructors—use only named
  parameters, even for parameters that are mandatory. See the next section for
  details.
{{site.alert.end}}

You can use [trailing commas][] when you pass arguments to a function
or when you define function parameters.


### Named parameters

Named parameters are optional
unless they're explicitly marked as `required`.

When defining a function, use
<code>{<em>param1</em>, <em>param2</em>, …}</code>
to specify named parameters.
If you don't provide a default value
or mark a named parameter as `required`,
their types must be nullable
as their default value will be `null`:

<?code-excerpt "misc/lib/language_tour/functions.dart (specify-named-parameters)"?>
```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool? bold, bool? hidden}) {...}
```

When calling a function, 
you can specify named arguments using
<code><em>paramName</em>: <em>value</em></code>. 
For example:

<?code-excerpt "misc/lib/language_tour/functions.dart (use-named-parameters)"?>
```dart
enableFlags(bold: true, hidden: false);
```

<a id="default-parameters"></a>
To define a default value for a named parameter besides `null`,
use `=` to specify a default value.
The specified value must be a compile-time constant.
For example:

<?code-excerpt "misc/lib/language_tour/functions.dart (named-parameter-default-values)"?>
```dart
/// Sets the [bold] and [hidden] flags ...
void enableFlags({bool bold = false, bool hidden = false}) {...}

// bold will be true; hidden will be false.
enableFlags(bold: true);
```

If you instead want a named parameter to be mandatory,
requiring callers to provide a value for the parameter,
annotate them with `required`:

<?code-excerpt "misc/lib/language_tour/functions.dart (required-named-parameters)" replace="/required/[!$&!]/g"?>
```dart
const Scrollbar({super.key, [!required!] Widget child});
```

If someone tries to create a `Scrollbar`
without specifying the `child` argument,
then the analyzer reports an issue.

{{site.alert.note}}
  A parameter marked as `required`
  can still be nullable:

  <?code-excerpt "misc/lib/language_tour/functions.dart (required-named-parameters-nullable)" replace="/Widget\?/[!$&!]/g; /ScrollbarTwo/Scrollbar/g;"?>
  ```dart
  const Scrollbar({super.key, required [!Widget?!] child});
  ```
{{site.alert.end}}

You might want to place positional arguments first,
but Dart doesn't require it.
Dart allows named arguments to be placed anywhere in the
argument list when it suits your API:

<?code-excerpt "misc/lib/language_tour/functions.dart (named-arguments-anywhere)"?>
```dart
repeat(times: 2, () {
  ...
});
```

### Optional positional parameters

Wrapping a set of function parameters in `[]`
marks them as optional positional parameters.
If you don't provide a default value,
their types must be nullable
as their default value will be `null`:

<?code-excerpt "misc/test/language_tour/functions_test.dart (optional-positional-parameters)"?>
```dart
String say(String from, String msg, [String? device]) {
  var result = '$from says $msg';
  if (device != null) {
    result = '$result with a $device';
  }
  return result;
}
```

Here's an example of calling this function
without the optional parameter:

<?code-excerpt "misc/test/language_tour/functions_test.dart (call-without-optional-param)"?>
```dart
assert(say('Bob', 'Howdy') == 'Bob says Howdy');
```

And here's an example of calling this function with the third parameter:

<?code-excerpt "misc/test/language_tour/functions_test.dart (call-with-optional-param)"?>
```dart
assert(say('Bob', 'Howdy', 'smoke signal') ==
    'Bob says Howdy with a smoke signal');
```

To define a default value for an optional positional parameter besides `null`,
use `=` to specify a default value.
The specified value must be a compile-time constant.
For example:

<?code-excerpt "misc/test/language_tour/functions_test.dart (optional-positional-param-default)"?>
```dart
String say(String from, String msg, [String device = 'carrier pigeon']) {
  var result = '$from says $msg with a $device';
  return result;
}

assert(say('Bob', 'Howdy') == 'Bob says Howdy with a carrier pigeon');
```


## The main() function

Every app must have a top-level `main()` function, which serves as the
entrypoint to the app. The `main()` function returns `void` and has an
optional `List<String>` parameter for arguments.

Here's a simple `main()` function:

<?code-excerpt "misc/test/samples_test.dart (hello-world)"?>
```dart
void main() {
  print('Hello, World!');
}
```

Here's an example of the `main()` function for a command-line app that
takes arguments:

<?code-excerpt "misc/test/language_tour/functions_test.dart (main-args)"?>
```dart
// Run the app like this: dart args.dart 1 test
void main(List<String> arguments) {
  print(arguments);

  assert(arguments.length == 2);
  assert(int.parse(arguments[0]) == 1);
  assert(arguments[1] == 'test');
}
```

You can use the [args library]({{site.pub-pkg}}/args) to
define and parse command-line arguments.

## Functions as first-class objects

You can pass a function as a parameter to another function. For example:

<?code-excerpt "misc/lib/language_tour/functions.dart (function-as-param)"?>
```dart
void printElement(int element) {
  print(element);
}

var list = [1, 2, 3];

// Pass printElement as a parameter.
list.forEach(printElement);
```

You can also assign a function to a variable, such as:

<?code-excerpt "misc/test/language_tour/functions_test.dart (function-as-var)"?>
```dart
var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
assert(loudify('hello') == '!!! HELLO !!!');
```

This example uses an anonymous function.
More about those in the next section.

## Anonymous functions

Most functions are named, such as `main()` or `printElement()`.
You can also create a nameless function
called an _anonymous function_, or sometimes a _lambda_ or _closure_.
You might assign an anonymous function to a variable so that,
for example, you can add or remove it from a collection.

An anonymous function looks similar
to a named function—zero or more parameters, separated by commas
and optional type annotations, between parentheses.

The code block that follows contains the function's body:

<code>
([[<em>Type</em>] <em>param1</em>[, …]]) { <br>
&nbsp;&nbsp;<em>codeBlock</em>; <br>
}; <br>
</code>

The following example defines an anonymous function
with an untyped parameter, `item`,
and passes it to the `map` function.
The function, invoked for each item in the list,
converts each string to uppercase.
Then in the anonymous function passed to `forEach`,
each converted string is printed out alongside its length.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anonymous-function)"?>
```dart
const list = ['apples', 'bananas', 'oranges'];
list.map((item) {
  return item.toUpperCase();
}).forEach((item) {
  print('$item: ${item.length}');
});
```

Click **Run** to execute the code.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anonymous-function-main)"?>
```dart:run-dartpad:height-400px:ga_id-anonymous_functions
void main() {
  const list = ['apples', 'bananas', 'oranges'];
  list.map((item) {
    return item.toUpperCase();
  }).forEach((item) {
    print('$item: ${item.length}');
  });
}
```

If the function contains only a single expression or return statement,
you can shorten it using arrow notation. 
Paste the following line into DartPad and click **Run**
to verify that it is functionally equivalent.

<?code-excerpt "misc/test/language_tour/functions_test.dart (anon-func)"?>
```dart
list
    .map((item) => item.toUpperCase())
    .forEach((item) => print('$item: ${item.length}'));
```


## Lexical scope

Dart is a lexically scoped language, which means that the scope of
variables is determined statically, simply by the layout of the code.
You can "follow the curly braces outwards" to see if a variable is in
scope.

Here is an example of nested functions with variables at each scope
level:

<?code-excerpt "misc/test/language_tour/functions_test.dart (nested-functions)"?>
```dart
bool topLevel = true;

void main() {
  var insideMain = true;

  void myFunction() {
    var insideFunction = true;

    void nestedFunction() {
      var insideNestedFunction = true;

      assert(topLevel);
      assert(insideMain);
      assert(insideFunction);
      assert(insideNestedFunction);
    }
  }
}
```

Notice how `nestedFunction()` can use variables from every level, all
the way up to the top level.


## Lexical closures

A *closure* is a function object that has access to variables in its
lexical scope, even when the function is used outside of its original
scope.

Functions can close over variables defined in surrounding scopes. In the
following example, `makeAdder()` captures the variable `addBy`. Wherever the
returned function goes, it remembers `addBy`.

<?code-excerpt "misc/test/language_tour/functions_test.dart (function-closure)"?>
```dart
/// Returns a function that adds [addBy] to the
/// function's argument.
Function makeAdder(int addBy) {
  return (int i) => addBy + i;
}

void main() {
  // Create a function that adds 2.
  var add2 = makeAdder(2);

  // Create a function that adds 4.
  var add4 = makeAdder(4);

  assert(add2(3) == 5);
  assert(add4(3) == 7);
}
```


## Testing functions for equality

Here's an example of testing top-level functions, static methods, and
instance methods for equality:

<?code-excerpt "misc/lib/language_tour/function_equality.dart"?>
```dart
void foo() {} // A top-level function

class A {
  static void bar() {} // A static method
  void baz() {} // An instance method
}

void main() {
  Function x;

  // Comparing top-level functions.
  x = foo;
  assert(foo == x);

  // Comparing static methods.
  x = A.bar;
  assert(A.bar == x);

  // Comparing instance methods.
  var v = A(); // Instance #1 of A
  var w = A(); // Instance #2 of A
  var y = w;
  x = w.baz;

  // These closures refer to the same instance (#2),
  // so they're equal.
  assert(y.baz == x);

  // These closures refer to different instances,
  // so they're unequal.
  assert(v.baz != w.baz);
}
```


## Return values

All functions return a value. If no return value is specified, the
statement `return null;` is implicitly appended to the function body.

<?code-excerpt "misc/test/language_tour/functions_test.dart (implicit-return-null)"?>
```dart
foo() {}

assert(foo() == null);
```

To return multiple values in a function, aggregate the values in a [record][].

```dart
(String, int) foo() {
  return ('something', 42);
}
```

## Generators

When you need to lazily produce a sequence of values,
consider using a _generator function_.
Dart has built-in support for two kinds of generator functions:

* **Synchronous** generator: Returns an [`Iterable`] object.
* **Asynchronous** generator: Returns a [`Stream`] object.

To implement a **synchronous** generator function,
mark the function body as `sync*`,
and use `yield` statements to deliver values:

<?code-excerpt "misc/test/language_tour/async_test.dart (sync-generator)"?>
```dart
Iterable<int> naturalsTo(int n) sync* {
  int k = 0;
  while (k < n) yield k++;
}
```

To implement an **asynchronous** generator function,
mark the function body as `async*`,
and use `yield` statements to deliver values:

<?code-excerpt "misc/test/language_tour/async_test.dart (async-generator)"?>
```dart
Stream<int> asynchronousNaturalsTo(int n) async* {
  int k = 0;
  while (k < n) yield k++;
}
```

If your generator is recursive,
you can improve its performance by using `yield*`:

<?code-excerpt "misc/test/language_tour/async_test.dart (recursive-generator)"?>
```dart
Iterable<int> naturalsDownFrom(int n) sync* {
  if (n > 0) {
    yield n;
    yield* naturalsDownFrom(n - 1);
  }
}
```

[`Iterable`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Iterable-class.html
[`Stream`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-async/Stream-class.html
[record]: /language/records#multiple-returns

[Function API reference]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Function-class.html
[Callable objects]: /language/callable-objects
[type annotations for public APIs]: /effective-dart/design#do-type-annotate-fields-and-top-level-variables-if-the-type-isnt-obvious
[if statement]: /language/branches#if
[conditional expression]: /language/operators#conditional-expressions
[Flutter]: {{site.flutter}}
[trailing commas]: /language/collections#lists
