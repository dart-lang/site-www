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

One example of a Dart server that uses Cloud Run is dartbug.com,
the redirect service for Dart issues and bugs.
You can find its source code in the [dart-lang/dartbug.com repo][].

For more information about using Cloud Run, see the documentation for
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

The App Engine support for Dart is incomplete and experimental,
so we recommend that you **use Cloud Run** instead of App Engine
to run new server-side Dart code.
If you _do_ use App Engine,
you might also want to use the [`appengine` package][].


[`appengine` package]: {{site.pub-pkg}}/appengine
[ce]: https://cloud.google.com/compute/docs/containers
[cr]: https://cloud.google.com/run/docs/quickstarts/build-and-deploy/other
[dart-lang/dartbug.com repo]: https://github.com/dart-lang/dartbug.com
[Docker images]: https://hub.docker.com/r/google/dart
[GKE overview]: https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview
