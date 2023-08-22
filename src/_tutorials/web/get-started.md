---
title: "Get started: Web apps"
description: A guide to get you quickly writing web apps in Dart.
js: [{url: 'https://dartpad.dev/inject_embed.dart.js', defer: true}]
---

Follow these steps to start using Dart to develop **web-only** apps.
If you want to write a **multi-platform** app, then
[try Flutter.]({{site.flutter}}/web)

Still here?
First you'll play with Dart in your browser, no download required.
Then you'll install Dart and build a small web app.


## 1. Play with a web app in DartPad

With [DartPad][DartPad documentation]
you can experiment with the Dart language and APIs,
no download necessary.

For example, here's an embedded DartPad that lets you play with
the code for a todo-list generator.
Click **Run** to run the app;
the UI output appears to the right of the code.
Try editing the source code—perhaps you'd like to add "horses"
to the list of pets. 

{{site.alert.note}}
  {% include dartpad-embedded-troubleshooting.md %}
{{site.alert.end}}

```dart:run-dartpad:mode-html:ga_id-play_with_a_web_app
{$ begin main.dart $}
import 'dart:html';

Iterable<String> thingsTodo() sync* {
  const actions = ['Walk', 'Wash', 'Feed'];
  const pets = ['cats', 'dogs'];

  for (final action in actions) {
    for (final pet in pets) {
      if (pet != 'cats' || action == 'Feed') {
        yield '$action the $pet';
      }
    }
  }
}

void addTodoItem(String item) {
  final listElement = LIElement()..text = item;
  todoList.children.add(listElement);
}

final UListElement todoList = querySelector('#todolist') as UListElement;

void main() {
  thingsTodo().forEach(addTodoItem);
}

{$ end main.dart $}
{$ begin index.html $}
<h2>A Simple To-Do List</h2>

<p>Things to do:</p>

<ul id="todolist">
</ul>
{$ end index.html $}
```

More information:

* [DartPad documentation][]
* [Dart language tour][]
* [Dart library tour][]
* [Tutorial introduction to using Dart for basic web programming][]

## 2. Install Dart

{% include get-sdk.md %}

## 3. Get CLI tools or an IDE (or both)

<i class="material-icons">terminal</i>
If you like to use the command line, install the [`webdev`][] package:

```terminal
$ dart pub global activate webdev
```

<i class="material-icons">web</i>
Although using an IDE is optional, we highly recommend using one.
For a list of available IDEs, see the
[overview of editors & debuggers][].


## 4. Create a web app

<i class="material-icons">terminal</i>
To create a web app from the command line, use these commands:

```terminal
$ dart create -t web quickstart
```

<i class="material-icons">web</i>
To create the same web app from an IDE that has Dart integration,
create a project using the template named **Bare-bones Web App**.


## 5. Run the app

<i class="material-icons">terminal</i>
To run the app from the command line, 
use [`webdev`][] to build and serve the app:

```terminal
$ cd quickstart
$ webdev serve
```

<i class="material-icons">web</i>
Or run the app from your IDE.

To view your app, use the Chrome browser
to visit the app's URL—for example, 
[localhost:8080](http://localhost:8080).

Whether you use an IDE or the command line,
[`webdev serve`][] builds and serves your app
using the development JavaScript compiler.
Startup is slowest the first time the 
development compiler builds and serves your app.
After that, assets are cached on disk and incremental builds are much faster.

Once your app has compiled, the browser should display
"Your Dart app is running."

![Launched bare-bones app](/assets/img/bare-bones-web-app.png){:width="500"}


## 6. Add custom code to the app

Let's customize the app you just created.

 1. Copy the `thingsTodo()` function from the DartPad above
    to the `web/main.dart` file.

 2. Add the `newLI()` function (as shown below).
    It creates a new `LIElement` containing the specified `String`.

    {% prettify dart tag=pre+code %}
    Iterable<String> thingsTodo() sync* { ... }

    [!LIElement newLI(String itemText) => LIElement()..text = itemText;!]

    void main() { ... }
    {% endprettify %}

 3. In the `main()` function, initialize the `output` element using
    `thingsTodo()`:

    {% prettify dart tag=pre+code %}
    Iterable<String> thingsTodo() sync* { ... }

    LIElement newLI(String itemText) => LIElement()..text = itemText;

    void main() {
      querySelector('#output')?[!.children.addAll(thingsTodo().map(newLI));!]
    }
    {% endprettify %}

 4. Save your changes.

 5. The webdev tool automatically rebuilds your app.
    Refresh the app's browser window.
    Now your simple Dart app has a todo list!
    It should look something like this:<br>
    ![Running the revised app](/assets/img/bare-bones-todo.png){:width="500"}

 6. Optionally, improve the formatting by editing `web/styles.css`,
    then reload the app to check your changes.

    {% prettify css tag=pre+code %}
    #output {
      padding: 20px;
      [!text-align: left;!]
    }
    {% endprettify %}


## 7. Use Dart DevTools to inspect the app

Use Dart DevTools to set breakpoints, view values and types,
and step through your app's Dart code.
For setup details and a walkthrough, see
[Debugging Dart Web Apps][].

{{site.alert.info}}
  **Feeling lost? Don't worry!** This was a whirlwind introduction to Dart and
  web programming that left out many details. For a gentler approach, try a
  [low-level HTML tutorial for Dart][].
{{site.alert.end}}


## What next?

Check out these resources:

* Tutorials and codelabs for Dart
  * [Tutorials](/tutorials)
  * [Codelabs](/codelabs)
* Dart language, libraries, and conventions
  * [Language tour](/language)
  * [Library tour](/guides/libraries/library-tour)
  * [Effective Dart](/effective-dart)
* Tools & libraries
  * [Dart SDK](/tools/sdk)
  * [Dart tools](/tools)
  * [IDEs](/tools#ides-and-editors)
  * [Web libraries and packages](/web/libraries)

If you get stuck, find help at [Community and support.](/community)

[DartPad documentation]: /tools/dartpad
[Dart language tour]: /language
[Dart library tour]: /guides/libraries/library-tour
[Dart tools]: /tools
[Debugging Dart Web Apps]: /web/debugging
[low-level HTML tutorial for Dart]: /tutorials/web/low-level-html
[overview of editors & debuggers]: /tools#ides-and-editors
[Tutorial introduction to using Dart for basic web programming]: /tutorials/web/low-level-html/connect-dart-html
[`webdev`]: /tools/webdev
[`webdev serve`]: /tools/webdev#serve
