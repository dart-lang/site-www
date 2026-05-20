---
title: "Quick fixes for analysis issues"
description: "Resolving diagnostics with a single click"
publishDate: 2022-03-04
author: bwilkerson
image: images/0PHnbrlzf5BzJAyp8.webp
category: other
layout: blog
---


If you’re like me, too much of your development time is spent fixing problems (diagnostics) the analyzer finds. If you’ve ever wished it could be easier, then I have some good news for you. Many of the diagnostics the analyzer produces can be fixed automatically using quick fixes.

A *quick fix* is an automated edit targeted at fixing the issue reported by a specific diagnostic. In the [Dart diagnostic messages](https://medium.com/dartlang/dart-diagnostic-messages-ae302aa398e8) article, we looked at the following code:

<DashImage src="images/0PHnbrlzf5BzJAyp8.webp" alt="Code snippet showing an error with quick fix suggestions." />


The correction message suggests two ways of resolving the problem: “Try making the access conditional (using ‘?.’) or adding a null check to the target (‘!’).”

If you click in the highlighted region (the area with the red squiggly underline), you’ll see a light bulb icon near the left edge of the editor. If you hover over it, you can then click to open a menu containing the available quick fixes.

Both of the suggested corrections are available from the menu. Selecting one applies the change to your code. For example, if you select the first fix, it updates the code to the following:

<DashImage src="images/0kv6ByFzA_oUH-1J-.webp" alt="Dart code after applying a quick fix, replacing values.length with values?.length inside a null check." />


Let’s first take a quick look at how to apply a fix in both [IntelliJ IDEA](https://www.jetbrains.com/idea/) and [Visual Studio Code](https://code.visualstudio.com/), then look at a more powerful example of what quick fixes can do.

## IntelliJ IDEA

The context actions menu in the editor looks like the following:

<DashImage src="images/0SSy3gV3OrvEOjqyY.webp" alt="IntelliJ IDEA context actions menu offering to replace '.' with '?.' or add a null check for values.length." />


You can access the same list by selecting “Show Context Actions” from the context menu in the editor or by using its keyboard equivalent (**Alt+Enter** on Windows and Linux, or **Option+Enter** on macOS).

You can also invoke these fixes directly from the hover text when you hover over the highlighted region. If there are too many fixes, there’s a **More Actions** item also opens the menu:

<DashImage src="images/09fUhfo7YYZeSkbwJ.webp" alt="IntelliJ IDEA hover text explaining that values.length can't be unconditionally accessed and offering the ?. quick fix." />


If that’s not enough, you can also invoke the available fixes from the context menu in the Dart Analysis view:

<DashImage src="images/0KOFAwRRqF1nxP-X4.webp" alt="Dart Analysis context menu in IntelliJ IDEA offering quick fixes for the nullable values.length diagnostic." />


## Visual Studio Code

The code actions menu in the editor looks like the following:

<DashImage src="images/06MrUQEB2aHocDDXS.webp" alt="Visual Studio Code actions menu offering to replace '.' with '?.' or add a null check for values.length." />


The first two items are the quick fixes, the others are refactorings. You can access the same list by using its keyboard equivalent (**Control+.** on Windows and Linux, or **Command+.** on MacOS), or by selecting **Quick Fix …** from the hover text in the editor:

<DashImage src="images/0t9j1bNBN9t_H_vGm.webp" alt="An IDE showing the Problems panel in Visual Studio Code with a quick fix menu open offering to replace '.' with '?.'." />


You can also invoke them from the context menu in the Problems panel:

<DashImage src="images/0rD7c_L6FPLusv6lm.webp" alt="The Visual Studio Code context menu for a problem entry showing 'Quick Fix' and 'Copy' options." />


## Another example

While the fix above saves you the time and effort of finding the correction message and then making the edit by hand, adding a single character is admittedly not a huge time-saver. However, some fixes provide a bigger productivity boost. Consider the following code:

<DashImage src="images/0JudcB_TM8lvc32Ld.webp" alt="An IDE showing the code 'await file.readAsString();' with a red squiggly line under 'await' and an error about using await in a non-async function." />


The diagnostic tells you that “the await expression can only be used in an async function.” Assuming that you don’t want to use synchronous I/O, the correction is to mark the body of the function with the `async` keyword. Doing that causes another error telling you that the return type of the method needs to be `Future`, so you’ll also end up updating the return type.

Fortunately, there’s a quick fix for the original problem:

<DashImage src="images/0sgdKZfY_KVOLiIJU.webp" alt="An IDE showing the quick fix menu with 'Add async modifier' highlighted to fix the 'await' error." />


Selecting this fix not only adds the modifier, but also updates the return type, allowing you to fix the problem in one step:

<DashImage src="images/0WW-9wW23CnKxWZO2.webp" alt="An IDE showing the code after the quick fix, now with the 'async' keyword and the return type updated to a Future of String." />


## Summary

Not every problem can be fixed automatically, and there isn’t a quick fix for every problem that could have one. Nevertheless, it’s definitely worth checking to see whether there’s an available quick fix the next time you have a diagnostic to fix. And if you don’t see a fix for a diagnostic that ought to have one, please let us know by [creating a dart-lang/sdk issue](https://github.com/dart-lang/sdk/issues/new).
