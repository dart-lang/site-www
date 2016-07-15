library linkcheck.destination;

class Destination {
  /// The uri as specified by source file.
  final Uri uri;
  final Uri uriWithoutFragment;

  /// The HTTP status code returned.
  int statusCode;

  /// Uri after all redirects.
  Uri finalUri;

  bool isInvalid = false;
  bool didNotConnect = false;
  bool isPermanentlyRedirected = false;
  // TODO: redirect path, then make ^^^ into a getter

  Destination(Uri uri)
      : uri = uri,
        uriWithoutFragment = uri.removeFragment();

  /// Link that wasn't valid, didn't connect, or the [statusCode] was not
  /// HTTP 200 OK.
  bool get isBroken => statusCode != 200;

  String get statusDescription {
    if (isInvalid) return "invalid URL";
    if (didNotConnect) return "connection failed";
    if (!wasTried) return "wasn't tried";
    return "HTTP $statusCode"
        "${isPermanentlyRedirected ? ' through permanent redirect' : ''}";
  }

  bool get wasTried => isInvalid || didNotConnect || statusCode != null;

  bool operator ==(other) => other is Destination && other.uri == uri;
  int get hashCode => uri.hashCode;

  String toString() => uri.toString();
}

/// Destination that should be parsed.
class ParseableDestination extends Destination {
  Set<String> hashAnchors = new Set<String>();
  bool wasProcessed = false;

  ParseableDestination(Uri uri) : super(uri);
}
