---
title: Dart team packages
description: Packages published by the Dart team under the dart.dev, tools.dart.dev, and labs.dart.dev publishers.
---

The Dart team also supports a number of packages on [pub.dev]({{site.pub-pkg}}),
published under three distinct pub.dev [verified publishers](/tools/pub/verified-publishers):

  * [`dart.dev`]({{site.pub-pkg}}/publishers/dart.dev/packages):
    The more core packages; these are foundational packages
    that complement the [core libraries](/guides/libraries).

  * [`tools.dart.dev`]({{site.pub-pkg}}/publishers/tools.dart.dev/packages):
    Packages used by the Dart team to build various Dart tools. These may be used for 
    building other tools, but note that our support commitment is lower than for core packages (see below).

  * [`labs.dart.dev`]({{site.pub-pkg}}/publishers/labs.dart.dev/packages):
    Experimental packages shared for early feedback.
    It should be expected that some of these will get discontinued.

# Maintainance and support levels

The maintainance and support levels for the packages vary across the three publishers:

|                                    | dart.dev                                      | tools.dart.dev                                                    | labs.dart.dev                                                 |
|------------------------------------|-----------------------------------------------|-------------------------------------------------------------------|---------------------------------------------------------------|
| Contents                           | Core packages that complement core libraries. | Tooling functionality used to build various Dart tools.           | Experimental packages shared for early feedback.              |
| Expected quality and completeness  | High.                                         | Medium.                                                           | Low/incomplete.                                               |
| Community engagement (issues, PRs) | High: Triaged on a regular basic.             | Medium-low: occasional triage, not able to respond to all issues. | Varying; no firm promise, maintained on an best-effort basis. |
