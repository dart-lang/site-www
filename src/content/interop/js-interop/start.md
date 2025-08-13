---
title: Getting started with JavaScript interop
breadcrumb: Get started
description: A basic example of using browser APIs and a bundled JS library.
---

This tutorial teaches you the basics of interacting with JavaScript
in Dart code by using various browser and JavaScript APIs. 

## Access and define a JavaScript object

To access a global JavaScript object, such as the browser's
`document` object, declare an `@JS`-annotated, external
top-level getter. This returns the value as an opaque `JSObject`.

```dart
import 'dart:js_interop';

// All top-level JS interop APIs need the @JS annotation.
@JS()
external JSObject get document;
```

A `JSObject` is opaque and doesn't provide type safety or auto-completion.
To add type-safe members, define an interop type using an extension type.
This acts as an interface, allowing you to declare more interop APIs as
external members. You can define an interop type using
[extension types][] to view it differently:

```dart
@JS()
external Document get document;

extension type Document._(JSObject _) implements JSObject {}
```

Now, you can add external methods to your `Document` interface. For example,
add the `createElement()` instance method:

```dart
extension type Document._(JSObject _) implements JSObject {
  external JSObject createElement(JSString tag);
}
```

With the `createElement` method defined, you can call it on the
`document` object. Notice that you must convert `'button'` from
a `String` to a `JSString` using the `.toJS` extension method.

```dart
var button = document.createElement('button'.toJS);
```

Values passed to and from interop APIs must be either an
interop type (like `JSObject` or `JSString`) or an allowed
Dart primitive.

## Use automatic type conversions

The compiler automatically converts most Dart primitive types
(like `String`, `num`, `bool`, and `null`), so you can often
use them directly in interop signatures to simplify your code.

For example, you can rewrite the `createElement` declaration
from the previous section to accept a Dart `String` directly.
For example:

```dart
external JSObject createElement(String tag);
```

Now, you can call it without the explicit `.toJS` conversion.
For example:

```dart
var button = document.createElement('button');
```

To add the newly created button to the document's body, first
define interop types for the `body` and its `appendChild()` method:

```dart
extension type Document._(JSObject _) implements JSObject {
  external JSObject createElement(String tag);
  external Body get body;
}

extension type Body._(JSObject _) implements JSObject {
  external JSObject appendChild(JSObject child);
}
```

With these definitions, you can create a button and add it to
the page:

```dart
var button = document.createElement('button');
document.body.appendChild(button);
```

## Handle events and callbacks

To handle user interactions, such as a button click,
you can register an event listener using `addEventListener()`.

First, create an interface for a button element. Then, call
`addEventListener` with the event name and a callback function.

```dart
extension type ButtonElement(JSObject _) implements JSObject {
  external void addEventListener(String event, JSFunction listener);
}
```

```dart
var button = ButtonElement(document.createElement('button'));
document.body.appendChild(button);
button.addEventListener('click', (JSObject event) {
  print('Clicked!');
}.toJS);
```

Callbacks converted to JS with `.toJS` have the same
type limitations as other interop APIs in that their parameters
and return values must be interop types or compatible primitives.

## Work with Promises and Arrays

JavaScript interop provides helpers for other common types, like
converting JavaScript Promises to and from Dart `Futures`, and
`Arrays` to and from `Lists`.

### Promises and futures

This example uses the `fetch` API, which returns a `Promise`.
The `.toDart` extension converts the `Promise` to a `Future`,
so you can `await` its result in Dart:

```dart
import 'dart:js_interop';

extension type Response._(JSObject _) implements JSObject {
  external bool get ok;
}

@JS()
external Response fetch(String resource);

void main() async {
  var response = await fetch('image.png').toDart;
  print(response.ok);
}
```

### Arrays and Lists

This example calls the static JavaScript `Array.of` method
to create a `JSArray`. It then converts the array to a
Dart `List`, iterates over it, and prints each element.

```dart
import 'dart:js_interop';

@JS('Array.of')
external JSArray<JSString> arrayOf(String a, String b);

void main() {
  var array = arrayOf('hello', 'world');
  var list = array.toDart;
  for (var element in list) {
    print(element.toDart);
  }
}
```

When converting a generic type like a `List`, its elements
must already be JS interop types. For example, to convert
a `List<String>`, you must first convert each `String`
into a `JSString`.

```dart
// Option 1: Create the list with JS types initially.
List<JSString> list = ['hello'.toJS, 'world'.toJS];
JSArray jsArray1 = list.toJS;

// Option 2: Map a Dart list to a list of JS types.
List<String> dartList = ['hello', 'world'];
JSArray jsArray2 = dartList.map((e) => e.toJS).toList().toJS;
```

## Learn more

* For more information on type conversions, check out [Conversions][].
* For more information on how to write interop APIs, see the [Usage guide][].
* To access common utility functions, see:
  * The [`dart:js_interop`][] library, and
  * The [`dart:js_interop_unsafe`][] library.
* The [`package:web`][] exposes many of the browser APIs
  (including those used in the above examples) through interop declarations.

[extension types]: /language/extension-types
[Conversions]: /interop/js-interop/js-types#conversions
[Usage guide]: /interop/js-interop/usage
[`dart:js_interop`]: {{site.dart-api}}/dart-js_interop/
[`dart:js_interop_unsafe`]: {{site.dart-api}}/dart-js_interop_unsafe/
[`package:web`]: /interop/js-interop/package-web
