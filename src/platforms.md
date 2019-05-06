---
title: Platforms
description: "You can use Dart to write mobile apps, web apps, command-line apps, backends, and more."
toc: true
---

You can use Dart to write simple scripts or full-featured apps. Whether you're
creating a mobile app, web app, command-line script, or server-side app, there's
a Dart solution for that.

Flexible compiler technology lets you run Dart code in different ways,
depending on your target platform and goals:

  * **Dart Native**: For programs targeting devices (mobile, desktop, server,
    and more), Dart Native includes both a Dart VM with JIT (just-in-time)
    compilation and an AOT (ahead-of-time) compiler for producing machine
    code.
  * **Dart Web**: For programs targeting the web, Dart Web includes both a
    development time compiler (`dartdevc`) and a production time compiler
    (`dart2js`).

<img src="{% asset platforms.svg @path %}" width="800px" alt="Dart platform">

## Dart Native (VM JIT and AOT)

Dart Native enables running Dart code compiled to native ARM or X64
machine code for mobile, desktop, and server apps.

The [Flutter framework]({{site.flutter}}) is a popular multi-platform UI toolkit
that's powered by Dart Native when targeting mobile or desktop devices.

More information:
* [Flutter get started documentation]({{site.flutter}}/docs/get-started/)
* [Get started: command-line and server apps](/tutorials/server/get-started)
* [Write command-line apps](/tutorials/server/cmdline)
* [Write HTTP clients and servers](/tutorials/server/httpserver)

### Lightning fast developer workflow (Dart VM JIT)

Having a fast developer cycle is critical for iteration. 

The Dart VM has a just-in-time compiler (JIT) that supports both pure interpretation
(as required on iOS devices, for example) and runtime optimization.

More information: [`dart` VM tool](/tools/dart-vm)

### Optimized production code (Dart AOT)

When apps are ready to be deployed to production — whether you're
publishing to an app store or deploying to a production backend —
you can use the Dart AOT compiler to ahead-of-time compile your app
to native ARM or X64 code machine code.
Your AOT-compiled app starts instantly and runs smoothly.

The AOT-compiled code runs inside an efficient Dart runtime that enforces
the sound Dart type system and manages memory using fast object allocation and a [generational garbage
collector.](https://medium.com/flutter-io/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30)

More information: [`dart2aot` tool](/tools/dart2aot)

## Dart Web (JavaScript)

Dart Web enables running Dart code on web platforms powered by
JavaScript. With Dart Web, you compile Dart code to JavaScript code, which in
turn runs in a browser — for example, [V8](https://v8.dev/) inside
[Chrome](https://www.google.com/chrome/).

The [Flutter framework]({{site.flutter}}), a popular multi-platform UI toolkit,
is powered by Dart Web when targeting web apps. The
[AngularDart]({{site.angulardart}}) framework, a popular web app toolkit, is
also powered by Dart Web.


More information: [Get started: web apps](/tutorials/web/get-started)

### Lightning fast developer workflow (Dart dev compiler)

The Dart dev compiler (dartdevc) is a Dart-to-JavaScript compiler
that's optimized for quick turnaround. Instead of using dartdevc directly,
you use it with `webdev`, a tool that supports core developer tasks such as
running, debugging, and building.

More information:
* [`dartdevc` compiler](/tools/dartdevc)
* [`webdev` tool](/tools/webdev)

### Optimized production code (Dart JS compiler)

The `dart2js` tool compiles Dart code to fast, compact, deployable JavaScript.
It employs techniques such as dead-code elimination

More information:
* [Deployment tips](/web/deployment)
* [`dart2js` compiler](/tools/dart2js)
* [`webdev` tool](/tools/webdev)
