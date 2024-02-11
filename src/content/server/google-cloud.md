---
title: Using Google Cloud
short-title: Google Cloud
description: "Your Dart app can use many Google Cloud services: Firebase, Google Cloud Platform, and more."
---

Dart servers can use many
[Google Cloud products](https://cloud.google.com/products),
often with the help of the pre-packaged Docker
[Official Images for Dart](https://hub.docker.com/_/dart).
For information about creating HTTP servers with Dart, see the
[Write HTTP servers page](/tutorials/server/httpserver).

For information about other Google APIs (including Firebase)
that you might want to use from Dart code,
see the [Google APIs page](/guides/google-apis).

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

### Functions Framework for Dart

The Functions Framework is a FaaS (Function as a Service) framework
that makes it easy to write Dart functions
instead of server applications for handling web requests.
Using the framework, you can create functions that handle HTTP requests
and [CloudEvents][] and deploy them to Google Cloud.

The [Dart Functions Framework][] is a community-supported project. 

For more information, see [the README][functions docs].

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
[server examples]: https://github.com/dart-lang/samples/tree/main/server
[GKE overview]: https://cloud.google.com/kubernetes-engine/docs/concepts/kubernetes-engine-overview
[Dart Functions Framework]: {{site.pub-pkg}}/functions_framework
[CloudEvents]: https://cloudevents.io/
[functions docs]: https://github.com/GoogleCloudPlatform/functions-framework-dart/blob/main/docs/README.md
