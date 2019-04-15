---
title: "A tour of Dart Web"
short-title: Get-started
description: "A guide to get you quickly writing web apps in Dart."
toc: true
---

{% assign channel = site.data.pkg-vers.SDK.channel -%}
{% if channel == 'stable' -%}
  {% assign isStable = true -%}
{% else -%}
  {% assign isDev = true -%}
{% endif -%}

Follow these steps to start using Dart to develop web apps.

## 1. Install Dart {%-if isDev%} 2 **dev channel** release {%-endif%}

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


## 2. Get CLI tools

<i class="fas fa-terminal dark"></i> Install [stagehand:][stagehand] and
[webdev][], used for creating and running Dart web apps.

```terminal
> pub global activate stagehand
> pub global activate webdev
```

More information, incl. tips for IDEs that support Dart Web: [Dart tools for the
web](/tools).

## 3. Create a web app

<i class="fas fa-terminal dark"></i>
To create a web app and retrive all it's dependencies, use these commands:

```terminal
> mkdir quickstart
> cd quickstart
> stagehand web-simple
> pub get
```

More information:
[Overview of Dart web libraries](/guides/web-programming)

## 4. Run the app

<i class="fas fa-terminal dark"></i>
To run the app from the command line, use [webdev][] to build and serve the app:

```terminal
> webdev serve
```

Then, to view your app, use your browser to visit
[localhost:8080](localhost:8080). (Details about Dart's browser support are [in
the
FAQ](/faq#q-what-browsers-do-you-support-as-javascript-compilation-targets).)
Webdev is slower when it builds and serves your app for the first time. After
that, assets are cached on disk and incremental builds are much faster.

Once your app has compiled, the browser should display
"Your Dart app is running."

<img src="images/bare-bones-dart-app.png" alt="Launched bare-bones app">

## 5. Add custom code to the app

Let's customize the app you just created.

 1. Copy the `thingsTodo()` function from the DartPad above
    to the `web/main.dart` file.

 2. In the `main()` method, initialize the `output` element using
    `thingsTodo()`:

    ```dart
    void main() {
      Element output = querySelector('#output');
      [!output.children.addAll(thingsTodo().map(newLI));!]
    }

    [!LIElement newLI(String itemText) => LIElement()..text = itemText;!]

    [!Iterable<String> thingsTodo() sync* { ... }!]
    ```

 3. Save your changes.

 4. `webdev` will automatically rebuild your app, so refresh the app's browser
    window to see the updated app. Now your simple Dart app has a todo list! It
    should look something like this:<br>
    <img src="images/bare-bones-todo.png" alt="Running the revised app">

 5. Optionally, improve the formatting by editing `web/styles.css`,
    then reload the app to check your changes.

    ```css
    #output {
      padding: 20px;
      [!text-align: left;!]
    }
    ```

## 6. Use DevTools to inspect the app

TODO: Update to use [Dart DevTools](https://flutter.github.io/devtools/).

## 7. Compile for production

The steps above used `ddc` to compile Dart to JS. `ddc` is optimized for fast,
incremental compilation to ensure a super-fast developer cycle. Now that our
small app is done, it's time to compile our Dart code to optimized JavaScript
code we can deploy to production code using the `dart2js` compiler. This will
produce code that is smaller and faster.

`dart2js` is integrated into the `webdev` tool:

```terminal
> webdev build
```

The release version is now placed in the `build` directory.

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
