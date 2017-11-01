// #docplaster
void main() {
  // #docregion
  String say(String from, String msg,
      [String device = 'carrier pigeon', String mood]) {
    var result = '$from says $msg';
    if (device != null) {
      result = '$result with a $device';
    }
    if (mood != null) {
      result = '$result (in a $mood mood)';
    }
    return result;
  }

  // #enddocregion
  print(say('Bob', 'Howdy'));
  // #docregion
  assert(say('Bob', 'Howdy') ==
      'Bob says Howdy with a carrier pigeon');
  // #enddocregion
}
