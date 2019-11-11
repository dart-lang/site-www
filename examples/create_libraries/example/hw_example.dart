import 'package:create_libraries/hw_mp.dart';

main(List<String> arguments) {
  if (arguments.isEmpty) {
    alarm();
  } else {
    alarm(arguments.first);
  }
}
