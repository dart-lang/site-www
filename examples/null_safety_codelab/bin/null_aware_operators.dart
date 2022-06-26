// ignore_for_file: prefer_if_null_operators, unnecessary_null_comparison

class TestObject {
  void action() {}
}

TestObject? nullableObjectGenerate() => TestObject();

String? nullableStringGenerate() => null;

void other() {
  final nullableObject = nullableObjectGenerate();

  // #docregion conditional-property-access
  // The following calls the 'action' method only if nullableObject is not null
  nullableObject?.action();
  // #enddocregion conditional-property-access

  var nullableString = nullableStringGenerate();

  // #docregion null-coalescing
  // Both of the following print out 'alternate' if nullableString is null
  print(nullableString ?? 'alternate');
  print(nullableString != null ? nullableString : 'alternate');
  // #enddocregion null-coalescing

  // #docregion null-coalescing-assignment
  // Both of the following set nullableString to 'alternate' if it is null
  nullableString ??= 'alternate';
  nullableString = nullableString != null ? nullableString : 'alternate';
  // #enddocregion null-coalescing-assignment
}
