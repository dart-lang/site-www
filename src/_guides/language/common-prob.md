---
layout: guide
title: "Sound Dart: Common Problems"
description: "."
---

## Troubleshooting

### Am I really in strong mode?

If you're not seeing strong mode errors, make sure that you are in strong mode.
A good test is to add the following code to a file:

{% prettify dart %}
void test() {
  var fruits = ["apple"];
  var fruit = fruits[0];
  int apple = fruit;
}
{% endprettify %}

If you are in strong mode, you'll see the following error from the analyzer:

{% prettify none %}
[error] A value of type 'String' can't be assigned to a variable of type 'int'.
{% endprettify %}

### I'm not in strong mode and I think I should be

Strong mode is enforced by Dart Analyzer.
The answer slightly varies depending on whether you are running `dartanalyzer`
from the command line, or via one of the JetBrains IDEs.

#### Command line analyzer

If you are running `dartanalyzer --strong` and you don't see expected
strong mode errors, be sure that you didn't disable strong mode in an
analysis options file in the same directory where you run the analyzer.
If you do, the analysis options file overrides your command line flag.

For more information on how to set up an analysis options file, see
[Customize Static Analysis](/guides/language/analysis-options).

#### JetBrains IDEs

Make sure that you have an analysis options file with
[strong mode turned on](/guides/language/analysis-options#specifying-strong-mode).
This file needs to be placed in a content root, or in a parent
directory of your content root. The steps for viewing a project's
content root varies a bit for WebStorm and IntelliJ.

Note that a large project may have multiple content roots.
The following instructions describe how to see a list of content roots in
WebStorm or IntelliJ.

WebStorm
: In the **Preferences** panel (**WebStorm > Preferences**), click
  **Directories** from the list on the left.
  The **+Add Content Root** button in the column on the far right appears
  above the content roots, shown in bold.

IntelliJ
: In the **Project Structure** panel (**File > Project Structure**),
  **Modules** is selected from the list on the left by default.
  The **+Add Content Root** button in the column on the far right appears
  above the content roots, shown in bold.

For more information on where to put your analysis options file, see
[The analysis options file](g/guides/language/analysis-options#the-analysis-options-file).
This section is part of [Customize Static Analysis](/guides/language/analysis-options),
which shows how to create and customize an analysis options file.

## Common errors

Here are some errors you may run into when you enable strong mode, and how
to fix them.

### Undefined member

The analyzer complains that `context2D`, in the following code, is undefined.

<div class="fails-sa" markdown="1">
{% prettify dart %}
var canvas = querySelector("canvas");
canvas.[[highlight]]context2D[[/highlight]]; // <-- Error.
{% endprettify %}
</div>

The `querySelector()` method statically returns an Element, but the code assumes
it returns a CanvasElement, which is where `context2D` is defined. This is fine
in classic Dart is declared using `var`. That types it as `dynamic`, which silences
all errors in classic Dart. Strong mode Dart infers `canvas` to be an Element.
These errors usually appear in code where _statically_ a variable is known
to be some supertype but you happen to know it's a subtype.

**Fix** this error with an explicit type declaration or a downcast:

<div class="passes-sa" markdown="1">
{% prettify dart %}
[[highlight]]CanvasElement[[/highlight]] canvas = querySelector("canvas");
canvas.context2D;
{% endprettify %}
</div>

If you actually want a dynamic look-up, use `dynamic`:

<div class="passes-sa" markdown="1">
{% prettify dart %}
[[highlight]]dynamic[[/highlight]] canvas = querySelector("canvas");
canvas.context2D;
{% endprettify %}
</div>

### Invalid method override

In order to maintain
[Listov substitutability](https://en.wikipedia.org/wiki/Liskov_substitution_principle),
when a subclass overrides a method, that method should accept every object that
the superclass's method takes. For example:

<div class="fails-sa" markdown="1">
{% prettify dart %}
abstract class NumberAdder {
  num add(num a, num b);
}

class IntAdder extends NumberAdder {
  int add(int a, int b) => a + b;
}
{% endprettify %}
</div>

This code passes static analysis in class Dart, but is unsafe and fails analysis in
strong mode Dart. Consider the following scenario where floating point values are
passed to an IntAdder:

NumberAdder adder = new IntAdder(); // Upcast
adder.add(1.2, 3.4);                // Kaboom!
{% endprettify %}


**Fix** this problem by widening the types in the subclass.

{% prettify dart %}
abstract class NumberAdder {
  num add(num a, num b);
}

class IntAdder extends NumberAdder {
  num add(num a, num b) => a + b;
}
{% endprettify %}

For more information, see [Use proper input parameter types when overriding methods](/guides/language/sound-dart#use-proper-input-parameter-types-when-overriding-methods-).

<aside class="alert alert-info" markdown="1">
**Note:**
Some coding patterns require this functionality. If you have a valid reason to do this,
use can use the `@checked` annotation. For this example:

{% prettify dart %}
[[highlight]]import 'package:meta/meta.dart';[[/highlight]]

abstract class NumberAdder {
  num add([[highlight]]@checked[[/highlight]] num a, [[highlight]]@checked[[/highlight]] num b);
}
{% endprettify %}

Learn more about the
[@checked annotation](/guides/language/sound-dart##checked-annotation).
</aside>

### Constructor initialization list super() call

If you use `super()` in your constructor's initialization list,
**fix** this error by putting it last.


<div class="fails-sa" markdown="1">
{% prettify dart %}
HoneyBadger(Eats food, String name)
  : _name = name,
    [[highlight]]super[[/highlight]](food) { ... }
{% endprettify %}
</div>

<div class="passes-sa" markdown="1">
{% prettify dart %}
HoneyBadger(Eats food, String name)
  : [[highlight]]super[[/highlight]](food),
    _name = name { ... }
{% endprettify %}
{% endprettify %}
</div>

DDC generates simpler code if it relies on the `super()` call appearing last.
For more information, see [DO place the super() call last in a constructor initialization
list](/guides/language/effective-dart/usage#do-place-the-super-call-last-in-a-constructor-initialization-list)
in [Effective Dart(/guides/language/effective-dart/).

## Known issues

## Help

## Appendices
