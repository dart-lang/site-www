import 'dart:html';

void miscDeclAnalyzedButNotTested() {
  {
    void submitData() {}
    // #docregion listen
    // Find a button by ID and add an event handler.
    querySelector('#submitInfo').onClick.listen((e) {
      // When the button is clicked, it runs this code.
      submitData();
    });
    // #enddocregion listen
  }
}
