// #docregion deprecated
class Television {
  /// _Deprecated: Use [turnOn] instead._
  @deprecated
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {/*...*/}
}
// #enddocregion deprecated

// #docregion override
class SmartTelevision extends Television {
  @override
  void turnOn() {/*...*/}
  // #enddocregion override
  // #docregion override
}
