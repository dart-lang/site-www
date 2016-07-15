library linkcheck.check;

import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io' hide Link;

import 'package:console/console.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

import 'destination.dart';
import 'link.dart';
import 'source.dart';

Future<List<Link>> check(List<Uri> uris, Set<String> hosts,
    bool shouldCheckExternal, bool verbose) async {
  bool isInternal(Uri uri) => hosts.contains(uri.host);

  Console.init();
  var cursor = new Cursor();

  if (verbose) print("Crawl will start on the following URLs: $uris");
  if (verbose) print("Crawl will check pages only on following hosts: $hosts");

  Set<Destination> destinations =
      uris.map((uri) => new ParseableDestination(uri)).toSet();

  /// Determines whether this destination is still pending to be processed.
  bool _isUnprocessed(Destination destination) =>
      destination is ParseableDestination &&
      !destination.wasProcessed &&
      isInternal(destination.uri);

  Set<Link> links = new Set<Link>();

  var client = new HttpClient();

  int count = 0;
  cursor.write("Crawling pages: $count");

  do {
    // Get an unprocessed parseable file.
    ParseableDestination current = destinations.where(_isUnprocessed).first;
    var uri = current.uriWithoutFragment;
    if (verbose) {
      print(uri);
    } else {
      cursor.moveLeft(count.toString().length);
      count += 1;
      cursor.write(count.toString());
    }

    // Fetch the document
    HttpClientResponse response = await _fetchParseable(client, uri, current);
    if (response == null) continue;
    current.updateFromResponse(response);
    if (current.statusCode != 200 || !hosts.contains(current.finalUri.host)) {
      await response.drain();
      current.wasProcessed = true;
      updateOthers(destinations, current);
      // TODO: update all others with same destination URL
      continue;
    }
    String html = await response.transform(UTF8.decoder).join();

    // Parse it
    var doc = parse(html, generateSpans: true, sourceUrl: uri.toString());

    // Find parseable destinations
    var linkElements =
        doc.querySelectorAll("a[href], area[href], iframe[src]"); // TODO: add?
    List<Link> currentLinks = linkElements
        .map((element) =>
            extractLink(uri, element, ["href", "src"], destinations, true))
        .toList(growable: false);

    if (verbose)
      print("- found ${currentLinks.length} links leading to "
          "${currentLinks.map((link) => link.destination.uriWithoutFragment)
          .toSet().length} different URLs: ${currentLinks.map((link) => link.destination.uriWithoutFragment)
          .toSet()}");

    destinations.addAll(currentLinks.map((link) => link.destination));
    links.addAll(currentLinks);

    // Find resources
    var resourceElements =
        doc.querySelectorAll("link[href], [src], object[data]"); // TODO: add?
    List<Link> currentResourceLinks = resourceElements
        .map((element) => extractLink(
            uri, element, ["src", "href", "data"], destinations, false))
        .toList(growable: false);

    // TODO: add srcset extractor (will create multiple links per element)

    if (verbose) print("- found ${currentResourceLinks.length} resources");

    destinations.addAll(currentResourceLinks.map((link) => link.destination));
    links.addAll(currentResourceLinks);

    // TODO: take note of anchors on page, add it to current

    current.wasProcessed = true;
    updateOthers(destinations, current);
  } while (destinations.where(_isUnprocessed).isNotEmpty);

  // TODO: (optionally) check anchors

  // Get unparseable.
  Set<Destination> resources = destinations
      .where((destination) =>
          !destination.wasTried &&
          (isInternal(destination.uri) || shouldCheckExternal))
      .toSet();
  await checkDestinations(resources, client, verbose, cursor);

  client.close();

  return links.toList(growable: false);
}

/// Update all parseable destinations that share the same uriWithoutFragment
void updateOthers(Set<Destination> destinations, Destination current) {
  Iterable<Destination> equivalent = destinations.where(
      (destination) =>
          destination.uriWithoutFragment == current.uriWithoutFragment);
  equivalent.forEach((Destination destination) {
    destination.statusCode = current.statusCode; // TODO: updateFrom(other)
    if (destination is ParseableDestination && current is ParseableDestination) {
      destination.wasProcessed = current.wasProcessed;
    }
  });
}

Future<Null> checkDestinations(Iterable<Destination> destinations,
    HttpClient client, bool verbose, Cursor cursor) async {
  int resourcesCount = 0;
  cursor.write("\nFetching ${destinations.length} resources: $resourcesCount");

  // List of hosts that do not support HTTP HEAD requests.
  Set<String> headIncompatible = new Set<String>();

  var queue = new Queue<Destination>.from(destinations);
  while (queue.isNotEmpty) {
    var resource = queue.removeFirst();
    Uri uri = resource.uriWithoutFragment;
    if (verbose) {
      print(uri);
    } else {
      cursor.moveLeft(resourcesCount.toString().length);
      resourcesCount += 1;
      cursor.write(resourcesCount.toString());
    }
    try {
      HttpClientResponse response;
      if (headIncompatible.contains(uri.host)) {
        response = await _getUri(client, uri, response);
      } else {
        var request = await client.headUrl(uri);
        response = await request.close();

        if (response.statusCode == 405) {
          headIncompatible.add(uri.host);
          response = await _getUri(client, uri, response);
        }
      }
      // Copy status code
      destinations
          .where((destination) => destination.uriWithoutFragment == uri)
          .forEach((destination) => destination.updateFromResponse(response));
      if (verbose) print(response.statusCode);
      await response.drain();
    } on HttpException {
      resource.didNotConnect = true;
    } on HandshakeException {
      resource.didNotConnect = true;
    }
  }
}

Link extractLink(Uri uri, Element element, final List<String> attributes,
    final Set<Destination> existingDestinations, bool parseable) {
  var source = new Source(uri, element.sourceSpan, element.localName,
      element.text, element.outerHtml);
  String reference;
  for (var attributeName in attributes) {
    reference = element.attributes[attributeName];
    if (reference != null) break;
  }
  if (reference == null) {
    throw new StateError("Element $element does not have any of the attributes "
        "$attributes");
  }
  // TODO: work with http://www.w3schools.com/tags/tag_base.asp
  var destinationUri = uri.resolve(reference);
  for (var existing in existingDestinations) {
    if (destinationUri == existing.uri) {
      return new Link(source, existing);
    }
  }
  Destination destination;
  if (parseable) {
    destination = new ParseableDestination(destinationUri);
  } else {
    destination = new Destination(destinationUri);
  }
  existingDestinations.add(destination);
  return new Link(source, destination);
}

Future<HttpClientResponse> _fetchParseable(
    HttpClient client, Uri uri, ParseableDestination current) async {
  HttpClientRequest request;
  try {
    request = await client.getUrl(uri);
  } on SocketException {
    // TODO: abort when we encounter X of these in a row
    //      print("\n\nERROR: Couldn't connect to $uri. Are you sure you've "
    //          "started the localhost server?");
    //      print("Try, for example:\n  \$ jekyll build && firebase serve");
    exitCode = 1;
    current.didNotConnect = true;
    current.wasProcessed = true;
    return null;
  }
  var response = await request.close();
  return response;
}

Future<HttpClientResponse> _getUri(
    HttpClient client, Uri uri, HttpClientResponse response) async {
  var request = await client.getUrl(uri);
  response = await request.close();
  return response;
}
