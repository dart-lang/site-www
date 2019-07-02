// #docregion
import 'dart:io';

Future<void> main() async {
  final server = await HttpServer.bind('127.0.0.1', 8082);
  await for (HttpRequest request in server) {
    request.response.write('Hello, world');
    await request.response.close();
  }
}
