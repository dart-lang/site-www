import 'dart:html';

void miscDeclAnalyzedButNotTested() {
  const url = 'humans.txt';

  {
    // #docregion then
    HttpRequest.getString(url).then((String result) {
      print(result);
    });
    // #enddocregion then
  }

  {
    // #docregion catchError
    HttpRequest.getString(url).then((String result) {
      print(result);
    }).catchError((e) {
      // Handle or ignore the error.
    });
    // #enddocregion catchError
  }
}
