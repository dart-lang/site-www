// BEGIN(io_http_server)
import 'dart:io';

main() async {
  HttpServer server = await HttpServer.bind('127.0.0.1', 8082);
  await for (HttpRequest request in server) {
    request.response.write('Hello, world');
    request.response.close();
  }
}
// END(io_http_server)
