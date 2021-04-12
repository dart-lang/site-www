import 'dart:html';

void miscDeclAnalyzedButNotTested() {
  {
    void submitData() {}
    var submitButton = querySelector('#submitInfo')!;
    // #docregion listen
    // Add an event handler to a button.
    submitButton.onClick.listen((e) {
      // When the button is clicked, it runs this code.
      submitData();
    });
    // #enddocregion listen
  }
}
