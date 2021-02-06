// ignore_for_file: unnecessary_cast, sort_constructors_first

Map fetchDefaultData() => {}; // stub

// #docregion super
class Person {
  String? firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

// #docregion method-then-constructor
class Employee extends Person {
  // #enddocregion super
  Employee() : super.fromJson(fetchDefaultData());
  // #enddocregion method-then-constructor
  // #docregion super
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
  print(emp);
  // Prints:
  // in Person
  // in Employee
  // Instance of 'Employee'
  // #enddocregion super
  // #docregion emp-is-Person
  if (emp is Person) {
    // Type check
    emp.firstName = 'Bob';
  }
  // #enddocregion emp-is-Person
  // #docregion emp-as-Person
  (emp as Person).firstName = 'Bob';
  // #enddocregion emp-as-Person
// #docregion super
}
// #enddocregion super
