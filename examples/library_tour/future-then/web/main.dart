import 'dart:html';

void main() {
  findElements();
  replaceElement();
  displayConditionally();
  setAttribute();
  createElements();
  funWithNodes();
  funWithCss();
  handleEvents();
}

void deleteMe(Event event) {
  var text = querySelector("#sample_text_id").text;
  var buffer = new StringBuffer();
  for (int i = text.length - 1; i >= 0; i--) {
    buffer.write(text[i]);
  }
  querySelector("#sample_text_id").text = buffer.toString();
}

void findElements() {
  // Find an element by id (an-id).
  Element elem1 = querySelector('#an-id');

  // Find an element by class (a-class).
  Element elem2 = querySelector('.a-class');

  // Find all elements by tag (<div>).
  List<Element> elems1 = querySelectorAll('div');

  // Find all text inputs.
  List<Element> elems2 = querySelectorAll('input[type="text"]');

  // Find all elements with the CSS class 'class'
  // inside of a <p> that is inside an element with
  // the ID 'id'.
  List<Element> elems3 = querySelectorAll('#id p.class');
}

void replaceElement() {
  var elem = querySelector('#example') as AnchorElement;
  elem.href = 'http://dartlang.org';
}

void displayConditionally() {
  // In Dart:
  final osList = ['macos', 'windows', 'linux'];

  // In real code you'd programmatically determine userOs.
  var userOs = 'linux';

  for (var os in osList) {
    // For each possible OS...
    bool shouldShow = (os == userOs); // Matches user OS?

    // Find all elements with class=os. For example, if
    // os == 'windows', call querySelectorAll('.windows')
    // to find all elements with the class "windows".
    // Note that '.$os' uses string interpolation.
    for (var elem in querySelectorAll('.$os')) {
      elem.hidden = !shouldShow; // Show or hide.
    }
  }
}

void setAttribute() {
  Element elem = querySelector('#shy');

  // Set a non-existent attribute. No error checking/complaints!
  elem.attributes['someAttribute'] = 'someValue';

  elem.attributes['hidden'] = 'true';
  // elem.hidden = true;  // BETTER!
}

void createElements() {
  var elem = new ParagraphElement();
  elem.text = 'Creating is easy!';
  document.body.children.add(elem);

  var elem2 = new Element.html('<p>Creating <em>is</em> easy!</p>');
  document.body.children.add(elem2);
}

void funWithNodes() {
  var elem = new Element.html('<p>Some <b>styled</b> text.</p>');

  // Find the parent by ID, and add elem as its last child.
  querySelector('#inputs').nodes.add(elem);

  // Find a node by ID, and replace it in the DOM.
  querySelector('#status').replaceWith(elem);

  // Find a node by ID, and remove it from the DOM.
  querySelector('#expendable').remove();
}

void funWithCss() {
  var element = querySelector('#message');
  element.classes.add('warning');
//
//  var message = new DivElement();
//  message.id = 'message2';
//  message.text = 'Please subscribe to the Dart mailing list.';

  var message = new DivElement()
    ..id = 'message2'
    ..text = 'Please subscribe to the Dart mailing list.';

  message.style
    ..fontWeight = 'bold'
    ..fontSize = '2em';

  querySelector("#fun-with-css").children.add(message);
}

void handleEvents() {
  // Find a button by ID and add an event handler.
  querySelector('#submitInfo').onClick.listen((_) {
    // When the button is clicked, it runs this code.
    submitData();
  });

  document.body.onClick.listen((e) {
    var clickedElement = e.target as ButtonElement;
    var id = clickedElement.id;
    var description;

    if (id != null && id.length > 0) {
      description = 'the "$id"';
    } else {
      description = 'a <${clickedElement.tagName}>';
    }

    print('You clicked $description element.');
  });
}

void submitData() {
  print('data submitted');
}
