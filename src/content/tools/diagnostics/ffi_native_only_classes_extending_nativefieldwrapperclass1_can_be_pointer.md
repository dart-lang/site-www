---
title: ffi_native_only_classes_extending_nativefieldwrapperclass1_can_be_pointer
description: >-
  Details about the ffi_native_only_classes_extending_nativefieldwrapperclass1_can_be_pointer
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
show_breadcrumbs: true
bodyClass: highlight-diagnostics
---

_Only classes extending NativeFieldWrapperClass1 can be passed as Pointer._

## Description

The analyzer produces this diagnostic when a function or method annotated
with `@Native` has a parameter in its FFI signature that is a `Pointer`,
but the corresponding Dart parameter type is a class instance that doesn't
extend `NativeFieldWrapperClass1` (or is a Pointer or TypedData).

## Example

The following code produces this diagnostic because `MyService` doesn't
extend `NativeFieldWrapperClass1`, but the `@Native` signature for its
`process` method indicates the receiver should be passed as a `Pointer<Void>`:

```dart
import 'dart:ffi';

class MyService { // MyService does not extend NativeFieldWrapperClass1
  @Native<Void Function(Pointer<Void>, Int8)>(symbol: 'MyService_process')
  external void [!process!](int data);
}
```

## Common fixes

1.  **If the Dart class is intended to wrap a native object:**
    Make the Dart class extend `NativeFieldWrapperClass1`. This is the
    correct approach if the Dart class instance has a corresponding native
    object whose pointer should be passed.
    ```dart
    import 'dart:ffi';

    class MyService extends NativeFieldWrapperClass1 {
      @Native<Void Function(Pointer<Void>, Int8)>(symbol: 'MyService_process')
      external void process(int data);
    }
    ```

2.  **If you intend to pass an opaque handle to the Dart object:**
    Change the FFI signature in the `@Native` annotation to use `Handle`
    instead of `Pointer` for the parameter. This allows passing a
    reference to the Dart object itself, which native code can interact
    with using the Dart C API.
    ```dart
    import 'dart:ffi';

    class MyService {
      @Native<Void Function(Handle, Int8)>(symbol: 'MyService_process')
      external void process(int data);
    }
    ```
