---
title: "Quick assists for editing"
description: "Using localized refactorings to be more productive"
publishDate: 2022-07-13
author: bwilkerson
image: images/0V2JRi49yUj_MkFjS.png
category: other
tags:
  - dart
  - linter
  - analyzer
  - dartlang
layout: blog
---


Do you spend too much time performing repetitive tasks while coding? If so, then I have some good news for you. Many of the repetitive tasks can be performed automatically using a feature we call quick assists.

A *quick assist* is an automated edit targeted at making a common change to the code. Unlike a quick fix, which we looked at in [Quick fixes for analysis issues](https://medium.com/dartlang/quick-fixes-for-analysis-issues-c10df084971a) and [Bulk application of fixes](https://medium.com/dartlang/bulk-application-of-fixes-e6add333c3c1), the presence of a quick assist isn’t a suggestion that you should change your code, it’s simply there to make your work easier.

Let’s look at a couple of examples.

## Declaring local variables

You likely spend a fair bit of time declaring and initializing local variables. The tools can help with some of that. If you type the initializer expression then you can use a quick assist to create a local variable to capture the value of the expression.

If you start with the code below and place the cursor anywhere in the expression, then the lightbulb icon appears near the left edge of the editor. If you hover over it you can then click to open a menu containing the available quick assists.

<DashImage src="images/0V2JRi49yUj_MkFjS.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0SH7NIMTeCdgyE2Uf.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Choosing the assist inserts a variable declaration, using the expression as the initializer, and selects the name of the variable so that you can either choose one of the suggested names or type your own name:

<DashImage src="images/0zkIBfG56juJk2AuT.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0jfAvjus6m7-TCP4S.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Pressing the enter/return key accepts the entered name.

## Function body styles

If you frequently use expression bodied functions, then you’ve likely needed to convert one into a block bodied function at some point. There’s an assist for that too. For example, if you have code like the following and you place the cursor inside the arrow, you’ll see the following options:

<DashImage src="images/0hp1u0YSRQsoNMaJl.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0Ca5bRUzZ-Y4dHkw2.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Selecting “Convert to block body” rewrites the function body to look like this:

<DashImage src="images/0mU7Y97eTeCILB1sr.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0miez1wvKHge96Ggl.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


And, yes, there’s another assist that converts from a block body to an expression body.

## Rewriting if statements

Assists can also help with bigger restructurings. If you’ve ever written code structured like this:

```
void f(int a, int b, int c, int d) {
  if (a == b) {
    if (a == c || a == d) {
      print(0);
    }
  }
}
```


and realized that you could combine the two conditions, there’s an assist for that. Put the cursor on the inner `if` and open the menu:

<DashImage src="images/06C745jOIAaB-k0f-.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/09mRjNGVqm82qAeg0.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Selecting “Join ‘if’ statement with outer ‘if’ statement” rewrites the code to look like this:

```
void f(int a, int b, int c, int d) {
  if (a == b && (a == c || a == d)) {
    print(0);
  }
}
```


The assist also shows up if you put the cursor on the outer `if`, though the menu then reads “Join ‘if’ statement with inner ‘if’ statement”.

## Using newer language features

There are also assists to help you convert to newer language features. For example, if you have a class like this:

```
class A {
  A({int? x, int? y});
}

class B extends A {
  B({int? x, int? y}) : super(x: x, y: y);
}
```


where the constructor in the subclass passes some parameters to the superclass without modifying them, there’s a cleaner way to write the code. Put the cursor on the name of the constructor `B` and open the menu:

<DashImage src="images/0PGLOLXQPGGTZFTCE.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0pfrf--11lE_B1oTf.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


Selecting “Convert to using super parameters” rewrites the code to look like this:

<DashImage src="images/0Lr2HLGu31CqL5JLd.png" alt="[Visual Studio Code](https://code.visualstudio.com/)" caption="[Visual Studio Code](https://code.visualstudio.com/)" />


<DashImage src="images/0nHsQKP9Wtm1UZn6-.png" alt="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" caption="[IntelliJ IDEA](https://www.jetbrains.com/idea/)" />


There are more assists available than we can cover in a single article. The next time you find yourself about to perform an edit that you do all the time, check out the context actions to see whether there’s an assist to make the task easier.