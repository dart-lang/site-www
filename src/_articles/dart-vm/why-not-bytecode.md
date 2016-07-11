---
layout: article
title: "Why Not a Bytecode VM?"
description: "This article discusses the trade-offs VMs have to make,
       and explains why we think that a language VM makes more sense for Dart."
written: 2011-11-01
category: dart-vm
---

_Written by Florian Loitsch and Bob Nystrom<br>
November 2011_

When we released an early preview of Dart we were frequently asked why the
Dart VM is not bytecode based, but instead works on Dart source code directly.
A bytecode VM seems to have a big advantage over a language VM: given a
standardized bytecode format, developers can write in the language of their
choice and then simply compile to the specified bytecodes.

In this article we will discuss the trade-offs VMs have to make, and explain
why we think that a language VM makes more sense for Dart.

## Apparent advantages of a bytecode VM

The biggest advantage of a bytecode VM is that it is not restricted to one
input language. The <a href="http://en.wikipedia.org/wiki/JVM">JVM</a>, for
instance, supports a multitude of languages such as
<a href="http://www.scala-lang.org/">Scala</a>,
<a href="http://groovy.codehaus.org/">Groovy</a>,
<a href="http://clojure.org/">Clojure</a>, and, of course,
<a href="http://java.com/">Java</a>.
This does not mean that the JVM is an easy compilation target, though.
The above-mentioned languages have all been designed with the JVM in
mind. For languages that have different requirements than Java, the JVM is a
poor compilation target. It is usually possible to compile them to the JVM, but
their performance is generally not on par with specialized VMs (see
<a href="http://jruby.org">JRuby</a> or
<a href="http://www.mozilla.org/rhino">Rhino</a>).
The reasons for the difficulties are numerous:
for example, the JVM assumes you want classes, single dispatch, inheritance,
and primitives. It assumes you
<a href="http://darksleep.com/player/JavaAndUnsignedTypes.html">don't need
32-bit unsigned math</a>. If you don't like the lack of unsigned math, sidestepping
Java and going straight to the bytecode won't help. If you want true dynamic
dispatch, <a href="http://en.wikipedia.org/wiki/Tail_call">tail call
elimination</a>, or <a href="http://www.gigamonkeys.com/book/beyond-exception-handling-conditions-and-restarts.html">
restartable conditions</a>, you're stuck. It's not just that <em>Java</em> lacks
them, the <em>bytecode</em> does too. It's <em>Java</em> bytecode on the <em>Java</em>
Virtual Machine, after all.

## More bytecodes

Another advantage of bytecode VMs is that they can evolve by simply
adding new bytecodes (which the JVM is doing
with
<a href="http://java.sun.com/developer/technicalArticles/DynTypeLang/"><code>invokedynamic</code></a>).
However, the cost is increased complexity in the VM.
Worse, seemingly similar features might require different bytecodes. For
instance, in order to support all possible languages a VM needs to support a
multitude of calling conventions: tail calls, optional arguments,
rest arguments, keyed arguments, overloaded methods, and so on.

Sometimes you can get around "missing" opcodes by compiling to other
existing ones, but often that's impossible while still getting good
performance. Tail-call elimination, continuations (<code>call/cc</code>), <code>
eval()</code>, floats, and long doubles require specialized opcodes to be fast.
Eventually one ends up with something very close to the native CPU
instructions.

<a href='https://developer.chrome.com/native-client'>Native Client</a> is an
example of this most generalist approach. It is
already supported in Chrome and is fully language neutral.
If the Dart VM is not flexible enough as
compilation target for your language, consider compiling for Native Client
instead.

## It's not just bytecode

There's more to a VM than the instruction set. If you look at the JVM, it
specifies a class file format,
a concurrency model (in the case of the JVM threads with shared state), class
initialization, and
a bunch of other stuff that nails down semantic choices.

If you're building a VM (bytecode or not) from scratch, you have to think
about and make those decisions. If you want at least <em>one</em> language to
be great on that VM, many of your choices will be made to serve that language. For
example, each Dart isolate has its own heap. Even if we had a bytecode VM, it
would assume things worked that way. Adding support for sharing memory across
threads in our VM would be pointless since the one language we know our VM will
run doesn't use it.

## Optimizing for the language

If you ask one of the VM guys why a language VM is better than a bytecode VM,
  they'll tell you
a different but maybe even more important story: performance. Optimization is
often based on being able to take things for granted. A VM tailored for a single
language can take that language for granted and optimize specifically for it.

For example, V8 internally uses "smis" ("small integers") to make integer
operations less costly. Other JavaScript engines use similar tricks such as
<a href="http://wingolog.org/archives/2011/05/18/value-representation-in-javascript-implementations">NaN tagging</a> to
similar effect. They do this to help make dynamic languages run fast.

Meanwhile, JVMs don't do these optimizations. Since all types are statically
known, the compiler knows exactly how much storage they need and what operations
they support. It can then generate appropriate tight code for those types. This
is fast if your language is statically typed, but if you're trying to compile a
<em>dynamically typed</em> language to the JVM, it won't be able to run as fast
as a VM that can assume dynamic typing all the way down and optimize
specifically for that.

## The line of trust

Opening up bytecode has another important implication: you've moved the
security boundary. When your VM's input is program source code, it can rely on
the grammar of the language itself to enforce important invariants. If it
allows raw bytecode to walk in the door, the story changes.

You can craft bytecode sequences that a regular Java compiler would never
emit. When you do, you go off the VM's beaten path. These non-exercised
code paths likely haven't been optimized as much and often have more bugs. (Many
JVM exploits that rely on broken
<a href="http://java.sun.com/docs/white/langenv/Security.doc3.html">bytecode
verification</a> could never be generated by a Java compiler.)

This does not necessarily mean that bytecode VMs are less secure, but they
require additional complexity which makes it much harder.

## The case <em>for</em> a language VM

So far, we haven't given a good reason to exclude bytecode VMs. We have
demonstrated that they don't bring all the advantages one would expect, but
none of our arguments make them a worse choice than a language VM. The key
argument in <em>favor</em> of a language VM is the development process.

If you're writing JavaScript, your "compile
step" is just refreshing the browser. Dart must be equally simple to use.
We want to make
development in the browser a great experience. Not only do we want to keep the
fast 'edit-refresh-view' cycle that JavaScript developers love, but
we also want to introduce web developers to the powerful live editing
features that Smalltalk developers pioneered.
Sure, you may minify or do other obfuscation when you deploy, but your core
iteration loop is fast and easy because the engine for your language runs it
directly from source.


You may ask, "but doesn't Dart require an explicit compile step to
compile to JavaScript for running in the browser?" Well, yes, but we're talking
specifically about the native Dart VM here. And we <em>are</em> working to make
the Dart-to-JavaScript side of things as nice of a development experience as we
can. Iteration time matters.


## Compiling to source

Of course, Scala and F# show that a new language can be
developed for an existing VM, but it's possible to do that without bytecode: you
can compile to source. Right now, if you want a new language that runs in the
browser, compiling to JavaScript is your only option. <a
href="https://github.com/jashkenas/coffeescript/wiki">CoffeeScript</a>
is the most prominent example of this today, but there are many others.
Dart itself compiles to JavaScript to
let you use it on browsers that don't support Dart natively.

Likewise, if you want a new language that runs on Dart's native VM, you
  could compile that language to Dart. Doing so will then let your language
  take advantage of all of the optimizations that the VM does when it compiles
  from source to machine code. In other words, Dart <em>is</em> your (highly
  specialized) bytecode.
