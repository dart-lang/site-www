import 'dart:convert';
import 'dart:html';
HttpRequest request;

void saveData() {
  
  // snip setting up HttpRequest

  var mapData = new Map();
  mapData["language"] = "dart";
  mapData["targets"] = new List();
  mapData["targets"].add("dartium");

  String jsonData = JSON.encode(mapData); // convert map to String
  request.send(jsonData); // perform the async POST
}