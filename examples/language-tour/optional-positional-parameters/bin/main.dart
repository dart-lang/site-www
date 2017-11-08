// #docregion
String say(String from, String msg, [String device]) {
  var result = '$from says $msg';
  if (device != null) {
    result = '$result with a $device';
  }
  return result;
}
// #enddocregion

void main() {
  // #docregion call-without-optional-param
  assert(say('Bob', 'Howdy') == 'Bob says Howdy');
  // #enddocregion call-without-optional-param
  print(say('Bob', 'Howdy'));
  // #docregion call-with-optional-param
  assert(say('Bob', 'Howdy', 'smoke signal') ==
      'Bob says Howdy with a smoke signal');
  // #enddocregion call-with-optional-param
  print(say('Bob', 'Howdy', 'smoke signal'));
}
