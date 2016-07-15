library linkcheck.writer_report;

import 'dart:math' show min;

import 'link.dart';

/// Writes the reports from the perspective of a website writer - which pages
/// reference broken links.
void reportForWriters(List<Link> broken) {
  List<Uri> sourceUris =
      broken.map((link) => link.source.uri).toSet().toList(growable: false);
  sourceUris.sort((a, b) => a.toString().compareTo(b.toString()));

  for (var uri in sourceUris) {
    print(uri);

    var links = broken.where((link) => link.source.uri == uri);
    for (var link in links) {
      String tag = _buildTagSummary(link);
      print("- (${link.source.span.start.line}"
          ":${link.source.span.start.column}) "
          "$tag"
          "=> ${link.destination.uri} "
          "(${link.destination.statusDescription})");
      if (link.destination.isRedirected) {
        print("  - redirect path:");
        Uri current = link.destination.uri;
        for (var redirect in link.destination.redirects) {
          print("    - $current (${redirect.statusCode})");
          current = redirect.location;
        }
        print("    - $current (${link.destination.statusCode})");
      }
    }
    print("");
  }
}

String _buildTagSummary(Link link) {
  String tag = "";
  if (link.source.tagName == 'a') {
    const maxLength = 10;
    var text = link.source.text;
    int length = text.length;
    if (length > 0) {
      if (length <= maxLength) {
        tag = "'$text' ";
      } else {
        tag = "'${text.substring(0, min(length, maxLength -2 ))}..' ";
      }
    }
  } else {
    tag = "<${link.source.tagName}> ";
  }
  return tag;
}
