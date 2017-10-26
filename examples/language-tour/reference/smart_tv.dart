class Television {
  void turnOn() {
    _illuminateDisplay();
    _activateIrSensor();
  }

  void _illuminateDisplay() {}
  void _activateIrSensor() {}
}

class SmartTelevision extends Television {
  void turnOn() {
    super.turnOn();
    _bootNetworkInterface();
    _initializeMemory();
    _upgradeApps();
  }

  void _bootNetworkInterface() {}
  void _initializeMemory() {}
  void _upgradeApps() {}
}
