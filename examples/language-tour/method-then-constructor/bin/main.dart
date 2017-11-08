class Person {
  Map data;
  Person.fromJson(this.data);
}

// #docregion
class Employee extends Person {
  Employee() : super.fromJson(findDefaultData());
  // #enddocregion
  Employee.fromJson(Map data) : super.fromJson(data);

  static Map findDefaultData() => {'employeeData': 'none'};
  // #docregion
}
// #enddocregion

void main() {
  var emp = new Employee.fromJson({});
  print(emp.data); // {}

  emp = new Employee(); // {employeeData: none}
  print(emp.data);
}
