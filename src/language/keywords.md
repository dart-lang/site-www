---
title: Keywords
description: Keywords in Dart.
---

The following table lists the words that the Dart language treats specially.

{% assign ckw = '&nbsp;<sup title="contextual keyword" alt="contextual keyword">1</sup>' %}
{% assign bii = '&nbsp;<sup title="built-in-identifier" alt="built-in-identifier">2</sup>' %}
{% assign lrw = '&nbsp;<sup title="limited reserved word" alt="limited reserved word">3</sup>' %}
<div class="table-wrapper" markdown="1">
| [abstract][]{{bii}}   | [else][]              | [import][]{{bii}}     | [show][]{{ckw}}   |
| [as][]{{bii}}         | [enum][]              | [in][]                | [static][]{{bii}} |
| [assert][]            | [export][]{{bii}}     | [interface][]{{bii}}  | [super][]         |
| [async][]{{ckw}}      | [extends][]           | [is][]                | [switch][]        |
| [await][]{{lrw}}      | [extension][]{{bii}}  | [late][]{{bii}}       | [sync][]{{ckw}}   |
| [break][]             | [external][]{{bii}}   | [library][]{{bii}}    | [this][]          |
| [case][]              | [factory][]{{bii}}    | [mixin][]{{bii}}      | [throw][]         |
| [catch][]             | [false][]             | [new][]               | [true][]          |
| [class][]             | [final][]             | [null][]              | [try][]           |
| [const][]             | [finally][]           | [on][]{{ckw}}         | [typedef][]{{bii}}|
| [continue][]          | [for][]               | [operator][]{{bii}}   | [var][]           |
| [covariant][]{{bii}}  | [Function][]{{bii}}   | [part][]{{bii}}       | [void][]          |
| [default][]           | [get][]{{bii}}        | [required][]{{bii}}   | [while][]         |
| [deferred][]{{bii}}   | [hide][]{{ckw}}       | [rethrow][]           | [with][]          |
| [do][]                | [if][]                | [return][]            | [yield][]{{lrw}}  |
| [dynamic][]{{bii}}    | [implements][]{{bii}} | [set][]{{bii}}        |                   |
{:.table .table-striped .nowrap}
</div>

[abstract]: /language/classes#abstract-classes
[as]: /language/operators#type-test-operators
[assert]: /language/control-flow#assert
[async]: /language/async
[await]: /language/async
[break]: /language/control-flow#break-and-continue
[case]: /language/control-flow#switch-and-case
[catch]: /language/error-handling#catch
[class]: /language/classes#instance-variables
[const]: /language/variables#final-and-const
{% comment %}
  [TODO #2950: Make sure that points to a place that talks about const constructors,
  as well as const literals and variables.]
{% endcomment %}
[continue]: /language/control-flow#break-and-continue
[covariant]: /guides/language/sound-problems#the-covariant-keyword
[default]: /language/control-flow#switch-and-case
[deferred]: /guides/libraries/visibility#lazily-loading-a-library
[do]: /language/control-flow#while-and-do-while
[dynamic]: /language/basics#important-concepts
[else]: /language/control-flow#if-and-else
[enum]: /language/enum
[export]: /guides/libraries/create-library-packages
[extends]: /language/extend
[extension]: /language/extension-methods
[external]: https://spec.dart.dev/DartLangSpecDraft.pdf#External%20Functions
[factory]: /language/constructors#factory-constructors
[false]: /language/built-in-types#booleans
[final]: /language/variables#final-and-const
[finally]: /language/error-handling#finally
[for]: /language/control-flow#for-loops
[Function]: /language/functions
[get]: /language/methods#getters-and-setters
[hide]: /guides/libraries/visibility#importing-only-part-of-a-library
[if]: /language/control-flow#if-and-else
[implements]: /language/classes#implicit-interfaces
[import]: /guides/libraries/visibility#using-libraries
[in]: /language/control-flow#for-loops
[interface]: /language/classes#implicit-interfaces
[is]: /language/operators#type-test-operators
[late]: /language/variables#late-variables
[library]: /guides/libraries/visibility
[mixin]: /language/mixins
[new]: /language/classes#using-constructors
[null]: /language/variables#default-value
[on]: /language/error-handling#catch
[operator]: /language/methods#operators
[part]: /guides/libraries/create-library-packages#organizing-a-library-package
[required]: /language/functions#named-parameters
[rethrow]: /language/error-handling#catch
[return]: /language/functions#return-values
[set]: /language/methods#getters-and-setters
[show]: /guides/libraries/visibility#importing-only-part-of-a-library
[static]: /language/classes#class-variables-and-methods
[super]: /language/extend
[switch]: /language/control-flow#switch-and-case
[sync]: /language/generators
[this]: /language/constructors
[throw]: /language/error-handling#throw
[true]: /language/built-in-types#booleans
[try]: /language/error-handling#catch
[typedef]: /language/typedefs
[var]: /language/variables
[void]: /language/built-in-types
{% comment %}
  TODO #2950: Add coverage of void to the language tour.
{% endcomment %}
[with]: /language/mixins
[while]: /language/control-flow#while-and-do-while
[yield]: /language/generators

Avoid using these words as identifiers.
However, if necessary, the keywords marked with superscripts can be identifiers:

* Words with the superscript **1** are **contextual keywords**,
  which have meaning only in specific places.
  They're valid identifiers everywhere.

* Words with the superscript **2** are **built-in identifiers**.
  These keywords are valid identifiers in most places,
  but they can't be used as class or type names, or as import prefixes.

* Words with the superscript **3** are limited reserved words related to
  [asynchrony support][].
  You can't use `await` or `yield` as an identifier
  in any function body marked with `async`, `async*`, or `sync*`.

All other words in the table are **reserved words**,
which can't be identifiers.

[asynchrony support]: /language/async
