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

Records are comma-delimited lists of named or positional fields,
enclosed in parenthesis:

```dart
var record = ('first', a: 2, b: true, 'last');    // Record expression
```

Named fields inside record type annotations go inside a brace-delimited section
of type and name pairs:

```dart
(Sring, {int a, bool b}, String?) record;    // Record type annotation
```
Naming fields in record type annotations is optional for documentation purposes.
The names don't need to match any record expression corresponding to the type.

## Record fields

Record fields are accessible through built-in getters. Records are immutable,
so fields do not have setters. 

Named fields expose getters of the same name. Positional fields expose getters
of the name `$<position>`, skipping named fields:

```dart
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

There is no explicit record type; records are
structurally typed based on the types of their fields.

Each field in a record has its own type, which can be different from other
fields' types in the same record. Records are transparent to the type system.
The type system remembers and applies each fields' type wherever it is
accessed from the record:

```dart
var oneField = record.$1;       // oneField is a String
var anotherField = record.a;    // anotherField is an int 
```

If two unrelated libraries create records with the same set of fields,
the type system understands that those records are the same type even though the
libraries are not coupled to each other.

## Record equality

Two records are equal if they have the same _shape_ (set of fields),
and their corresponding fields have the same values.
Named field order does not affect a record's shape:

```dart
var a = (x: 1, 2);
var b = (2, x: 1);
assert(a == b);        // True
```

Records automatically define `hashCode` and `==` methods structurally based on
their fields.

{% comment %}
    Example of record as a composite hash key in map? Supposedly a benefit of
    record value semantice.
{% endcomment %}

## Multiple returns

Records allow functions to return multiple values bundled together:

```dart
(String, int) userInfo(Map<String, dynamic> json) {
  return (json['name'] as String, json['age'] as int);
}

main() {
  var info = userInfo(json);
  var name = info.$1;
  var age  = info.$2;
}
```

The only ways to accomplish multiple returns otherwise are
either to create a class (which is verbose), or use
another collection type like List or Map (which lose type safety).

{{site.alert.note}}
  Records' multiple-return and heterogenous-type characteristics enable
  parallelization of Futures of different types, which you can read about in the
  [Library tour][].
{{site.alert.end}}

[collection types]: /language/collections
[Patterns]: /language
[Library tour]: /guides/libraries/library-tour#handling-errors-for-multiple-futures