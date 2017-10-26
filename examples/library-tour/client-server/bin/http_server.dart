import 'dart:io';
import 'dart:async';

Future main() async {
  void dartHandler(HttpRequest request) {
    request.response.headers.contentType = new ContentType('text', 'plain');
    request.response.write('Sending a response');
    request.response.close();
  }

  var requests = await HttpServer.bind('127.0.0.1', 8888);
  await for (var request in requests) {
    print('Got request for ${request.uri.path}');
    if (request.uri.path == '/languages/dart') {
      dartHandler(request);
    } else {
      request.response.write('Not found');
      request.response.close();
    }
  }
}
