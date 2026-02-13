---
title: "Dart gets a Type System"
description: "Rejoice, all ye faithful, for Dart 2.0 is coming, and it has types."
publishDate: 2017-07-04
author: "davidmorgan"
image: images/0C4V5HBaOprKmpRUh.jpg
category: other
tags:
  - programming
  - dartlang
  - dart
---


<DashImage src="images/0C4V5HBaOprKmpRUh.jpg" />


This is Dart’s first major breaking change — hence the “2” — and it’s precisely *because* it’s a breaking change that it’s such an important development. Let’s dig into why that is. First, some Dart 1 code:

```
void main() {
  cleanUp([new TempFile(), new BankAccount()]);
}

void cleanUp(List<TempFile> files) =>
    files.forEach((f) => f.delete());

class TempFile {
  void delete() => print('TempFile deleted.');
}

class BankAccount {
  void delete() => print('BankAccount deleted. Whoops!');
}

> TempFile deleted.
> BankAccount deleted. Whoops!
```


The code is a little surprising.

Both “TempFile” and “BankAccount” have a “delete” method; it so happens that since Dart 1 does not, by default, care about types, it will happily let us call “delete” on a “BankAccount” when we were very clearly trying to call “delete” on a “TempFile”.

Not good.

## Strong Mode Analysis

Enter Strong Mode, the new type system for Dart. (We won’t need the name once Dart 2.0 arrives; it’ll just be “the type system”).

The [Dart analyzer](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli) has supported Strong Mode static analysis for some time; it uses type inference to work out what types you most likely meant, and requires that each variable can only have a single type. It also adds strictness around overrides and generics.

If we feed the code snippet above to the analyzer with Strong Mode enabled, it tells us:

```
error: The element type 'BankAccount' can't be assigned to the list type 'TempFile'.
```


…which seems reasonable. Problem solved. Or is it?

Unfortunately not. There are a few ways to trick static analysis. For example, we can use “new List.from”, which takes any “Iterable”:

```
void main() {
  var list = new List<TempFile>.from(
      [new TempFile(), new BankAccount()]);
  cleanUp(list);
}

> TempFile deleted.
> BankAccount deleted. Whoops!
```


…and the analyzer is powerless to help. There is simply no way to catch this problem with static checks.

## Strong Mode Proper

Here we approach the concept of soundness; whether the type system is able to deliver on what it promises. Extra static checks via the analyzer help catch bugs, but they’re not enough to close all the holes. What’s needed is some additional runtime checks.

There is currently only one Dart runtime that implements those checks; the [Dart Dev Compiler (DDC)](https://github.com/dart-lang/sdk/tree/master/pkg/dev_compiler). If we run that last snippet with DDC we get a runtime error:

```
Type 'BankAccount' is not a subtype of type 'TempFile'
```


So, our bank account is safe. Strong Mode with runtime checks guarantees that if we are trying to run “TempFile.delete” we will never, under any circumstances[1], run “BankAccount.delete” instead.

## Dart 2.0

And here we return to the announcement about Dart 2.0, and why it’s important.

The reason DDC is the only runtime to add these checks is that they are breaking changes to the language. Programs that used to be valid are no longer valid. DDC is a development tool, so it doesn’t need to compile and run all valid Dart; the VM and dart2js do.

So with the change to Dart 2.0, those programs with type problems can now be declared invalid — and all the runtimes can move on to providing types that do what they promise. A happy ending, and an important step for my favourite programming language.

## Aside: And Nothing of Value was Lost

It’s natural to ask about the *downsides* of the change. What if we *want* loose types from Dart?

Fortunately the language has that covered. We can always opt out of type checks with the special “dynamic” type. In fact, “dynamic” is the default if you don’t add a type annotation, so we could just have written “List” instead of “List&lt;TempFile&gt;”:

```
void main() {
  cleanUp([new TempFile(), new BankAccount()]);
}

void cleanUp(List files) =>
    files.forEach((f) => f.delete());

class TempFile {
  void delete() => print('TempFile deleted.');
}

class BankAccount {
  void delete() => print('BankAccount deleted. Whoops!');
}

> TempFile deleted.
> BankAccount deleted. Whoops!
```


…and we have perfectly valid Dart 2.0 code[2]. The “cleanUp” method is now written to work on *any* class with a “delete” method — and that’s exactly what it does.

*[1] As other languages [have shown](https://dev.to/rosstate/java-is-unsound-the-industry-perspective), getting a type system 100% sound is hard. But there won’t be any* known *ways of breaking the type system.*

*[2] Dart 2.0 doesn’t exist yet, so this isn’t 100% guaranteed. But as far as the types go, this should be fine.*