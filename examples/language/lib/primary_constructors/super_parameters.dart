// #docregion super-parameters
class Person(final String name, final int age);

class Employee(super.name, super.age, final String role) extends Person;
// #enddocregion super-parameters
