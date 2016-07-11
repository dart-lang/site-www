---
layout: default
title: Performance
description: Track the performance of your Dart code using benchmarks.
permalink: /performance
---

Dart was founded on the belief that performance matters.
From the start, we focused on delivering fast runtimes, compilers,
and a programming model that helps developers stay on the fast path.

The Dart VM implements an optimizing compiler, which looks at many
signals from the running program and generates optimized native code.
It does this by, among other techniques, looking at the actual types
of the objects flowing through the code.
Type annotations are not used for generating optimized code.

The Dart to JavaScript compiler implements an SSA architecture,
and can inline code and tree-shake (eliminate) unused code.

The Dart language is designed to be fast. The static structure of
Dart code helps make it easier for runtimes to generate optimized code.

The following are answers to commonly asked questions.

## How do I benchmark Dart?

Check out the article on
[benchmarking best practices](/articles/dart-vm/benchmarking).

## What benchmarks are the Dart team tracking?

Check out the [ton80 benchmark suite](https://github.com/dart-lang/ton80).
It contains benchmarks that help
measure real-world properties of object-oriented languages,
runtimes, and compilers.

## Do type annotations affect runtime performance?

Dart is an optionally typed language, and the type annotations are
ignored at runtime (modulo _checked mode_, a developer mode).
It turns out that looking at the actual types of live objects as they
flow through a running app is more useful than static types in the code.

## Are there public benchmarks for server-side Dart?

Yes. Check out
[TechEmpower benchmarks](https://www.techempower.com/benchmarks),
which look at performance in a variety of server-side scenarios.

## I found a case where I think Dart is slower than expected. What do I do?

Please read the [benchmark article](/articles/dart-vm/benchmarking),
and then write a simple benchmark using the
[benchmark](https://github.com/dart-lang/ton80) package.
If you continue to see a performance delta from expectations,
you can then file an issue with your benchmark.
Please ensure all the necessary files are attached to the issue
so that we can easily run the benchmark.

