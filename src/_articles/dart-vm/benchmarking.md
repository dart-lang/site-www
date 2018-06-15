---
title: "Benchmarking the Dart VM"
description: "Learn how to benchmark your applications"
written: 2012-10-01
updated: 2012-11-01
category: dart-vm
obsolete: true
---

_Written by John McCutchan <br>
October 2012 (updated November 2012)_

{% comment %}
update-for-dart-2.0
{% endcomment %}

<aside class="alert alert-info" markdown="1">
**Note:**
This article was initially targeted for the standalone VM under the
1.x Dart SDK.  It does not reflect the Flutter VM,
nor does it reflect the changes that are coming in [Dart 2](/dart-2).
</aside>

Programmers often create benchmarks that exercise an important algorithm in a
larger application. The point of the benchmark is to have an easy to run,
reproducible stress test of the performance-sensitive algorithm.
The benchmark verifies that changes to the algorithm are indeed
improvements, and not regressions.

## Benchmarking Dart

Dart can go really fast, but you have to give the VM time to optimize your code.
Most benchmarks we've seen are short and to the point—so short that they don’t
trigger the VM’s optimizer. This isn’t an issue with real-world applications,
which execute long enough to be optimized.
Read on to find out how to use the benchmark_harness library
to properly run a Dart benchmark.

### Use the benchmark harness

The Dart team has provided an official benchmark harness that ensures
your benchmark follows the benchmarking procedures necessary
for the Dart VM's optimizer.

The harness is available as a pub package and is incredibly easy to use.

<ol markdown="1">
<li markdown="1">Add the following to your pubspec.yaml, and run `pub get`:

{% prettify yaml %}
dependencies:
  benchmark_harness: ">=1.0.0 <2.0.0"
{% endprettify %}
</li>

<li markdown="1">Copy the following template, which creates a class extending
    `BenchmarkBase`:

{% prettify dart %}
// Import BenchmarkBase class.
import 'package:benchmark_harness/benchmark_harness.dart';

// Create a new benchmark by extending BenchmarkBase.
class TemplateBenchmark extends BenchmarkBase {
  const TemplateBenchmark() : super("Template");

  static void main() {
    new TemplateBenchmark().report();
  }

  // The benchmark code.
  void run() {
  }

  // Not measured: setup code executed before the benchmark runs.
  void setup() { }

  // Not measured: teardown code executed after the benchmark runs.
  void teardown() { }
}

// Main function runs the benchmark.
main() {
  // Run TemplateBenchmark.
  TemplateBenchmark.main();
}
{% endprettify %}
</li>
</ol>

#### Output

The benchmark will output something like the following:

    Template(RunTime): 0.1568472448997197 µs.

<aside class="alert alert-info" markdown="1">
**Note:**
µs is an abbreviation for microseconds. A microsecond is one millionth of a
second.
</aside>

### Run in production mode

The Dart VM can run in two modes: checked and production mode.
Checked mode is slower because the VM is checking types at runtime.
Before benchmarking make sure that your code runs without issue in checked mode.
If checked mode finds an issue,
it will likely cause a performance problem in production mode.
After making sure your program is correct,
you should run your benchmark in production mode
to get an accurate measurement of real world performance.

When executing from the command line checked mode is off by default and can be
turned on by passing the
[`--checked`]({{site.prev-url}}/dart-vm/tools/dart-vm#enabling-checked-mode) command line flag.
WebStorm has checked mode on by default but can be turned off by
going to **Preferences** > **Languages & Frameworks** > **Dart**
and toggling the **Start Dartium in checked mode** checkbox.

## Summary

When benchmarking your application be sure to follow these three rules:

1. Use the official benchmarking harness.
1. Ensure the code does not raise any errors when run in checked mode.
1. Run your benchmark in production mode.

If you follow these rules you will be able to accurately measure how fast your
code runs. Once you've sped up your application, share your secrets on the
<a href="https://groups.google.com/a/dartlang.org/forum/?fromgroups#!forum/misc"
  data-proofer-ignore>mailing list</a>.
Happy benchmarking!
