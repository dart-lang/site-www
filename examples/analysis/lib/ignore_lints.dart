// #docregion ignore_type_for_file
// ignore_for_file: type=lint
// #enddocregion ignore_type_for_file

void main() {
  String unnecessarilyTyped = '' + "2342";
  unnecessarilyTyped += '${""}';
  print(unnecessarilyTyped);
}
