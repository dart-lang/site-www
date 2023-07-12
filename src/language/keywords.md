---
title: Keywords
description: Keywords in Dart.
toc: false
prevpage:
  url: /language/libraries
  title: Libraries
nextpage:
  url: /language/built-in-types
  title: Built-in types
---

The following table lists the words that the Dart language treats specially.

{% assign ckw = '&nbsp;<sup title="contextual keyword" alt="contextual keyword">1</sup>' %}
{% assign bii = '&nbsp;<sup title="built-in-identifier" alt="built-in-identifier">2</sup>' %}
{% assign lrw = '&nbsp;<sup title="limited reserved word" alt="limited reserved word">3</sup>' %}
<div class="table-wrapper" markdown="1">
| [abstract][]{{bii}}   | [else][]                 | [import][]{{bii}}     | [show][]{{ckw}}    |
| [as][]{{bii}}         | [enum][]                 | [in][]                | [static][]{{bii}}  |
| [assert][]            | [export][]{{bii}}        | [interface][]{{bii}}  | [super][]          |
| [async][]{{ckw}}      | [extends][]              | [is][]                | [switch][]         |
| [await][]{{lrw}}      | [extension][]{{bii}}     | [late][]{{bii}}       | [sync][]{{ckw}}    |
| [base][]{{bii}}       | [external][]{{bii}}      | [library][]{{bii}}    | [this][]           |
| [break][]             | [factory][]{{bii}}       | [mixin][]{{bii}}      | [throw][]          |
| [case][]              | [false][]                | [new][]               | [true][]           |
| [catch][]             | [final (variable)][]     | [null][]              | [try][]            |
| [class][]             | [final (class)][]{{bii}} | [on][]{{ckw}}         | [typedef][]{{bii}} |
| [const][]             | [finally][]              | [operator][]{{bii}}   | [var][]            |
| [continue][]          | [for][]                  | [part][]{{bii}}       | [void][]           |
| [covariant][]{{bii}}  | [Function][]{{bii}}      | [required][]{{bii}}   | [when][]           |
| [default][]           | [get][]{{bii}}           | [rethrow][]           | [while][]          |
| [deferred][]{{bii}}   | [hide][]{{ckw}}          | [return][]            | [with][]           |
| [do][]                | [if][]                   | [sealed][]{{bii}}     | [yield][]{{lrw}}   |
| [dynamic][]{{bii}}    | [implements][]{{bii}}    | [set][]{{bii}}        |                    |
{:.table .table-striped .nowrap}
</div>

[abstract]: /language/class-modifiers#abstract
[as]: /language/operators#type-test-operators
[assert]: /language/error-handling#assert
[async]: /language/async
[await]: /language/async
[base]: /language/class-modifiers#base
[break]: /language/loops#break-and-continue
[case]: /language/branches#switch
[catch]: /language/error-handling#catch
[class]: /language/classes#instance-variables
[const]: /language/variables#final-and-const
[continue]: /language/loops#break-and-continue
[covariant]: /guides/language/sound-problems#the-covariant-keyword
[default]: /language/branches#switch
[deferred]: /language/libraries#lazily-loading-a-library
[do]: /language/loops#while-and-do-while
[dynamic]: /language#important-concepts
[else]: /language/branches#if
[enum]: /language/enums
[export]: /guides/libraries/create-packages
[extends]: /language/extend
[extension]: /language/extension-methods
[external]: https://spec.dart.dev/DartLangSpecDraft.pdf#External%20Functions
[factory]: /language/constructors#factory-constructors
[false]: /language/built-in-types#booleans
[final (variable)]: /language/variables#final-and-const
[final (class)]: /language/class-modifiers#final
[finally]: /language/error-handling#finally
[for]: /language/loops#for-loops
[Function]: /language/functions
[get]: /language/methods#getters-and-setters
[hide]: /language/libraries#importing-only-part-of-a-library
[if]: /language/branches#if
[implements]: /language/classes#implicit-interfaces
[import]: /language/libraries#using-libraries
[in]: /language/loops#for-loops
[interface]: /language/class-modifiers#interface
[is]: /language/operators#type-test-operators
[late]: /language/variables#late-variables
[library]: /language/libraries
[mixin]: /language/mixins
[new]: /language/classes#using-constructors
[null]: /language/variables#default-value
[on]: /language/error-handling#catch
[operator]: /language/methods#operators
[part]: /guides/libraries/create-packages#organizing-a-package
[required]: /language/functions#named-parameters
[rethrow]: /language/error-handling#catch
[return]: /language/functions#return-values
[sealed]: /language/class-modifiers#sealed
[set]: /language/methods#getters-and-setters
[show]: /language/libraries#importing-only-part-of-a-library
[static]: /language/classes#class-variables-and-methods
[super]: /language/extend
[switch]: /language/branches#switch
[sync]: /language/functions#generators
[this]: /language/constructors
[throw]: /language/error-handling#throw
[true]: /language/built-in-types#booleans
[try]: /language/error-handling#catch
[typedef]: /language/typedefs
[var]: /language/variables
[void]: /language/built-in-types
[when]: /language/branches#when
[with]: /language/mixins
[while]: /language/loops#while-and-do-while
[yield]: /language/functions#generators

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
