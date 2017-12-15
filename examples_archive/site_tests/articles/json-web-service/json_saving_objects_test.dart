import 'dart:html';

void saveData() {
  HttpRequest request = new HttpRequest(); // create a new XHR
  
  // add an event handler that is called when the request finishes
  request.onReadyStateChange.listen((_) {
    if (request.readyState == HttpRequest.DONE &&
        (request.status == 200 || request.status == 0)) {
      // data saved OK.
      print(request.responseText); // output the response from the server
    }
  });

  // POST the data to the server
  var url = "http://127.0.0.1:8080/programming-languages";
  request.open("POST", url, async: false);

  String jsonData = '{"language":"dart"}'; // etc...
  request.send(jsonData); // perform the async POST
}
