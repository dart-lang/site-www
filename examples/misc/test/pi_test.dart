@Tags(['browser'])
@TestOn('browser')
import 'dart:html';

import 'package:examples/pi/pi_monte_carlo.dart' as mc_pi;
import 'package:test/test.dart';

void main() {
  test('pi', () async {
    const numIterations = 10;
    const expectedNumOutputLines = //
        1 + // for the 'Compute π...' heading
            numIterations + // lines 'π ≅ ...'
            1; // for the trailing \n

    final html = '''
      <h1>π ≅ <span id="value-of-pi">?</span></h1>
    ''';
    document.body!.appendHtml(html);

    // Run as async function to capture printed output.
    expect(() async {
      mc_pi.numIterations = numIterations;
      await mc_pi.main();
      var pi = querySelector('#value-of-pi') as SpanElement;
      expect(pi.text, startsWith('3.'));
    },
        prints(allOf([
          contains('Compute π using the Monte Carlo method.'),
          contains('π ≅ 3.'),
          predicate<String>((consoleOutput) {
            final lines = consoleOutput.split('\n');
            return lines.length == expectedNumOutputLines;
          }, 'output $expectedNumOutputLines lines'),
        ])));
  });
}
