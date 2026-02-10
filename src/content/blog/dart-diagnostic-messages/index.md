---
title: "Dart diagnostic messages"
description: "Understanding error and warning messages from the Dart analyzer"
publishDate: 2021-11-11
author: bwilkerson
image: images/1kUNsHzJZkZNRysNJmbNTdw.png
category: other
tags:
  - dart
  - programming
  - tooling
layout: blog
---


Have you ever seen an error message and wondered what it means and what you should do about it? There might be more information available to help you answer those questions than you realize.

Let’s take a fairly common example. There’s a problem in the following code:

<DashImage src="images/1KDUXUtf0E8hb0kZBeIUdSA.png" />


In IntelliJ IDEA, the message is visible in the Dart Analysis view:

<DashImage src="images/1mjwyDt_bsYpTZBPwLbFhwg.png" />


In Visual Studio Code, the problem message appears in the Problems panel:

<DashImage src="images/1XTJeTrWGGKzxfQv41qVfug.png" />


It seems odd that there’s a problem because we just checked that `values` isn’t `null`on the line above.

The message tells us what’s wrong, but it doesn’t really help us understand why the check wasn’t sufficient or how to respond to the error. That extra information is actually available; it just might not be obvious how to find it. The rest of this article shows you how to find the location of this extra information in the output of [IntelliJ IDEA](https://www.jetbrains.com/idea/), [Visual Studio Code](https://code.visualstudio.com/), and the `dart analyze` command-line tool.

### IntelliJ IDEA

If you hover over the highlighted text you can get more information:

<DashImage src="images/1m2K6XXsAfB7gK0oBPGNwag.png" />


The hover includes the message we saw above (which we call the *problem message*), but it also includes other useful information:

* A link to [external documentation about the diagnostic](https://dart.dev/tools/diagnostic-messages#unchecked_use_of_nullable_value)

* A *context message* that explains why the null comparison wasn’t sufficient to promote the type of the property to be non-nullable

* A *correction message* that describes some of the things you can do to correct the code

The context message includes the URL of additional documentation related to type promotion and tells you the line and file on which the field is defined. Unfortunately you can’t navigate to the context location from the hover, but you can from the Dart Analysis view.

Although the Dart Analysis view displays only the problem message, double-clicking the message navigates you to the text with the red squiggly underline where the problem is being reported. For other useful features, bring up the context menu:

<DashImage src="images/1KUQaTyshPTkO9eF0Rdxe2w.png" />


With the context menu, you can navigate to either the location where the diagnostic was reported (using **Jump to Source**, which works just like double-clicking the problem message) or to the declaration of `values` (using the menu item labeled by the context message). Selecting **Open Documentation** opens the external documentation about the diagnostic.

### Visual Studio Code

In Visual Studio Code there are two ways to see the extra information. The first is to expand the entry in the Problems panel:

<DashImage src="images/1qsXBZQMBgk6W5WaUBOQ_bA.png" />


The first line is the message we saw before (which we call the *problem message*). Double-clicking either the first or second line navigates you to the text with the red squiggly underline where the problem is.

The second line is a *correction message* that describes some of the things you can do to correct the code. It also contains a link, labeled by the ID of the diagnostic, that opens [external documentation about the diagnostic](https://dart.dev/tools/diagnostic-messages#unchecked_use_of_nullable_value).

The third line is a *context message* that explains why the null comparison wasn’t sufficient to promote the type to be non-nullable. Double-clicking the context message navigates you to the declaration of `values`. The context message includes the URL of additional documentation related to type promotion.

You can also see this information by hovering over the highlighted text, which causes hover text to be opened:

<DashImage src="images/1kUNsHzJZkZNRysNJmbNTdw.png" />


The hover text contains the same information as the Problems panel. It contains a link to take you to the external documentation and another link to navigate to the declaration of `values`.

### dart analyze

The command-line analyzer `dart analyze` can display the same information as the IDEs, but you need to use the`--verbose`flag to see all of it.

<DashImage src="images/1GtSPY3IoZDeGkfkolrXO7A.png" />


### Summary

I hope this article helps you more easily find the information you need to understand the analyzer’s diagnostics.

If you find diagnostics that are still hard to understand — because the message isn’t clear, it needs a context message to help you find other related code locations, or the documentation isn’t complete enough — please let us know by [creating a dart-lang/sdk issue](https://github.com/dart-lang/sdk/issues/new). We’re always interested in improving the tools.