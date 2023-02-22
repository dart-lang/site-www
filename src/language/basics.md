---
title: Introduction to the Dart language
description: A brief introduction to Dart programs and important concepts.
short-title: Dart basics
---

This page shows you how to use each major Dart feature, from
variables and operators to classes and libraries, with the assumption
that you already know how to program in another language.
For a briefer, less complete introduction to the language, see the
[language samples page](/samples).

To learn more about Dart's core libraries, see the
[library tour](/guides/libraries/library-tour).
Whenever you want more details about a language feature,
consult the [Dart language specification][].

## A basic Dart program

The following code uses many of Dart’s most basic features:

<?code-excerpt "misc/test/language_tour/basic_test.dart"?>
```dart
// Define a function.
void printInteger(int aNumber) {
  print('The number is $aNumber.'); // Print to console.
}

// This is where the app starts executing.
void main() {
  var number = 42; // Declare and initialize a variable.
  printInteger(number); // Call a function.
}
```

Here’s what this program uses that applies to all (or almost all) Dart
apps:

<code>// <em>This is a comment.</em> </code>
:   A single-line comment.
    Dart also supports multi-line and document comments.
    For details, see [Comments][].

`void`
:   A special type that indicates a value that's never used.
    Functions like `printInteger()` and `main()` that don't explicitly return a value
    have the `void` return type.
    
`int`
:   Another type, indicating an integer.
    Some additional [built-in types][]
    are `String`, `List`, and `bool`.

`42`
:   A number literal. Number literals are a kind of compile-time constant.

`print()`
:   A handy way to display output.

`'...'` (or `"..."`)
:   A string literal.

<code>$<em>variableName</em></code> (or <code>${<em>expression</em>}</code>)
:   String interpolation: including a variable or expression’s string
    equivalent inside of a string literal. For more information, see
    [Strings][].

`main()`
:   The special, *required*, top-level function where app execution
    starts. For more information, see
    [The main() function][].

`var`
:   A way to declare a variable without specifying its type.
    The type of this variable (`int`)
    is determined by its initial value (`42`).


{{site.alert.note}}
  This site's code follows the conventions in the
  [Dart style guide](/guides/language/effective-dart/style).
{{site.alert.end}}


## Important concepts

As you learn about the Dart language, keep these facts and concepts in
mind:

-   Everything you can place in a variable is an *object*, and every
    object is an instance of a *class*. Even numbers, functions, and
    `null` are objects.
    With the exception of `null` (if you enable [sound null safety][ns]),
    all objects inherit from the [`Object`][] class.

    {{site.alert.version-note}}
      [Null safety][ns] was introduced in Dart 2.12.
      Using null safety requires a [language version][] of at least 2.12.
    {{site.alert.end}}

-   Although Dart is strongly typed, type annotations are optional
    because Dart can infer types. In the code above, `number`
    is inferred to be of type `int`.

-   If you enable [null safety][ns],
    variables can’t contain `null` unless you say they can.
    You can make a variable nullable by
    putting a question mark (`?`) at the end of its type.
    For example, a variable of type `int?` might be an integer,
    or it might be `null`.
    If you _know_ that an expression never evaluates to `null`
    but Dart disagrees,
    you can add `!` to assert that it isn't null
    (and to throw an exception if it is).
    An example: `int x = nullableButNotNullInt!`

-   When you want to explicitly say
    that any type is allowed, use the type `Object?`
    (if you've enabled null safety), `Object`,
    or—if you must defer type checking until runtime—the
    [special type `dynamic`][ObjectVsDynamic].

-   Dart supports generic types, like `List<int>` (a list of integers)
    or `List<Object>` (a list of objects of any type).

-   Dart supports top-level functions (such as `main()`), as well as
    functions tied to a class or object (*static* and *instance
    methods*, respectively). You can also create functions within
    functions (*nested* or *local functions*).

-   Similarly, Dart supports top-level *variables*, as well as variables
    tied to a class or object (static and instance variables). Instance
    variables are sometimes known as *fields* or *properties*.

-   Unlike Java, Dart doesn’t have the keywords `public`, `protected`,
    and `private`. If an identifier starts with an underscore (`_`), it’s
    private to its library. For details, see
    [Libraries and visibility][].

-   *Identifiers* can start with a letter or underscore (`_`), followed by any
    combination of those characters plus digits.

-   Dart has both *expressions* (which have runtime values) and
    *statements* (which don't).
    For example, the [conditional expression][]
    `condition ? expr1 : expr2` has a value of `expr1` or `expr2`.
    Compare that to an [if-else statement][], which has no value.
    A statement often contains one or more expressions,
    but an expression can't directly contain a statement.

-   Dart tools can report two kinds of problems: _warnings_ and _errors_.
    Warnings are just indications that your code might not work, but
    they don’t prevent your program from executing. Errors can be either
    compile-time or run-time. A compile-time error prevents the code
    from executing at all; a run-time error results in an
    [exception][] being raised while the code executes.


[Dart language specification]: /guides/language/spec
[Comments]: /language/comments
[built-in types]: /language/built-in-types
[Strings]: /language/built-in-types#strings
[The main() function]: /language/functions#the-main-function
[ns]: /null-safety
[`Object`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/Object-class.html
[language version]: /guides/language/evolution#language-versioning
[ObjectVsDynamic]: /guides/language/effective-dart/design#avoid-using-dynamic-unless-you-want-to-disable-static-checking
[Libraries and visibility]: /guides/libraries/visibility
[conditional expression]: /language/operators#conditional-expressions
[if-else statement]: /language/control-flow#if-and-else
[exception]: /language/error-handling#exceptions