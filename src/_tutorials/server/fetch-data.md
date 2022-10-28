---
title: Fetch data dynamically
description: Fetch data over the internet using the http package.
js: [{url: 'https://dartpad.dev/inject_embed.dart.js', defer: true}]
---

### URIs and HTTP requests

### Getting the necessary dependencies

While you can directly use `dart:io` or `dart:html`
to make HTTP requests, those are platform dependent.
`package:http` provides a cross-platform library
for making composable HTTP requests,
with optional fine-grained control.

Run the [`dart pub add`](/tools/pub/cmd/pub-add) command
and specify `http`
to add a dependency on the package:

```terminal
$ dart pub add http
```

To then use `package:http` in your code,
import it and optionally [provide a prefix][].

```dart
import 'package:http/http.dart' as http;
```

[provide a prefix]: /guides/language/language-tour#specifying-a-library-prefix

### Making network requests

If you just need the body of the response, 
you can use the top-level `read` function.

If you need other information from the response,
such as the `statusCode` or the `headers`,
you can instead use the top-level `get` function.

If the endpoint you are requesting from requires more information,
it often requires you to include [HTTP headers][].
You can specify headers by passing in a `Map<String, String>`
of the key-value pairs to the `headers` optional named parameter.

```dart
```

[HTTP headers]: https://developer.mozilla.org/docs/Web/HTTP/Headers

#### Making multiple requests

If you're making multiple requests to the same server,
you can instead keep a persistent connection
through a `Client`,
and close it when done.

```dart
```

To enable the client to retry failed requests,
wrap your created `Client` in a `RetryClient`:

```dart
```

### Parsing the retrieved data

Now that you have made a network request
and retrieved the returned data,
you can utilize that data.

To learn more about JSON and parsing it,
see the [Using JSON][] guide.

[Using JSON]: /guides/json

### What next?

Now that you've retrieved and parsed the data,
you can do a lot more than just print it out.
One common use case is displaying the retrieved data
within a web or Flutter application.
To learn more about integrating the retrieved data into a Flutter app,
see Flutter's [Fetching data from the internet][] documentation.

[Fetching data from the internet]: {{site.flutter-docs}}/cookbook/networking/fetch-data
