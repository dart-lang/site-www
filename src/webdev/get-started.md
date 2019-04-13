---
title: Get Started
description: A guide to get you quickly writing web apps in Dart.
---

{% assign channel = site.data.pkg-vers.SDK.channel -%}
{% if channel == 'stable' -%}
  {% assign isStable = true -%}
{% else -%}
  {% assign isDev = true -%}
{% endif -%}

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
<a href="http://dartpad.dartlang.org/2a24f3f042f1c86cf91621c30adce771"
   target="_blank">open the example at dartpad.dartlang.org.</a>

<iframe
    src="{{site.custom.dartpad.embed-inline-prefix}}?id=2a24f3f042f1c86cf91621c30adce771&verticalRatio=70"
    width="100%"
    height="450px"
    style="border: 1px solid #ccc;">
</iframe>

More information:

* [DartPad documentation]({{site.dartlang}}/tools/dartpad)
* [Dart language tour]({{site.dartlang}}/guides/language/language-tour)
* [Dart library tour]({{site.dartlang}}/guides/libraries/library-tour)
* [Tutorial introduction to using Dart for basic web programming](/tutorials/low-level-html/connect-dart-html)


## 2. Install Dart {%-if isDev%} 2 **dev channel** release {%-endif%}

Once you're ready to move beyond DartPad and develop real apps,
you need the Dart SDK.

As you install, **note the path to the SDK.**
You'll need it in step 4.

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">Mac</li>
</ul>

<div id="tab-sdk-install-windows" class="tabs__content current" markdown="1">
  Use [Chocolatey](https://chocolatey.org) to install a {{channel}} release of
  the Dart SDK:
  ```terminal
  C:\> choco install dart-sdk {%-if isDev%} --pre {%-endif%}
  ```
</div>

<div id="tab-sdk-install-linux" class="tabs__content" markdown="1">
  You can use Aptitude to install the Dart SDK on Linux.

   1. Perform the following one-time setup:
      ```terminal
      > sudo apt-get update
      > sudo apt-get install apt-transport-https
      > sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
      {% if isStable -%}
      > sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
      {% else -%}
      ```
      Set up Dart **{{site.data.pkg-vers.SDK.channel}} channel**:
      ```terminal
      > sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list'
      {% endif -%}
      ```
   2. Install the Dart SDK:
      ```terminal
      > sudo apt-get update
      > sudo apt-get install dart
      ```
</div>

<div id="tab-sdk-install-mac" class="tabs__content" markdown="1">
  With [Homebrew](http://brew.sh/),
  installing Dart is easy.

  ```terminal
  > brew tap dart-lang/dart
  {% if isStable -%}
  > brew install dart
  {% else -%}
  ```
  Get **{{site.data.pkg-vers.SDK.channel}} channel** release:
  ```terminal
  > brew install dart --devel
  {% endif -%}
  ```
</div>

More information: [Install the SDK](/tools/sdk#install)


## 3. Get CLI tools or WebStorm (or both)

<i class="fas fa-terminal dark"></i>
If you like to use the command line, install [webdev][]
and [stagehand:][stagehand]

```terminal
> pub global activate webdev
> pub global activate stagehand
```

<i class="material-icons">web</i>
Although using an IDE is optional, we highly recommend that you
[download and install WebStorm](/tools/webstorm). WebStorm comes
with Dart support, making it easy to write correct Dart code and to run it in a
browser.

{% include webstorm-status.md %}

More information: [Dart tools for the web](/tools)

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
Here's how to use WebStorm to create the same web app:

1. Choose **Create New Project** from WebStorm's welcome screen,
   or **File > New > Project...** from the menu. A dialog appears.
1. Choose **Dart** from the list on the left.
1. If the **Dart SDK path** field doesn't have a value, enter it.
1. Edit the **Location** field to set the app location and name.
1. Select **Generate sample content** to show the list of templates.
1. Choose the **Bare-bones Web App** template.
1. Click **Create**.<br>![WebStorm new project dialog][]

More information:
[Overview of Dart web libraries](/guides/web-programming)

## 5. Run the app

<i class="fas fa-terminal dark"></i>
To run the app from the command line, use [webdev][] to build and serve the app:

```terminal
> webdev serve
```

Then, to view your app, use the Chrome browser to visit
[localhost:8080](localhost:8080).
(Details about Dart's browser support are
[in the FAQ](/faq#q-what-browsers-do-you-support-as-javascript-compilation-targets).)
Webdev is slowest when it builds and serves your app for the first time.
After that, assets are cached on disk and incremental builds are much faster.

<i class="material-icons">web</i>
To run the app from WebStorm, do the following:

1. Right-click the app's `web/index.html` file in the project view.
2. Choose **Run 'index.html'** in the pop up menu.

![Running the app from WebStorm]({% asset webstorm-run-index-html.png @path %})

{% include pub-get-workaround.html %}

Once your app has compiled, the browser should display
"Your Dart app is running."

![Launched bare-bones app]({% asset bare-bones-dart-app.png @path %}){:width="500"}


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

 4. WebStorm and webdev automatically rebuild your app.
    Refresh the app's browser window.
    Now your simple Dart app has a todo list!
    It should look something like this:<br>
    ![Running the revised app]({% asset bare-bones-todo.png @path %}){:width="500"}
{% comment %}
TODO: remove my-first-angular-app-at-work.png
{% endcomment %}

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
[Debugging Dart Web Apps](/guides/debugging).

<aside class="alert alert-info" markdown="1">
  **Feeling lost? Don't worry!**
  This was a whirlwind introduction to Dart and web programming
  that left out many details.
  For a gentler approach, try a
  [low-level HTML tutorial for Dart](/tutorials/low-level-html) or the
  [AngularDart tutorial](/angular/tutorial).
</aside>


## What next?

Check out these resources:

* Web-related tutorials and codelabs for Dart
  * [Tutorials](/tutorials)
  * [Codelabs](/codelabs)
* Dart language, libraries, and conventions
  * [Sample code]({{site.dartlang}}/samples)
  * [Language tour]({{site.dartlang}}/guides/language/language-tour)
  * [Library tour]({{site.dartlang}}/guides/libraries/library-tour)
  * [Effective Dart]({{site.dartlang}}/guides/language/effective-dart)
* Tools & libraries
  * [Dart SDK]({{site.dartlang}}/tools/sdk)
  * [Dart tools for the web](/tools)
  * [IDEs]({{site.dartlang}}/tools#ides-and-editors)
  * [Web libraries](/guides/web-programming)
  * [AngularDart](/angular)

If you get stuck, find help at [Community and Support.](/community)

[AngularDart]: /angular
[AngularDart Components]: /angular/components
[stagehand]: {{site.pub-pkg}}/stagehand
[webdev]: /tools/webdev
[WebStorm new project dialog]: {% asset webstorm-new-project.png @path %}
