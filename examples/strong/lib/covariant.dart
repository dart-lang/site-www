// ignore_for_file: annotate_overrides
class Animal {
  void chase(Animal x) {/* ... */}
}

class Mouse extends Animal {/* ... */}

class Cat extends Animal {
  @override
  void chase(covariant Mouse x) {/* ... */}
}
