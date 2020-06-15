---
title: Dart null safety codelab
description: Interactively learn Dart's support for null safety.
---

<style>
  iframe {
    border: 1px solid #ccc;
    width: 100%;
    height: 400px;
  }

  iframe[short] {
    height: 220px;
  }
</style>

Welcome to Dart's null safety koans. This is the first in a series of code
examples designed to illustrate the new syntax and coding patterns currently
being added to the Dart language.

Each koan starts off in a bad or broken state. You will likely see warnings from
the Dart analyzer, and they probably won't compile. By following the
instructions and making edits to the code, however, you can update each one to a
working state. In the process, you'll learn a little bit about null safety!

{{site.alert.note}}
  This page uses embedded DartPads to display runnable examples.
  {% include dartpads-embedded-troubleshooting.md %}
{{site.alert.end}}

## Introducing non-nullable types

This first koan is as basic as they come. The variable `a` below is declared as
an `int`. With null safety enabled for a Dart project, all types are
non-nullable by default. Try changing the value in the assignment to `3` or
`145`. Anything but `null`!

### Code example

<iframe src="{{site.dartpad-embed}}?id=191102c2da72b40531dd3aa03c2bd203&ga_id=null_safety_introducing"></iframe>

## Nullable types

What if you need a variable that can hold a null value? You can declare it
nullable by adding a question mark to the end of the type. In this case, try
`int?`.

### Code example

<iframe src="{{site.dartpad-embed}}?id=65780fac4a9769e30fcb030f9822b010&ga_id=null_safety_introducing"></iframe>

## What next?

We hope you enjoyed using this codelab to learn or test your knowledge of
null safety support in the Dart language.
Here are some suggestions for what to do now:

* Try [other Dart codelabs](/codelabs).
* [Get the Dart SDK](/get-dart).
