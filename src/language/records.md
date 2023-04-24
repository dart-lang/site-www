---
title: Records
description: Summary of the record data structure in Dart.
toc: false
---

Records are an anonymous, immutable, aggregate type. Like other [collection types][], 
they let you bundle multiple objects into a single object. Unlike other collection 
types, records are fixed-sized, heterogeneous, and typed.

Records are real values; you can store them in variables, pass them to and from
functions, and store them in lists.

## Record syntax

_Records expressions_ are comma-delimited lists of named or positional fields,
enclosed in parenthesis:

```dart
var record = ('first', a: 2, b: true, 'last');    // Record expression
```

_Record type annotations_ are comma-delimited lists of types enclosed in parenthesis.
The `(int, int)` statements here are record type annotations used as a return
type and as parameter types:

```dart
(int, int) swap((int, int) record) {
  var (a, b) = record;
  return (b, a);
}
```

Named fields inside _record type annotations_ go inside a brace-delimited section
of type and name pairs, after all positional fields:

```dart
// Record type annotation in a variable declaration
(String, String?, {int a, bool b}) record;
```

Naming fields in record type annotations is optional for documentation purposes.
The names of those named fields are not optional, though,  
once you create a record with named fields. The field names become part of the
[record's type definition](#record-types). They can be omitted, but not replaced.

For more information, see the [Record equality](#record-equality) section.

## Record fields

Record fields are accessible through built-in getters. Records are immutable,
so fields do not have setters. 

Named fields expose getters of the same name. Positional fields expose getters
of the name `$<position>`, skipping named fields:

```dart
var record = ('first', a: 2, b: true, 'last');

print(record.$1);    // Prints '123'
print(record.a);     // Prints 2
print(record.b);     // Prints true
print(record.$2);    // Prints 'last'
```

To streamline record field access even more, see the page on [Patterns][].

{% comment %}
    TODO: link to patterns page, specifically records destructuring section.
{% endcomment %}

## Record types

There is no type declaration for individual record types. Records are structurally
typed based on the types of their fields. A record's _shape_ (the set of its fields,
the fields' types, and their names, if any) uniquely determines the type of a record. 

Each field in a record has its own type, which can be different from other
fields' types in the same record. The type system is aware of each
field's type wherever it is accessed from the record:

```dart
(num, Object) pair = (42, "a");

var first = pair.$1;     // static type `num`, runtime type `int`
var second = pair.$2;    // static type `Object`, runtime type `String`
```

If two unrelated libraries create records with the same set of fields,
the type system understands that those records are the same type even though the
libraries are not coupled to each other.

## Record equality

Two records are equal if they have the same _shape_ (set of fields),
and their corresponding fields have the same values.
Since named field _order_ is not part of a record's shape, the order of named
fields does not affect equality:

```dart
(int x, int y, int z) point = (1, 2, 3);
(int r, int g, int b) color = (1, 2, 3);

// OK:
point = color;
```

```dart
({int x, int y, int z}) point = (x: 1, y: 2, z: 3);
({int r, int g, int b}) color = (r: 1, g: 2, b: 3);

// Error, different types:
point = color;
```

Records automatically define `hashCode` and `==` methods structurally based on
their fields.

## Multiple returns

Records allow functions to return multiple values bundled together.
Using [pattern matching][], you can retrieve record values from a return by
destructuring them directly into local variables:

{% comment %}
    TODO: link to patterns page, specifically records destructuring section.
{% endcomment %}

```dart
// Returns multiple values in a record:
(String, int) userInfo(Map<String, dynamic> json) {
  return (json['name'] as String, json['age'] as int);
}

void main() {
  // Destructures using a record pattern:
  var (name, age) = userInfo(json);

  /* Equivalent to:
  var info = userInfo(json);
  var name = info.$1;
  var age  = info.$2;
  */
}
```

Other ways to accomplish multiple returns are
either to create a class (which is more verbose), or use
another collection type like `List` or `Map` (which loses type safety).

{{site.alert.note}}
  Records' multiple-return and heterogenous-type characteristics enable
  parallelization of futures of different types, which you can read about in the
  [Library tour][].
{{site.alert.end}}

[collection types]: /language/collections
[Patterns]: /language
[pattern matching]: /language
[Library tour]: /guides/libraries/library-tour#handling-errors-for-multiple-futures