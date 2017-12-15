import 'dart:async';
main() {
  print('main #1 of 2');
  scheduleMicrotask(() => print('microtask #1 of 2'));
  
  new Future.delayed(new Duration(seconds:1),
                     () => print('future #1 (delayed)'));
  new Future(() => print('future #2 of 3'));
  new Future(() => print('future #3 of 3'));
    
  scheduleMicrotask(() => print('microtask #2 of 2'));

  print('main #2 of 2');
}
