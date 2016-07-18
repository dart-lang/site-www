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
  if (!verbose) {
    cursor.write("Crawling pages: $count");
  }

  // TODO: crawl all destinations regardless if they're "parseable" or not
  // - just one huge `open` queue and one big list of 'broken links' (even just 301s and other warnings)
  // - a checkDestination takes destination and returns it updated with optional links on top
  // - paralellism: List<StreamChannel> isolates
  //   - listen to replies: either IDLE or results of a checkDestination
  //     - if IDLE and should quit => don't do anything
  //     - if IDLE and should quit and all others IDLE => all Done
  //     - if IDLE and open queue isNotEmpty => send new Destination to all IDLE isolates
  //     - if IDLE and all others IDLE and open queue empty => all done
  //     - results? add new links to open
  //   - send out first destinations
  //   - await allDone.future;
  do {
    // Get an unprocessed parseable file.
    ParseableDestination current = destinations.where(_isUnprocessed).first;
    var uri = current.uriWithoutFragment;
    if (verbose) {
      print(uri);
      var sources =
          links.where((link) => link.destination.uriWithoutFragment == uri);
      print("- visiting because it was liked from $sources");
    } else {
      cursor.moveLeft(count.toString().length);
      count += 1;
      cursor.write(count.toString());
    }

    // Fetch the document
    HttpClientResponse response = await _fetchParseable(client, uri, current);
    if (response == null) {
      // Request failed completely.
      // TODO: abort when we encounter X of these in a row
      //      print("\n\nERROR: Couldn't connect to $uri. Are you sure you've "
      //          "started the localhost server?");
      //      print("Try, for example:\n  \$ jekyll build && firebase serve");
      exitCode = 1;
      current.didNotConnect = true;
      current.wasProcessed = true;
      continue;
    }
    current.updateFromResponse(response);
    if (verbose) {
      print("- ${current.statusCode}, ${current.contentType}");
    }
    if (current.statusCode != 200 ||
        !hosts.contains(current.finalUri.host) ||
        !current.isHtmlMimeType) {
      await response.drain();
      current.wasProcessed = true;
      updateOthers(destinations, current);
      // TODO: update all others with same destination URL
      continue;
    }

    String html;
    try {
      Converter<List<int>, String> decoder;
      if (current.contentType.charset == LATIN1.name) {
        decoder = LATIN1.decoder;
      } else {
        decoder = UTF8.decoder;
      }
      html = await response.transform(decoder).join();
    } on FormatException {
        throw new UnsupportedError("We don't support any encoding other than "
            "utf-8 and iso-8859-1 (latin-1). Crawled site has explicit charset "
            "'${current.contentType}' and couldn't be parsed by UTF8.");
    }

    // TODO: detect WEBrick/1.3.1 (Ruby/2.3.1/2016-04-26) (and potentially
    // other ugly index files).

    // Parse it
    var doc = parse(html, generateSpans: true, sourceUrl: uri.toString());

    // Find parseable destinations
    // TODO: add following: media, meta refreshes, forms, metadata
    //   `<meta http-equiv="refresh" content="5; url=redirect.html">`
    // TODO: work with http://www.w3schools.com/tags/tag_base.asp (can be anywhere)
    // TODO: get <meta> robot directives - https://github.com/stevenvachon/broken-link-checker/blob/master/lib/internal/scrapeHtml.js#L164

    var linkElements =
        doc.querySelectorAll("a[href], area[href], iframe[src]");
    List<Link> currentLinks = linkElements
        .map((element) =>
            extractLink(uri, element, ["href", "src"], destinations, true))
        .toList(growable: false);

    if (verbose)
      print("- found ${currentLinks.length} links leading to "
          "${currentLinks.map((link) => link.destination.uriWithoutFragment)
          .toSet().length} "
          "different URLs: "
          "${currentLinks.map((link) => link.destination.uriWithoutFragment)
          .toSet()}");

    destinations.addAll(currentLinks.map((link) => link.destination));
    links.addAll(currentLinks);

    // Find resources
    var resourceElements =
        doc.querySelectorAll("link[href], [src], object[data]");
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

/// Update all destinations that share the same uriWithoutFragment.
void updateOthers(Set<Destination> destinations, Destination current) {
  Iterable<Destination> equivalent = destinations.where((destination) =>
      destination.uriWithoutFragment == current.uriWithoutFragment);
  equivalent.forEach((Destination destination) {
    destination.updateFrom(current);
  });
}

Future<Null> checkDestinations(Iterable<Destination> destinations,
    HttpClient client, bool verbose, Cursor cursor) async {
  int resourcesCount = 0;
  cursor.write("\nFetching ${destinations.length} resources: $resourcesCount");

  // List of hosts that do not support HTTP HEAD requests.
  Set<String> headIncompatible = new Set<String>();

  // TODO: add hashmap with robots (don't redownload). Special case for localhost

  var queue = new Queue<Destination>.from(destinations);
  while (queue.isNotEmpty) {
    // TODO: throttle?
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
    } on SocketException {
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
  // Valid URLs can be surrounded by spaces.
  reference = reference.trim();
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
  } on HttpException {
    return null;
  } on SocketException {
    return null;
  } on HandshakeException {
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
