import 'dart:html';
import 'dart:convert' show JSON;

void main() {
  querySelector('#getColors').onClick.listen(showColors); // Event handling.
}
void showColors(Event e) {
  HttpRequest.getString('colors.json')             // One-line HTTP request.
      .then((String jsonString) {                   // Uses Futures and Streams.
        UListElement colors = querySelector('#colors');  // DOM element types.
        List colorList = JSON.decode(jsonString);
        for (int i = 0; i < colorList.length; i++) {
          colors.children.add(                      // Dynamic DOM manipulation.
            new LIElement()..text = colorList[i]    // Dynamic element creation.
             ..style.color = colorList[i]           // Uniform CSS styles.
             ..style.fontFamily = 'Marker Felt');
        }
      })
      .catchError((_) { /* Handle error. */ });
}
