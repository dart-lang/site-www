---
title: Getting started with JavaScript interop
description: A basic example of using browser APIs and a bundled JS library.
---

In this tutorial, you'll learn the basics of interacting with JavaScript 
in Dart, using various JavaScript and browser APIs.

```dart
import 'dart:js_interop';

// All top-level JS interop APIs need the @JS annotation.
@JS()
external JSObject get document;
```

You use an `@JS`-annotated external top-level getter to access the document that's
available within `globalThis`. The result is a JS object, and is typed in Dart as a `JSObject`.
An opaque JS object isn't very useful, so you define an interop type using
[extension types][] to view it differently:

```dart
@JS()
external Document get document;

extension type Document._(JSObject _) implements JSObject {}
```

You define an interface for the `JSObject`, which allows you to interact with the
`JSObject` by declaring more interop APIs:

```dart
extension type Document._(JSObject _) implements JSObject {
  external JSObject createElement(JSString tag);
}
```

You've declared an external method within `Document` that allows you to call
instance methods on it, like:

```dart
var button = document.createElement('button'.toJS);
```

An important thing to note is that all values that flow into and out of interop
APIs should be typed as an interop type or an allowed Dart primitive type.
To convert some Dart values to a JS value and vice versa,
you use conversion methods like .toJS above.
When a Dart primitive type is used,
the compiler automatically converts the Dart value to a JS value and vice versa,
so you can rewrite the above code as:

```dart
external JSObject createElement(String tag);
```

and call it as:

```dart
var button = document.createElement('button');
```

The above call creates a button element,
which we can add to the document body using `appendChild`:

```dart
extension type Document._(JSObject _) implements JSObject {
  external JSObject createElement(String tag);
  external Body get body;
}

extension type Body._(JSObject _) implements JSObject {
  external JSObject appendChild(JSObject child);
}
```

```dart
var button = document.createElement('button');
document.body.appendChild(button);
```

It is useful sometimes to register event listeners
so that we know when the button is clicked:

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

Here, you create an interface for a button element and register an event listener
for the "click" event using a Dart function that is converted to a JS function using toJS.
Functions converted using toJS have the same limitations as interop APIs: 
their parameter and return types can only be an interop type or a primitive type.

There are other common types you may come across when using JS interop,
like Promises. We can convert Promises to and from Dart Futures as well:

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

The above example uses the fetch API.

You may also come across Arrays, which also can be converted to and from Dart Lists:

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

The above example uses `Array.of` using renaming to create an Array from two string values,
converts the Array to a List of `JSStrings`,
iterates over the List, and converts and prints out the string values.

An important thing to note when dealing with generic JS types like `JSArray`
and `JSPromise` is that the generic must be a JS value.
For example, with Lists, you’ll need to convert the contents before converting the List e.g.

```dart
List<JSString> list = ['hello'.toJS, 'world'.toJS];
list.toJS;
```

or

```dart
List<String> list = ['hello', 'world'];
list.map((e) => e.toJS).toList().toJS;
```

## Learn more

* For more information on which types have conversions, check out [Conversions][].
* For more information on how to write interop APIs, check out [Usage][].
* To access common utility functions, check out:
  * The [`dart:js_interop`][] library, and
  * The [`dart:js_interop_unsafe`][] library.
* [`package:web`][] exposes many of the browser APIs
  (including those used in the above examples) through interop declarations.

[extension types]: /language/extension-types
[Conversions]: /interop/js-interop/js-types#conversions
[Usage]: /interop/js-interop/usage
[`dart:js_interop`]: {{site.dart-api}}/main/dart-js_interop/dart-js_interop-library.html
[`dart:js_interop_unsafe`]: {{site.dart-api}}/main/dart-js_interop_unsafe/dart-js_interop_unsafe-library.html
[`package:web`]: /interop/js-interop/package-web