// ignore_for_file: unused_local_variable, dead_code

void miscDeclAnalyzedButNotTested() {
  (bool done, int col) {
    // #docregion op-logical
    if (!done && (col == 0 || col == 3)) {
      // ...Do something...
    }
    // #enddocregion op-logical
  };

  {
    bool isPublic = true;
    // #docregion if-then-else-operator
    var visibility = isPublic ? 'public' : 'private';
    // #enddocregion if-then-else-operator
  }

  {
    // #docregion nested-cascades
    final addressBook = (AddressBookBuilder()
          ..name = 'jenny'
          ..email = 'jenny@example.com'
          ..phone = (PhoneNumberBuilder()
                ..number = '415-555-0100'
                ..label = 'home')
              .build())
        .build();
    // #enddocregion nested-cascades
  }

  {
    // #docregion cannot-cascade-on-void
    var sb = StringBuffer();
    sb.write('foo')
        // #enddocregion cannot-cascade-on-void
        /*
      // #docregion cannot-cascade-on-void
      ..write('bar'); // Error: method 'write' isn't defined for 'void'.
      // #enddocregion cannot-cascade-on-void
      */
        ;
  }
}

// Minimal class definitions in support of nested-cascades

mixin Builder<T> {
  T build();
}

class PhoneNumber {
  String number = '', label = '';
}

class PhoneNumberBuilder extends PhoneNumber with Builder<PhoneNumber> {
  @override
  PhoneNumber build() => PhoneNumber();
}

class AddressBook {
  String name = '', email = '';
  PhoneNumber phone = PhoneNumber();
}

class AddressBookBuilder extends AddressBook with Builder<AddressBook> {
  @override
  AddressBook build() => AddressBook();
}
