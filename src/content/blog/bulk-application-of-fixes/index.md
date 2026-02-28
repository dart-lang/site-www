---
title: "Bulk application of fixes"
description: "Fixing multiple analysis issues in one step"
publishDate: 2022-05-05
author: bwilkerson
image: images/0URmNnWSjGRGOorjv.png
category: other
tags:
  - dart
  - linter
  - analyzer
  - dartlang
layout: blog
---


In [Quick fixes for analysis issues](https://medium.com/dartlang/quick-fixes-for-analysis-issues-c10df084971a) we looked at support for automatically fixing individual diagnostics while editing. Sometimes even that’s too slow and you’d really like to fix multiple diagnostics all at once. Fortunately, there’s support for that too, which we cover in this article.

There are several ways to fix multiple diagnostics, depending on just how many diagnostics you want to fix, and we’ll look at each one separately.

## Fixing multiple occurrences of the same diagnostics

Have you ever refactored your code by moving a class to a different file? If so, it’s fairly likely that some imports were only needed because of references in the class being moved, which leaves you with unused imports:

<DashImage src="images/0URmNnWSjGRGOorjv.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/03QaE0FunXWpPp2Az.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


For any fix that can be applied more than once within the same file, the tooling offers an option to apply it everywhere in the file.

These fixes show up in the same places as other fixes and are usually labeled similarly to the single location fixes, but with some phrase like “in file” added. For example, here’s how this fix appears in your IDE:

<DashImage src="images/0p2Pf06L6A4JSX7IS.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0S4UnOqdx-h0U55jU.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Selecting the “in-file” fix does exactly what you’d expect — it removes all unused imports in the file:

<DashImage src="images/0dHw4rjdxTR0liZX8.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0Wk6qnyUlNr3qN0GQ.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


## Fixing all the diagnostics in a file

That’s great, but it only fixes a single kind of diagnostic, and it requires you to find the place where the diagnostic is being reported (either in the editor or in the problems view) to invoke the fix. It seems like the tooling could do more.

And in [Visual Studio Code](https://code.visualstudio.com/), it can. You can apply fixes for all the diagnostics within a single file. To see how, we’ll use the same example as above:

<DashImage src="images/0mr1A2XnnRCaamU22.png" />


If you right click to open the context menu, you’ll see the following:

<DashImage src="images/03klKEJk5p40lCPbO.png" />


If you select **Source Action…**, it opens a second menu:

<DashImage src="images/0iRZIzPrwKl7jEYNY.png" />


Selecting **Fix All** causes fixes to be applied to all the diagnostics in the editor, producing the following:

<DashImage src="images/0FDf16dDPwfPg_dET.png" />


You can also invoke the **Fix All** command from the command palette, which you can open by selecting **Command Palette…** from the **View** menu, or by using the keyboard shortcut (`F1` on any platform, `Control+Shift+P` on Windows and Linux, or `Command+Shift+P` on macOS). You can filter the list by typing the name of the command. The command palette looks something like this:

<DashImage src="images/0Jrz3MRfYVtcXrb9C.png" />


## Fixing all the diagnostics in a directory

The most complete tool we have for fixing diagnostics is the `[dart fix](https://dart.dev/tools/dart-fix)` command-line tool. It can fix all the diagnostics in a given directory, which means that you can use it to fix everything in your package or application.

Of course, there are a couple of caveats. It doesn’t fix every diagnostic, because it applies the same quick fixes that are available in the IDE, and there aren’t quick fixes for every diagnostic. It also doesn’t apply quick fixes for diagnostics when there are multiple equally valid ways of fixing the problem, because it can’t know which fix you prefer to apply. These caveats also apply to the **Fix All** command described in the previous section.

While the need for this tool doesn’t come up often (which is one reason you might not know about it), there are a couple of situations where it’s especially useful.

First, consider the case where you want to enable a new lint, or even a set of lints, such as one of the [`core`](https://github.com/dart-lang/lints/blob/main/lib/core.yaml), [`recommended`](https://github.com/dart-lang/lints/blob/main/lib/recommended.yaml), or [`flutter`](https://github.com/flutter/packages/blob/master/packages/flutter_lints/lib/flutter.yaml) rule sets. Chances are good that there are at least a few violations of the lint rules in your package. If there’s a fix associated with the lint, then it’s convenient to apply that fix everywhere in one step rather than applying the fix to each violation individually.

Second, consider the case where you’re updating from one release of Flutter to another. If there have been API changes between the two releases, there’s a good chance that there’s a fix to upgrade your code to conform to the latest release. Again, it’s convenient if all of those changes are applied in a single operation.

That’s where the [`dart fix`](https://dart.dev/tools/dart-fix) command comes in. It can apply quick fixes for multiple diagnostics in multiple files.

The command has two modes. The *dry-run* mode tells you how many changes it can apply and which diagnostics it can fix, but without modifying any files. The *apply* mode applies the changes.

You can provide the path to the directory containing the files to be fixed, but if you omit the directory it recursively fixes all the files in the current directory and its subdirectories.

Let’s assume that you’ve enabled the `prefer_single_quotes` lint, and that you have a file containing the following:

```
import 'package:logging/logging.dart';

void main() {
  var logger = Logger("myApp");
  logger.info("Entering myApp");
  // Do stuff.
  logger.info("Exiting myApp");
}
```


Running the [`dart fix`](https://dart.dev/tools/dart-fix) command with the `--dry-run` option from the directory containing this file produces the following output:

```
$ dart fix --dry-run
Computing fixes in __bin__ (dry run)... 4.3s

3 proposed fixes in 1 file.

demo.dart
  prefer_single_quotes • 3 fixes
```


The tool has found three violations of the lint and reports that it’s able to fix all three, but it doesn’t modify the file.

Running the [`dart fix`](https://dart.dev/tools/dart-fix) tool again, but this time with the `--apply` option, produces almost the same output:

```
$ dart fix --apply
Computing fixes in __bin__... 5.3s
Applying fixes...         0.0s

3 proposed fixes in 1 file.

demo.dart
  prefer_single_quotes • 3 fixes

3 fixes made in 1 file.
```


But this time the file is updated to contain the following:

```
import 'package:logging/logging.dart';

void main() {
  var logger = Logger('myApp');
  logger.info('Entering myApp');
  // Do stuff.
  logger.info('Exiting myApp');
}
```


Because the dry-run mode doesn’t produce any kind of diff output that allows you to see the actual changes that are being proposed, **consider committing your changes before running the tool using the `--apply` option**. That way it’s easier to see what changes the tool has actually made and to revert any changes you don’t like.

If you don’t want to commit before running the tool, and you’re using IntelliJ IDEA, you can use the **File-&gt;Local History** feature to compare the state before and after applying the fixes. (For more information see [Add labels to specific states Local History](https://www.jetbrains.com/help/idea/local-history.html#label-local-history-revisions).)

The [`dart fix`](https://dart.dev/tools/dart-fix) command can’t fix every problem, but when it can, it’s much easier than manually applying the fix everywhere.

## Summary

Being able to apply multiple fixes in a single operation not only increases the power of quick fixes, but might also make it easier to make larger scale changes, such as enabling a new lint rule or upgrading to the latest version of Flutter.

As always, if you have ideas for how to improve these tools, please let us know by [creating a dart-lang/sdk issue](https://github.com/dart-lang/sdk/issues/new).