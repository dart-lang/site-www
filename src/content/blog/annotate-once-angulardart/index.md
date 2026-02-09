---
title: "Annotate Once: AngularDart"
description: "Introducing Component Inheritance"
publishDate: 2017-08-31
author: "leonsenft"
image: images/1JLI4Zv7yp3j6qSzoaGEehw.png
category: other
tags:
  - dart
  - angular
  - programming
  - angulardart
  - components
---


<DashImage src="images/1JLI4Zv7yp3j6qSzoaGEehw.png" />


AngularDart allows developers to create [components and directives](https://webdev.dartlang.org/angular/guide/architecture) by annotating class definitions with metadata. This metadata instructs the compiler to generate code necessary for dependency injection, template construction, data binding, and more.

```dart
import 'package:angular/angular.dart';

@Component(
  selector: 'greet',
  template: '<p>Hello {{name}}!</p>',
)
class GreetComponent {
  String name;
}
```

Until recently, the AngularDart compiler did not process metadata on supertypes. This meant sharing common functionality between different components and directives via inheritance required redeclaring all of the metadata in each class.

Let’s see what this pattern looked like.

*Throughout this article, the following example will be revisited to demonstrate the benefits of metadata inheritance. This is a simplified example drawn from the official [Material Design components for AngularDart](https://pub.dartlang.org/packages/angular_components) used at Google.*

```dart
import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';

@Directive(selector: '[my-button]')
class MyButtonDirective {
  final StreamController<UIEvent> _trigger = new StreamController<UIEvent>();
  
  @Input()
  bool disabled = false;

  @Output()
  Stream<UIEvent> get trigger => _trigger.stream;

  @HostListener('click', const [r'$event'])
  void onClick(MouseEvent event) {
    if (disabled) return;
    _trigger.add(event);
  }

  @HostListener('keypress', const [r'$event'])
  void onKeyPress(KeyboardEvent event) {
    if (disabled) return;
    if (event.keyCode == KeyCode.ENTER) {
      _trigger.add(event);
    }
  }
}
```

Here we have a simple directive that adds button functionality to its host element. If the host element is clicked, or focused when the enter key is pressed, it will emit an event via the `trigger` output. It can also be disabled to prevent emitting events. This logic can be reused to create a button component using inheritance.

```dart
import 'package:angular/angular.dart';

import 'my_button_directive.dart';

@Component(
  selector: 'my-button',
  template: '<ng-content></ng-content>',
  inputs: const ['disabled'],
  outputs: const ['trigger'],
  host: const {
    '(click)': r'onClick($event)',
    '(keypress)': r'onKeyPress($event)',
  },
)
class MyButtonComponent extends MyButtonDirective {}
```

Now we have a component which inherits button behavior from the directive, but notice the need to redeclare the input, output, and host listeners in the derived component annotation?

As of version 4.0, redeclaring metadata on derived types is no longer necessary!

```dart
import 'package:angular/angular.dart';

import 'my_button_directive.dart';

@Component(
  selector: 'my-button',
  template: '<ng-content></ng-content>',
)
class MyButtonComponent extends MyButtonDirective {}
```

Now `MyButtonComponent` implicitly has the same input, output and host listeners as `MyButtonDirective`, similar to how a class normally inherits properties and methods. Now that you’ve seen a simple — and hopefully compelling — example, let’s look at what exactly is inheritable and how it works.

### What is inheritable?

The following annotations are now inherited from all supertypes, including superclasses, interfaces, and mixins.

* `@ContentChild` / `@ContentChildren`

* `@HostBinding`

* `@HostListener`

* `@Input`

* `@Output`

* `@ViewChild` / `@ViewChildren`

This means it’s no longer necessary to redeclare any of the above annotations in a derived class.

### What isn’t inheritable?

Templates, styles, and other `@Directive` parameters are *not* inherited. Only metadata that is bound to a property or method is inherited. This decision was made because derived types can override accessors and methods, referencing their original implementation via `super`, whereas no such mechanism exists for the values bound to other metadata.

### Inherited metadata is immutable

It’s still valid to redeclare annotations in derived types; however, modifying the inherited metadata or binding it to a different property is not permitted.

```dart
import 'package:angular/angular.dart';

import 'my_button_directive.dart';

@Directive(selector: '[illegal-button]')
class IllegalButtonDirective extends MyButtonDirective {
  @Input('notEnabled') // Changing the binding name causes a compile error.
  set disabled(bool value) {
    super.disabled = value; 
  }
}
```

This restriction may be lifted in the future, but for now is necessary to simplify tooling and ensure components and directives are easily substitutable.

### Metadata base types

An interesting consequence arises as a result of metadata inheritance: classes that are not directives or components themselves, may now be annotated to serve as base types or mixins for others. Let’s further develop our example to demonstrate.

There’s an issue with the current button component implementation: the button isn’t focusable. This means it’s not accessible, and can’t be triggered via the key press listener. This issue is also present with the button directive if its host element isn’t focusable. We can solve this problem by making the button directive set the `tabindex` property on the host element.

`MyButtonDirective` could implement this directly, but let’s imagine we have other components that will want focusable behavior as well. Instead, we’ll create an abstract class that can be extended or mixed in by directives or components.

```dart
import 'package:angular/angular.dart';

abstract class HasTabIndex {
  bool get disabled;

  @HostBinding('tabindex')
  String get tabIndex => disabled ? null : '0';
}
```

We can now simply extend or mix in `HasTabIndex` to make the button directive — and consequently the derived component — focusable.

```dart
@Directive(selector: '[my-button]')
class MyButtonDirective extends HasTabIndex {
  ...
}
```

### Conclusion

We’ve seen how inheritable metadata reduces code duplication among components and directives with shared functionality. Furthermore, it should improve readability by allowing metadata to live next to its associated field or method. Hopefully you’ll find this feature helpful in developing and maintaining your own projects.