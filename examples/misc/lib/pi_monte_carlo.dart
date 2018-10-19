// ignore_for_file: type_annotate_public_apis
// Note: this DartPad version has a few extra lines of code,
// marked "web-only", to make the sample execution nicer on the web
// (approximations of π are added to the DOM in addition to being
// printed on the console).

import 'dart:async'; //!tip("import")
import 'dart:html'; //!web-only
import 'dart:math' show Random; //!tip("dart:math")
//!web-only
int numIterations = 500; //!web-only

main() async { //!tip("main()")
  print('Compute π using the Monte Carlo method.'); //!tip("π")
  var output = querySelector("#value-of-pi"); //!web-only
  await for (var estimate in computePi().take(numIterations)) { //!tip("await")
    print('π ≅ $estimate'); //!tip("$estimate")
    output.text = estimate.toStringAsFixed(5); //!web-only
    await window.animationFrame; //!web-only
  }
}

/// Generates a stream of increasingly accurate estimates of π. //!tip("///")
Stream<double> computePi({int batch = 100000}) async* { //!tip("async*") //!tip("{int batch = 100000}") //!tip("<double>")
  var total = 0; //!tip("var")
  var count = 0;
  while (true) { //!tip("while (true)")
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

Iterable<Point> generateRandom([int seed]) sync* { //!tip("sync*") //!tip("[int seed]") //!tip("Iterable")
  final random = Random(seed); //!tip("final")
  while (true) {
    yield Point(random.nextDouble(), random.nextDouble()); //!tip("yield")
  }
}

class Point { //!tip("class")
  final double x, y; //!tip("double")
  const Point(this.x, this.y); //!tip("this.x") //!tip("const")
  bool get isInsideUnitCircle => x * x + y * y <= 1; //!tip("get")
}

