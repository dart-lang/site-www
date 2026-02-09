---
title: "Google Summer of Code 2021 results"
description: "The Dart team received 92 GSoC project proposals from students around the world. Here are the results of the 3 projects we accepted."
publishDate: 2021-10-14
author: "jonasfj"
image: images/1QswESHAF6CO9UNYCcRVKXA.png
category: other
tags:
  - dartlang
  - flutter
  - open-source
  - google-summer-of-code
---


[Google Summer of Code](https://summerofcode.withgoogle.com/) (GSoC) is a global program focused on bringing student developers into open source software development. Students are sponsored by Google to work with a mentoring open source organization on a 10-week programming project during the summer. Over the past 16 years more than 16,000 students have participated in Google Summer of Code.

2021 is the second time that the Dart organization participated in Google Summer of Code as a mentoring organization. Following our [call for student proposals in March](https://medium.com/dartlang/dart-in-google-summer-of-code-2021-e89eaf1d177a) we received 92 project proposals from students around the world, out of which we were thrilled to accept 3 projects. Today, we are excited to share our results, as described by the students who worked on these projects.

## Cronet-based HTTP client for Dart

*By Soumyadip Mondal*

The [cronet](https://pub.dev/packages/cronet) package is an HTTP package for Dart Native platforms, backed by [Chromium’s network engine](https://chromium.googlesource.com/chromium/src/+/refs/heads/main/components/cronet).

You might ask “why add an HTTP package?” when Dart already has HTTP support in `dart:io`. One reason is that `package:cronet` can use the QUIC/HTTP3 protocol, which is [a highly requested](https://github.com/dart-lang/sdk/issues/38595) community feature. Besides that, `package:cronet` is [faster than `d](https://github.com/google/cronet.dart/blob/main/dart_io_comparison.md#performance-comparison)art:io` in many scenarios.

A Dart binding of Cronet gives us easy access to its [features](https://www.chromium.org/developers/design-documents/network-stack#TOC-Connection-Management), such as: reusability of sockets, powerful caching and compression algorithms, request prioritization, and [more reliable](https://www.youtube.com/watch?v=YWiRef3wOYY) network connections. Various Google products — including YouTube, Chrome, Google Maps, Google Photos, and the Google App — already depend on the Cronet library for their networking needs. With `package:cronet`, you get access to the Cronet library using an API [similar](https://github.com/google/cronet.dart/blob/main/dart_io_comparison.md#api-comparison) to `dart:io`, with little to no code changes in your existing Dart/Flutter app.

Check out [github.com/google/cronet.dart](https://github.com/google/cronet.dart) for [benchmarks](https://github.com/google/cronet.dart/blob/main/dart_io_comparison.md#performance-comparison), [examples](https://github.com/google/cronet.dart/tree/main/example), and [comparisons with `d](https://github.com/google/cronet.dart/blob/main/dart_io_comparison.md)art:io`. Also check [this blog post](https://unsuitable001.medium.com/package-cronet-an-http-dart-flutter-package-with-dart-ffi-84f9b69c8a24) about `package:cronet` for a technical overview and discussion of the challenges we faced.

## Flutter desktop tool

*By Abdullah Deshmukh*

After the beta release of desktop support in Flutter 2, we needed a sample app to demonstrate how to write a Flutter app that can run on Windows, macOS, and Linux. I worked on that sample, in the form of a [Flutter linting tool that ](https://github.com/flutter/samples/tree/master/experimental/linting_tool)helps you manage lint rules for your Flutter projects. The app’s source code shows how you might implement basic desktop app techniques like reading and writing files, implementing a responsive layout, using persistent storage, and even how to work with YAML files. Also the sample might be used to test the distribution of Flutter apps to the various desktop app stores.

For more details, visit [GSoC ’21: Creating a desktop sample for Flutter](https://medium.com/flutter/gsoc-21-creating-a-desktop-sample-for-flutter-7d77e74812d6).

<DashImage src="images/1QswESHAF6CO9UNYCcRVKXA.png" alt="Flutter linting tool" caption="Flutter linting tool" />


## License detection for pub.dev

*By Bharat Biradar*

A package published on [pub.dev](https://pub.dev/) is evaluated on various metrics such as whether it follows Dart file conventions, has a CHANGELOG file, etc. This analysis is done by [pana](https://github.com/dart-lang/pana) (Package ANAlysis for Dart). Pana is also responsible for detecting the license identifier under which the package is published.

Until now the license names displayed on pub.dev were determined through simple regular expression heuristics, and they only supported detection of a few licenses with poor accuracy. The task of this project was to create a license detector for pana to detect [SPDX licenses](https://spdx.org/licenses), in line with the [SPDX matching guidelines](https://spdx.dev/license-list/matching-guidelines/).

The license detector built for pana uses the same approach as [v2_licenseclassifier](https://github.com/google/licenseclassifier), with modifications made to suit our requirements better.

Given the LICENSE file from a package, pana uses three steps to detect the SPDX license identifiers:

1. **Eliminate obvious mismatches from SPDX corpus: **Split the text into tokens (basically words), check whether the LICENSE file has a sufficient number of tokens (at least 50%) as compared to a known license, and eliminate all known licenses that do not satisfy the criteria. This step allows pana to quickly rule out a lot of licenses, allowing for more expensive computations in step 2.

1. **Find matching substrings in the unknown license and remaining SPDX licenses: **For the remaining known licenses, find the substrings in the unknown text that match a known license text. We look for substrings, because the unknown text might contain multiple licenses. When identifying matching substrings, we ignore sequences with fewer tokens than `threshold * number_of_tokens_in_known_license`, because such sequences do not have sufficient token density to constitute a match. If no substrings with sufficient token densities are found for a given known license, then we know it isn’t a match.

1. **Determine confidence scores: **This step** **estimates a confidence score (between [0,1] ) to the substrings found. First the substring is diffed, using [levenshtain word diff](https://github.com/google/diff-match-patch/wiki/Line-or-Word-Diffs#word-mode), against the SPDX corpus license in which it was detected. Then license is considered a match if the confidence calculated as follows is above the set threshold:

<DashImage src="images/1wB7F9CgvSn7yt2Rgoj75pw.png" />


We hope this gives you some idea of the license detection process. If you want to play with the license detector, you can find it in the [pana repository](https://github.com/dart-lang/pana/tree/master/bin).

*Huge thanks to everyone who applied for Google Summer of Code 2021 with Dart, to the students who completed projects this year, and to the mentors who helped make this an awesome summer of code. If you’re interested in hearing more about Dart in Google Summer of Code, check out [our 2020 post](https://medium.com/dartlang/google-summer-of-code-2020-results-a38cd072c9fe).*