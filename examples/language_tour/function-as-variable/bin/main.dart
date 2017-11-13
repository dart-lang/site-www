void main() {
  // #docregion
  var loudify = (msg) => '!!! ${msg.toUpperCase()} !!!';
  assert(loudify('hello') == '!!! HELLO !!!');
  // #enddocregion
  print(loudify('hello'));
}
