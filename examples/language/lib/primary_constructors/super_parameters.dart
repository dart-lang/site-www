abstract class Widget {
  final Key? key;
  const Widget({this.key});
}

abstract class Key {
  const Key();
}

abstract class StatelessWidget extends Widget {
  const StatelessWidget({super.key});
}

// #docregion super-parameters
class A(final int a);

class B(super.a) extends A;
// #enddocregion super-parameters

// #docregion widget-example
class MyWidget({super.key, required final String title})
    extends StatelessWidget;
// #enddocregion widget-example

