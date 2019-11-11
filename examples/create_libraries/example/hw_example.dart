// #docregion import
import 'package:create_libraries/hw_mp.dart';
// #enddocregion import

main(List<String> arguments) {
  if (arguments.isEmpty) {
    alarm();
  } else {
    alarm(arguments.first);
  }
}
