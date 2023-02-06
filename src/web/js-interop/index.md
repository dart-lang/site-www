---
title: JavaScript interoperability
short-title: JS interop
description: Integrate JavaScript code into your Dart web app.
---

The [Dart web platform](/overview#web-platform) supports communication with
JavaScript apps and libraries, and browser DOM APIs, using the `js_interop`
package, also known as `dart:js_interop`.
Web developers can benefit from using external JS libraries in their Dart code, without
having to rewrite anything in Dart.

## Static interop

The principal model of JS interop in Dart is **static interop**.
Static interop means interop that requires staticly typing external members,
rather than allowing dynamic invocations.
This enables [features](#features) like better performance, type soundness, and more.

Performant static interop model is made possible by **[inline classes][]**.
Inline classes are a special class type that wrap an existing type into a new static type,
without the overhead of a traditional class, enabling zero cost wrapping.

### Why static interop?

Static interop represents the desire to decouple Dart's "core" from the platform
where it's embedded
(*maybe definition of "embedded" or examples here, like the browser, Flutter, etc.?*).

Our [previous iterations of JS interop][] provided the capabillity
to access the embedder, but were not primed to handle that decoupling.
Too much of the process was entwined into the Dart side,
like writing all the bindings to the browser
(*not sure if I understood that note correctly*). 
They also had limitations around using the DOM,
typing (which is a cornerstone of Dart),
and expanding to new interop types
(*this is me trying to refer to wasm without actually saying, idk if "interop types" is the right term*). 

Static interop addresses all of the shortcomings of Dart's previous JS interop solutions.
Check out the [Features](#features) section for a summary of improvements. 

[previous iterations of JS interop]: /web/js-interop/past-js-interop

## Usage

The following example implements inline class-based, static, JS interop in Dart,
using its key members and syntaxes:

```dart
@JS()
library;
// library names aren't cool anymore...

import 'dart:js_interop';

inline class SomeThing {
  @JS('JSON.stringify')
  external String stringify(Object obj);
}
// idk where `inline` fits into this but basically just show the key components as briefly as possible
```

// *Below the example, go through the steps line by line **and why**:*

1. Append the `@JS` annotation to a `library` directive *so that....*

2. Import `dart:js_interop`, which provides most of the tools needed for static interop,
including annotations, the representation type for inline classes, *... etc.*

3. Create an `inline` class because it *allows you to...*, 
which is the core of static interop.

4. Use the `@JS` annotation to call a main-spaced function, or top level external member, from your JS app

    // *(or, call the external member from outside an inline class if you don't care about types?*
*idk if that's worth mentioning)*

5. Use the `external` keyword to.... *(allow external and non-external members to communicate? idk)*

6. *show external and non-external members interacting if that's not already shown?*

## Features

Inline class-based static interop enable the following features:

<div class="table-wrapper" markdown="1">
| **Rename external members**                      | Complex JS member names can be re-written and represented in Dart |
| **Interact external and non-external members**   | Process external calls, but "keep it on the type itself" (*idk what that means?*), without writing a separate function |
| **Zero cost wrapping**                           | Inline classes require virtually no overhead for re-typing external members as static types. (*idk*)  |
| **Static error checking**                        | Since external members must be statically typed, static error checking on types and other parts of the interop is possible (partially sound, more work coming) |
| **Interop with DOM types**                       | *You can interop with DOM types because...?*   |
| **Compatibility with Wasm**                      | Disallowing generative constructors from the model makes `js_interop` compatible with Wasm  |
{:.table .table-striped .nowrap}
</div>


## Up next

For a complete summary of static JS interop concepts, members, and syntaxes:
* The [static interop reference][].

For tutorials and help:
* [How to interop with DOM APIs][]
* [How to interop with JavaScript libraries and apps][]
* [How to test and mock JavaScript interop in Dart][]

For additonal types of documentation on `js_interop`:
  * [pub.dev site page][]
  * [API reference][]

For information on other iterations of JS interop in Dart:
  * [`dart:js_util`][]
  * [Past JS interop][]


[inline classes]: /
[static interop reference]: /web/js-interop/reference
[How to interop with DOM APIs]: /web/js-interop/dom
[How to interop with JavaScript libraries and apps]: /web/js-interop/js-app
[How to test and mock JavaScript interop in Dart]: /web/js-interop/test-and-mock
[pub.dev site page]: /
[API reference]: /
[`dart:js_util`]: /web/js-interop/js-util
[Past JS interop]: /web/js-interop/past-js-interop
