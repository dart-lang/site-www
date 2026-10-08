---
title: "Announcing Genkit Dart 1.0: Production-ready AI and agents in Dart"
description: >-
  Announcing the stable 1.0 release of Genkit Dart, an open-source framework
  for building AI-powered features and agentic workflows in Dart.
publishDate: 2026-10-08
author: chrisraygill
image: images/banner.png
category: announcements
layout: blog
---

<DashImage src="images/banner.png" alt="Announcing Genkit Dart 1.0" />

Today, we're announcing **Genkit Dart 1.0**, the first stable, production-ready
release of Google's open-source framework for building AI-powered features and
agentic workflows in Dart. Since our
[preview launch](https://dart.dev/blog/announcing-genkit-dart-build-full-stack-ai-apps-with-dart-and-flutter)
earlier this year, feedback from the Dart and Flutter community has helped us
refine the core APIs and expand the toolkit for production workloads.

We've published the full walkthrough and code deep dives on the Flutter blog:
**[Announcing Genkit Dart 1.0: Build production-ready agentic apps with Dart and Flutter](https://flutter.dev/blog/announcing-genkit-dart-1-0)**.

To get started right away, add `genkit` to your Dart or Flutter project:

```shell
dart pub add genkit
```

You can also install the agent skill to give AI coding assistants like
Antigravity, Claude Code, and Codex up-to-date knowledge of Genkit Dart APIs:

```shell
npx skills add genkit-ai/skills
```

## Highlights in Genkit Dart 1.0

Genkit Dart 1.0 brings a unified model interface, end-to-end type safety, and
agentic primitives to any Dart environment, whether you're building backend
services, CLI tools, or full-stack Flutter apps:

* **One API across model providers:** Swap between Google Gemini, Anthropic
  Claude, OpenAI, and OpenAI-compatible models without rewriting your
  application logic.
* **End-to-end type safety with `schemantic`:** Define your data schemas once
  in Dart using [`schemantic`](https://pub.dev/packages/schemantic) to generate
  structured model output, wrap AI logic in observable **flows**, and share
  types between your Dart server and client.
* **Flexible deployment across client and server:** Run flows on a Dart server
  with `GenkitRouter`, invoke them from a client using `defineRemoteAction`, or
  keep your AI logic on the client while routing model requests through a
  secure backend with `defineRemoteModel`.
* **Human-in-the-loop tool interrupts:** Pause tool execution inside
  `defineTool` by returning `.interrupt(...)` when an action requires user
  confirmation, then resume generation from where it left off.
* **Composable generation middleware:** Attach pre-packaged middleware from
  [`genkit_middleware`](https://pub.dev/packages/genkit_middleware) (including
  automatic retries, dynamic `SKILL.md` loading, and tool approval rules) or
  write custom middleware with `defineGenerateMiddleware`.
* **Prompt management with Dotprompt:** Keep prompt templates, model
  configuration, and schemas together in `.prompt` files with
  [Dotprompt](https://genkit.dev/docs/dart/dotprompt/).
* **Local Developer UI and OpenTelemetry:** Test flows and inspect execution
  traces locally with `genkit start`, and export production traces and metrics
  with [`genkit_otel`](https://pub.dev/packages/genkit_otel).
* **Experimental stateful agents and A2UI:** Try out multi-turn persistent
  agents (`defineAgent` and `remoteAgent` in `package:genkit/experimental.dart`)
  and stream interactive native UI surfaces with
  [`genkit_a2ui`](https://pub.dev/packages/genkit_a2ui).

```dart
@Schema()
abstract class $TripRequest {
  String get destination;
  int get days;
}
// ...plus an Itinerary schema for the result.

final ai = Genkit(plugins: [googleAI()]);

final planTrip = ai.defineFlow(
  name: 'planTrip',
  inputSchema: TripRequest.$schema,
  outputSchema: Itinerary.$schema,
  fn: (request, _) async {
    final response = await ai.generate(
      model: googleAI.gemini('gemini-flash-latest'),
      prompt: 'Plan a ${request.days}-day trip to ${request.destination}.',
      outputSchema: Itinerary.$schema,
    );
    return response.output!;
  },
);

await (GenkitRouter()..addAction(planTrip)).serve(port: 8080); // POST /planTrip
```

## Read the full announcement

For complete code examples covering multi-model generation, remote actions and
models, tool interrupts, middleware, Dotprompt, OpenTelemetry, stateful agents,
and generative UI with A2UI,
**[read the full Genkit Dart 1.0 announcement on the Flutter blog](https://flutter.dev/blog/announcing-genkit-dart-1-0)**.

* **Get started:** Follow the
  [quickstart guide](https://genkit.dev/docs/dart/get-started/) and check out
  [`genkit` on pub.dev](https://pub.dev/packages/genkit).
* **Explore samples:** Browse the
  [sample apps on GitHub](https://github.com/genkit-ai/genkit-dart/tree/main/testapps).
* **Join the community:** Chat with the team on
  [Discord](https://discord.gg/qXt5zzQKpc) and open issues on
  [GitHub](https://github.com/genkit-ai/genkit-dart).
