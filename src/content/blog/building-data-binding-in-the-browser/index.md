---
title: "Building data binding in the browser"
description: "Data binding, or updating the view (usually UI) from your application’s code is probably the holy grail of browser-based web frameworks —…"
publishDate: 2017-07-04
author: "matanlurey"
image: images/1QUn_zBM0SBDRG4TtMBiM2A.png
category: other
tags:
  - javascript
  - dart
  - react
  - framework
  - angular
---


<DashImage src="images/1QUn_zBM0SBDRG4TtMBiM2A.png" alt="Data binding as popularized by the Angular (MVC-style). Lots of arrows and pictures. That’s always a good sign." caption="Data binding as popularized by the Angular (MVC-style). Lots of arrows and pictures. That’s always a good sign." />


*Data binding*, or updating the view (usually UI) from your application’s code is probably the *holy grail* of browser-based web frameworks — the reason they exist, and the reason [web standards have tried to shift](https://developers.google.com/web/fundamentals/getting-started/primers/customelements) in order to make it easier to “use the platform”.

In this blog post I’ll be reviewing four forms of data binding, and writing a simple library/throw-away framework for each — mostly as a learning experience. I’ll be using [*Dart*](https://www.dartlang.org/), which is a high-level programming language I work on at Google (where I work on the AngularDart team), but *most* of the concepts below apply to JavaScript, TypeScript, or *Other*Script flavors.

Behold, the four horsemen of the data-binding apocalypse:

* Static templating

* Manual data-binding (i.e. just using the DOM)

* MVC-style data-binding (as popularized by Angular)

* Reactive data-binding (as popularized by React)

If you’re just interested in the code, it’s all available on GitHub:

***One quick note** — nothing here is optimized, and I’ve taken some shortcuts to make this tutorial achievable in about an hour, which means I didn’t write any pre-processors or code generators — and instead I’ve hand-written what generated code would look like; those files end in “.g.dart”.*

<GithubEmbed repo="matanlurey/building-data-binding" title="building-data-binding - Accompanying code for &quot;Building Data Binding in the Browser&quot;" image="images/0QVBz3DSv-QKuugcc.jpg" />


### Static templating

As popularized mostly by *server-side* frameworks, such as those in PHP, Python, Ruby, and such — they emit *static* HTML that is transferred and displayed (usually) directly in the browser. Most non-JavaScript sites with any sort of backend use this strategy.

So, at it’s core, you are just returning plain-HTML. Some newer web frameworks also allow *server-side rendering* (i.e. using your same client-side code to render all or part of the HTML on the server), but that is beyond the scope of this article.

Because Dart (and most *OtherScripts*, at this point) have [*interpolation*](https://www.dartlang.org/guides/language/language-tour#strings), or the ability to evaluate and create strings at runtime, doing a very basic form of static templating is extremely easy:

```dart
void main() {
  var name = 'Matan';
  print('Hello $name!');  
}

```

Or, we can get a little fancier, and *actually* output some HTML. In this example, I’ll return a bulleted list of all the things I like to do on mondays:

```dart
void main() {
  var sundays = [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  print(
    'On Sunday: \n'
    '<ul>\n'
    '${sundays.map((i) => '  <li>$i</li>\n').join('')}'
    '</ul>\n'
  );
}

```

This outputs:
> On Sunday: 
&lt;ul&gt;
 &lt;li&gt;sleep in&lt;/li&gt;
 &lt;li&gt;eat brunch&lt;/li&gt;
 &lt;li&gt;wash car&lt;/li&gt;
&lt;/ul&gt;

Not exactly the *best* templating solution, but something like this can often work for lots of sites, and I’ve increasingly become a fan of using the *simplest* tool you can for a job, and only scaling up when you really really need it. If you really need a micro-library though —OK let’s write one.

What would you want a basic static templating library to do? Probably in this case handle creating HTML syntax for you so it’s less error prone, and give you some helper functions for creating common tags and such. First let’s design a class called *Tag*, which encapsulates a single HTML element, and a class called *Node* and *Text*:

```dart
abstract class Node {}

class Tag implements Node {
  final String name;
  final List<Node> children;

  const Tag(this.name, {this.children: const []});

  @override
  String toString() => '<$name>${children.join('')}</$name>';
}

class Text implements Node {
  final String text;

  const Text(this.text);

  @override
  String toString() => text;
}

void main() {
  var sundays = [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  var output = new Tag(
    'ul',
    children: sundays.map(
      (i) => new Tag('li', children: [new Text(i)]),
    ).toList(),
  );
  print(output);
}

```

This roughly does the same as our above code, but we’ve implemented some abstractions — a *Tag* is an HTML element, and has any number of children, and *Text* is well — text. We’ve written more code than before, but perhaps this is nicer to have for some. It’s trivial to include things like HTML attributes, so I’ll skip that for now.

Personally though, one thing bothers me, which is using *toString* in order to output production code. I’m also a fan of the [visitor pattern](https://en.wikipedia.org/wiki/Visitor_pattern), which neatly separates this logic from our DSL:

```dart
abstract class Visitor<T> {
  T visitNode(Node node);
  T visitTag(Tag node);
  T visitText(Text node);
}

class HtmlEmitter implements Visitor<String> {
  @override
  String visitNode(Node node) => node.accept(this);

  @override
  String visitTag(Tag node) {
    final buffer = new StringBuffer('<${node.name}>');
    buffer
      ..writeAll(node.children.map(visitNode))
      ..write('</${node.name}>');
    return buffer.toString();
  }

  @override
  String visitText(Text node) => node.text;
}

abstract class Node {
  R accept<R>(Visitor<R> visitor);
}

class Tag implements Node {
  final String name;
  final List<Node> children;

  const Tag(this.name, {this.children: const []});

  @override
  R accept<R>(Visitor<R> visitor) => visitor.visitTag(this);
}

class Text implements Node {
  final String text;

  const Text(this.text);

  @override
  R accept<R>(Visitor<R> visitor) => visitor.visitText(this);
}

void main() {
  var sundays = [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  var output = new Tag(
    'ul',
    children: sundays.map(
      (i) => new Tag('li', children: [new Text(i)]),
    ).toList(),
  );
  print(new HtmlEmitter().visitNode(output));
}

```

Again, *more code*. But now if I want indented/formatted HTML syntax, or to add validation logic, or anything else, I can implement a new *Visitor* and I don’t have to change any of my other classes. Cool!

Finally, let’s wire up a very basic HTTP server using my new “library”. In this case, I’ll have it automatically listen on port 8080, and have it emit my TODO list for me:

```dart
import 'dart:io';

import 'package:static_templating/static_templating.dart';

main() async {
  final sundays = const [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  final server = await HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 8080);
  print('Listening to localhost:8080.');
  await for (final request in server) {
    print('Connection received. Writing TODO list...');
    final list = _createTodoList(sundays);
    final output = list.accept(new HtmlEmitter());
    request.response
      ..headers.contentType = ContentType.HTML
      ..write(output)
      ..close();
    print('Done!');
  }
}

Node _createTodoList(Iterable<String> tasks) {
  return new Tag(
    'ul',
    children: tasks.map((i) => new Tag('li', children: [new Text(i)])).toList(),
  );
}

```

*(One thing I especially like about Dart is I didn’t have to import any 3rd party library to do this, setup any special tools, and I got static analysis to help me figure out how to set the ContentType header without Googling anything).*

Pretty boring, but it works! If you want to write your own server like this, I’d first check out the, in the order provided (again, I’m a huge fan of using the least libraries, as possible, for a given task):

* [dart:io](https://www.dartlang.org/articles/dart-vm/io), the standard VM library (not available in the browser)

* [shelf](https://pub.dartlang.org/packages/shelf), a middleware-based server technology like Express for NodeJS

* more full-featured frameworks like [aqueduct](http://aqueduct.io/) or [angel](https://angel-dart.github.io/)

And that’s it. You can use similar techniques to render HTML in the browser, of course, but that’s rather boring, and you probably want the HTML to change when the user interacts with the page.

### Manual data-binding

*Before* the era of JavaScript web frameworks (when everything was more of a library), it was common to either write code directly against the DOM (in “vanilla” JavaScript) or to use a library like [jQuery](https://jquery.com/) to remove browser differences and make common tasks easier.

Luckily [dart:html](https://webdev.dartlang.org/tutorials/low-level-html/connect-dart-html) is a high-level library provided by the Dart SDK, and even in JavaScript modern-day browsers are full featured enough not to need a library for simple data-binding. What if I want to bring my new “Sunday TODO list” — and be able to check-off (delete) items as I finish them?

<DashImage src="images/1ggiMuy98lvPyUWVcf-HOFA.png" alt="The world’s greatest UI" caption="The world’s greatest UI" />


Enter *manual* data binding. Instead of relying on any framework or specific library, I will just create HTML elements, and listen to events in order to know when to update the DOM, all myself.

```html
<html>
  <body>
    <div id="todo-list"></div>
  </body>
  <script type="application/dart" src="main.dart"></script>
  <script src="packages/browser/dart.js"></script>
</html>

```

```dart
import 'dart:html';

main() {
  final sundays = const [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  document.querySelector('#todo-list')
    ..append(new UListElement()
      ..children.addAll(
        sundays.map(_createListItem),
      ));
}

Element _createListItem(String item) {
  final li = new LIElement();
  final button = new ButtonElement()
    ..text = 'Done'
    ..onClick.listen((_) => li.remove());
  li
    ..appendText(item)
    ..append(button);
  return li;
}

```

Again, pretty boring. But if I was really making a simple TODO app just like this, not too bad. Dart’s `..` or [method cascades](http://news.dartlang.org/2012/02/method-cascades-in-dart-posted-by-gilad.html) make this *relatively* terse, and I could add other basic behavior pretty easily.

More or less, every other form of data/template-binding is trying to do the *above —* build some DOM, and update the DOM when something happens — but either in a (a) more performant, (b) more elegant, (c) more ergonomic, and/or (d) more modular way.

## Automatic data-binding

As of the current browser specifications, nothing exists to make this *easier*. Some might argue that’s the reason WebComponents V1 hasn’t taken off compared to existing frameworks — frameworks have made it so easy and/or ergonomic to build and update DOM that nobody wants to go backwards.

I work on the AngularDart team, so I’ll be showing an example next of MVC-style data binding (as popularized by Angular, but I’m told Ember is another excellent example — and I’m sure there are many many others).

### MVC-style data-binding

The crux of MVC is separation of logic between the *view (*in the browser this is usually the DOM) and the controller (in the browser this is usually your JavaScript). I’ll skip the *m* or model, for now.

Angular popularized (or at least attempted) the idea that you should be able to write plain-old dumb-objects (PODOs), include any logic you want, and it “just bind” to an HTML template. Consider the following MVC-style encapsulation of our Sunday TODO list:

```html
<ul>
  <!--
    Invented syntax. *bind="<TYPE> <TO>".

    In this case, a for-loop bound to "items", with every individual "item".
  -->
  <li *bind="for items:item">
    <!-- Pretty much the gold-standard for string interpolation. -->
    {{item}}
    <!--
      Invented syntax. *event="<NAME>:<TO>".

      In this case, a "click" event that invokes the "onClick" method.
    -->
    <button *event="click:onClick">Done</button>
  </li>
</ul>

```

So what do you think? There are some advantages and disadvantages here:

**PROs**:

* You’re able to encapsulate much/all of your view logic in a single file.

* While non-standard, this is *fairly* readable to even non-coders with as little as some sort of “cheat-sheet” that explains additions to the HTML specification for your templating language.

* You didn’t write any actual code — so a framework with a good ahead-of-time preprocessor can “compile” this, potentially efficiently, to JavaScript/DOM invocations.

**CONs**:

* If you don’t buy into the MVC religion, you might not like this file.

* Even though you might have mastered HTML/CSS and Dart or JavaScript, you and your developers have to learn yet-another-thing that is neither of those.

* You didn’t write any actual code — so you are more or less hoping the framework authors are going to preprocess/compile this efficiently and the output is going to be nearly as good as if you would have wrote the data binding manually (*hint:* it almost never is).

I didn’t show any “controller” code yet, so let’s write a simple class:

```dart
class ListController {
  final List<String> items;

  ListController(this.items);

  void onClick(String item) {
    items.remove(item);
  }
}

```

Getting this to “just work” is going to require… writing a framework. This is a blog post, so instead of actually writing a parser for our template language, a pre-processor/compiler, we’ll simply hand-write the code a generator would otherwise create.

First lets establish our “framework”. I’m going to make it simple:

```dart
import 'dart:html';

abstract class Controller {
  View get view;

  /// Invoke when something in the DOM should be changed.
  ///
  /// In a "real framework" this would collate and be more intelligent.
  void markDirty() => view.detectChanges(this);
}

abstract class View<C extends Controller> {
  /// Create the initial representation of the DOM.
  Element build();

  /// Applies data-binding for a given [controller].
  void detectChanges(C controller);
}

```

I’ve created two abstractions, a *Controller*, or a class I’ll extend to create my business logic (in Angular this is commonly a *component*), and a *View*, or the representation of my HTML file as plain Dart (or later, JavaScript).

Let’s create the generated code, or “view”, first:

```dart
// A dart "partial library", that is, in the namespace of another library.
part of list;

class _ViewListController extends View<ListController> {
  UListElement _ul;
  List<String> _itemsLastCheck = const [];

  @override
  Element build() {
    return _ul = new UListElement();
  }

  @override
  void detectChanges(ListController controller) {
    // Not an exhaustive check. In a real framework you'd need to verify that
    // the contents of the list are the same, not just the lists are of
    // different lengths.
    if (_itemsLastCheck.length != controller.items.length) {
      _updateItems(controller);
    }
  }

  void _updateItems(ListController controller) {
    // Intentionally not efficient. In a real framework you'd want to track
    // every <li> individually to avoid blowing away big parts of the DOM and
    // rebuilding.
    _ul.children
      ..clear()
      ..addAll(controller.items.map((i) => _createLi(controller, i)));
    _itemsLastCheck = controller.items.toList();
  }

  Element _createLi(ListController controller, String item) {
    final li = new LIElement()..appendText(item);
    li.append(new ButtonElement()
      ..text = 'Done'
      ..onClick.listen((_) => controller.onClick(item)));
    return li;
  }
}

```

I took some shortcuts above, for example, *items* only updates when the list’s length changes, and I’m not maintaining state at all, so if the list updates I blow away the existing DOM and create new DOM. A typical framework (including Angular) would be much smarter about this — but part of this article is showing exactly how much work behind-the-scenes is happening for even the simplest data-binding.

Finally, let’s update our controller to use our framework:

```dart
library list;

import 'dart:html';

import 'package:mvc_data_binding/framework.dart';

// Would be generated in a typical framework.
part 'list.g.dart';

class ListController extends Controller {
  final List<String> items;

  ListController(this.items);

  void onClick(String item) {
    items.remove(item);
    markDirty();
  }

  @override
  final view = new _ViewListController();
}

```

And put it all together in *main.dart*:

```html
<html>
  <body>
    <div id="todo-list"></div>
  </body>
  <script type="application/dart" src="main.dart"></script>
  <script src="packages/browser/dart.js"></script>
</html>

```

```dart
import 'dart:html';

import 'package:mvc_data_binding/list.dart';

main() {
  final sundays = [
    'sleep in',
    'eat brunch',
    'wash car',
  ];
  final container = document.querySelector('#todo-list');
  final component = new ListController(sundays);
  container.append(component.view.build());

  // Start change detection. This should be automatic in most frameworks.
  component.view.detectChanges(component);
}


```

Now we have an *Angular-style* MVC framework, and I imagine it would take anywhere between a few hours and a few days (or weeks, or months) to create a code generator for automatically emitting the .g.dart file for you, depending on how simple or complex you want to go. That’s out of scope of this article though.

### Reactive-style data-binding

The FP or reactive approach to data-binding is different — instead of separating your view and controller logic, you instead model your application as functions (or classes) that take as inputs values (data) and emit as output “view” (html in this case).

This is the approach taken by React, Vue, and even [Flutter](https://flutter.io).

Consider the following:

```dart
Node todoList(List<String> todos) => new Tag(
  'ul',
  children: todos.map(
    (i) => new Tag('li', children: [
      new Text(i),
      new Tag('button', children: [
        'Done',
      ], events: {
        'click': () => throw new UnimplementedError(),
      }),
    ]),
  ).toList(),
);

```

This is actually not too different from what we did above in *static template binding*, except that modern day libraries and frameworks use a series of algorithms in order to minimize impact on the DOM. For example, if you remove a single `&lt;li&gt;` a typical framework like *React* won’t rebuild anything.

**PROs**:

* You’re able to encapsulate all your “component's” logic in a single place.

* Doesn’t require any special pre-processing or compilers.

* For programs written with say, the Flutter SDK, [your IDE becomes your god](https://flutter.io/intellij-ide/). Auto-complete all-the-things, and you never even need to learn how to type (sort of).

* Easy to use but [optional tools like JSX](https://facebook.github.io/react/docs/introducing-jsx.html) can make this quite a bit terser.

**CONs**:

* Like before, the MVC purists (and parts of various companies’ web platform DevRel teams) might scream a bit — you are now putting HTML, JavaScript, and potentially CSS in a JavaScript function (or class).

* Unlike something like Angular (though it has its own problems), you can’t really “inspect” the code outputted by this function, that is, you have to be very familiar with idiosyncrasies of the framework when optimizing lists of thousands of items, lazy scrolling, so on and so forth.

I promised I’d write a simple library for a reactive-style data-binding framework, but I decided by the end of this article it had already been done better by my colleague Yegor with his framework “Butterfly”:

<GithubEmbed repo="yjbanov/butterfly" title="butterfly - A web framework for Dart based on Flutter's widget model" image="images/0mC9GWhN0QE2u20u0.jpg" />


```dart
// Copyright 2016 Google Inc. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:butterfly/butterfly.dart';

class App extends StatelessWidget {
  Node build() {
    return div(attrs: {'id': 'greeting'})([
      text('Hello, World!'),
      button(eventListeners: {
        EventType.click: (_) {
          print('Woohoo!');
        }
      })([
        text('Update'),
      ]),
    ]);
  }
}
```

## So what is the conclusion?

There is none, so sorry to disappoint if you made down this far looking for a benchmark table or something to use to justify the 200 hours you spent migrating a project to the latest-and-greatest framework. Arguably each approach has strengths and weaknesses, and I’ve seen more frameworks start to use hybrid models in places as well.

Some general rules of thumb to take home:

* **Data-binding is hard**. Remember that the next time you ask why there isn’t a “simple lightweight data-binding library that just does X and Y”.

* **Template systems are built around tradeoffs**. You either trade-off ergonomics, speed, or complexity. I’ve yet to use a single framework that completely succeeds at everything — and my guess is nobody else has ever given the number of frameworks and models that exist.

* If you are building your own site, and are tempted to write a “micro” framework, **start simple**. Do just the smallest amount of things possible, and only add complexity when it solves a *big* problem. **Boiler-plate itself isn’t evil** — just boiler-plate that is error prone and hard to write *correctly*.

I’d be interested to hear from readers what they thought, and if they’d like me to go into any more detail on any given subject. Have a wonderful July 4th!