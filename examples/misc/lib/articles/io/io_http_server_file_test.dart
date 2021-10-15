// #docregion
import 'dart:io';

Future<void> runServer(String basePath) async {
  final server = await HttpServer.bind('127.0.0.1', 8082);
  await for (final request in server) {
    await handleRequest(basePath, request);
  }
}

Future<void> handleRequest(String basePath, HttpRequest request) async {
  final String path = request.uri.toFilePath();
  // PENDING: Do more security checks here.
  final String resultPath = path == '/' ? '/index.html' : path;
  final File file = File('$basePath$resultPath');
  if (await file.exists()) {
    try {
      await request.response.addStream(file.openRead());
    } catch (exception) {
      print('Error happened: $exception');
      await sendInternalError(request.response);
    }
  } else {
    await sendNotFound(request.response);
  }
}

Future<void> sendInternalError(HttpResponse response) async {
  response.statusCode = HttpStatus.internalServerError;
  await response.close();
}

Future<void> sendNotFound(HttpResponse response) async {
  response.statusCode = HttpStatus.notFound;
  await response.close();
}

Future<void> main() async {
  // Compute base path for the request based on the location of the
  // script, and then start the server.
  final script = File(Platform.script.toFilePath());
  await runServer(script.parent.path);
}
