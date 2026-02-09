---
title: "Pedantic Dart"
description: "Over at Dart’s package:pedantic, we’ve been slowly gathering a list of precisely correct lints you can apply to your Dart code."
publishDate: 2019-05-22
author: "davidmorgan"
image: images/1QCajckOeBhRaLzi0RoFqig.png
category: other
tags:
  - dart
  - dartlang
  - static-analysis
---


<DashImage src="images/1QCajckOeBhRaLzi0RoFqig.png" />


[Flutter](https://flutter.dev/) and [Flutter Web](https://flutter.dev/web) are generating plenty of buzz, and deservedly so; they are pushing the boundaries of UI development. Flutter is written in Dart, and Dart has just [gained a number of features](https://medium.com/dartlang/making-dart-a-better-language-for-ui-f1ccaf9f546c) under the banner “UI as Code” that will bring joy to every Flutter developer’s day. These are exciting times.

But, wait! Not everything should move fast. Sometimes it pays to be meticulous, fussy, fastidious, finicky, or—dare I say it—*pedantic*. So, over at Dart’s [package:pedantic](https://github.com/dart-lang/pedantic), we’ve been slowly gathering a list of *precisely correct lints* that you can apply to your code.

Of course, to check lints you need a linter. The [Dart linter](https://github.com/dart-lang/linter) is built right into the [Dart analyzer](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer), which means its 146 lints (as I write this) are available everywhere you want them: on the command line, in your presubmit, and in your IDE. As a Dart (or Flutter) developer you have hundreds of lints at your fingertips; the only problem is deciding *which* lints to enable.

This is a trickier problem than it might seem. If all you’d like to do is use the lints recommended by package:pedantic, no need to read on; simply [follow these instructions](https://dart.dev/guides/language/analysis-options#default-google-rules-pedantic).

Still with me? Great. Now, let’s dig into why you can’t just enable all 146 lints and start coding. We’ll begin with the simplest reasons, and work up. Then we’ll see exactly how a lint is evaluated for inclusion in package:pedantic, work through an example of a lint that was particularly troublesome to enforce, and finish with some pointers to how you could get involved.

## Obsolete lints

Some lints don’t make sense any more. An example is [super_goes_last](https://dart-lang.github.io/linter/lints/super_goes_last.html), which requires that `super` be placed last if it appears in a list of initializers. It was actually such a useful lint that with Dart 2 it became a requirement of the language, so the lint is no longer needed.

```
`// super_goes_last; now included in Dart 2, no need for a lint.
View(Style style, List children)
    : super(style), // LINT
      _children = children {`
```


## Contraindicated lints

Some lints are not actually intended for public consumption. In particular, a number of lints that are designed for use within the Flutter SDK directly contradict the [Dart style guide](https://dart.dev/guides/language/effective-dart). An example is [always_specify_types](https://dart-lang.github.io/linter/lints/always_specify_types.html); over-specifying types means you lose the benefits of type inference. The style guide [carefully explains](https://dart.dev/guides/language/effective-dart/design#types) how to strike a good balance between type annotations and type inference.

```
`// always_specify_types; do not use; breaks with recommended style!
var foo = 10; // LINT
final bar = new Bar(); // LINT
const quux = 20; // LINT`
```


## Expensive lints

Evaluating lints involves arbitrary computation over a complex data structure — your source code. How do you know they won’t slow you down? Of course, every effort is made when adding lints to keep them efficient; but surprises can happen. The [library_prefixes](https://dart-lang.github.io/linter/lints/library_prefixes.html) lint had a performance bug that only surfaced in very obscure cases; now fixed, of course.

```
`// library_prefixes; performance issue was fixed, now good to go!
import 'dart:math' as Math; // LINT
import 'dart:json' as JSON; // LINT
import 'package:js/js.dart' as JS; // LINT`
```


## Redundant lints

Most lints are extremely fast to compute, but they’re not quite free. So a lint needs to pull its weight; it needs to offer enough value. For example, we rejected the [empty_statements](https://dart-lang.github.io/linter/lints/empty_statements.html) lint on the grounds that using `dartfmt `makes empty statements easy to spot. They’re unlikely to get written by mistake, and so the lint is redundant.

```
`// empty_statements; considered redundant with dartfmt.
if (complicated.expression.foo()) ; // LINT`
```


## Overeager lints

Some lints are not precise enough to be enforced. For example, omitting types for local variables in Dart is [good style](https://dart.dev/guides/language/effective-dart/design#avoid-type-annotating-initialized-local-variables), but only *most of the time*. It’s a recommendation, not a hard rule. That makes the corresponding lint [omit_local_variable_types](https://dart-lang.github.io/linter/lints/omit_local_variable_types.html) too strict to be enforced everywhere.

```
`// omit_local_variable_types; too strict. Local variable types
// are good style where they improve readability.
void myMethod() {
  MyType bar = expression.methodCall().otherMethodCall(); // LINT
}`
```


## Opinionated lints

Some lints push the code in a direction that’s not *wrong*, but is nonetheless unusual. An example is [prefer_final_locals](https://dart-lang.github.io/linter/lints/prefer_final_locals.html), which requires that local variables be declared, if possible, as `final`. This is a style that some developers prefer, but it’s not what *most* Dart developers prefer, and so by default the lint should be off.

```
`// prefer_final_locals; inconsistent with common style.
void myMethod() {
  var label = 'foo'; // LINT` 
`}`
```


## Evaluating all the lints

It may seem that, even taking all this into account, someone with a close knowledge of Dart should be able to sit down with the list of 146 available lints and produce a list of recommended lints without too much trouble.

But that isn’t what we’ve found; it’s simply too big a task. Just as each lint can do arbitrary evaluation on your code, deciding whether a particular lint is both correct and useful turns out to be almost arbitrarily hard.

A good way to approach a hard question is to ask for hard data. So when considering each lint, we first benchmark its performance and gather information on all violations of the lint currently present in Google’s internal Dart code.

These numbers give us a good starting point for discussion.

If, for example, all of Google’s Dart code contains only five violations of the lint, then each had better be a serious bug; otherwise, it’s unlikely that the lint is pulling its weight. The [recursive_getters](https://dart-lang.github.io/linter/lints/recursive_getters.html) lint was a rare example of a lint catching a very small number of serious issues; a getter that calls itself is a stack overflow waiting to happen.

```
`// recursive_getters; definitely not what you meant to write!
`int get field => field; // LINT
```


If, on the other hand, we find many violations of the lint, the question turns around: the lint is going to change what a lot of developers are doing, so are we sure it’s an improvement, both overall and in each individual instance? If the lint will make a small number of cases worse, can we justify that? Or, perhaps, can we improve the lint?

The [unrelated_type_equality_checks](https://dart-lang.github.io/linter/lints/unrelated_type_equality_checks.html) lint is a good example. This lint requires that, before you are allowed to compare two objects, they must be of compatible static types. So you’re not allowed to check if `3` and `foo` are equal; it’s assumed that because one is an `int`and the other is a `String` that this question doesn’t even make sense.

```
`// unrelated_type_equality_checks; or, don't ask stupid questions!
void someFunction() {
  var x = '1';
  if (x == 1) print('surprise!'); // LINT
}`
```


This sounds good, but it’s not correct for two reasons.

It fails in theory because of `implements`; an object can be of more than one type, and so two objects that appear statically to be unrelated might turn out at runtime to implement the same type, and be perfectly valid to compare.

```
`// unrelated_type_equality_checks; objects _can_ hold surprises.
void checkForSurprise(Foo foo, Bar bar) {
  if (foo == bar) print('surprise!'); // LINT
}`

abstract class Foo {}
abstract class Bar {}
class Baz implements Foo, Bar {}

void main() {
  var baz = Baz();
  checkForSurprise(baz, baz);
}
```


It fails in practice because `operator==` is left to each class author to implement, and nothing forces them to follow its contract. We found, in particular, that `Int64` and `Int32` from `package:fixnum` allow comparisons with `int`, but only when the `int` is on the right hand side of the`==`.

So, the data showed three outcomes for the lint: lots of correct findings (bugs caught), a small number of incorrect findings due to runtime types being compatible when static types were not, and a relatively large number of incorrect findings due to `Int64` being compared to `int`.

What did we do? We improved the lint: it now knows about `Int64` (and `Int32`) and allows you to compare it to `int` as you did before. This left a very small number of false positives due to static types being incomplete; these we opted to refactor, using casts as necessary, to make them comply with the lint.

With these changes, we were able to reach a consensus on having unrelated_type_equality_checks be enforced.

By “we” in this instance, I mean “the set of all Google developers who care about Dart lints.” Anyone at Google who is writing Dart can get involved in this process, and many do, so we get plenty of input — particularly when a lint is controversial!

If and when there is consensus on a lint, the next thing that happens is that the person who proposed enforcing the lint cleans up all of Google’s internal Dart code to pass the lint. Sometimes we learn something new during this process; if we missed something that would make the cleanup a breaking or difficult change, the cleanup is typically paused. Right now we have enough lints to be working on that we can just skip such cases and come back to them later.

Once a lint is successfully cleaned up everywhere, it’s then enforced on presubmit, preventing any further violations in Google internal code, and it’s published in the next release of`package:pedantic`.

The [unawaited_futures](https://dart-lang.github.io/linter/lints/unawaited_futures.html) lint was an even harder case. This lint addresses what used to be a very common developer complaint: forgetting to `await` a `Future`, causing unpredictable runtime behaviour and flaky tests.

```
// unawaited_futures; catching accidentally asynchronous behaviour.

Future<void> doSomething() => ...;
Future<void> doSomethingElse() => ...;

void main() async {
  doSomething(); // LINT
  doSomethingElse(); // LINT
}
```


But the lint is problematic because we *know* there are cases when you *do* want to start a `Future` and then continue without waiting for it to complete. One example is logging: it’s typically okay to know that logging will complete at some point, without needing to wait for it.

The lint offered tremendous value but couldn’t possibly be made correct. We discussed for a long time the best path. Dart lints can be ignored by writing `// ignore: &lt;lint_name&gt;` on the preceding line, so enforcing a lint is never *actually* blocking for developers. But, we really didn’t want to train developers to write `ignore`; the majority of lints we enforce *are* always correct, and should never be ignored.

This discussion is actually what lead to the creation of `package:pedantic` in the first place. We wanted to provide the canonical way to say, “I know about the unawaited_futures lint, and it doesn’t apply here.” That is now the `unawaited` method in`package:pedantic`. Having published that, we updated the message and docs for the unawaited_futures lint to point to `unawaited`, and now we are in what we hope is a reasonably good place: we have a lint that you might sometimes need to turn off, and a canonical, readable way to do so.

```
// unawaited_futures; say `unawaited` if that's what you wanted.

Future<void> doSomething() => ...;
Future<void> doSomethingElse() => ...;

void main() async {
  unawaited(doSomething());
  unawaited(doSomethingElse());
}
```


This was sufficient to reach a consensus on enforcing the unawaited_futures lint.

## Step by step towards perfect Dart linting

And so the process continues. We are now up to 25 lints enabled and eight lints explicitly disabled, so we’re not quite a quarter of the way through the 146 lints available. Of course, people keep adding new lints — the linter design makes this easy to do — so it’s a moving target.

I’d love to be able to wave a magic wand and provide the perfect list of lints; hopefully this article has explained why that isn’t possible, and that we’re working on it.

Finally, if lints already exist that you’d like to see enabled sooner rather than later, you’re welcome to use the `pedantic` [issue tracker](https://github.com/dart-lang/pedantic/issues) to make that known; we take issues into account when looking at what to tackle next. Unfortunately, since Google internal code is key to deciding which lints to enable, we can’t make the whole process transparent, but we aim to be as open as possible in our GitHub discussions. In particular, we can give feedback, as far as possible, on what’s likely to get into package:pedantic and when.

If you’re interested in contributing new lints or improving existing ones, please get involved on GitHub!