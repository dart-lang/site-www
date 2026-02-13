---
title: "Making a Dart web app offline-capable: 3 lines of code"
description: "Have you ever tried to load a web application (maybe a game or a measurement converter) and couldn’t use it because the network was down…"
publishDate: 2017-03-28
author: "isoos"
image: images/1GsjtYvVghuA63qhhRdyfPQ.png
category: other
tags:
  - dart
  - service-worker
  - dartlang
  - progressive-web-app
  - offline
---


Have you ever tried to load a web application (maybe a game or a measurement converter) and couldn’t use it because the network was down? That’s an awful experience, but luckily we have the technology to make such apps available for our users.

For most apps and games, this can be done with 3 lines of Dart code and 1 command in the terminal. In this short article I’ll guide you through the steps, and make sure that you can always play [Pop, Pop, Win!](https://isoos.github.io/offline_pop_pop_win/)

<DashImage src="images/1GsjtYvVghuA63qhhRdyfPQ.png" alt="[Pop, Pop, Win!](https://dart-lang.github.io/sample-pop_pop_win/) — a [Minesweeper implementation](https://github.com/dart-lang/sample-pop_pop_win) in Dart" caption="[Pop, Pop, Win!](https://dart-lang.github.io/sample-pop_pop_win/) — a [Minesweeper implementation](https://github.com/dart-lang/sample-pop_pop_win) in Dart" />


## Service workers

A service worker is a JavaScript file that runs in the background. It can control the web page or the site it is associated with, intercepting and modifying navigation and resource requests, and caching resources in a very granular fashion.

It is a non-intrusive web technology: service workers can improve the user experience if the browser [supports them](http://caniuse.com/#feat=serviceworkers), but the site can operate just fine in their absence (with the default web behavior). This is a useful property that enables **progressive web applications (PWA)**, where you can provide more advanced features to the majority of the users, while making sure that the rest aren’t locked out.

As a background processing thread, a service worker can help with:

* offline mode (fetching resources from cache while the network is down)

* caching strategies (for near-instant cached responses that can be updated later with fresh content)

* push notifications (like in a mobile app)

* messaging (if the application is open on multiple tabs)

The important feature for our offline gaming experience is this: we would like to play Pop, Pop, Win!, and not meet this dinosaur:

<DashImage src="images/1cufcmiyxW8k4ku1-Y_zsvg.png" alt="Fun fact: you can play with that dinosaur by pushing the up arrow key." caption="Fun fact: you can play with that dinosaur by pushing the up arrow key." />


## Progressive web app with Dart

Supporting offline mode requires roughly the following:

1. Determining which resources to put in the cache for offline use.

1. Creating a service worker that prepares a cache of these resources.

1. Registering the service worker, so that subsequent requests can be served from the offline cache (in case the network is down).

1. In that service worker, pre-populating the offline cache with the URLs, and also handling the appropriate fetch request either from the cache, or from the network.

1. Making sure that the service worker detects changes to the app or static assets, and puts the new version in the cache.

While the above list may sound a bit scary, we have a [pwa](https://pub.dartlang.org/packages/pwa) package in Dart that does most of the work for us, providing a high-level API and automating most of the work.

### Changes in your application

Import the `pwa` package in your `pubspec.yaml`:

```
dependencies:
  pwa: ^0.1.2
```


After running `pub get`, add the client to your `web/main.dart`:

```
import ‘package:pwa/client.dart’ as pwa;

main() {
  // register PWA ServiceWorker for offline caching.
  new pwa.Client();

}
```


The above code handles item 3 from the above list by registering the service worker (which we will create in the following step). Right now we don’t use the Client instance for anything else, but as the `pwa` package gets new features, it may become useful for other purposes.

### Automatically generated progressive web application

The `pwa` package provides code generation that handles items 1–2 and 4–5 from the above list. To ensure proper cache use (both populating and invalidating the cache) use the following workflow:

1. Build your web app with all of the static resources landing in `build/web`:
`pub build`

1. Run `pwa`’s code generator to scan (or rescan) your offline assets:
`pub run pwa`

1. Build your project again, because you need to have your (new) `pwa.dart` file compiled:
`pub build`

These steps produce a file named `lib/pwa/offline_urls.g.dart` that contains a list of the offline URLs to be cached. The `.g.dart` extension indicates that the file is generated and may be overwritten automatically by `pwa`’s code generator tool.

On the first run, this workflow generates the `web/pwa.dart` file that contains your service worker with reasonable defaults. You can modify this file (to customize the offline URLs or use the high-level APIs, for example) because the code generator won’t change or override it again.

## Caveats

While Dartium is great for most web development, at the moment it’s hard to use with service workers. We recommend using Chrome or Firefox instead.

Cache invalidation is one of the hardest problems in computer science. The underlying [Web Cache API](https://developer.mozilla.org/en-US/docs/Web/API/Cache) provides some guarantees, and the `pwa` library goes to a great length to gracefully handle the edge cases, but don’t treat the cache as reliable storage for anything really important. Make use of the cache when it is available, and fail gracefully when it’s not.

## Try it out

You can now deploy the new version of your application. Or try the [offline Pop, Pop, Win! game](https://isoos.github.io/offline_pop_pop_win/).

After opening the game and playing one round, shut down your wi-fi or unplug the network cable, and then reload (or retype the URL). If you’re using Chrome or Firefox, your game should be up and running. Good luck, have fun!