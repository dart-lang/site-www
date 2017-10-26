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

void main() {
  print(say('Bob', 'Howdy'));
  assert(say('Bob', 'Howdy') == 'Bob says Howdy with a carrier pigeon');
}
