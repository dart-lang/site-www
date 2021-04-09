---
title: "Developing apps with Dart and Cloud-based services"
short-title: Dart & Cloud services
description: Leveraging Cloud services (Firebase, GCP, etc.) for your Dart apps.
---

# Firebase

For Flutter apps written in Dart, there is a large selection of Flutter plugins supporting popular Firebase products such as Analytics, Cloud Firestore, Could Functions, and Crashalytics. See [FlutterFire][] for more details.

For terminal apps, scripts, etc. written in Dart, the community-supported [`package:firebase`][] might serve your needs.

# Google Cloud

[Google Cloud](https://cloud.google.com/) offers a rich selection of [products](https://cloud.google.com/products), many of which can be leveraged from your app built in Dart.

Many of these are based on pre-packaged [Dart Docker images][] maintained by the Dart team.

### Compute Engine

Dart can be run on Compute Engine using Dart Docker images.
See [Running on Google Compute Engine][] for more information.

### Kubernetes Engine (GKE)

Dart can be run on Compute Engine using Dart Docker images.
See[Running on Google Container Engine][] for more information.

### Cloud Run

### App Engine

See Dart on App Engine Custom Runtimes for the Flex Environment to learn how to run your Dart application on Google App Engine using the flexible environment.


Google Container Engine : 

[Dart Docker images]: https://hub.docker.com/r/google/dart
[FlutterFire]: https://firebase.flutter.dev/
[`package:firebase`]: https://pub.dev/packages/firebase
[Running on Google Compute Engine]: https://github.com/dart-lang/dart_docker/tree/master/hello#running-on-google-compute-engine
[Running on Google Container Engine]: https://github.com/dart-lang/dart_docker/tree/master/hello#running-on-google-container-engine