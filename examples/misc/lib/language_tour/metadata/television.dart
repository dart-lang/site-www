// #docregion deprecated
class Television {
  /// Use [turnOn] to turn the power on instead.
  @Deprecated('Use turnOn instead')
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
