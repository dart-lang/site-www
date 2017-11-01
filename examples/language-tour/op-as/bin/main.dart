// #docregion
class Person {
  String firstName;

  Person.fromJson(Map data) {
    print('in Person');
  }
}

class Employee extends Person {
  // Person does not have a default constructor;
  // you must call super.fromJson(data).
  Employee.fromJson(Map data) : super.fromJson(data) {
    print('in Employee');
  }
}

void main() {
  var emp = new Employee.fromJson({});

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
