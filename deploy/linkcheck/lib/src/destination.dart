library linkcheck.destination;

import 'dart:io' show HttpClientResponse, RedirectInfo;

class Destination {
  /// The uri as specified by source file.
  final Uri uri;
  final Uri uriWithoutFragment;

  /// The HTTP status code returned.
  int statusCode;

  List<RedirectInfo> redirects;

  /// Uri after all redirects.
  Uri finalUri;

  bool isInvalid = false;
  bool didNotConnect = false;
  bool isPermanentlyRedirected = false;
  // TODO: redirect path, then make ^^^ into a getter

  Destination(Uri uri)
      : uri = uri,
        uriWithoutFragment = uri.removeFragment();

  int get hashCode => uri.hashCode;

  /// Link that wasn't valid, didn't connect, or the [statusCode] was not
  /// HTTP 200 OK.
  bool get isBroken => statusCode != 200;

  bool get isRedirected => redirects != null && redirects.isNotEmpty;

  String get statusDescription {
    if (isInvalid) return "invalid URL";
    if (didNotConnect) return "connection failed";
    if (!wasTried) return "wasn't tried";
    if (statusCode == 200) return "HTTP 200";
    if (isRedirected) {
      var path = redirects.map((redirect) => redirect.statusCode).join(" -> ");
      return "HTTP $path => $statusCode";
    }
    return "HTTP $statusCode";
  }

  bool get wasTried => isInvalid || didNotConnect || statusCode != null;

  bool operator ==(other) => other is Destination && other.uri == uri;
  String toString() => uri.toString();

  void updateFromResponse(HttpClientResponse response) {
    statusCode = response.statusCode;
    redirects = response.redirects;
    finalUri = redirects.isNotEmpty ? redirects.last.location : uri;
    isPermanentlyRedirected =
        redirects.isNotEmpty && redirects.first.statusCode == 301;
  }
}

/// Destination that should be parsed.
class ParseableDestination extends Destination {
  Set<String> hashAnchors = new Set<String>();
  bool wasProcessed = false;

  ParseableDestination(Uri uri) : super(uri);
}
