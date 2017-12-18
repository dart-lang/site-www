// ignore_for_file: unused_local_variable, one_member_abstracts
// #docplaster

void miscDeclAnalyzedButNotTested() {
  {
    var done, col;
    // #docregion op-logical
    if (!done && (col == 0 || col == 3)) {
      // ...Do something...
    }
    // #enddocregion op-logical
  }

  {
    bool isPublic = true;
    // #docregion if-then-else-operator
    var visibility = isPublic ? 'public' : 'private';
    // #enddocregion if-then-else-operator
  }

  {
    // #docregion nested-cascades
    final addressBook = (new AddressBookBuilder()
          ..name = 'jenny'
          ..email = 'jenny@example.com'
          ..phone = (new PhoneNumberBuilder()
                ..number = '415-555-0100'
                ..label = 'home')
              .build())
        .build();
    // #enddocregion nested-cascades
  }

  {
    // #docregion cannot-cascade-on-void
    var sb = new StringBuffer();
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

abstract class Builder<T> {
  T build();
}

class PhoneNumber {
  String number, label;
}

class PhoneNumberBuilder extends PhoneNumber with Builder<PhoneNumber> {
  @override
  PhoneNumber build() => null;
}

class AddressBook {
  String name, email;
  PhoneNumber phone;
}

class AddressBookBuilder extends AddressBook with Builder<AddressBook> {
  @override
  AddressBook build() => null;
}
