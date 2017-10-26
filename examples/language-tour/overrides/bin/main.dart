class Television {
  /// _Deprecated: Use [turnOn] instead._
  @deprecated
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {
    print('on!');
  }
}

void main() {
  var tv = new Television();
  //tv.activate();
  tv.turnOn();
}
