---
title: Using Google Cloud
short-title: Google Cloud
description: Your Dart app can use many Google Cloud services — Firebase, Google Cloud Platform, and more.
---

Dart servers can use many
[Google Cloud products](https://cloud.google.com/products),
often with the help of pre-packaged [Docker images][]
that the Dart team maintains.

For information about other Google APIs (including Firebase)
that you might want to use from Dart code,
see the [Google APIs page](/guides/google-apis).

## Cloud Run

You can use Cloud Run's flexible container support,
combined with Dart's Docker images,
to run server-side Dart code.

For more information, see the Cloud Run documentation for
[building and deploying a service in other languages][cr].

## Compute Engine

To run Dart code on Compute Engine,
use Compute Engine's support for running containers,
combined with Dart's Docker images.

For more information, see the Compute Engine documentation for
[using software containers][ce].

## Kubernetes

To run Dart on clusters of Compute Engine instances,
use Google Kubernetes Engine (GKE).

For more information, see the [GKE overview][].

## App Engine

To run Dart code on App Engine, use
the [`appengine` package][].

{{ site.alert.warn}}
  The App Engine support for Dart is incomplete and experimental.
  For new apps, we recommend using Google Cloud Run.
{{ site.alert.end}}


[`appengine` package]: {{site.pub-pkg}}/appengine
[ce]: https://cloud.google.com/compute/docs/containers
[cr]: https://cloud.google.com/run/docs/quickstarts/build-and-deploy/other
[Docker images]: https://hub.docker.com/r/google/dart
[GKE overview]: https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview
