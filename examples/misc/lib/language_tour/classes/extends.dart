// ignore_for_file: annotate_overrides
// #docregion
class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }
  // #enddocregion

  void _illuminateDisplay() {}
  void _activateIrSensor() {}
  // #docregion
}

class SmartTelevision extends Television {
  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
  // #enddocregion

  void _bootNetworkInterface() {}
  void _initializeMemory() {}
  void _upgradeApps() {}
  // #docregion
}
