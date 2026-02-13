---
title: "Announcement: IDE Tooling for AngularDart 5"
description: "Dart is a statically typed language which we know and love, and Dart 2 will be even more strictly typed. That is why it makes such a great…"
publishDate: 2018-03-27
author: "mfairhurst"
image: images/1_8_-jlg2S62p_a8plKAtgg.png
category: other
tags:
  - angular
  - angulardart
  - dart
  - dartlang
  - intellij
---


<DashImage src="images/1ZrNw6Wd0ZqQibsfXS8Gsng.png" />


Dart is a statically typed language which we know and love, and Dart 2 will be even more strictly typed. That is why it makes such a great platform for the Angular framework, where components are mostly statically linked together in templates to create performant UIs.

So, to further improve this productive and safe developer experience, we are announcing new IDE tools for preserving that type-safety inside your templates! It supports AngularDart 5, and works out of the box with IntelliJ/WebStorm. It can also be configured to work in VSCode, vim, and more.

You can skip straight to [setup](#a8cb) now if you’re already sold, or follow along for a tour of what our new IDE integration offers you!

## Errors

The new analysis plugin will find many type errors inside your templates for you. Expressions are validated against the directives you use, the inputs they contain, and the references you bind (`#foo`, `let item of`, …).

Here’s a misspelled member, so you don’t have to play human-spellchecker!

<DashImage src="images/0Ia1RMoPF9nmaAsIJ.png" />


And mismatched types on a component input are no longer a problem either.

<DashImage src="images/0LJKT0LftQFRjuKaN.png" />


We can also give you errors related to `$event` variable types,

<DashImage src="images/04UKHl3KVHtpV6Ysx.png" />


And we check the content you transclude inside your directives. This is one example of where we catch not only type errors but also dead code.

<DashImage src="images/02nWPvm2BGmt1SGMZ.png" />


And we could go on! We catch a slew of other types of errors, both in templates, and component definitions.

In addition to being highlighted in your editor, the full listing of errors is displayed in the Dart Analysis panel.

<DashImage src="images/1u34uyVu2qy_7p1xfxHFnCA.png" />


## Autocomplete

We didn’t just stop at validation! While much of the work was getting our analysis to be performant and fully well-behaved in regards to the compiler, much of the value comes from using that resolved template state to deliver you the goodness of regular Dart autocompletion in your templates:

<DashImage src="images/1Qh5P6t4ccwezdMLWjAWw9Q.png" />


But we can complete more than regular Dart members — how about inputs, outputs, and HTML tags?

Tags? Check.

<DashImage src="images/1d3wuZHY5Ja52fe00u2jgSQ.png" />


Attributes? Check.

<DashImage src="images/1UlT5D-O_rajaFS_MCyHWsA.png" />


Stars? Check.

<DashImage src="images/13QMba2E4BETXmoi-5bG6gQ.png" />


Attributes within stars? Check.

<DashImage src="images/1Ep9sEzWfe9Kife8HyMjvKw.png" />


Bonus points: Suggested tags *with* attributes within component transclusions!

<DashImage src="images/1_8_-jlg2S62p_a8plKAtgg.png" />


*Transclusions are a famously advanced topic within angular, so if you think you know what exactly it is that we’re suggesting, pat yourself on the back for knowing AngularDart very well.*

Suffice it to say, component APIs are much easier to follow when using our plugin!

## Navigation

Support here varies a lot more by editor, but within IntelliJ you can click through parts of Dart expressions. In other editors you may be able to navigate on even more entities such as tags and inputs/outputs.

<DashImage src="images/1ceQlGeSCVnfOJqtHEITljQ.png" />


## How To Use

Make sure you are using an AngularDart 5 beta release, and Dart 2.0.0-dev.31 or newer.

Simply add this to your [analysis_options.yaml](https://www.dartlang.org/guides/language/analysis-options#the-analysis-options-file) file:

```
analyzer:
  plugins:
    - angular
```


And restart your IDE. Note, it may take a few seconds to spin up the plugin. It will first have to download sources & dependencies for you, and the first analysis will be slower than subsequent ones.

You can also play around with it in our [analyzer plugin demo project](https://github.com/MichaelRFairhurst/dartconf-angular-plugin-lightning-demo).

If you are using IntelliJ, this should be all you have to do. For other editors, they may not run our plugin on HTML without extra work — for instance, VSCode requires [a flag](https://github.com/Dart-Code/Dart-Code/issues/396#issuecomment-366058798).

## Feedback & More

Our plugins source code lives [on Github](https://github.com/dart-lang/angular_analyzer_plugin), which has more information on what’s supported and where you can file issues if you have questions or come across any bugs.

The new IDE tooling will be part of the next stable release of AngularDart (v5). We’re very excited to offer you even better productivity as you write your Angular web apps!