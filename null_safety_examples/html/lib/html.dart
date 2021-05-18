// ignore_for_file: unused_element, unused_local_variable
// #docregion import
import 'dart:html';
// #enddocregion import

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion querySelector
    // Find an element by id (an-id).
    Element idElement = querySelector('#an-id')!;

    // Find an element by class (a-class).
    Element classElement = querySelector('.a-class')!;

    // Find all elements by tag (<div>).
    List<Element> divElements = querySelectorAll('div');

    // Find all text inputs.
    List<Element> textInputElements = querySelectorAll(
      'input[type="text"]',
    );

    // Find all elements with the CSS class 'class'
    // inside of a <p> that is inside an element with
    // the ID 'id'.
    List<Element> specialParagraphElements = querySelectorAll('#id p.class');
    // #enddocregion querySelector
  }

  {
    Element elem = querySelector('#an-id')!;
    // #docregion attributes
    elem.attributes['someAttribute'] = 'someValue';
    // #enddocregion attributes
  }

  {
    // #docregion creating-elements
    var elem = ParagraphElement();
    elem.text = 'Creating is easy!';
    // #enddocregion creating-elements

    // #docregion creating-from-html
    var elem2 = Element.html(
      '<p>Creating <em>is</em> easy!</p>',
    );
    // #enddocregion creating-from-html

    // #docregion body-children-add
    document.body!.children.add(elem2);
    // #enddocregion body-children-add

    // #docregion nodes-add
    querySelector('#inputs')!.nodes.add(elem);
    // #enddocregion nodes-add

    // #docregion replaceWith
    querySelector('#status')!.replaceWith(elem);
    // #enddocregion replaceWith

    // #docregion remove
    // Find a node by ID, and remove it from the DOM if it is found.
    querySelector('#expendable')?.remove();
    // #enddocregion remove
  }

  {
    // #docregion classes-add
    var elem = querySelector('#message')!;
    elem.classes.add('warning');
    // #enddocregion classes-add

    // #docregion set-id
    var message = DivElement();
    message.id = 'message2';
    message.text = 'Please subscribe to the Dart mailing list.';
    // #enddocregion set-id
  }

  {
    // #docregion elem-set-cascade
    var message = DivElement()
      ..id = 'message2'
      ..text = 'Please subscribe to the Dart mailing list.';
    // #enddocregion elem-set-cascade

    // #docregion set-style
    message.style
      ..fontWeight = 'bold'
      ..fontSize = '3em';
    // #enddocregion set-style

    void submitData() {}
    // #docregion onClick
    // Find a button by ID and add an event handler.
    querySelector('#submitInfo')!.onClick.listen((e) {
      // When the button is clicked, it runs this code.
      submitData();
    });
    // #enddocregion onClick

    // #docregion target
    document.body!.onClick.listen((e) {
      final clickedElem = e.target;
      // ...
    });
    // #enddocregion target
  }

  Future<void> tryGetString() async {
    String jsonUri = 'data.json';
    // #docregion try-getString
    try {
      var data = await HttpRequest.getString(jsonUri);
      // Process data...
    } catch (e) {
      // Handle exception...
    }
    // #enddocregion try-getString
  }

  {
    var encodedData = 'encoded data';
    var url = 'random-url';
    void requestComplete(HttpRequest req) {}
    // #docregion new-HttpRequest
    var request = HttpRequest();
    request
      ..open('POST', url)
      ..onLoadEnd.listen((e) => requestComplete(request))
      ..send(encodedData);
    // #enddocregion new-HttpRequest
  }
}
