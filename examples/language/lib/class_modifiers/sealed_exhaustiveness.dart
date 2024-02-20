sealed class Amigo {}

class Lucky extends Amigo {}

class Dusty extends Amigo {}

class Ned extends Amigo {}

String lastName(Amigo amigo) => switch (amigo) {
      Lucky _ => 'Day',
      Dusty _ => 'Bottoms',
      Ned _ => 'Nederlander',
    };
