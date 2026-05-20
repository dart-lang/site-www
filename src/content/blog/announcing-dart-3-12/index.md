---
title: "Announcing Dart 3.12"
description: "Supercharging developer productivity at Google I/O 2026"
publishDate: 2026-05-20
author: conooi
image: images/dart-3-12-cover.webp
category: releases
layout: blog
---

<DashImage src="images/dart-3-12-cover.webp" alt="Dart 3.12 release banner with the Dart logo and a bullseye icon." caption="Announcing Dart 3.12" />

This year at Google I/O 2026, the Flutter and Dart teams are celebrating a powerful theme: Everywhere, everyday, built by everyone, for everyone.

Dart 3.12 brings this theme to life. We are making the language more approachable and productive. Concise new primitives like private named parameters, alongside experimental support for primary constructors, make everyday coding cleaner. But we didn't stop at the syntax level. New features like Agentic Hot Reload and the addition of Genkit to the Dart ecosystem ensure you can build high-performance, AI-ready, and agentic apps that reach users anywhere. This is true whether you code alone or pair-program with an AI agent.

So [update Dart](https://dart.dev/get-dart) or run [`flutter upgrade`](https://docs.flutter.dev/install/upgrade) and follow along to explore the new features in Dart 3.12. But remember, a more powerful Dart is only half the story. When you're ready to see how these features translate into beautiful UI, check out the [What's new in Flutter](https://blog.flutter.dev/whats-new-in-flutter-3-44-b0cc1ad3c527) blog post.

## Language updates

### Private named parameters

Dart's initializing formals, using the `this.` constructor syntax, are incredibly convenient. They map a constructor parameter directly to a class field. This removes the need to write repetitive code.

But there was a catch. Initializing formals struggled when combining named parameters with private fields. Before Dart 3.12, the language didn't allow a named parameter to start with an underscore:

```dart
class Hummingbird {
  final String _petName;
  final int _wingbeatsPerSecond;

  // Compile error! Can't have private named parameter. :(
  Hummingbird({required this._petName, required this._wingbeatsPerSecond});
}
```

Instead, you had to write an explicit initializer list:

```dart
class Hummingbird {
  final String _petName;
  final int _wingbeatsPerSecond;

  Hummingbird({required String petName, required int wingbeatsPerSecond})
    : _petName = petName,
      _wingbeatsPerSecond = wingbeatsPerSecond;
}
```

This was tedious. All the initializer list is doing is removing the `_`. It added unnecessary boilerplate to simple classes.

In Dart 3.12, the language can do that for you. Dart now lets you write private named initializing formals:

```dart
class Hummingbird {
  final String _petName;
  final int _wingbeatsPerSecond;

  // OK with "Private Named Parameters"! :D
  Hummingbird({required this._petName, required this._wingbeatsPerSecond});
}
```

This code behaves exactly like the previous example. The initialized fields are private, but constructor parameters and the argument names written at the call site have the corresponding public names:

```dart
void main() {
  print(Hummingbird(petName: 'Dash', wingbeatsPerSecond: 75));
}
```

**Learn more**: [Private named parameters documentation](https://dart.dev/language/constructors#private-named-parameters)

### Primary constructors (experimental phase) {:#primary-constructors}

We are excited to offer an early look at one of the most requested syntax features in Dart. Primary constructors represent a major step forward for class conciseness. They eliminate the need to repeat field names and types across your class body and parameter lists.

Normally, even a simple two-field class requires multiple lines of repetitive boilerplate:

```dart
class Point {
  final int x;
  final int y;
  Point(this.x, this.y);
}
```

Primary constructors change this completely. You can now replace boilerplate with a single line of code by declaring parameters directly within the class header.

```dart
class Point(final int x, final int y);
```

The feature goes further. It introduces a shorter syntax for declaring constructors inside the class body using the `new` or `factory` keywords. It also allows classes with empty bodies to end with a simple semicolon:

```dart
class Pet {
  String name;

  new() : name = 'Fluffy';
  new withName(this.name);
}

class Dog extends Pet;
```

Primary constructors are launching as an experimental preview in Dart 3.12. Because this is a foundational shift in how Dart classes are defined, your real-world feedback is crucial. You can enable the feature using the `primary-constructors` [flag](https://dart.dev/tools/experiment-flags) when running your project:

```console
dart run --enable-experiment=primary-constructors bin/main.dart
```

If you encounter any issues or have feedback on the design, please file an issue on the [Dart SDK repository](https://github.com/dart-lang/sdk) (and feel free to cc `@kallentu`). We look forward to hearing your thoughts!

**Learn more**: [Primary constructors documentation](https://dart.dev/language/primary-constructors)

## Ecosystem updates

### Genkit Dart preview {:#genkit-dart}

We're excited to announce the preview launch of Genkit Dart, an open-source framework for building full-stack, AI-powered agentic Dart and Flutter apps on any platform. It provides everything you need for AI apps out of the box:

* **Model-agnostic API:** Supports Google, Anthropic, OpenAI, and OpenAI-compatible models.
* **Type safety:** Combines Dart's strong type system with the `schematic` package for strongly typed data generation and flows.
* **Run anywhere:** Write AI logic once and run it in a backend service or directly inside your Flutter app.
* **Developer UI:** Includes a local web UI to test prompts, view traces, and debug workflows.
* **Core AI primitives:** Built-in support for structured output, tool calling, and multi-step flows.

Call multiple models in just a few lines of code:

```dart
import 'package:genkit/genkit.dart';
import 'package:genkit_google_genai/genkit_google_genai.dart';
import 'package:genkit_anthropic/genkit_anthropic.dart';

void main() async {
  final ai = Genkit(plugins: [googleAI(), anthropic()]);

  // Call a Gemini model from Google.
  final geminiResponse = await ai.generate(
    model: googleAI.gemini('gemini-flash-latest'),
    prompt: 'Hello from Gemini',
  );

  // Call a Claude model from Anthropic.
  final claudeResponse = await ai.generate(
    model: anthropic.model('claude-opus-4.6'),
    prompt: 'Hello from Claude',
  );
}
```

Chat with the Genkit team on [Discord](https://discord.gg/qXt5zzQKpc) and report any issues on [GitHub](https://github.com/genkit-ai/genkit-dart).

**Learn more**: [Get started with Genkit for Dart](https://genkit.dev/docs/dart/get-started/)

### Cloud Functions for Firebase and experimental Dart support {:#cloud-functions}

We are also thrilled to highlight the recent announcement of experimental support for Dart in Cloud Functions for Firebase. For years, extending a Flutter app to the cloud meant context-switching into other backend languages and duplicating data structures.

Now, you can build a truly unified, full-stack Dart application. By leveraging the "Shared Package" pattern, you can share your data models, validation rules, and business logic directly between your frontend and backend—completely eliminating the "Double-Doc Tax."

Thanks to Dart's Ahead-of-Time (AOT) compilation, your serverless functions benefit from incredibly fast cold starts, giving you instant scaling and performance without the hassle of Dockerfiles or container configuration.

**Learn more**: [Dart and Firebase blog post](https://dart.dev/blog/flutter-missing-link-why-full-stack-dart-changes-everything).

## Tooling updates

### Agentic Hot Reload

We've heard from our community that you want AI coding agents to work seamlessly when using Dart and Flutter. That is why we are launching Agentic Hot Reload for Dart and Flutter apps, a new feature designed to keep you and your coding agent in flow. By using the Dart MCP server, your coding agent can now automatically hot reload, eliminating the friction of having to manually find and copy Dart Tooling Daemon (DTD) connection URIs.

Behind the scenes, the Dart Tooling Daemon automatically exposes the connection details through a CLI command run by the MCP server, allowing your coding agent to instantly discover and connect to your running app in your workspace.

With zero configuration, this integration streamlines your daily workflows. You can simply prompt your coding agent to fix a bug, change a UI widget, or diagnose a crash. The agent will autonomously modify your code, fetch live runtime diagnostics, and hot reload the app in real time.

<DashImage src="images/agentic-hot-reload.webp" caption="Agentic hot reload powered by the Dart MCP server." alt="An animation demonstrating the Dart MCP server hot reloading a Flutter star counter app after the Gemini CLI changes the theme and star animation. The split-screen setup shows the driving macOS terminal on the left and the resulting Android emulator on the right." />

### Analysis server performance diagnostics

To build the best tools for everyone, we want to understand Dart Analysis Server (DAS) performance exactly as you experience it on your machine. To make this possible, we have introduced the new `dart info record-performance` command.

Developers experiencing slow analysis times or unresponsive completion can use this command to capture execution traces and CPU profiling data from active DAS processes on their machines. Including these traces when you file issues on GitHub gives our team the exact real-world data needed to diagnose and solve complex performance bottlenecks. By sharing your traces, you directly help us make Dart faster and more reliable for every developer.

## Pub updates

### Native Git LFS support in `pub` {:#git-lfs-support}

Using packages with large files is now simpler than ever. As of Dart 3.12, `dart pub` natively supports git dependencies with Git Large File Storage (LFS).

You don't need any custom configurations in your `pubspec.yaml` file. As long as `git lfs` is installed on your machine, the pub client handles everything automatically:

```yaml
dependencies:
  kittens:
    git: https://github.com/munificent/kittens.git
```

This is a major improvement for teams versioning large media assets, data models, or binaries directly inside their git repositories.

## Wrap up

Dart 3.12 represents a major milestone in removing developer friction. From concise syntax additions to seamless agentic AI workflows and a stronger AI ecosystem, this release is built to support you. Every feature is designed to make your everyday development clean and efficient.

We are excited to see what you build with these new capabilities. We hope you [update Dart](https://dart.dev/get-dart) or [upgrade Flutter](https://docs.flutter.dev/install/upgrade) today to try out these updates. If you are testing our experimental features like primary constructors, please share your feedback. Together, we will keep building a language that brings developer joy to everyone, everyday, and everywhere.

**Learn more**: [Dart SDK changelog](https://github.com/dart-lang/sdk/blob/main/CHANGELOG.md#3120)
