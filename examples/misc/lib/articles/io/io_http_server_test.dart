// #docregion
import 'dart:io';

void main() async {
  final server = await HttpServer.bind('127.0.0.1', 8082);
  await for (final request in server) {
    request.response.write('Hello, world');
    await request.response.close();
  }
}
