import 'package:http/http.dart';

void miscDeclAnalyzedButNotTested() {
  final url = Uri.parse('humans.txt');
  final httpClient = Client();

  {
    // #docregion then
    httpClient.read(url).then((String result) {
      print(result);
    });
    // #enddocregion then
  }

  {
    // #docregion catchError
    httpClient.read(url).then((String result) {
      print(result);
    }).catchError((e) {
      // Handle or ignore the error.
    });
    // #enddocregion catchError
  }
}
