---
title: "Announcing Dart 3.9"
description: "Hello, Dart developers! The latest stable version, Dart 3.9, is officially here!"
publishDate: 2025-08-14
author: "antfitch"
image: images/1VIHR_FuzQzulhqczfx8eAA.gif
category: announcements
tags:
  - dart
  - flutter
  - mcp-server
---


This release is all about making your work easier and your apps more efficient. With key updates to null safety, performance boosts to the Dart CLI, and the exciting addition of the Dart and Flutter MCP Server to empower your AI assistants, there’s a lot to love. Read on to discover everything that’s new in Dart 3.9.

<DashImage src="images/1VIHR_FuzQzulhqczfx8eAA.gif" alt="Announcing Dart 3.9" caption="Announcing Dart 3.9" />


## Language updates

### Null safety

Dart 3.9 assumes null safety when computing type promotion, reachability, and definite assignment. To take advantage of these improvements, set your package’s SDK constraint lower bound to 3.9 or greater (`sdk: ^3.9.0`). As a result of this change, more dead_code warnings may be produced.

### **Soundness updates**

We fixed a soundness issue that allowed direct invocation of a value returned from a getter without any runtime checks when the getter’s return type was a generic type argument instantiated as dynamic or Function. This soundness issue arose with the dev-compiler DDC, and no other tools are affected.

Before the fix the following getter could trigger an issue with a direct invocation. For example:

```dart
// The following getter used to trigger an issue with a direct 
// invocation

// The getter
class Container<T> {
  T get value => ((int i) => i.isEven) as T;
}

// The direct invocation
Container<dynamic>().value('Invocation with missing runtime checks!');
```


## Tools updates

### **Dart and Flutter MCP Server**

The [Dart and Flutter MCP Server](https://dart.dev/tools/mcp-server) acts as a bridge, giving AI coding assistants such as Gemini CLI, Cursor, and GitHub Copilot, access to more of your Dart project’s context. Instead of just suggesting code, your AI assistant can now understand your project deeply and take action on your behalf.

With the Dart and Flutter MCP Server, you can ask an AI assistant to:

* Fix runtime errors ([see example](https://dart.dev/tools/mcp-server#fix-a-runtime-layout-error-in-a-flutter-app)).

* Manage dependencies ([see example](https://dart.dev/tools/mcp-server#add-new-functionality-with-package-search)).

* Write and correct code.

* And more.

The Dart and Flutter MCP Server is now available on the stable channel of the Dart SDK.

<DashImage src="images/13K1rgoDtIBWbIFZPp1VCEQ.gif" alt="*Fixing a layout issue, enabled by the Dart and Flutter MCP Server (parts of this recording have been sped up)*" caption="*Fixing a layout issue, enabled by the Dart and Flutter MCP Server (parts of this recording have been sped up)*" />


### **Faster Dart CLI**

Previously, when you ran some [Dart CLI commands](https://dart.dev/tools/dart-tool) like `dart analyze` ****and `dart fix`, your computer had to compile the code for the [analysis server](https://github.com/dart-lang/sdk/blob/main/pkg/analysis_server/README.md) just before running it. Now, these tools use an Ahead-Of-Time (AOT) compiled snapshot of the analysis server, which means the server has been pre-compiled into fast, native machine code.

Results vary depending on the source code, but we ran some common commands on a sample package and got some interesting results. Some short commands like `dart format` now complete in a fraction of the time and longer running ones like `dart analyze` got nearly 50% faster.

<DashImage src="images/1NkNNA4xfB08k9FjtIHSTEw.png" alt="Example performance results after the Dart CLI update" caption="Example performance results after the Dart CLI update" />


### **pub client updates**

[Git dependencies](https://dart.dev/tools/pub/dependencies#git-packages) can now be version-solved based on git tags.

When you use a `tag_pattern` in the descriptor and there is a `version` constraint, all commits matching the pattern are considered during resolution. In the following example, only version 2.0.1 of `my_dependency` and higher is considered:

```yaml
dependencies:
  my_dependency:
    git:
      url: https://github.com/example/my_dependency
      tag_pattern: v{{version}}
    version: ^2.0.1
```


Starting from language version 3.9, the `flutter` constraint upper bound is now respected in your root package (the `dart` constraint was already respected). Setting a narrow dart or flutter constraint can be useful to ensure a team of developers all use the same SDK version when jointly developing an app (see [issue #95472](https://github.com/flutter/flutter/issues/95472) for details).

For example, in a root pubspec like this `pub get` will fail if invoked with a version of the Flutter SDK that is not 3.33.0:

```yaml
name: my_app
environment:
  sdk: ^3.9.0
  flutter: 3.33.0
```


### **Dart native compiler**

We added [cross-compilation support](https://dart.dev/tools/dart-compile#cross-compilation-exe) for target architectures of `arm` (ARM32) and `riscv64` (RV64GC) when the target OS is Linux.

## Deprecations & breaking changes

### **32-bit x86 architecture**

Dart has deprecated the 32-bit x86 architecture. For most developers this will have no impact, as it mainly affects older x86-based Android emulators and a small number of physical devices. 32-bit ARM and 64-bit x86_64 emulators and devices are still supported. The full technical breakdown is available in the [Dart GitHub deprecation issue](https://github.com/dart-lang/sdk/issues/49969).

### **dart build**

`dart build` is in preview on the beta channel.

`dart build -f exe &lt;target&gt;` is now `dart build cli — target=&lt;target&gt;`. See `dart build cli — help` for more info.

## Wrap up

That’s a wrap on Dart 3.9! We hope you’re as excited about these updates as we are. We always appreciate your feedback, so feel free to share your thoughts. Until next time, happy coding!