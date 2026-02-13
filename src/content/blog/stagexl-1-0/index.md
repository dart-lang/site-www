---
title: "StageXL 1.0"
description: "A fast 2D rendering engine for HTML5 and Dart."
publishDate: 2016-12-03
author: "bp74"
image: images/1oPIKFEq7-9ndX53muruOsQ.jpeg
category: other
tags:
  - flash
  - dartlang
  - webgl
  - html5
  - javascript
---


<DashImage src="images/1oPIKFEq7-9ndX53muruOsQ.jpeg" />


After more than 4 years in development and available since the early beta versions of Dart, we are proud to announce the release of StageXL 1.0. [StageXL](http://www.stagexl.org/) is a fast and universal 2D render engine for games and applications on the web. This article talks about the most important features and applications of this library.

## Standing on the shoulders of giants: Adobe Flash

Several years ago it became apparent that Adobe Flash will be replaced by the capabilities of HTML5. Video streaming platforms replaced their Flash players with HTML5 players and Google’s AdWords network banned all Flash based display ads recently. The last big resort of Flash applications on the web are games. Even today most games on facebook are built with Flash.

Game developers had no other choice than using Flash for games in the past. The capabilities of the DOM were not suitable for games and even after the introduction of the canvas element you had to deal with performance issues, compatibility issues and last but not least JavaScript (a language born out of hell if you ask certain Flash/ActionScript developers). Things became better with the introduction of libraries like [CreateJS](http://www.createjs.com/) or [PixiJS](http://www.pixijs.com/) which provide a Flash like API and developer experience. Also the raise of languages like [TypeScript](https://www.typescriptlang.org/), [Haxe](https://haxe.org/) or [CoffeeScript](http://coffeescript.org/) reduced the pain.

As a former Flash/ActionScript game developer myself, I experienced all the things mentioned above first-hand. But once i got in touch with the early versions of Dart it was clear that it was a worthy successor to ActionScript. Dart looks and feels very similar to ActionScript and at the same time it is a much more modern language that avoids bloated syntax. But Flash is much more than the language. Flash provides a display tree based render engine, a sound engine, vector graphics, text rendering and much more. This was the foundation for StageXL — this new library should provider the features of Flash in combination with Dart and HTML5. Developers should be able to use Dart and StageXL to write their games in the same way as they did with Flash before. To make it even easier the API of StageXL is mostly identical to the one of Flash.

Flash developers should be familiar with StageXL code like this:

```
**Sprite** createContainer(**BitmapData** bitmapData) {
  var bitmap = new **Bitmap**(bitmapData);
  var sprite = new **Sprite**();
  bitmap.**x** = -bitmapData.**width** / 2;
  bitmap.**y** = -bitmapData.**height** / 2;
  sprite.**addChild**(bitmap);
  sprite.**alpha** = 0.5;
  return sprite;
}
```


[**StageXL - ActionScript to Dart comparison**
*Coming from ActionScript and learning Dart is easy. Both languages are class-based, single inheritance, object-oriented…*www.stagexl.org](http://www.stagexl.org/docs/actionscript-dart.html)

## StageXL in a nutshell

The API of StageXL covers a wide range of features. The main purpose of the library is a fast and easy to use render engine, but you need more than that to write a game or application.

**Graphics:** A display tree is built out of nodes that extend the abstract DisplayObject base class. The position of a node on the tree defines if the display object is in front or back of another object. To create branches on the tree, a second abstract base class called DisplayObjectContainer is used. You can build custom display objects by extending one of those two base classes, or you can use one of the built in classes like Sprite, Bitmap, TextField or Shape. All these classes are the [same as in Flash](http://help.adobe.com/en_US/as3/dev/WS5b3ccc516d4fbf351e63e3d118a9b90204-7e26.html) and similar concepts are used in other render engines too.

**Interaction:** The EventDispatcher class provides the capabilities to dispatch events and to subscribe listeners to certain events. All display objects extend the EventDispatcher class and therefore they are capable of dispatching events. Those events can be custom events dispatched by your game logic, or events for mouse, touch and keyboard interaction dispatched by the StageXL runtime. Since all display objects live within the display tree, an event is propagated over all nodes from the root node to the target node and back again (capturing, target and bubbling phase of an event).

**Audio:** Every game needs proper sound effects. StageXL provides the infrastructure to load and play audio samples without much hassle. The Sound class represents an audio sample that was loaded into memory. Calling the play method on the Sound class will start playing the audio sample and it will return an instance of the SoundChannel class to get control over the playback. You can play multiple instances of the same Sound concurrently, for example play multiple instances of an explosion sound.

**Resources:** StageXL makes it easy to load images, audio files and other resources from the server. Since loading such files is an asynchronous operation, a Future based API is provided. Loading an image is as easy as waiting for the completion of the Future returned by the BitmapData.load method. The same is true for the Future returned by the Sound.load or TextureAtlas.load methods. To make it even more convenient to load many different resources at once, the ResourceManager class can be used. This class loads all specified resources and provides easy access to those resources once the loading process has finished. The ResourceManager can be seen as the replacement for embedded resources in Flash.

**Animation:** StageXL also contains a framework for animations called Juggler. The Juggler framework was introduced by the [Starling](http://gamua.com/starling/) render engine well known among Flash developers. The Juggler is used to control so called Animatables based on the time that has passed between two render frames. One of those Animatables is the Tween class, which is used to animate the position, the rotation, the scaling or the translucency of any display object. The Juggler also provides time based Streams to control values in your game logic. More details can be found in the [Juggler documentation](http://www.stagexl.org/docs/wiki-articles.html?article=juggler).

## StageXL behind the scenes

The render engine of StageXL is built on top of WebGL for best performance and flexibility. Of course the developer does not need to know anything about WebGL to use StageXL. Still, it is worth noting that display objects are rendered by WebGL shader programs either by using a default shader or a more advanced shader for filter effects like BlurFilter, DropShadowFilter, ColorMatrixFilter and others. In more advanced use cases developers can use custom filters by implementing their own WebGL shader program code.

To achieve the best rendering performance possible it is essential to use so called texture atlases. All your image assets are combined in one big image that is uploaded to the memory of the GPU. Therefor StageXL supports the most common texture atlas formats out of the box. Use your favorite texture atlas generator (we highly recommend [TexturePacker](https://www.codeandweb.com/texturepacker)) to generate the texture atlas, the rest is handled by StageXL internally. As a special goodie StageXL supports advanced texture atlas features such as [polygon sprite meshes](https://www.codeandweb.com/texturepacker/tutorials/cocos2d-x-performance-optimization) and the polygon packing algorithm.

The sound engine of StageXL is build on top of the WebAudio API. Similar to WebGL the developer does not to need to know anything about this API. To play audio samples you just need to use the Sound and SoundChannel classes which do all the heavy lifting for you. A common pain with playing audio on different browsers is the missing support for certain audio codecs. You probably encode you audio samples as mp3 files, but it is not guaranteed that mp3 is supported on all platforms. The same is true if you encode your audio samples with any other file format. StageXL solves this problem by automatically loading the correct audio format based on the capabilities of the browser.

Other 2D render engines for JavaScript often claim to be the fastest and most flexible ones. Of course this claim depends heavily on the benchmark or the use case and is very difficult to verify. During the design and development of StageXL we constantly compared its performance and flexibility to other engines. In the end both quality factors do match or even surpass other engines which claim to be the best. One of the big advantages for StageXL in this regard is the use of the Dart programming language. The language not only allows a very clean API design, but also provides an outstanding compiler to JavaScript that optimizes certain patterns in a way you practically can’t implement by hand in JavaScript. The compiled JavaScript does not need to look pretty, it only needs to run fast. The compiler does function inlining, dead code elimination, constant folding, type inference and other optimizations. The compiler is also aware of how the JavaScript needs to look like to make it run fast in modern JavaScript engines. This is very different to other languages like TypeScript where the code is not compiled to JavaScript but only transpiled to JavaScript. Last but not least, you won’t need to change a single line of code to compile to native ES5 and ES6 JavaScript.

[**StageXL BunnyMark**
*Render as many bunnies as possible!*www.stagexl.org](http://www.stagexl.org/example/benchmark/bunny_mark/?v=2)

## StageXL to be continued

It took over 4 years to get to version 1.0 of StageXL. The reason for such a long time is that there is always something to improve or to add and you never think that the project is finished. This is also true for version 1.0 and new features will be added on a regular basis in the future. The feedback from the community is very valuable and feature requests are always welcome — bug reports too, to a certain degree ;)

Probably the biggest feature we see on the horizon is support for [Flutter](https://flutter.io/). You would be able to write mobile games in Dart and StageXL for Android and iOS. The early versions of Flutter look very promising, unfortunately the platform does not yet expose the OpenGL APIs you need to build StageXL on top of it. We will keep an eye on the development and hope that it won’t take too long to see StageXL on mobile devices.

[**Flutter: The best mobile development experience?**
*Developing for mobile just got a lot more fun with Flutter's live developer workflow. At the heart of this new workflow…*news.dartlang.org](http://news.dartlang.org/2016/11/flutter-best-mobile-development.html)

## Extension libraries

The StageXL library provides everything you need to render graphics, play audio, load resource files, do animations and much more. But there are other features you may need for your game or application. Therefore StageXL can be extended with more specialized features which are available in extra packages. The following extensions are available on GitHub as well as on [Pub](https://pub.dartlang.org/).

**[StageXL_Spine](https://github.com/bp74/StageXL_Spine):** [Spine](http://esotericsoftware.com/) is dedicated to 2D skeletal animation, providing an efficient workflow both for creating amazing animation and for integrating it into your games. Spine provides numerous tools to shape and refine your 2D animations. Bend and deform images with mesh skinning/weights, adjust timing with the dopesheet, visualize motion with ghosting, pose your characters with inverse kinematics, create pseudo 3D effects, and much more. ([demo](http://www.stagexl.org/show/spine/raptor/example.html))

**[StageXL_DragonBones](https://github.com/bp74/StageXL_DragonBones):** [DragonBones](http://dragonbones.com/) is an open source 2D skeleton animation solution very popular among Flash and Starling developers. The editor is available for Mac and Windows and does not require Adobe Flash. DragonBones may not be as feature rich as Spine, but provides enough functionality for most use cases. ([demo](http://www.stagexl.org/show/dragonbones/dragon_new/example.html))

**[StageXL_GAF](https://github.com/bp74/StageXL_GAF):** [GAF](http://www.gafmedia.com/) stands for Generic Animation Format. GAF is designed to store Flash animations in an open cross-platform format for further playback. GAF enables artists and animators to use Adobe Flash for creating complex animations and seamlessly use those animations in StageXL. ([demo](http://www.stagexl.org/show/gaf/skeleton/example.html))

**[StageXL_BitmapFont](https://github.com/bp74/StageXL_BitmapFont):** [Bitmap fonts](http://kvazars.com/littera/) are created with specialized tools or even designed in PhotoShop to render fancy looking texts. The glyphs are stored on a texture to render texts very efficiently at runtime. The StageXL bitmap font library also supports features like [distance fields](http://www.stagexl.org/show/bitmapfont/distance_field/example.html) for sharp edges when scaling or rotating the text. ([demo](http://www.stagexl.org/show/bitmapfont/texture_atlas/example.html))

<DashImage src="images/1mImI5oveZ9ohWbaxmFXarg.jpeg" alt="Spine animations rendered with StageXL ([demo](http://www.stagexl.org/show/spine/texture-atlas/example.html))" caption="Spine animations rendered with StageXL ([demo](http://www.stagexl.org/show/spine/texture-atlas/example.html))" />


## **Links**

**StageXL:**
[StageXL on Github](https://github.com/bp74/StageXL)
[StageXL examples on Github](https://github.com/bp74/StageXL_Samples)
[StageXL API Reference](http://www.stagexl.org/docs/api/stagexl/stagexl-library.html)
[StageXL Forum](https://groups.google.com/forum/#!forum/stagexl)

**Runtimes:**
[StageXL Spine runtime](https://github.com/bp74/StageXL_Spine)
[StageXL DragonBones runtime
StageXL GAF runtime](https://github.com/bp74/StageXL_GAF)
[StageXL Bitmap Fonts](https://github.com/bp74/StageXL_BitmapFont)

**Games:**
[Memory](http://www.stagexl.org/example/game/memory) ([source](http://www.stagexl.org/example/game/memory/))
[Escape (ported from Flash)](http://www.stagexl.org/example/game/escape) ([source](https://github.com/bp74/StageXL_Samples/tree/master/example/game/escape))
[Supersonic (ported from Flash)](http://www.stagexl.org/example/game/supersonic) ([source](https://github.com/bp74/StageXL_Samples/tree/master/example/game/supersonic))

**Benchmarks:**
[Bunny Mark](http://www.stagexl.org/example/benchmark/bunny_mark)
[Starling](http://www.stagexl.org/example/benchmark/starling/)

**Community projects:**
[Flash/ActionScript to StageXL/Dart converter](https://github.com/blockforest/stagexl-converter-pubglobal)
[Rockdot framework (UI and more)](https://github.com/blockforest/rockdot-framework)