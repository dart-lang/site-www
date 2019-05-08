---
title: Debugging Dart web apps
description: Learn how to use DevTools to debug your Dart web app.
---

You can use [Chrome DevTools][] and the
[Dart development compiler (dartdevc)][dartdevc]
to debug your Dart web app.

This page walks you through using Dart with Chrome DevTools,
with special attention for setup and Dart-specific considerations.
For general information on debugging with Chrome DevTools,
see the JavaScript debugging
[get started guide][JavaScript get started guide] and
[reference.][JavaScript debugging reference]

<div class="mini-toc" markdown="1">
  <h4>Overview</h4>
  * To serve your app, use `webdev serve` (which uses dartdevc),
    either at the command line or through your IDE.
  * To see Dart types in Chrome DevTools,
    [enable custom formatters](#enabling-custom-formatters).
  * You can't use Dart code in the Chrome DevTools console (`someProperty`),
    but sometimes you can use JavaScript code that's close (`this.someProperty`).
  * If you have trouble setting a breakpoint in Dart code, try
    [disabling and re-enabling source maps](#enabling-and-disabling-source-maps).
</div>

<aside class="alert alert-info" markdown="1">
  **Note:**
  A [Dart fork of Chrome DevTools][]
  exists but isn't ready yet for general use. For the latest status, see the
  [devtools-frontend README.][devtools-frontend README]
</aside>

{% asset chrome-devtools-screenshot.png %}

{% comment %}
NOTE TO EDITORS:
Be careful to match the text formatting and terminology of the Chrome DevTools
docs (https://developers.google.com/web/tools/chrome-devtools/) — especially
the JavaScript debugging reference and JavaScript get started guide,
so readers can easily switch back and forth between these docs.

TODO:
Once Dart DevTools (or whatever we call it)
is ready for use by ordinary developers,
make DDT the first section/page and CDT the second,
with the DDT section having all the step-by-step directions.
{% endcomment %}


## Getting started with Chrome DevTools {#using-chrome-devtools}

The Dart development compiler ([dartdevc][])
has built-in support for source maps
and for custom formatting of Dart objects.


### Prerequisites {#prerequisites}

To use the Chrome DevTools to debug with dartdevc, you need the following software:

* [Google Chrome.][Google Chrome]
* [Dart SDK][], version **2.0.0-dev.65.0** or higher.
* One of the following development environments:
  * Command-line: [webdev and (optionally) stagehand](#getting-webdev-and-stagehand)  <br>_or_
  * A [Dart IDE or editor][] that supports web development with Dart 2.
* A [Dart 2 compatible web app][] to debug.
  The following walkthrough shows how to create a suitable app.


### Walkthrough {#walkthrough}

This section leads you through the basics of
using Chrome DevTools to debug a web app.
If you already have an app that's ready to debug,
you can skip creating the test app (step 1),
but you'll need to adjust the instructions to match your app.

1. _Optional:_ Create an app named `test_app` that uses Stagehand's
   [web-angular template.][web-angular template]

   * If you're using the command line, here's how to create the app
     using [Stagehand:][stagehand]

     ```terminal
> mkdir test_app
> cd test_app
> stagehand web-angular
> pub get
```

   * If you're using a Dart IDE or editor,
    create an **AngularDart web app** and name it `test_app`.
    You might see the description _A web app with material design components_.

1. Compile and serve the app with dartdevc,
   using either your IDE or `webdev` at the command line.

   ```terminal
   > webdev serve
   ```

   <aside class="alert alert-info" markdown="1">
    **Note:**
    The first dartdevc compilation takes the longest,
    because the entire app must be compiled.
    After that, refreshes are much faster.
   </aside>

1. Open the app in a Chrome browser window.
   <br>
   For example, if you use `webdev serve` with no arguments, open
   [localhost:8080](http://localhost:8080){: .no-automatic-external}.

1. Open DevTools: Press <kbd>Control</kbd>+<kbd>Shift</kbd>+<kbd>I</kbd>
   (or <kbd>Command</kbd>+<kbd>Option</kbd>+<kbd>I</kbd> on Mac).

1. [Enable custom formatters](#enabling-custom-formatters),
   so that you can see Dart types in Chrome DevTools.
   {% comment %}
   [**Using Dart DevTools?** You can skip this step,
   since custom formatters are enabled by default.]
   {% endcomment %}

1. Select the **Sources** tab.

1. In the **File Navigator** pane, select **Page** and navigate to
   the Dart file for a nontrivial component.
   <br>
   For example, navigate to
   [`packages/test_app/src/todo_list/todo_list_component.dart`.][todo_list_component.dart]

1. Set a line-of-code breakpoint in a method that's called
   in response to a user event.
   <br>
   For example, break at the top of the `add()` method
   by clicking the line number **36**.
   {% comment %}
   TODO: Add this page to
   https://github.com/dart-lang/stagehand/wiki/Docs-that-depend-on-stagehand.
   Periodically check that the line number hasn't changed,
   due to template changes.
   {% endcomment %}

1. In the app's UI, trigger the event that causes the method call.
   Execution stops at the breakpoint.
   <br>
   For example, type something into a text field and press <kbd>Enter</kbd>.

1. In the **Code Editor** pane, mouse over the properties.
   You can see their Dart runtime types and values.
   <br>
   For example, in the `add()` method,
   `items` is a `List<String>` with a length of 0.

   <aside class="alert alert-info" markdown="1">
   **Troubleshooting:**
   If you see `Array` instead of `List`,
   then custom formatters aren't on.
   [Enable them](#enabling-custom-formatters).
   </aside>

1. Look at the **Call Stack** and **Scope** panes,
   which are in the **JavaScript Debugging** pane.
   Under **Scope**, look at the type and value of the local variable `this`.

1. Resume script execution, and trigger the event again.
   Execution pauses again.

1. If the console isn't visible, press <kbd>Esc</kbd>.

1. In the console, try viewing a property of the component.
   <br>

   For example, try to view the `items` object:

   * Enter `items`.
     It doesn't work because JavaScript requires a `this.` prefix.

   * Enter `this.items`.
     This works because the JavaScript object has the same name as
     the Dart object.
     Thanks to custom formatters, you can see the Dart type and value.

   * Enter `this.items[0]`.
     This works because Dart lists map to JavaScript arrays.

   * Enter `this.items.first`.
     This doesn't work, because unlike the [Dart List class,][List]
     JavaScript arrays don't have a `first` property.

{% comment %}
Dart DevTools:
items.first
items.isEmpty
items.length
items.runtimeType
[PENDING: once indexing works in DDT, tell them to try items[0])
{% endcomment %}

1. Try [other DevTools features.][JavaScript debugging reference]


## Changing DevTools settings

This section covers settings that you might need to change
as you debug your app.


### Enabling custom formatters {#enabling-custom-formatters}

To see Dart types in Chrome DevTools, you need to enable custom formatters.

1. From the DevTools **Customize and control DevTools ⋮** menu,
   choose **Settings**. Or press <kbd>F1</kbd>.
1. Select **Enable custom formatters**,
   which is under the **Console** heading in the **Preferences** settings.
1. Close Settings: Press <kbd>Esc</kbd> or click the **x** at the upper right.

{% comment %}
The best description I found was http://www.mattzeunert.com/2016/02/19/custom-chrome-devtools-object-formatters.html.
{% endcomment %}


### Disabling and re-enabling source maps {#enabling-and-disabling-source-maps}

Chrome DevTools <!-- and Dart DevTools --> enables source maps, by default.
You might want to temporarily disable source maps so that you can see
the generated JavaScript code.

{% comment %}
In Dart DevTools, use <kbd>Alt</kbd>+<kbd>S</kbd> to toggle source maps.
{% endcomment %}

1. From the DevTools **Customize and control DevTools ⋮** menu,
   choose **Settings**.
   Or press <kbd>F1</kbd>.
1. Find the **Enable JavaScript source maps** checkbox,
   which is under the **Sources** heading in the **Preferences** settings.
   * To display _only JavaScript_ code,
   _clear_ **Enable JavaScript source maps**.
   * To display _Dart_ code (when available),
     _select_ **Enable JavaScript source maps**.
1. Close Settings: Press <kbd>Esc</kbd> or click the x at the upper right.


## Getting webdev and stagehand {#getting-webdev-and-stagehand}

If you're using the command line instead of an IDE or Dart-enabled editor,
then you need the [webdev tool][webdev].
To use the command line to create apps from standard templates,
you also need the [stagehand tool.][stagehand]
Use pub to get these tools:

```terminal
> pub global activate webdev
> pub global activate stagehand
```

If your PATH environment variable is set up correctly,
you can now use these tools at the command line:

```terminal
> webdev --help
A tool to develop Dart web projects.
...
```

For information on setting PATH, see the
[`pub global` documentation.][pub global documentation]

Whenever you update the Dart SDK or
want to get the latest Stagehand templates,
update the tools by activating them again:

```terminal
> pub global activate webdev     # update webdev
> pub global activate stagehand  # update stagehand
```

[Chrome DevTools]: https://developers.google.com/web/tools/chrome-devtools
[Dart 2 compatible web app]: /dart-2
[Dart fork of Chrome DevTools]: https://github.com/dart-lang/devtools-frontend
[Dart IDE or editor]: /tools#ides-and-editors
[Dart SDK]: /tools/sdk#install
[dartdevc]: /tools/dartdevc
[devtools-frontend README]: https://github.com/dart-lang/devtools-frontend/blob/master/readme.md#dart-devtools
[Google Chrome]: https://www.google.com/chrome
[JavaScript debugging reference]: https://developers.google.com/web/tools/chrome-devtools/javascript/reference
[JavaScript get started guide]: https://developers.google.com/web/tools/chrome-devtools/javascript/
[List]: {{site.dart_api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/List-class.html
[pub global documentation]: /tools/pub/cmd/pub-global
[stagehand]: {{site.pub-pkg}}/stagehand
[todo_list_component.dart]: https://github.com/dart-lang/stagehand/blob/master/templates/web-angular/lib/src/todo_list/todo_list_component.dart
[web-angular template]: https://github.com/dart-lang/stagehand/tree/master/templates/web-angular
[webdev]: /tools/webdev
