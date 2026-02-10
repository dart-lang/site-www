---
title: "Experimenting with Dart and Wasm"
description: "Compiling Dart to Wasm, and calling Wasm modules from Dart"
publishDate: 2021-07-27
author: mit-mit
image: images/1UqHnD9vyTvndgJpz8gOv7Q.png
category: other
tags:
  - dart
  - wasm
  - computer-science
  - interoperability
  - webassembly
layout: blog
---


*By Liam Appelbe & Michael Thomsen*

[WebAssembly](https://webassembly.org/) (commonly abbreviated to Wasm) is *“a binary instruction format for a stack-based virtual machine”.* Although Wasm was originally designed for running native code on the web, Wasm has since evolved into a general technology for running compiled code across multiple platforms. Dart is already a highly portable and multi-platform language, so we’re very interested in how Wasm might enable us to extend these qualities of Dart.

## Why experiment with Wasm?

Wasm has gained [broad support](https://webassembly.org/roadmap/) by browser vendors, such as Chrome, Edge, Firefox, and WebKit. This makes Wasm a very interesting prospect for running binary code in the browser. However, originally Wasm wasn’t designed for programming languages with garbage collection (GC), such as Dart and Java/Kotlin, making it difficult to efficiently compile GC-based languages to Wasm. By engaging with the Wasm project on their recent [GC proposal](https://github.com/WebAssembly/gc/blob/master/README.md), we’re hoping to both provide technical feedback on the proposal, and learn more about what gains we might get from running Dart-based web apps via Wasm code.

A second quality of Wasm is that the binary Wasm modules are platform independent. This potentially makes interoperability with existing code more practical: If that existing code could be compiled to Wasm, then Dart apps across all platforms could depend on a single, shared binary Wasm module.

In the remainder of this post we’ll discuss our experiments with Wasm and Dart in two forms:

1) **Dart to Wasm compilation**: Extending our AOT compilers with support for compiling Dart source code to Wasm binary code (issue [32894](https://github.com/dart-lang/sdk/issues/32894)).

2) **Dart to Wasm interop**: Support for calling from Dart code to compiled Wasm modules (issues [37355](https://github.com/dart-lang/sdk/issues/37355) & [37882](https://github.com/dart-lang/sdk/issues/37882)).

<DashImage src="images/1UqHnD9vyTvndgJpz8gOv7Q.png" alt="Illustration of the two potential uses of Wasm with Dart" caption="Illustration of the two potential uses of Wasm with Dart" />


## Compiling Dart to Wasm

As mentioned, Wasm originated as a way of running native code on the web. The web is traditionally powered by JavaScript code, which is run in a virtual machine (VM) that performs just-in-time (JIT) compilation of the JavaScript code to native code while the web app is running. In current Dart frameworks that target the web, such as [Flutter web](https://flutter.dev/web), the Dart app code is compiled to [optimized](https://dart.dev/web/deployment) JavaScript for deployment, and this JavaScript is then JIT-compiled by the web platform to native code when the app is running.

We’re investigating compilation of Dart code directly to Wasm native code to see if we can get a more direct path to running native code on the web. The Wasm assembly format is low-level and closer than JavaScript to the abstraction level of machine code, which leads to improved startup time and generally a more predictable efficiency.

Dart’s support for compiling to Wasm is an early stage investigation and the compiler is incomplete, but we’re experimenting to learn. We’ve always had an interest in Wasm as a compilation target for Dart, but its original form doesn’t work well for languages with garbage collection. Wasm lacks built-in garbage collection support, so languages like Dart must include a garbage collection implementation into the compiled Wasm module. Including a GC implementation would be highly complex, would inflate the size of the compiled Wasm code and hurt startup time, and wouldn’t lend itself well to object-level interop with the rest of the browser system.

Fortunately, an ongoing effort in the WebAssembly community, known as [Wasm GC](https://github.com/WebAssembly/gc/blob/master/README.md), is exploring the possibility of expanding Wasm with direct and performant support for garbage collected languages. Given our longstanding interest in Wasm, we saw an opportunity to engage the community and provide real-world experience by writing a compiler that translates Dart to Wasm GC.

It’s too early to predict where this might take us, but our initial prototyping is showing very positive results, with initial benchmarks showing both faster time to first frame and faster average frame time / throughput. If you’re interested in learning more about the project, take a look at the [wasm_prototype](https://github.com/askeksa-google/sdk/blob/wasm_prototype/dart2wasm.md) source code.

## Interoperability with Wasm code (package:wasm)

Besides compiling to Wasm, we’re also interested in investigating if Wasm can be used for integrating with existing code in a way that is more cross platform. Several languages support compiling to modules that follow the C calling convention, and with [Dart FFI](https://dart.dev/guides/libraries/c-interop) you have interoperability with these modules. Dart FFI can be a great way of leveraging existing source code and libraries, rather than having to reimplement the code in Dart.

However, because C modules are platform specific, distributing shared packages with native C modules is complicated: it requires either a universal build system, or distributing multiple binary modules (one for each desired platform). Distribution would be much easier if a single Wasm binary assembly format could be used across all platforms. Then, rather than compiling your library to platform-specific binary code for every target platform, you could compile it once to a Wasm binary module and run that everywhere. This would potentially open the door to easy distribution on [pub.dev](https://pub.dev) of packages that contain native code.

We’re experimenting with support for Wasm interop in a new package, [`package:wasm`](https://pub.dev/packages/wasm). This prototype is built on the [Wasmer](https://wasmer.io/) runtime, and it supports [WASI](https://wasi.dev/) for OS interaction. Note that our current prototype is incomplete and supports only desktop platforms (Windows, Linux, and macOS).

## Example: Calling into the Brotli compression library

Let’s take a look at an example of using `package:wasm` to leverage the [Brotli compression library](https://github.com/google/brotli), compiled to a Wasm module. In the example, we’ll read an input file, compress it, report its compression ratio, and then decompress it and verify we get the input back. See the GitHub repo for the full [sample source code](https://github.com/dart-lang/wasm/tree/main/example). Because `package:wasm` is built on top of [`dart:ffi`](https://dart.dev/guides/libraries/c-interop), you may find the steps familiar if you have experience with FFI.

There are a few ways of compiling C code to Wasm, but in this case we used [wasienv](https://github.com/wasienv/wasienv). Full details are available in the [README](https://github.com/dart-lang/wasm/blob/main/README.md).

For this example, we’ll try to call these Brotli functions for compressing and decompressing data:

```
int BrotliEncoderCompress(
  int quality, int lgwin, int mode, size_t input_size,
  const uint8_t* input_buffer, size_t* output_size,
  uint8_t* output_buffer);

int BrotliDecoderDecompress(
  size_t encoded_size, const uint8_t* encoded_buffer,
  size_t* output_size, uint8_t* output_buffer);
```


The `quality`, `lgwin`, and `mode` arguments are tuning parameters for the encoder. The details aren’t relevant to the example, so we’ll just use default values for these. Another thing to note is that `output_size` is an in-out parameter. When we call these functions, `output_size` must be initialized with the size of the `output_buffer` that we have allocated, and afterwards it will be set to the amount of the buffer that was actually used.

The first step is to use our compiled Wasm binary to construct a `WasmModule` object. The binary data should be a `Uint8List`, which we can get by reading it from a file using `file.readAsBytesSync()`.

```
var brotliPath = Platform.script.resolve(‘libbrotli.wasm’);
var moduleData = File(brotliPath.path).readAsBytesSync();
var module = WasmModule(moduleData);
```


A very useful debugging tool for making sure our Wasm module has the API we expect is `module.describe()`. This returns a string listing all of the module’s imports and exports.

```
print(module.describe());
```


For our Brotli library, this is the output:

```
import function: int32 wasi_unstable::fd_close(int32)
import function: int32 wasi_unstable::fd_write(int32, int32, int32, int32)
import function: int32 wasi_unstable::fd_fdstat_get(int32, int32)
import function: int32 wasi_unstable::fd_seek(int32, int64, int32, int32)
import function: void wasi_unstable::proc_exit(int32)

export memory: memory
export function: int32 BrotliDecoderSetParameter(int32, int32, int32)
export function: int32 BrotliDecoderCreateInstance(int32, int32, int32)
export function: void BrotliDecoderDestroyInstance(int32)
export function: int32 BrotliDecoderDecompress(int32, int32, int32, int32)
…
export function: int32 BrotliEncoderSetParameter(int32, int32, int32)
export function: int32 BrotliEncoderCreateInstance(int32, int32, int32)
export function: void BrotliEncoderDestroyInstance(int32)
export function: int32 BrotliEncoderMaxCompressedSize(int32)
export function: int32 BrotliEncoderCompress(int32, int32, int32, int32, int32, int32, int32)

…
```


We can see that the module imports some WASI functions, and exports its memory and a bunch of Brotli functions. The two functions we’re interested in are exported, but their signature looks a bit different. This is because Wasm only supports 32-bit and 64-bit ints and floats. The pointers have become `int32` indexes into the exported memory.

The next step is to instantiate the module. During instantiation we must fill every import that the module is expecting. Instantiation uses the builder pattern `(module.instantiate(). initialization… .build())`. Our library only imports WASI functions, so we can just call `enableWasi()`:

```
var instance = module.instantiate().enableWasi().build();
```


If we had additional non-WASI function imports we could use `addFunction()` to import a Dart function into the wasm library.

Now that we have a `WasmInstance`, we can look up any of its exported functions, or inspect its memory:

```
var memory = instance.memory;
var compress = instance.lookupFunction(“BrotliEncoderCompress”);
var decompress = instance.lookupFunction(“BrotliDecoderDecompress”);
```


The next thing we want to do is use the compress and decompress functions on our input file. But we can’t pass the data directly to these functions. The C functions take `uint8_t` pointers to the data, but in Wasm code these pointers become `int32` indexes into the instance’s memory. Brotli also reports the size of the compressed and decompressed data using `size_t` pointers, which also become `int32`s.

So to pass our data to the functions we have to copy it into the instance’s memory and pass its index to the function. We need 5 regions of memory: the input data, the compressed data, the compressed size, the decompressed data, and the decompressed size. For simplicity we’re just going to grab some unused areas of memory, but you could also export `malloc()` and `free()` in your library.

To make sure we’re putting the data in unused memory, we’re going to grow the instance memory and use the new region for our data:

```
var inputPtr = memory.lengthInBytes;
memory.grow((3 * inputData.length /
    WasmMemory.kPageSizeInBytes).ceil());
var memoryView = memory.view;
var outputPtr = inputPtr + inputData.length;
var outSizePtr = outputPtr + inputData.length;
var decodedPtr = outSizePtr + 4;
var decSizePtr = decodedPtr + inputData.length;
```


Our memory regions look like this:

```
[initial instance memory][input][output][output size][decoded][decoded size]
```


Next, we load the input data in the memory, and call our compression function:

```
memoryView.setRange(
    inputPtr, inputPtr + inputData.length, inputData);

var status = compress(kDefaultQuality, kDefaultWindow, kDefaultMode,
    inputData.length, inputPtr, outSizePtr, outputPtr);
```


The rest of the example works similarly. This is the result:

```
Loading lipsum.txt
Input size: 3210 bytes

Compressing…
Compression status: 1
Compressed size: 1198 bytes
Space saving: 62.68%

Decompressing…
Decompression status: 1
Decompressed size: 3210 bytes

Verifying decompression…
Decompression succeeded :)
```


## Trying package:wasm

If you’re interested in trying Wasm interop, check out the `package:wasm` [README](https://pub.dev/packages/wasm) for instructions.

## Roadmap

Both Wasm compilation and Wasm interop are experiments. If those experiments prove fruitful, we plan to continue to develop them and eventually productize them into stable, supported versions. However, if we learn that something doesn’t work as intended, or see a lack of interest, we’ll discontinue the experiments.

We’re making these experiments to learn, with two main components. First, we want to learn about the feasibility of technically supporting Wasm, and what the characteristics of this support might be. Can it make Dart code faster, smaller, or more predictable? Second, we’re interested in exploring what new technical capabilities Wasm might unlock, and what new use cases these might enable for Dart developers. Can we make interop with native code more portable?

How do you think Wasm might apply to your needs? What do you think you’d use it for? We’d love to hear your thoughts. Please let us know on the [Dart misc discussion group](https://groups.google.com/a/dartlang.org/g/misc/).