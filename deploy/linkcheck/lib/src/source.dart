library linkcheck.source;

import 'package:source_span/source_span.dart';

class Source {
  final Uri uri;
  final SourceSpan span;
  final String tagName;
  final String text;
  final String outerHtml;

  Source(this.uri, this.span, this.tagName, this.text, this.outerHtml);

  String toString() => uri.toString();
}
