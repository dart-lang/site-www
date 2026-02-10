---
title: "A Dart REPL PoC"
description: "Hacking with Dart"
publishDate: 2017-01-17
author: BlackHC
image: images/0lOBcrb2bYgKV6VYT.png
category: other
tags:
  - programming
  - javascript
  - python
  - google
  - software-development
layout: blog
---


<DashImage src="images/0lOBcrb2bYgKV6VYT.png" />


[Python](https://www.python.org/)’s interactive mode is great. [Dart](http://dartlang.org/) does not have an interactive mode at the moment, but it is really good for prototyping ideas quickly, so let’s see if we can hack something together!

*Disclaimer: I do work for Google, but this post is about a personal project. I’m not on the Dart team or related. This is just my humble opinion and my story. Come along.*

The interactive mode in languages like Python or Ruby has helped make them very approachable for beginners. But these are not the only ones that use the concept of a [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop). A REPL is a read-eval-print loop. Shells like BASH or zsh also employ REPLs when you interact with them in a terminal. It is also what you get when you work with notebooks in [Jupyter](http://jupyter.org/) (IPython Notebooks), [Matlab](https://www.mathworks.com/products/matlab.html), [Mathematica](https://www.wolfram.com/mathematica/) or [Maple](https://www.maplesoft.com/products/maple/). This way of interactive computing is very popular with researchers.

This is what Python’s interactive mode looks like:

<DashImage src="images/1sqspbSjstPhKIsIbZBDq-Q.gif" alt="Good ol’ Python REPL" caption="Good ol’ Python REPL" />


Dart does not support evaluating statements in a global scope like Python, so there is no obvious way to do it correctly. In Dart, statements have to be inside functions and the main function is the entry point of a program. Just like in C++ or C#. Personally, I prefer this as it makes it easier to figure out what is happening when a program runs. But… I’d still really want an interactive mode. It would allow me to play around with ideas and try things out even faster. So let’s see if we can create a REPL as a proof of concept!

## How can we create a REPL in dart?

Dart is really good for prototyping. So let’s do just that and not get bogged down by language design questions :)

Now there is no `eval` function like in JavaScript or Python, and I don’t want to write a full blown interpreter myself to implement one. It wouldn’t be very fast and I don’t have a lot of time either. However, when you debug [Dart code in Intellij](https://www.dartlang.org/tools/jetbrains-plugin), you can evaluate expressions while you step through your code. Evaluating expressions is very much what we’d like to do, isn’t it? Can we use this feature?

Dart’s debugging capabilities are exposed through its [VM service](https://github.com/dart-lang/sdk/blob/master/runtime/vm/service/service.md). It is an JSON-RPC service provided by the [Dart VM](https://www.dartlang.org/dart-vm) that you can connect to to debug your application. [Natalie Weizenbaum](https://twitter.com/nex3) has published an article about the `vm_service_client` package that provides a very nice API to interact with the VM service: [http://news.dartlang.org/2016/05/unboxing-packages-vmserviceclient.html](http://news.dartlang.org/2016/05/unboxing-packages-vmserviceclient.html)

Now what we can do is: our REPL can connect to its own VM service to evaluate expressions that it reads from the terminal! That sounds crazy…

<DashImage src="images/0wtt2rUBIRxHnPUHv.jpg" />


… but it works! I have written a [quick spike](https://github.com/BlackHC/dart_repl/blob/ca3518074c94f48ce5be872b15b58556133a474c/bin/repl.dart) and indeed it works. Dart supports [asynchronous programming](https://www.dartlang.org/tutorials/language/futures), which comes in really handy as it keeps the program from blocking itself when talking to its own VM service.
> # Spikes are a concept from test-driven development: they are quick and dirty experiments one writes to figure out some technical questions.

With the question of feasibility settled, it is easy to write a proper proof of concept. To evaluate expressions that go beyond `1 + 1`, we need to support variables. Now variables cannot easily be created because a variable declaration is not an expression in Dart. In Python, you can just declare a variable on the fly by assigning to it. In Dart, we can simulate dynamic fields by overloading `n[oSuchMethod](https://www.dartlang.org/articles/language/emulating-functions#interactions-with-mirrors-and-nosuchmethod)` to create elements in a dictionary on the fly. I call this class `Scope` and when we [evaluate expressions within an instance](https://www.dartdocs.org/documentation/vm_service_client/0.2.3/vm_service_client/VMInstanceRef/evaluate.html) of it, the fields can be accessed like globals.

<DashImage src="images/02PUDlyPF7rchkNmA.jpg" />


The code is actually more straight-forward:

```dart
// Copyright (c) 2016, Andreas 'blackhc' Kirsch. All rights reserved. Use of 
// this source code is governed by a BSD-style license that can be found in the 
// LICENSE file.
import 'dart:mirrors';

Scope currentScope;

@proxy
class Scope {
  final _scope = <Symbol, dynamic>{};

  Scope();

  Scope.predefined(Map<Symbol, dynamic> symbols) {
    _scope.addAll(symbols);
  }

  factory Scope.clone(Scope other) => new Scope.predefined(other._scope);

  @override
  dynamic noSuchMethod(Invocation invocation) {
    if (invocation.isGetter) {
      if (_scope.containsKey(invocation.memberName)) {
        return _scope[invocation.memberName];
      } else {
        return super.noSuchMethod(invocation);
      }
    } else if (invocation.isSetter) {
      final variable = MirrorSystem.getSymbol(
          MirrorSystem.getName(invocation.memberName).split('=').first);
      _scope[variable] = invocation.positionalArguments.first;
      return null;
    } else if (invocation.isMethod) {
      return Function.apply(_scope[invocation.memberName] as Function,
          invocation.positionalArguments, invocation.namedArguments);
    } else {
      throw new UnsupportedError('Neither setter, nor getter, nor method!');
    }
  }

  @override
  String toString() => _scope.toString();
}
```

With this, we can already do stuff like `a = 3`and `b = a*3`:

<DashImage src="images/12tDjwpxSxslDUfiv8enwow.gif" alt="Simple expressions: DONE" caption="Simple expressions: DONE" />


One limitation, we quickly run into is, that we can only access symbols that have been imported in the file that declares the `Scope` class. `import ‘…’;` cannot be evaluated using the VM service. So no `dart:io` if we don’t import it explicitly, and no custom libraries :(

Oh wait! Dart can spawn new isolates (independent workers) using a URI with [Isolate.spawnUri](https://api.dartlang.org/stable/1.21.1/dart-isolate/Isolate/spawnUri.html). Users could specify additional imports on the command-line, and the REPL could generate source code to include these imports and then spawn a new isolate using the generated code that has the imports available for the user.

<DashImage src="images/0bgs2vFlKPkZsFbSO.jpg" />


And it works \o/

<DashImage src="images/1eh9q0mNToXK0R_QiYdrylw.gif" alt="Custom imports: DONE" caption="Custom imports: DONE" />


## Supporting more Dart

Now another issue is that we only can evaluate expressions. Control statements like `if/else` blocks or `while` loops are not expressions. For statements, we could wrap them in a closure and execute the closure, which is a function call expression. Thus, `if (a == 1) print('a is 1!!');` would become

```
() { if (a == 1) print('a is 1!!'); }();
```


We just need to figure out if the input is an expression or a statement. This is difficult because we’d have to write a Dart parser for this. But Dart is written in Dart, and the [`analyzer`](https://pub.dartlang.org/packages/analyzer) package provides a parser that can parse any Dart code for free!

```dart
// Copyright (c) 2016, Andreas 'blackhc' Kirsch. All rights reserved. Use of 
// this source code is governed by a BSD-style license that can be found in the 
// LICENSE file.
import 'dart:io';

import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/error/listener.dart';
import 'package:analyzer/src/dart/scanner/reader.dart';
import 'package:analyzer/src/dart/scanner/scanner.dart';
import 'package:analyzer/src/generated/parser.dart';

bool _tryParse(String code, Function parse) {
  final reader = new CharSequenceReader(code);
  final errorListener = new BooleanErrorListener();
  final scanner = new Scanner(null, reader, errorListener);
  final token = scanner.tokenize();
  final parser = new Parser(null, errorListener);
  final node = parse(parser, token) as AstNode;

  return !errorListener.errorReported &&
      node != null &&
      node.endToken.next.type == TokenType.EOF;
}

bool isExpression(String code) => _tryParse(
    code, (Parser parser, Token token) => parser.parseExpression(token));

bool isStatements(String code) => _tryParse(code, (Parser parser, Token token) {
      final statements = parser.parseStatements(token);
      if (statements.isEmpty) {
        return null;
      }
      return statements.last;
    });
```

And thus, that is also solved.

<DashImage src="images/1uemGA2TzYypx2RmooQfwmg.gif" alt="Statements and expressions: DONE" caption="Statements and expressions: DONE" />


## More imports

The last bit that keeps us from importing just any library is that by default a new Isolate only sees the packages that are mentioned in its `pubspec.yaml`. We want to support importing any library though. `Isolate.spawnUri` has a `packageConfig` parameter that allows us to specify a map from package name to package path. We can just use another command-line parameter to target another package and use its package config in our Isolate. Woohoo!

We quickly run into the problem that our Isolate needs to access the `analyzer` package (and others) that might not be loaded by whatever package you want to toy around with in your REPL session. Package [`package_resolver`](https://pub.dartlang.org/packages/package_resolver) to the rescue! With it, we can easily manipulate package configurations.

```dart
import 'package:package_resolver/package_resolver.dart';

Future<PackageResolver> mergePackageConfigs(String otherPackageRoot) async {
  final currentConfig = await PackageResolver.current.packageConfigMap;
  final otherConfig =
      (await SyncPackageResolver.loadConfig(otherPackageRoot + '/.packages'))
          .packageConfigMap;
  // We do something horrible here: We simply merge the current config with
  // the other. Hoping it will still work..
  final config = <String, Uri>{};
  config.addAll(currentConfig);
  config.addAll(otherConfig);
  return new PackageResolver.config(config);
}
```

With all this, we have a full workflow implemented:

<DashImage src="images/1KKIJauKlylkVMaLvhJQq9w.gif" alt="Import any library from another package: DONE" caption="Import any library from another package: DONE" />


## What’s next?

This was a long post… The whole proof of concept clocks in at **451 lines of code**, so almost as long as this post.

<DashImage src="images/0Xn430bpRfeDmM9uF.jpg" />


The code can be found on [https://github.com/BlackHC/dart_repl](https://github.com/BlackHC/dart_repl/tree/master/lib). You can give it a go easily if you have Dart installed:

```
pub global activate dart_repl
pub global run dart_repl
```


I really enjoyed creating this proof of concept in my spare time. All the pieces just fell into place within a couple of hours. IDE support for Dart in Intellij is excellent, and there are a ton of documentation and articles around now. Check out [Natalie Weizenbaum](https://twitter.com/nex3)’s Unboxing Packages series for example: [http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html](http://news.dartlang.org/2016/04/unboxing-packages-async-part-3.html) et al. Low-level hacking in Dart is fun, and there are great libraries to get creative with. [`code_builder`](https://github.com/dart-lang/code_builder) is looking very promising and [`built_collection`](https://github.com/google/built_collection.dart) is providing immutable collections. [David Morgan](https://twitter.com/__davidmorgan__) has also been publishing articles on [immutable collections](https://medium.com/dartlang/darts-built-collection-for-immutable-collections-db662f705eff#.kj3ubd2xj) in Dart.

For `dart_repl`, it would be nice to import additional libraries at runtime without restarts. The Dart team has recently added support for hot reloading to the VM. This mainly provides a better experience in [Flutter](https://flutter.io/) for mobile app developers. Maybe, this could be used for adhoc imports and for defining functions and classes in the REPL, too.

In general, Dart could be great for research and for researchers, and I would absolutely love to see Jupyter support for Dart. One would only have to implement its kernel interface to make such a Dart REPL compatible with it… :) That should be easy, right?

<DashImage src="images/00_DI8nuDDB5VwIbc.jpg" />
