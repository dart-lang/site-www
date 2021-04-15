---
title: "Google Cloud"
short-title: Dart & Google Cloud services
description: Leveraging Cloud services (Firebase, GCP, etc.) for your Dart apps.
---

[Google Cloud](https://cloud.google.com/) offers a rich selection of
[products](https://cloud.google.com/products), many of which can be leveraged
from your app built in Dart.

Many of these are based on pre-packaged [Dart Docker images][] maintained by the
Dart team.

You may also be interested in using [Firebase](/guides/services).

### Cloud Run

Dart can be run on Google Cloud Run using it's flexible container support
combined with Dart's Docker images.

See [Build and deploy a service][] for more  information.

### Compute Engine

Dart can be run on Google Compute Engine using it's support for running
Containers combined with Dart's Docker images.

See [Containers on Compute Engine][] for more information.

### Kubernetes Engine (GKE)

You can run Dart on clusters of Compute Engine instances using Google Kubernetes
Engine (GKE).

See [GKE overview][] for more information.

### App Engine

Dart can be run on Google App Engine using it's _Custom Runtimes for the Flex
Environment_ support.

See the documentation in [`package:appengine`][] for more information.

**Note:**: Dart's AppEngine support is incomplete and experimental. For new
apps, we recommend using Cloud Run.


[Dart Docker images]: https://hub.docker.com/r/google/dart
[`package:appengine`]: https://pub.dev/packages/appengine
[`package:googleapis`]: https://pub.dev/packages/googleapis
[Build and deploy a service]: https://cloud.google.com/run/docs/quickstarts/build-and-deploy/other
[Containers on Compute Engine]: https://cloud.google.com/compute/docs/containers
[GKE overview]: https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview
