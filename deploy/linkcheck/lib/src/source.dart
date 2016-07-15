library linkcheck.source;

import 'package:source_span/source_span.dart';

class Source {
  final Uri uri;
  final SourceSpan span;

  Source(this.uri, this.span);

  String toString() => uri.toString();
}
