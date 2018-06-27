import 'dart:async';
import 'dart:io';

int stopAfter = 10;
// #docregion
Future main() async {
  final requests = await HttpServer.bind('localhost', 8888);
  // #enddocregion
  final _requests = requests.take(stopAfter);
  // #docregion
  await for (var request in _requests) {
    processRequest(request);
  }
}

void processRequest(HttpRequest request) {
  print('Got request for ${request.uri.path}');
  final response = request.response;
  if (request.uri.path == '/dart') {
    response
      ..headers.contentType = ContentType(
        'text',
        'plain',
      )
      ..write('Hello from the server');
  } else {
    response.statusCode = HttpStatus.notFound;
  }
  response.close();
}
