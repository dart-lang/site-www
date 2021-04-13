---
title: "Dart apps and Cloud services"
short-title: Dart & Cloud services
description: Leveraging Cloud services (Firebase, GCP, etc.) for your Dart apps.
---

## Google API access

To access various Google Cloud APIs -- such as Google Docs API, YouTube Data
API, Cloud Translation API, and Cloud Storage API -- from a Dart client, you can
use [`package:googleapis`][]. This has client interfaces for more than 180
Google APIs.

## Firebase

For Flutter apps written in Dart, there is a large selection of Flutter plugins
supporting popular Firebase products such as Analytics, Cloud Firestore, Could
Functions, and Crashalytics. See [FlutterFire][] for more details.

For terminal apps, scripts, etc. written in Dart, the community-supported
[`package:firebase`][] might serve your needs.

## Google Cloud

[Google Cloud](https://cloud.google.com/) offers a rich selection of
[products](https://cloud.google.com/products), many of which can be leveraged
from your app built in Dart.

Many of these are based on pre-packaged [Dart Docker images][] maintained by the
Dart team.

### App Engine

Dart can be run on Google App Engine using it's _Custom Runtimes for the Flex
Environment_ support.

See the documentation in [`package:appengine`][] for more information.

### Compute Engine

Dart can be run on Compute Engine using it's support for running Containers
combined with Dart's Docker images.

See [Containers on Compute Engine][] for more information.

### Kubernetes Engine (GKE)

You can run Dart on clusters of Compute Engine instances using Google Kubernetes
Engine (GKE).

See [GKE overview][] for more information.

[Dart Docker images]: https://hub.docker.com/r/google/dart
[FlutterFire]: https://firebase.flutter.dev/
[`package:appengine`]: https://pub.dev/packages/appengine
[`package:firebase`]: https://pub.dev/packages/firebase
[`package:googleapis`]: https://pub.dev/packages/googleapis
[Containers on Compute Engine]: https://cloud.google.com/compute/docs/containers
[GKE overview]: https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview
