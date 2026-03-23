---
title: "Dart-on-LLVM"
description: "This is a story about an experiment to compile the Dart language using the LLVM compiler framework. On its face this is pretty pointless…"
publishDate: 2017-01-11
author: erikcorry
image: images/1DN03P0ofCSyHM6UwB42Nyg.png
category: other
tags:
  - programming
  - javascript
  - dart
  - dartlang
  - llvm
layout: blog
---


This is a story about an experiment to compile the [Dart](https://www.dartlang.org/) language using the [LLVM](http://llvm.org/) compiler framework. On its face this is pretty pointless, since

<DashImage src="images/1DN03P0ofCSyHM6UwB42Nyg.png" />


Dart already has an excellent [virtual machine](https://www.dartlang.org/dart-vm/tools/dart-vm) which uses [just-in-time](https://en.wikipedia.org/wiki/Just-in-time_compilation) compilation to get excellent performance. Since Dart is dynamically typed (more precisely, it’s [optionally typed](https://www.dartlang.org/articles/language/optional-types)), a JIT compiler is a natural fit — it can use the types available at runtime to perform optimizations that a static compiler can’t do.

Another reason Dart-on-LLVM looks like a fool’s errand is that, despite the name, LLVM is not a virtual machine, and until recently it was not suitable for languages with garbage collection. By suitable, we mean:

* Moving, precise (non-leaking) GC

* Highly optimized

This is because, once the optimizer had munged your code, you no longer had any way to find the GC-able pointers on the stack. A common strategy was to move all pointers to special memory areas, but this defeats many of the optimization strategies in a modern compiler, which relies on register allocation of local variables to work its magic. You could either have good GC or full performance, not both.

New winds are blowing in LLVM-land, though. Recently, LLVM has grown some GC support in the form of the experimental [*Statepoint*](http://llvm.org/docs/Statepoints.html) feature. This has been used by various brave groups, including the people behind the [LLV8](https://github.com/ispras/llv8/wiki) experiment and [Azul](http://llvm.org/devmtg/2015-10/slides/DasReames-LLVMForAManagedLanguage.pdf), who are using it for a new top-tier compiler for their JVM.

<DashImage src="images/1g6p0yM6fD_UD3rfsOWGQ-A.png" />


It appears that building a real VM based on LLVM has gone from being “mission impossible” to being merely “[mission difficult](https://www.youtube.com/watch?v=gJGJMi-sUS8)”. At the same time, [strong mode](https://github.com/dart-lang/dev_compiler/blob/master/STRONG_MODE.md) makes Dart more statically typed, and less dynamic. Also, we at Google are building [Flutter](https://www.youtube.com/watch?v=Mx-AllVZ1VY&t=0m29s) for iOS, where JIT compilation is banned. Both these developments align Dart better with the LLVM project’s goals and trade-offs.

## Why LLVM?

LLVM is a modern, well maintained Open Source compiler framework, which gives us a lot of optimization and platforms “for free”. For example, there’s a complete [inlining](http://llvm.org/docs/Passes.html#inline-function-integration-inlining) pass which can inline any function into any other, and contains [heuristics](https://bugs.chromium.org/p/v8/issues/detail?id=3354) for when to do so.

It also looks like an open, welcome community, which welcomes contributions.

## Goals of the experiment

* The context is Strong Mode Dart in an ahead-of-time compiled scenario

* Evaluate the feasibility of using Statepoint support for precise, moving GC

* Evaluate performance

## Methodology

We ([Erik Corry](https://twitter.com/erikcorry) and Dmitry Olshansky) based our experiment on the discontinued “[Dartino](https://github.com/dartino/sdk)” runtime. This was an experimental Dart runtime optimized for small devices. It had a few advantages for us over using the DartVM as a basis:

* There was already an experimental LLVM backend for Dartino, built by [Martin Kustermann](https://medium.com/@kustermann.martin). This had no GC support, so it crashed when it ran out of memory.

* Dartino makes use of a lot of the machinery of [Dart2JS](https://webdev.dartlang.org/tools/dart2js), and so it doesn’t need a complete parser, front end etc. The Dartino bytecodes we use as input already have a lot of difficult Dart features lowered away. For example, closures are objects, and optional arguments have been turned into different versions of functions.

* We were both already familiar with Dartino.

* Dartino comes with a relatively complete runtime and is capable of running large apps, eg hosting Dart2JS. It doesn’t have a lot of Unix IO support and the threading model is different, so it is not a drop-in replacement.

## Garbage Collection in Dartino

The existing Dartino LLVM experiment was forked from Dartino a while back, when the GC was very simple (semispace [Cheney collector](https://en.wikipedia.org/wiki/Cheney's_algorithm), no generations, big pauses, 2x memory footprint overhead). We cherry-picked changes from the main Dartino branch to get a more conventional 2-generation GC with write barriers. There are no read barriers, and collection is stop-the-world, without concurrent GC (though LLVM Statepoints do look to have support for these features, and they are almost certainly being used by Azul in their closed source VM).

We did not cherry pick the compacting old-generation support from newer Dartino versions.

<DashImage src="images/1VqmfjhoN9cMWH0vz37zU6A.jpeg" />


## Architecture

<DashImage src="images/1pyM5bJo-_-i8Leum4yHPOQ.png" />


The above pipeline shows the path from Dart source to machine code. In a real implementation, the first parts would be replaced by something based on the ‘[kernel](https://github.com/dart-lang/sdk/tree/master/pkg/kernel)’ format (preparsed Dart source frontend).

### Translation to LLVM and high level optimization

llvm-codegen is linked to our own copy of LLVM, and performs high level optimizations. At this stage, LLVM maintains the fiction that pointers are valid across GCs, but the pointers are marked with a non-default “address space” which prohibits LLVM from reasoning about their bit patterns in ways that would be incorrect in the presence of moving GC. Various custom LLVM intrinsics are used to mark points where GC can occur.

Because of tagged pointers, the LLVM bitcode is very ugly with lots of casts and adds. Therefore this document contains “LLVM pseudocode”, and not the true .ll file. If you are used to actual .ll files this is going to look like “Baby’s first .ll babblings”, sorry! The following represents the code for a dynamic dispatch after mem2reg, the pass that lifts local variables from the stack into [SSA](https://en.wikipedia.org/wiki/Static_single_assignment_form) registers:

```llvm
%class = load_class(%this)
%id = load_class_id(%class)
%offset = add 291, %id
%code = array_load(@dartino_vtable, %offset)
%method_result = call %code(%process, %16)
; We can still use “%this” here, even if there has been a GC in the call
```

After the optimizer has run, the rather laborious lookup above has been lifted out of the loop, leaving only the call instruction. This is possible because class pointers are immutable in Dart and we have attached various metadata to the load instructions (not shown), including `invariant.load`and `never.faults`(the latter is an addition to our [patched version of LLVM](https://github.com/ErikCorryGoogle/llvm)).

### Lowering

Once high level optimizations have been run, we lower most of the intrinsics to normal LLVM instructions. For example, the write barrier is reduced to a series of stores (Dartino uses a card marking scheme that owes a lot to [Urs](https://medium.com/@urs.hoelzle)’ [PhD](http://hoelzle.org/publications/urs-thesis.pdf) section 6.2.3). After lowering, every local-variable pointer is rewritten by an opaque intrinsic at every possible GC point (every call, basically). This inhibits a lot of optimizations (which is why we had to do optimization passes before lowering), but serves two purposes:

* The intrinsic will later be used to generate stack maps, detailing the location of GC-able pointers on the stack.

* The SSA values are broken up into before-GC and after-GC values, which makes the GC visible to the optimizer and prevents invalid codegen.

The call now looks more like this (the dispatch has been hoisted out of a loop, so `%code` contains the code pointer — the loop is not shown)

```llvm
%statepoint_token = call token (…) @llvm.experimental.gc.statepoint(326, 0, %code, 3, 0, %process, %this, %16)
%method_result = call @llvm.experimental.gc.result(token %statepoint_token)
%this.relocated = call coldcc @llvm.experimental.gc.relocate(token %statepoint_token, 10, 10) ; (%this, %this)
%16.relocated = call coldcc @llvm.experimental.gc.relocate(token %statepoint_token, 11, 11) ; (%16, %16)
; We now have to use %this.relocated instead of %this,
; and %16.relocated instead of %16
```

The transformation is rather clumsy, creating a special token in the transformed call, and using that as an argument in the calls to `gc.result` and `gc.relocate`. The GC-able pointers are still specially marked (with a non-zero address space, not shown in the pseudo-LLVM above), which inhibits some optimizations at the next stage.

### Code generation

The final step is code generation, performed by the LLVM program `llc`. This step can be done by a completely unpatched ToT LLVM with the command `llc -O3`. The only backend with support for the experimental GC intrinsics is currently x64, but we don’t see any fundamental barriers to adding and upstreaming ARM support. The dynamic dispatch call site now looks like:

```unix assembly
movq %rdx, (%rsp)
movq %rcx, 8(%rsp)
movq %rdx, 16(%rsp)
movq %rbx, %rdi
movq %rcx, %rsi
callq *%r14
```

This uses the standard (mostly register-based) calling convention for x64. Before every call, a bunch of registers are spilled to the stack, where they can be moved by the GC if needed. There is no support for callee-saved GC-able values (V8 and DartVM don’t support this either).

## Performance

Dartino byte code is optimized for simplicity and compactness in a very dynamically typed environment. For this analysis we attempt to look forward to a scenario where strong mode is used, and types are known when compiling. In this scenario, dispatch of methods and access to member variables on objects would be simpler and faster. In order to get closer to that scenario, we are making use of some whole program analyses when generating LLVM code.

The most important consequence of this is that if only a few classes have a method `foo()`, then we check for those classes and call the `foo()` method directly. Unlike some vtable-like dispatch mechanism, this lets LLVM inline the method where it makes sense. This is a huge win, especially for [getters and setters](https://www.dartlang.org/resources/dart-tips/dart-tips-ep-10), which are a great feature of Dart.

The compiler still has to handle a lot of dynamic-language issues, which it does mostly correctly (see test status section below). In particular, integers can overflow and become real heap allocated number objects at any time. Together with the overloading of operators this makes even simple for-loops rather complicated. More static analysis can probably improve this.

One difference to the real DartVM is that we don’t check for stack overflows and we don’t check for thread interruptions on loop back edges. Based on experience from V8 we guesstimate that fixing this could cost about 10% performance.

<DashImage src="images/1_B_KUgeFwaeUxC97GBIHPw.png" />


We compare against the regular JITing DartVM, and the new ahead-of-time support that has been added to the DartVM for [Flutter](https://flutter.io/). Benchmarks are [from Dartino](https://github.com/dartino/sdk/tree/master/benchmarks).

<DashImage src="images/1uB5TngqsrAvvzu_fr8KCdg.png" />


Running a short lived program like Hello World shows mainly the time to do startup. The JIT-based system spends time compiling code, and both the non-LLVM solutions here are deserializing a data heap on startup.

## Performance Conclusions

We have comparable performance to Flutter’s existing ahead-of-time technology (which is a moving target — these measurements were made in late November 2016 on a beefy 64 bit Linux workstation). The JIT is still a long way ahead. The garbage collection performance of the Dartino fork we are running on, is not up to speed.
We also measured startup time. Dartino-LLVM generates static data for the classes, constants, and dispatch tables. These are loaded by the highly optimized [ld.linux](https://www.cs.virginia.edu/~dww4s/articles/ld_linux.html) runtime linker, and they load faster than the current Dart AOT data heap snapshot, giving very good performance for startup. For the startup tests the CPU governor was set to “performance”.

## A note on compatibility

For this study we have not been especially focused on getting 100% Dart compatibility. It is sufficient to do the “hard things” i.e. GC and exception handling, to prove they are possible. In some cases we took a shortcut that showed a real solution was possible without wasting time on actually implementing the real solution. Here are some places we compromised:

* Like Dartino we don’t have infinite-precision integers. However, we do check all int operations for overflow and switch dynamically to a boxed number representation (however, the boxed representation is only 64 bit, wrapping).

* On no-such-method (a failed type check, essentially), we don’t follow the full Dart semantics, which includes calling the no-such-method method and checking for a getter, that has the same name as the missing method and returns an object with a ‘call’ method. However, we do throw an exception at a safe point (a point where allocation can take place).

* We don’t check for stack overflow on calls, or check for interruptions on loop back edges. LLVM does have experimental support for these. The solutions we are comparing against do support this. Experience from V8 suggests that fixing this might cause about 10% performance degradation.

* Our front-end compiler is a modified Dart2JS. Since Dartino was discontinued, it has not kept up with the latest changes to the language, and so there are some tests we cannot run.

* Dart exception handling is fully implemented apart from the no-such-method related exceptions. For this we used the exception handling support built into LLVM, which looks adequate for the task and well aligned to Dart’s exception model (which is at heart not so different from C++, for which LLVM was designed).

<DashImage src="images/14bthU0tgek2j09dJuKn-aQ.png" />


In all, we pass almost 90% of the tests that Dartino could pass. Of the ones we fail, the biggest reasons are problems with the compiler front-end and problems handling no-such-method events.

Of the ca 11.6% tests that fail, here is a breakdown of why they fail:

<DashImage src="images/1f_vtnoVYGfdXXqPUaGrOGw.png" />


## Conclusions

The experimental LLVM GC support appears to be fully functional on x64.
Performance of the prototype was on a par with our more mature DartVM-based ahead-of-time solution.

For the performance analysis we are making no use of Dart strong mode, which can be expected to yield optimization opportunities that play to LLVM’s strengths. We are, however, making use of some closed world assumptions, which we think are realistic.

We are able to compile the last stage from LLVM bitcode to machine code using only an unpatched LLVM ToT build (marked in blue on the pipeline diagram above). The optimizations performed at this stage (-O3) did not cause any miscompilations or GC issues that we observed.

## Future

There has been no decision on how and whether to use this approach for Dart or Flutter, but here are some random thoughts on interesting avenues that could be explored.

* Having a home-grown language other than C++-with-handles to write runtime routines. The back-end would be LLVM-with-Statepoints. (There is a little Forth experiment in the current branch, but something more beefy would be needed to write more than the very simplest native routines in).

* What impact would wrapping 64 bit integers have?

* How can we use whole-program knowledge to generate code while still allowing parallel compilation of large projects?

## References

LLVM GC support [http://llvm.org/docs/Statepoints.html](http://llvm.org/docs/Statepoints.html)
Dartino-LLVM repository [https://github.com/dartino/sdk/tree/llvm](https://github.com/dartino/sdk/tree/llvm)
Modified LLVM repo [https://github.com/ErikCorryGoogle/llvm](https://github.com/ErikCorryGoogle/llvm)
Urs Hölzle PhD: [http://hoelzle.org/publications/urs-thesis.pdf](http://hoelzle.org/publications/urs-thesis.pdf)
LLV8: [https://github.com/ispras/llv8](https://github.com/ispras/llv8)