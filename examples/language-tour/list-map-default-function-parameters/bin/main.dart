void doStuff(
    {List<int> list = const [1, 2, 3],
    Map<String, String> gifts = const {
      'first': 'paper',
      'second': 'cotton',
      'third': 'leather'
    }}) {
  print('list:  $list');
  print('gifts: $gifts');
}

void main() {
  // Use the default values for both parameters.
  doStuff();

  // Use the default values for the "gifts" parameter.
  doStuff(list: [4, 5, 6]);

  // Don't use the default values for either parameter.
  doStuff(list: null, gifts: null);
}
