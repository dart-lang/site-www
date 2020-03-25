// ignore_for_file: unnecessary_cast, sort_constructors_first

Map get defaultData => {}; // stub

// #docregion
class Person {
  String firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

// #docregion method-then-constructor
class Employee extends Person {
  // #enddocregion ''
  Employee() : super.fromJson(defaultData);
  // #enddocregion method-then-constructor
  // #docregion
  // Person does not have a default constructor;
  // you must call super.fromJson(data).
  Employee.fromJson(Map data) : super.fromJson(data) {
    print('in Employee');
  }
// #docregion method-then-constructor
}
// #enddocregion method-then-constructor

void main() {
  var emp = Employee.fromJson({});
  // Prints:
  // in Person
  // in Employee

  // #docregion emp-is-Person
  if (emp is Person) {
    // Type check
    emp.firstName = 'Bob';
  }
  // #enddocregion emp-is-Person
  // #docregion emp-as-Person
  (emp as Person).firstName = 'Bob';
  // #enddocregion emp-as-Person
}
