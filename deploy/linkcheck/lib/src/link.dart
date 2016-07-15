library linkcheck.link;

import 'package:linkcheck/src/destination.dart';
import 'package:linkcheck/src/source.dart';

class Link {
  Source source;
  Destination destination;

  Link(this.source, this.destination);

  String toString() => "$source => $destination "
      "(${destination.statusDescription})";
}
