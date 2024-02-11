---
title: Using Google APIs
short-title: Google APIs
description: Your Dart apps can use Firebase and Google client APIs.
---

This page points to resources to help you use
[Firebase][] and [Google client APIs][] from a Dart app.


## Firebase

The Dart API that you use with Firebase depends
on whether you're writing code for a Flutter app or another kind of Dart app.

Flutter apps can choose from many officially supported plugins for
popular Firebase products such as Analytics, Cloud Firestore,
Cloud Functions, and Crashlytics.
For a full list of these plugins, see [FlutterFire][].

Other kinds of Dart apps can use
the community-supported [`firebase` package][].

## Google client APIs

The [`googleapis` package][] contains generated APIs for
over 180 Google client APIs,
such as the Google Docs API, YouTube Data API,
Cloud Translation API, and Cloud Storage API.

If you're building a Flutter application, see the
[Flutter guide for Google APIs][flutter-google-apis].

If you'd like to use Google APIs as part of a server application, see the
[google_apis server sample][server-sample].

Some packages provide idiomatic Dart wrappers for
the APIs provided by `googleapis`.
For example, if you want to use the Google Sheets API,
consider the [`gsheets` package][],
which provides an [alternative API][gsheets-api-docs] to the
[automatically generated API][gsheets-api-docs-gapi].

To find wrapper packages for Google client APIs, search for
[packages that depend on `googleapis`][gapi-packages].


[Firebase]: https://firebase.google.com/use-cases
[FlutterFire]: https://firebase.flutter.dev/
[`firebase` package]: {{site.pub-pkg}}/firebase
[gapi-packages]: {{site.pub-pkg}}?q=dependency%3Agoogleapis
[Google client APIs]: https://developers.google.com/api-client-library
[`googleapis` package]: {{site.pub-pkg}}/googleapis
[`gsheets` package]: {{site.pub-pkg}}/gsheets
[gsheets-api-docs]: {{site.pub-api}}/gsheets/latest/gsheets/gsheets-library.html
[gsheets-api-docs-gapi]: {{site.pub-api}}/googleapis/latest/sheets_v4/sheets_v4-library.html
[flutter-google-apis]: https://flutter.dev/docs/development/data-and-backend/google-apis
[server-sample]: https://github.com/dart-lang/samples/tree/main/server/google_apis
