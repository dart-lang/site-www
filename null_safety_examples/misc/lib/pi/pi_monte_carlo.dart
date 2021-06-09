// ignore_for_file: sort_constructors_first, type_annotate_public_apis

// IMPORTANT NOTE:
// 1. If you change this file, ensure that the associated tooltip data remains
//    valid (*_tooltips.html).
// 2. Regenerate the HTML version of this sample, by running
//    tool/create_code_with_tooltips.dart
// 3. To generate the DartPad version: (1) delete lines containing only tip
//    instructions. (2) Trim //!foo markers from the end of the remaining lines,
//    e.g., using this Perl regexp: / ?\/\/!.*//g

import 'dart:html'; //!web-only
// #docregion try-dart
import 'dart:math' show Random; //!tip("dart:math") //!tip("import")

// #enddocregion try-dart
int numIterations = 500; //!web-only
//!web-only
// We changed a few lines of code to make this sample nicer //!web-only
// on the web (so that the execution waits for animation frame, //!web-only
// the number gets updated in the DOM, and the program ends //!web-only
// after 500 iterations). //!web-only
//!web-only
//!tip("main()")
// #docregion try-dart
Future<void> main() async {
  print('Compute π using the Monte Carlo method.'); //!tip("π")
  var output = querySelector('#value-of-pi')!; //!web-only
  //!tip("await")
  await for (var estimate in computePi().take(numIterations)) {
    print('π ≅ $estimate'); //!tip("$estimate")
    output.text = estimate.toStringAsFixed(5); //!web-only
    await window.animationFrame; //!web-only
  }
}

/// Generates a stream of increasingly accurate estimates of π. //!tip("///")
//!tip("async*") //!tip("{int batch = 100000}") //!tip("<double>")
Stream<double> computePi({int batch = 100000}) async* {
  var total = 0; //!tip("var")
  var count = 0;
  //!tip("while (true)")
  while (true) {
    var points = generateRandom().take(batch); //!tip("take")
    var inside = points.where((p) => p.isInsideUnitCircle); //!tip("=>")
    total += batch;
    count += inside.length; //!tip("length")
    var ratio = count / total;
    // Area of a circle is A = π⋅r², therefore π = A/r².
    // So, when given random points with x ∈ <0,1>,
    // y ∈ <0,1>, the ratio of those inside a unit circle
    // should approach π / 4. Therefore, the value of π
    // should be:
    yield ratio * 4; //!tip("yield")
  }
}

//!tip("sync*") //!tip("[int? seed]") //!tip("Iterable")
Iterable<Point> generateRandom([int? seed]) sync* {
  final random = Random(seed); //!tip("final")
  while (true) {
    yield Point(random.nextDouble(), random.nextDouble()); //!tip("yield")
  }
}

//!tip("class")
class Point {
  final double x, y; //!tip("double")
  const Point(this.x, this.y); //!tip("this.x") //!tip("const")
  bool get isInsideUnitCircle => x * x + y * y <= 1; //!tip("get")
}
