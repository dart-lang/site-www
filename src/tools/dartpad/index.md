---
title: DartPad
description: The tool that lets you interactively play with Dart in a browser.
---

DartPad is an [open source tool](https://github.com/dart-lang/dart-pad)
that lets you play with the Dart language in any modern browser.
Many pages in this site—especially [codelabs](/codelabs)—have
[embedded DartPads](#embedding).
To open DartPad as a standalone web page, visit 
the [DartPad site (dartpad.dev)][DartPad]{:target="_blank" rel="noopener"}.

{{site.alert.tip}}
  If you're in China, try [dartpad.cn.](https://dartpad.cn)

  If you have issues using DartPad, see the [DartPad troubleshooting
  tips](/tools/dartpad/troubleshoot).
{{site.alert.end}}

Here's what DartPad looks like when configured to run Dart:

<img 
   src="/assets/img/dartpad-hello.png" 
   alt="Showcases what a Hello World app looks like in DartPad">


## Library support

DartPad supports `dart:*` [core libraries](/guides/libraries) marked as
multi-platform and web platform. When writing Flutter apps,
DartPad also supports the `package:flutter`
and `dart:ui` libraries.

DartPad doesn't support [deferred loading][] 
or using packages from the [pub.dev]({{site.pub}}) package repository
besides the [currently supported packages][].

[currently supported packages]: https://github.com/dart-lang/dart-pad/wiki/Package-and-plugin-support#currently-supported-packages

## Getting started

To get familiar with DartPad,
try running some samples and creating a simple command-line app.


### Open DartPad and run a sample {#step-1-open-and-run}

1. Go to [DartPad][]{:target="_blank" rel="noopener"}.  
   
   Dart code appears on the left, and 
   a place for the output appears on the right.
  

2. Choose a Flutter sample such as **Sunflower**, 
   using the **Samples** list at the upper right.  
   
   The rendered output appears to the right.


### Create a command-line app {#step-2-server}

To create a simple command-line app, use **New Pad**.

1. Click the **New Pad** button,
   and confirm that you want to discard changes to the current pad.
   

2. Click the Dart logo, make sure that **HTML** support is disabled,
   and then click **Create**.
   

3. Change the code. For example, change the `main()` function
   to contain this code:  

   ```dart
   for (final char in 'hello'.split('')) {
     print(char);
   }
   ``` 
   
   As you type, DartPad shows hints, documentation,
   and autocomplete suggestions.
   

4. Click the **Format** button.  
   
   DartPad uses the [Dart formatter](/tools/dart-format)
   to ensure that your code has proper indentation, white space,
   and line wrapping.
   

5. Run your app.
   

6. If you didn't happen to have any bugs while you were entering the code,
   try introducing a bug.  

   For example, if you change `split` to `spit`,
   you get warnings at the bottom right of the window.
   If you run the app, a compilation error appears in the console.


## Checking Dart version info

The language features and APIs that DartPad supports depend on the
**Dart SDK** version that DartPad is currently using.
You can find this SDK version at the bottom right of DartPad.

## Embedding DartPad in web pages {#embedding}

You can embed DartPad inside of web pages,
customizing it to suit your use case.
For example, the [futures codelab][]
contains multiple embedded DartPads
labeled as _examples_ and _exercises_.

For more information about how to use embedded DartPads, see
[best practices for using DartPad in tutorials][].

For technical details on embedding DartPads, see the
[DartPad embedding guide.][]

[DartPad]: {{site.dartpad}}
[best practices for using DartPad in tutorials]: /tools/dartpad/dartpad-best-practices
[DartPad embedding guide.]: https://github.com/dart-lang/dart-pad/wiki/Embedding-Guide
[deferred loading]: /language/libraries#lazily-loading-a-library
[futures codelab]: /codelabs/async-await
