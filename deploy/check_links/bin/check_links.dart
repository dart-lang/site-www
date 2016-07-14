import 'dart:io';
import 'dart:convert' show UTF8;

import 'package:html/parser.dart' show parse;
import 'package:source_span/source_span.dart';
import 'package:html/dom.dart';
import 'package:args/args.dart';

const helpFlag = "help";
const verboseFlag = "verbose";
const hostsFlag = "hosts";

main(List<String> arguments) async {
  final parser = new ArgParser()
    ..addFlag(helpFlag,
        abbr: 'h', negatable: false, help: "Prints usage and exits.")
    ..addFlag(verboseFlag, abbr: 'v', negatable: false, help: "Verbose mode.")
    ..addOption(hostsFlag,
        allowMultiple: true,
        splitCommas: true,
        help: "Additional hosts (domains) to check.");
  final argResults = parser.parse(arguments);

  if (argResults[helpFlag]) {
    print(parser.usage);
    return;
  }

  bool verbose = argResults[verboseFlag];

  final List<String> urls = argResults.rest.toList();
  if (urls.isEmpty) {
    print("No URLs given");
    urls.add("http://localhost:4000");
  }

  print("Crawl will start on the following URLs:");
  urls.forEach((url) => print("- $url"));

  List<Uri> uris = urls.map((url) => Uri.parse(url)).toList();
  Set<String> hosts = uris.map((uri) => uri.host).toSet();
  hosts.addAll(argResults[hostsFlag]);

  print("Crawl will check pages only on following hosts:");
  hosts.forEach((host) => print("- $host"));

  Iterable<Page> initial = uris.map((uri) => new Page(uri));
  var open = new Set<Page>.from(initial);
  var closed = new Set<Page>();
  var externals = new Set<Page>();
  var resources = new Set<Resource>();

  var client = new HttpClient();

  stdout.write("\nCrawling pages");
  while (open.isNotEmpty) {
    var page = open.first;
    open.remove(page);
    closed.add(page);
    if (verbose) {
      print(page);
    } else {
      stdout.write(".");
    }

    // Fetch the document
    HttpClientRequest request;
    try {
      request = await client.getUrl(page.uri);
    } on SocketException {
      print("\n\nERROR: Couldn't connect to ${page.uri}. Are you sure you've "
          "started the Firebase server?");
      print("Try:\n  \$ jekyll build && firebase serve");
      exit(2);
    }
    var response = await request.close();
    page.statusCode = response.statusCode;
    if (response.statusCode != 200) {
      await response.drain();
      continue;
    }
    String html = await response.transform(UTF8.decoder).join();

    // Parse it
    var doc = parse(html, generateSpans: true, sourceUrl: page.toString());

    // Find links
    var links = doc.querySelectorAll("a[href], iframe[src]");
    Set<Page> linkedPages = links
        .map((link) => createPageFromAnchor(link, page, open, closed))
        .toSet();
    Set<Page> internals =
        linkedPages.where((page) => hosts.contains(page.uri.host)).toSet();
    externals.addAll(linkedPages.difference(internals));
    open.addAll(internals.difference(closed));

    // Find resources
    var hrefElements =
        doc.querySelectorAll("link[href], img[src], script[src]");
    Iterable<Resource> linkedResources = hrefElements
        .map((element) => createResourceFromElement(element, page, resources));
    resources.addAll(linkedResources);
  }

  stdout.write("\nChecking resources");
  for (var resource in resources) {
    if (verbose) {
      print(resource);
    } else {
      stdout.write(".");
    }
    var request = await client.getUrl(resource.uri);
    var response = await request.close();
    resource.statusCode = response.statusCode;
    await response.drain();
  }

  client.close();

  print("\n");
  print("Found:");
  print("- ${closed.length} internal links (html)");
  print("- ${resources.length} resources (images, css, js, ...)");
  print("- ${externals.length} external links (NOT CHECKED)\n");

  Set<Page> failingPages =
      closed.where((page) => page.statusCode != 200).toSet();
  Set<Resource> failingResources =
      resources.where((resource) => resource.statusCode != 200).toSet();
  Set<Resource> failing = new Set<Resource>.from(failingPages)
    ..addAll(failingResources);

  Set<Referrer> allReferrers = failing.expand((page) => page.referrers).toSet();

  if (allReferrers.isEmpty) {
    print("NO ISSUES FOUND");
    return;
  }

  print("ISSUES FOUND");
  exitCode = 2;
  print("${allReferrers.length} links are broken\n");
  for (Uri uri
      in allReferrers.map((Referrer referrer) => referrer.uri).toSet()) {
    print(uri);
    var currentReferrers =
        allReferrers.where((referrer) => referrer.uri == uri);
    for (var resource in failing) {
      var referrers = resource.referrers
          .where((referrer) => currentReferrers.contains(referrer))
          .toList();
      if (referrers.isNotEmpty) {
        print("-> $resource (HTTP ${resource.statusCode})");
        for (var referrer in referrers) {
          print("    (line ${referrer.sourceSpan.start.line}"
              ":${referrer.sourceSpan.start.column}) "
              "-- ${referrer.sourceSpan.text}");
        }
      }
    }
  }
}

Page createPageFromAnchor(
    Element link, Page currentPage, Set<Page> open, Set<Page> closed) {
  String href = link.attributes["href"] ?? link.attributes["src"];
  Uri uri = currentPage.uri.resolve(href).removeFragment();
  Referrer referrer = new Referrer(currentPage.uri, link.sourceSpan);
  Page destination = new Page(uri);
  List<Page> existing = open.where((page) => page == destination).toList();
  existing.addAll(closed.where((page) => page == destination));
  if (existing.isEmpty) {
    destination.referrers.add(referrer);
    return destination;
  }
  if (existing.length > 1) {
    throw new StateError("Cannot have more of one page: $existing");
  }
  existing.single.referrers.add(referrer);
  return existing.single;
}

Resource createResourceFromElement(
    Element link, Page page, Set<Resource> resources) {
  String href = link.attributes["href"] ?? link.attributes["src"];
  Uri uri = page.uri.resolve(href).removeFragment();
  Referrer referrer = new Referrer(page.uri, link.sourceSpan);
  Resource resource = new Resource(uri);
  List<Resource> existing =
      resources.where((page) => page == resource).toList();
  if (existing.isEmpty) {
    resource.referrers.add(referrer);
    return resource;
  }
  if (existing.length > 1) {
    throw new StateError("Cannot have more of one resource: $existing");
  }
  existing.single.referrers.add(referrer);
  return existing.single;
}

class Referrer {
  final Uri uri;
  final SourceSpan sourceSpan;
  Referrer(this.uri, this.sourceSpan);

  String toString() => "$uri "
      "(line ${sourceSpan.start.line}:${sourceSpan.start.column})";
}

class Page extends Resource {
  Page(Uri uri) : super(uri);
}

class Resource {
  final Set<Referrer> referrers = new Set<Referrer>();
  final Uri uri;
  Resource(this.uri);

  int statusCode;
  operator ==(other) => other is Resource && other.uri == uri;
  int get hashCode => uri.hashCode;

  String toString() => "$uri";
}
