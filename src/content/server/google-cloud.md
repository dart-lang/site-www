---
title: Using Google Cloud
shortTitle: Google Cloud
description: >-
  Your Dart app can use many Google Cloud services:
  Firebase, Google Cloud Platform, and more.
---

Dart servers can use many
[Google Cloud products](https://cloud.google.com/products),
often with the help of the pre-packaged Docker
[Official Images for Dart](https://hub.docker.com/_/dart).
To get started creating HTTP servers with Dart,
check out some of the popular [server frameworks][server-frameworks].

For information about other Google APIs (including Firebase)
that you might want to use from Dart code,
see the [Google APIs page](/resources/google-apis).

[server-frameworks]: /server#frameworks

## Recommended solutions

To run Dart in the Cloud, we recommend using serverless computing solutions.

### Cloud Run

You can use Cloud Run's flexible container support,
combined with Dart's Docker images, to run server-side Dart code.
Creating scalable, high performance APIs and event-driven apps
are good use cases for Cloud Run's serverless platform,
which frees developers from managing infrastructure.

Examples of Dart servers implemented to run on Cloud Run are
[in the dart-lang/samples/repo][server examples].

For more information about using Cloud Run, see the documentation for
[building and deploying a service in other languages][cr].

### Cloud Functions for Firebase

Write Cloud Functions for Firebase using Dart to enable full-stack development,
reuse code between your client and backend, and respond to Firebase triggers.
To get started, see the
[Cloud Functions for Firebase documentation][firebase-docs].

[Firebase Functions package]({{site.pub-pkg}}/firebase_functions)
: The core package to write backend functions and APIs in Dart.

[Firebase Admin SDK package]({{site.pub-pkg}}/firebase_admin_sdk)
: Access Firebase services securely from backend servers or Cloud Functions.
  Use it to manage data, send notifications, or verify authentication tokens.

[Firebase Functions for Dart repository][firebase-repo]
: GitHub repository with quickstart guides, examples, and source code.

[firebase-docs]: https://firebase.google.com/docs/functions/start-dart
[firebase-repo]: https://github.com/firebase/firebase-functions-dart

## Other solutions

Depending on your needs, you may also want to consider running Dart on the
following Google Cloud compute platforms.

### Compute Engine

To run Dart code on Compute Engine,
use Compute Engine's support for running containers,
combined with Dart's Docker images.

For more information, see the Compute Engine documentation for
[using software containers][ce].

### Kubernetes

To run Dart on clusters of Compute Engine instances,
use Google Kubernetes Engine (GKE).

For more information, see the [GKE overview][].

### App Engine

[App Engine][] support for Dart is incomplete and requires the
[App Engine flexible environment][], which does not
[autoscale to zero instances][scale to zero], so we recommend **Cloud Run** for new
server-side Dart code.
If you _want_ to use App Engine, consider using the [`appengine` package][].


[App Engine]: https://cloud.google.com/appengine
[App Engine flexible environment]: https://cloud.google.com/appengine/docs/flexible
[scale to zero]: https://cloud.google.com/run/docs/about-instance-autoscaling
[`appengine` package]: {{site.pub-pkg}}/appengine
[ce]: https://cloud.google.com/compute/docs/containers
[cr]: https://cloud.google.com/run/docs/quickstarts/build-and-deploy/other
[server examples]: {{site.repo.dart.samples}}/tree/main/server
[GKE overview]: https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview
[Dart Functions Framework]: {{site.pub-pkg}}/functions_framework
[CloudEvents]: https://cloudevents.io/
[functions docs]: https://github.com/GoogleCloudPlatform/functions-framework-dart/blob/main/docs/README.md
