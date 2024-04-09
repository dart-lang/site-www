---
title: Build a web app with Dart
description: Get started writing web apps in Dart.
---

This page describes the steps to start developing **web-only** apps with Dart.
If you want to write a **multi-platform** app, then
[try Flutter.]({{site.flutter}}/web)

Before you begin, ensure you're comfortable with Dart basics
by reading the [Introduction to Dart](/language).
Then follow the steps below to create a small web app with Dart.

## 1. Install Dart {:#install-dart}

{% include 'get-sdk.md' %}

## 2. Get CLI tools or an IDE (or both) {:#tools}

<i class="material-symbols">terminal</i>
If you like to use the command line, install the [`webdev`][] package:

```console
$ dart pub global activate webdev
```

<i class="material-symbols">web</i>
Although using an IDE is optional, we highly recommend using one.
For a list of available IDEs, see the
[overview of editors & debuggers][].

[overview of editors & debuggers]: /tools#editors

## 3. Create a web app {:#create}

<i class="material-symbols">terminal</i>
To create a web app from the command line,
use the [`dart create`][] command with the `web` template:

```console
$ dart create -t web quickstart
```

<i class="material-symbols">web</i>
To create the same web app from an IDE that has Dart integration,
create a project using the template named **Bare-bones Web App**.

[`dart create`]: /tools/dart-create

## 4. Run the app {:#run}

<i class="material-symbols">terminal</i>
To run the app from the command line,
use [`webdev`][] to build and serve the app:

```console
$ cd quickstart
$ webdev serve
```

<i class="material-symbols">web</i>
Or run the app from your IDE.

To view your app, use the Chrome browser
to visit the app's URL—for example,
[`localhost:8080`](http://localhost:8080).

Whether you use an IDE or the command line,
[`webdev serve`][] builds and serves your app
using the development JavaScript compiler.
Startup is slowest the first time the
development compiler builds and serves your app.
After that, assets are cached on disk and incremental builds are much faster.

Once your app has compiled, the browser should display
"Your Dart app is running."

![Launched bare-bones app](/assets/img/bare-bones-web-app.png){:width="500"}

[`webdev serve`]: /tools/webdev#serve

## 5. Add custom code to the app {:#add-code}

Let's customize the app you just created.

1. Copy the `thingsTodo()` function from the following snippet
   to the `web/main.dart` file:

   ```dart
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
   ```

2. Add the `newLI()` function (as shown below).
   It creates a new `LIElement` containing the specified `String`.

   ```dart
   Iterable<String> thingsTodo() sync* { /* ... */ }

   [!HTMLLIElement newLI(String itemText) =>!]
     [!(document.createElement('li') as HTMLLIElement)..text = itemText;!]
    
   void main() { /* ... */ }
   ```

3. In the `main()` function, append content to the `output` element
   using `appendChild` and the values from `thingsTodo()`:

   ```dart
   Iterable<String> thingsTodo() sync* { /* ... */ }

   HTMLLIElement newLI(String itemText) =>
     (document.createElement('li') as HTMLLIElement)..text = itemText;

   void main() {
    final output = querySelector('#output');
    [!for (final item in thingsTodo()) {!]
      [!output?.appendChild(newLI(item));!]
    [!}!]
   }
   ```

4. Save your changes.

5. The `webdev` tool automatically rebuilds your app.
   Refresh the app's browser window.
   Now your simple Dart app has a todo list!
   It should look something like this:<br>
   ![Running the revised app](/assets/img/bare-bones-todo.png){:width="500"}

6. Optionally, improve the formatting by editing `web/styles.css`,
   then reload the app to check your changes.

   ```css
   #output {
     padding: 20px;
     [!text-align: left;!]
   }
   ```


## 6. Use Dart DevTools to inspect the app {:#devtools}

Use Dart DevTools to set breakpoints, view values and types,
and step through your app's Dart code.
For setup details and a walkthrough, see
[Debugging Dart Web Apps][].

[Debugging Dart Web Apps]: /web/debugging

## 7. Build and deploy your web app {:#deploy}

To run your web app outside your development environment,
you'll need to build and deploy it.
To learn more about deploying Dart web apps,
check out [Web deployment][].

[Web deployment]: /web/deployment

## What next?

Check out these resources:

* Dart language, libraries, and conventions
  * [Language tour](/language)
  * [Core library walkthrough](/libraries)
  * [Effective Dart](/effective-dart)
* Web development
  * [JavaScript interoperability](/interop/js-interop)
  * [Web libraries and packages](/web/libraries)
  * [`dart:html` overview](/libraries/dart-html)
  * [Introduction to the DOM][]
* Tutorials and codelabs for Dart
  * [Tutorials](/tutorials)
  * [Codelabs](/codelabs)

If you get stuck, find help at [Community and support.](/community)

[Introduction to the DOM]: https://developer.mozilla.org/docs/Web/API/Document_Object_Model/Introduction

[`webdev`]: /tools/webdev
