// #docregion deprecated
// #docregion override
class Television {
  // #enddocregion override
  /// Use [turnOn] to turn the power on instead.
  @Deprecated('Use turnOn instead')
  void activate() {
    turnOn();
  }

  /// Turns the TV's power on.
  void turnOn() {/*...*/}
  // #enddocregion deprecated

  // #docregion override
  set contrast(int value) {/*...*/}
  // #docregion deprecated
}
// #enddocregion deprecated

class SmartTelevision extends Television {
  @override
  set contrast(num value) {/*...*/}
  // #enddocregion override
  // #docregion override
}
// #enddocregion override
