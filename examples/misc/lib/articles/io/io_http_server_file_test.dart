// #docregion
import 'dart:async' show Future;
import 'dart:io';

_sendNotFound(HttpResponse response) {
  response.statusCode = HttpStatus.notFound;
  response.close();
}

Future<void> startServer(String basePath) async {
  HttpServer server = await HttpServer.bind('127.0.0.1', 8082);
  await for (HttpRequest request in server) {
    final String path = request.uri.toFilePath();
    // PENDING: Do more security checks here.
    final String resultPath = path == '/' ? '/index.html' : path;
    final File file = File('${basePath}${resultPath}');
    if (await file.exists()) {
      try {
        await file.openRead().pipe(request.response);
      } catch (e) {
        print(e);
      }
    } else {
      _sendNotFound(request.response);
    }
  }
}

void main() {
  // Compute base path for the request based on the location of the
  // script and then start the server.
  File script = File(Platform.script.toFilePath());
  startServer(script.parent.path);
}
