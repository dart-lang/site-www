---
title: "Get started: web apps"
description: A guide to get you quickly writing web apps in Dart.
---

Follow these steps to start using Dart to develop web apps.
First you'll play with Dart in your browser, no download required.
Then you'll install Dart and build a small web app.


## 1. Play with a web app in DartPad

With DartPad you can experiment with the Dart language and APIs,
no download necessary.

For example, here's an embedded DartPad that lets you play with
the code for a todo-list generator.
Click run {% asset red-run.png alt="" %} to run the app;
the console output appears beneath the code.
Try editing the source code—perhaps you'd like to add "horses"
to the list of pets. To get the full DartPad experience,
which includes the web UI that the app produces,
<a href="{{site.dartpad}}/2a24f3f042f1c86cf91621c30adce771"
   target="_blank">open the example at dartpad.dartlang.org.</a>

<iframe
    src="{{site.custom.dartpad.embed-inline-prefix}}?id=2a24f3f042f1c86cf91621c30adce771&verticalRatio=70"
    width="100%"
    height="450px"
    style="border: 1px solid #ccc;">
</iframe>

More information:

* [DartPad documentation][]
* [Dart language tour][]
* [Dart library tour][]
* [Tutorial introduction to using Dart for basic web programming][]

## 2. Install Dart

{% include get-sdk.md %}

## 3. Get CLI tools or an IDE (or both)

<i class="fas fa-terminal dark"></i>
If you like to use the command line, install [webdev][]
and [stagehand:][stagehand]

```terminal
> pub global activate webdev
> pub global activate stagehand
```

<i class="material-icons">web</i>
Although using an IDE is optional, we highly recommend using one.
For a list of available IDEs, see the
[overview of editors & debuggers][].



## 4. Create a web app

<i class="fas fa-terminal dark"></i>
To create a web app from the command line, use these commands:

```terminal
> mkdir quickstart
> cd quickstart
> stagehand web-simple
> pub get
```

<i class="material-icons">web</i>
To create the same web app from an IDE that has Dart integration,
create a project using the template named **Bare-bones Web App**.


## 5. Run the app

<i class="fas fa-terminal dark"></i>
To run the app from the command line, use [webdev][] to build and serve the app:

```terminal
> webdev serve
```

<i class="material-icons">web</i>
Or run the app from your IDE.

To view your app, use the Chrome browser to visit the app's URL —
for example, [localhost:8080](localhost:8080).

Whether you use an IDE or the command line,
[webdev serve][] builds and serves your app
using the Dart development compiler, [dartdevc][].
Startup is slowest the first time dartdevc builds and serves your app.
After that, assets are cached on disk and incremental builds are much faster.

Once your app has compiled, the browser should display
"Your Dart app is running."

![Launched bare-bones app]({% asset bare-bones-web-app.png @path %}){:width="500"}


## 6. Add custom code to the app

Let's customize the app you just created.

 1. Copy the `thingsTodo()` function from the DartPad above
    to the `web/main.dart` file.

 2. In the `main()` method, initialize the `output` element using
    `thingsTodo()`:

    {% prettify dart %}
    void main() {
      Element output = querySelector('#output');
      [!output.children.addAll(thingsTodo().map(newLI));!]
    }

    [!LIElement newLI(String itemText) => LIElement()..text = itemText;!]

    [!Iterable<String> thingsTodo() sync* { ... }!]
    {% endprettify %}

 3. Save your changes.

 4. The webdev tool automatically rebuilds your app.
    Refresh the app's browser window.
    Now your simple Dart app has a todo list!
    It should look something like this:<br>
    ![Running the revised app]({% asset bare-bones-todo.png @path %}){:width="500"}

 5. Optionally, improve the formatting by editing `web/styles.css`,
    then reload the app to check your changes.

    {% prettify css %}
    #output {
      padding: 20px;
      [!text-align: left;!]
    }
    {% endprettify %}


## 7. Use DevTools to inspect the app

Use Chrome DevTools to set breakpoints, view values and types,
and step through your app's Dart code.
For setup details and a walkthrough, see
[Debugging Dart Web Apps][].

<aside class="alert alert-info" markdown="1">
  **Feeling lost? Don't worry!**
  This was a whirlwind introduction to Dart and web programming
  that left out many details.
  For a gentler approach, try a
  [low-level HTML tutorial for Dart][].
</aside>


## What next?

Check out these resources:

* Tutorials and codelabs for Dart
  * [Tutorials](/tutorials)
  * [Codelabs](/codelabs)
* Dart language, libraries, and conventions
  * [Sample code](/samples)
  * [Language tour](/guides/language/language-tour)
  * [Library tour](/guides/libraries/library-tour)
  * [Effective Dart](/guides/language/effective-dart)
* Tools & libraries
  * [Dart SDK](/tools/sdk)
  * [Dart tools](/tools)
  * [IDEs](/tools#ides-and-editors)
  * [Web libraries and packages](/web/libraries)

If you get stuck, find help at [Community and Support.](/community)

[Chocolatey]: https://chocolatey.org
[dartdevc]: /tools/dartdevc
[DartPad documentation]: /tools/dartpad
[Dart language tour]: /guides/language/language-tour
[Dart library tour]: /guides/libraries/library-tour
[Dart tools]: /tools
[Debugging Dart Web Apps]: /web/debugging
[Homebrew,]: http://brew.sh/
[Install the SDK]: /get-dart
[low-level HTML tutorial for Dart]: /tutorials/web/low-level-html
[Overview of Dart web libraries]: /web/web-programming
[overview of editors & debuggers]: /tools#ides-and-editors
[stagehand]: {{site.pub-pkg}}/stagehand
[Tutorial introduction to using Dart for basic web programming]: /tutorials/web/low-level-html/connect-dart-html
[webdev]: /tools/webdev
[webdev serve]: /tools/webdev#serve
