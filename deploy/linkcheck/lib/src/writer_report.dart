import 'link.dart';

/// Writes the reports from the perspective of a website writer - which pages
/// reference broken links.
void reportForWriters(List<Link> broken) {
  List<Uri> sourceUris = broken.map((link) => link.source.uri).toSet().toList(growable: false);
  sourceUris.sort((a, b) => a.toString().compareTo(b.toString()));

  for (var uri in sourceUris) {
    print(uri);

    var links = broken.where((link) => link.source.uri == uri);
    for (var link in links) {
      print("- (${link.source.span.start.line}"
          ":${link.source.span.start.column}) "
          "=> ${link.destination.uri} "
          "(${link.destination.statusDescription})");
    }
    print("");
  }
}