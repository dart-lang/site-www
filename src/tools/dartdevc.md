---
title: "dartdevc: The Dart development compiler"
short-title: dartdevc
description: A development compiler for fast, modular compilation of Dart code to JavaScript.
---

The Dart development compiler (_dartdevc_)
compiles Dart as JavaScript AMD modules. These modules
work for web app development in modern browsers.

{{site.alert.note}}
  Dart 2.18 removes the `dartdevc` command-line tool from the Dart
  package, but retains the dartdevc compiler.
  
  Use [`webdev serve`](/tools/webdev#serve) to compile Dart code
  to modular JavaScript. This makes compilation faster and debugging easier.
{{site.alert.end}}

