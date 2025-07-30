// #docregion target-kinds
import 'package:meta/meta_meta.dart';

@Target({TargetKind.function, TargetKind.method})
// #docregion definition
class Todo {
  // #enddocregion target-kinds
  final String who;
  final String what;

  const Todo(this.who, this.what);
  // #docregion target-kinds
}

// #enddocregion definition, target-kinds
