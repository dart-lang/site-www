// BEGIN(io_timer)
import 'dart:async';

main() {
  new Timer(new Duration(seconds: 1), () => print('timer'));
  print('end of main');
}
// END(io_timer)
