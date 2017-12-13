// #docplaster
// #docregion import
import 'dart:mirrors';
// #enddocregion import
import 'package:test/test.dart';
import 'package:dartlang_examples_util/print_matcher.dart' as m;

void main() {
  test('Symbol', () {
    String askUserForNameOfFunction() => 'toString';
    // #docregion Symbol
    // If the symbol name is known at compile time.
    const className = #MyClass;

    // If the symbol name is dynamically determined.
    var userInput = askUserForNameOfFunction();
    var functionName = new Symbol(userInput);
    // #enddocregion Symbol
    expect(className.toString(), 'Symbol("MyClass")');
    expect(functionName.toString(), 'Symbol("toString")');
  });

  test('getName', () {
    // #docregion getName
    const className = #MyClass;
    assert('MyClass' == MirrorSystem.getName(className));
    // #enddocregion getName
  });

  test('ClassMirror', () {
    // #docregion ClassMirror
    ClassMirror mirror = reflectClass(Person);

    assert('Person' == MirrorSystem.getName(mirror.simpleName));
    // #enddocregion ClassMirror
  });

  test('runtimeType', () {
    // #docregion runtimeType
    var person = new Person('Bob', 'Smith', 33);
    ClassMirror mirror = reflectClass(person.runtimeType);
    assert('Person' == MirrorSystem.getName(mirror.simpleName));
    // #enddocregion runtimeType
  });

  test('showConstructors', () {
    // #docregion showConstructors
    void showConstructors(ClassMirror mirror) {
      var constructors = mirror.declarations.values
          .where((m) => m is MethodMirror && m.isConstructor);

      constructors.forEach((m) {
        MethodMirror mm = m as MethodMirror;
        print('The constructor ${mm.simpleName} has '
            '${mm.parameters.length} parameters.');
      });
    }
    // #enddocregion showConstructors

    ClassMirror mirror = reflectClass(Person);
    expect(() => showConstructors(mirror),
        m.prints('The constructor Symbol("Person") has 3 parameters.'));
  });

  const fieldInfo =
      '''The field Symbol("firstName") is not private and not final and is annotated as Symbol("String").
The field Symbol("lastName") is not private and not final and is annotated as Symbol("String").
The field Symbol("age") is not private and not final and is annotated as Symbol("int").
''';

  test('showFields', () {
    // #docregion showFields
    void showFields(ClassMirror mirror) {
      var fields = mirror.declarations.values.where((m) => m is VariableMirror);

      fields.forEach((m) {
        final v = m as VariableMirror;
        var finalStatus = v.isFinal ? 'final' : 'not final';
        var privateStatus = v.isPrivate ? 'private' : 'not private';
        var typeAnnotation = v.type.simpleName;

        print('The field ${v.simpleName} is $privateStatus ' +
            'and $finalStatus and is annotated as ' +
            '$typeAnnotation.');
      });
    }

    // #enddocregion showFields
    ClassMirror mirror = reflectClass(Person);
    expect(() => showFields(mirror), prints(fieldInfo));
  });

  test('InstanceMirror', () {
    void main() {
      // #docregion InstanceMirror, invoke, getField-setField
      var p = new Person('Bob', 'Smith', 42);
      InstanceMirror mirror = reflect(p);
      // #enddocregion InstanceMirror, invoke, getField-setField
      // #docregion reflectee
      var person = mirror.reflectee;
      assert(identical(p, person));
      // #enddocregion reflectee
      // #docregion invoke

      mirror.invoke(#greet, ['Sundar']);
      // #enddocregion invoke
      // #docregion getField-setField

      // Get the value of a property.
      var fullName = mirror.getField(#fullName).reflectee;
      assert(fullName == 'Bob Smith');

      // Set the value of a property.
      mirror.setField(#firstName, 'Mary');
      assert(p.firstName == 'Mary');
      assert(p.fullName == 'Mary Smith');
      // #enddocregion getField-setField
    }

    expect(main, prints('Hello there, Sundar!\n'));
  });

  test('getField()/setField()', () {});
}

// #docregion Person
class Person {
  String firstName;
  String lastName;
  int age;

  Person(this.firstName, this.lastName, this.age);

  String get fullName => '$firstName $lastName';

  void greet(String other) {
    print('Hello there, $other!');
  }
}
