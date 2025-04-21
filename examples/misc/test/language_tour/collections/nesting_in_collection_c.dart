import 'package:test/test.dart';

String oneThing() {
  return 'oneThing'; // In a real scenario, this would likely return a value
}

List<String> multiple() {
  return ['multiple_a', 'multiple_b'];
}

String things() {
  return 'things';
}

void main() {
  var condition = true;
  // #docregion code_sample
  var items = [
    if (condition) oneThing(),
    if (condition) ...[multiple(), things()],
  ]; // [oneThing, [multiple_a, multiple_b], things]
  // #enddocregion code_sample

  print(items);
  expect(
    items,
    equals([
      'oneThing',
      ['multiple_a', 'multiple_b'],
      'things',
    ]),
  );
}
