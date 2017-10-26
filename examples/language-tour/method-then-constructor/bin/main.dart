class Person {
  Map data;
  Person.fromJson(this.data);
}

class Employee extends Person {
  Employee() : super.fromJson(findDefaultData());
  Employee.fromJson(Map data) : super.fromJson(data);

  static Map findDefaultData() => {'employeeData': 'none'};
}

void main() {
  var emp = new Employee.fromJson({});
  print(emp.data); // {}

  emp = new Employee(); // {employeeData: none}
  print(emp.data);
}
