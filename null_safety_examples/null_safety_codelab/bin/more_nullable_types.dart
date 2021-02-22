void main() {
  List<String> aListofStrings = ['one', 'two', 'three'];
  List<String?> aNullableListOfStrings = [];
  List<String?> aListofNullableStrings = ['one', null, 'three'];

  print('aListofStrings is $aListofStrings.');
  print('aNullableListOfStrings is $aNullableListOfStrings.');
  print('aListofNullableStrings is $aListofNullableStrings.');
}