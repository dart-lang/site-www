import 'dart:mirrors';

class MyClass {
  int i, j;
  void my_method() {  }
  
  int sum() => i + j;

  MyClass(this.i, this.j);
  
  static noise() => 42;
  
  static var s;
}

main() {
  MyClass myClass = new MyClass(3, 4);
  InstanceMirror myClassInstanceMirror = reflect(myClass);
  ClassMirror MyClassMirror = myClassInstanceMirror.type;

  InstanceMirror res = myClassInstanceMirror.invoke(#sum, []);
  print('sum = ${res.reflectee}');

  var f = MyClassMirror.invoke(#noise, []);
  print('noise = $f');

  print('\nMethods:');  
  Iterable<DeclarationMirror> decls =
      MyClassMirror.declarations.values.where(
        (dm) => dm is MethodMirror && dm.isRegularMethod);
  decls.forEach((MethodMirror mm) {
    print(MirrorSystem.getName(mm.simpleName));
  });
  
  print('\nAll declarations:');
  for (var k in MyClassMirror.declarations.keys) {
    print(MirrorSystem.getName(k));
  }
  
  MyClassMirror.setField(#s, 91);
  print(MyClass.s);
}