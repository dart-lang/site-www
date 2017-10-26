import 'dart:html';
import 'dart:async';
import 'dart:convert' show JSON;

// A JSON-formatted file next to this page.
String jsonUri = 'data.json';
// Besides 'data.json', also try 'nodata.json' and 'nofile.json'.

// An XML-formatted file next to this page.
String xmlUri = 'data.xml';
// Besides 'data.xml', also try 'nodata.xml' and 'nofile.xml'.

Future main() async {
  var data;

  // Read a JSON file.
  try {
    data = await HttpRequest.getString(jsonUri);
    processString(data);
  } catch (e) {
    handleError(e);
  }

  // Read an XML file.
  try {
    data = await HttpRequest.request(xmlUri);
    processRequest(data);
  } catch (e) {
    handleError(e);
  }
}

void processString(String jsonText) {
  parseText(jsonText);
}

void processRequest(HttpRequest request) {
  var xmlDoc = request.responseXml;
  try {
    var license = xmlDoc.querySelector('license').text;
    print('License: $license');
  } catch (e) {
    print("$xmlUri doesn't have correct XML formatting.");
  }
}

void parseText(String jsonText) {
  var response;

  try {
    response = JSON.decode(jsonText);
  } on FormatException catch (e) {
    print("$jsonUri doesn't have correct JSON formatting.");
    print(e.message);
    return;
  }

  String name = response['name'];
  String license = response['license'];
  print('The $name project uses the $license license.');
}

// PENDING: We should do more explicit error handling, once it's available.
void handleError(int error) {
  print('Uh oh, there was an error.');
  print(error.toString());
}
