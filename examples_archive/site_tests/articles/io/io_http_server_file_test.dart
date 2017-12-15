// BEGIN(io_http_server_file)
import 'dart:io';

_sendNotFound(HttpResponse response) {
  response.statusCode = HttpStatus.NOT_FOUND;
  response.close();
}

startServer(String basePath) async {
  HttpServer server = await HttpServer.bind('127.0.0.1', 8082);
  await for (HttpRequest request in server) {
    final String path = request.uri.toFilePath();
    // PENDING: Do more security checks here.
    final String resultPath = path == '/' ? '/index.html' : path;
    final File file = new File('${basePath}${resultPath}');
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

main() {
  // Compute base path for the request based on the location of the
  // script and then start the server.
  File script = new File(Platform.script.toFilePath());
  startServer(script.parent.path);
}
// END(io_http_server_file)
