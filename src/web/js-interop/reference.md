---
title: JS interop reference
description: A glossary of key terms and concepts in JS interop.
---

## Members

// *I'm not sure if members, syntax, etc are interchangeable or different categories,*
*so rearrange / add more headings as needed*

### Inline classes

[Inline classes][] are a language feature independent of JS interop and static interop.
They are a special kind of class that wraps an existing type into a new static type, without the overhead of a traditional class.

In the context of JS interop and static interop,
inline classes are an entirely static type representation of a JavaScript object.
They consume no additional memory, as opposed to using the representation type directly.
This zero-cost wrapper capability makes static interop possible.

Inline classes can call *non-static* external fields, getters, setters,
and methods, as well as *static* external getters, setters, and methods. 

// *You should always wrap external types with inline classes?*


#### Usage:

```dart
// 

// 

// 
```

[Inline classes]: /

// *TO DO: link to inline class page*

### `external`

The [`external` keyword][] calls a method from an external source.
It is not exclusive to JS interop or static interop.
To specify external *JavaScript* members,
you need to use the `@JS` annotation with `external`.

#### Usage:

```dart
// 

// 

// 
```

[`external` keyword]: https://spec.dart.dev/DartLangSpecDraft.pdf#External%20Functions

### Top-level external members

Communication with top-level external members is a core feature of static interop,
though not exclusive to it. We have improved it to be more sound for static interop.

You can call a main-spaced function from a JavaScript app
without concern for type using the [`@JS` annotation](#js).

// *Why/when will users want to use this/ not be concerned with type?*

#### Usage:

```dart
// 
@JS(‘...’) 

// 

// 
```

### External factories

External factories are not exclusive to static interop,
but are an importatnt part of the interface. 
You can use a factory to instantiate a JavaScript object.

// *You will want to do this because/when...*

#### Usage:

```dart
// 

// 

// 
```

### Extensions with external members

// *Does this go under external, or extensions, or...?*

Extensions extend types. When you have an external class that you don't own,
and you don't want to add members to it, you can simply extend it.
Just write an extension and add members.

// *More detail on when/why you might want to use this maybe?*

#### Usage:

```dart
// 

// 

// 
```

## Annotations

### `@JS`

The `@JS` annotation belongs to the `dart:js_interop` library.
It specifies that you're using JavaScript interop,
as opposed to any other kind of interop.
It provides the bindings between a JavaScript API and your Dart API.
The use of `@JS` interop, combined with [inline classes](#inline-classes),
is what makes static interop possible. 

#### Usage:

```dart
// append to library directive

// call main-spaced JS function when you're not concerned with type (if that's a feature? idk)

// specify `external` declaration is JS
```

The `@JS` annotation was also a member of one of Dart's past JS interop solutions,
`package:js`. You can read more about that on the [Past JS interop][] page.

[Past JS interop]: /web/js-interop/past-js-interop

### `@staticInterop`

The `@staticInterop` annotation of `package:js` was an intermeditate static interop
solution before developing the complete, inline-class based, static interop model. 
Inline classes and the `@JS` annotations replace the functionality of `@staticInterop`. 

#### Usage:

```dart
// using @staticInterop
...

// same example using @JS + inline classes
...
```



