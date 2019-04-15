---
title: "Dart Native & Web"
short-title: Platforms
description: "The Dart Platform is flexible and portable, enabling execution on mobile, desktop, and web."
toc: true
---

<img src="images/platforms.png" alt="Dart platform run-times">

Dart is a scalable & portable language that you can use to write simple scripts or full
featured apps. Whether you're creating a mobile app, web app, command-line script,
or supporting back-end, there's a Dart platform solution for that.

## Dart Native (VM & AOT)

The Dart Native platform enables running Dart code compiled to native machine
code for apps running on mobile devices, desktops, and backends.

More information: [A tour of Dart Native](/platforms/native-tour)

### Lightning fast developer workflow (Dart VM)

During development having a fast developer cycle is critical to enable 

The Dart VM supports both pure intrepretation (as required on for example iOS
devices), and runtime optimization via a just-in-time compiler (JIT).

More information: [`dart` VM tool](/tools/dart2aot)

### Optimized production code (Dart AOT)

When apps are ready to be deployed to production (i.e., published to an app
store, or be deployed to a production backend), the Dart AOT compiler can be
used to Ahead-of-time compile them to native ARM and x86 code machine code. This
ensures that your app starts instantly (as no code needs to be compiled), and
runs smoothly.

The AOT code is run inside an efficient Dart run-time, which ensures the sound
Dart type system is enforced, and which manages Dart memory with high
performance through Dart’s fast object allocation and [generational garbage
collector](https://medium.com/flutter-io/flutter-dont-fear-the-garbage-collector-d69b3ff1ca30).

More information: [`dart2aot` tool](/tools/dart2aot)

## Dart Web (JS)

The Dart Web platform enables running Dart code on web platforms powered by
JavaScript. It does so by transpiling Dart code to JavaScript code, which is
turn run in a JS browser run-time (e.g. [V8](https://v8.dev/) inside
[Chrome](https://www.google.com/chrome/)).

More information: [A tour of Dart Native](/platforms/native-tour)

### Lightning fast developer workflow (Dart Dev compiler)

The Dart Web platform enables fast development via the Dart Dev Compiler
(`dartdevc`), a dedicated JS transpiler optimized for quick turn-around. This is
paired with `webdev`, a web-specific end-to-end CLI (command-line interface)
tool that supports core developer tasks such as running, debugging, and
building.

More information: [`dartdevc` compiler](/tools/dartdevc), [`webdev` tool](/tools/webdev)

### Optimized production code (Dart JS compiler)

The `dart2js` tool compiles Dart code to fast & compact, deployable JavaScript.
It employes a number of techniques such as dead-code elimination, 

More information: [`dart2js` compiler](/tools/dart2js), [`webdev` tool](/tools/webdev), [deployment tips](/platforms/web-deployment)