// ignore_for_file: annotate_overrides
// #docregion smart-tv
class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }
  // #enddocregion smart-tv

  void _illuminateDisplay() {}
  void _activateIrSensor() {}
  // #docregion smart-tv
}

class SmartTelevision extends Television {
  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }
  // #enddocregion smart-tv

  void _bootNetworkInterface() {}
  void _initializeMemory() {}
  void _upgradeApps() {}
  // #docregion smart-tv
}
// #enddocregion smart-tv
