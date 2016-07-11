// Note: all commented out code fails the static type checker
//import "package:json_object/json_object.dart";
import "dart:html";

void onDataLoaded(HttpRequest req) {
  // decode the JSON response text using JsonObject
  //JsonObject data = new JsonObject.fromJsonString(req.responseText);
  var data;

  // dot notation property access
  print(data.language);         // Get a simple value
  data.language = "Dart";       // Set a simple value
  print(data.targets[0]);       // Get a value in a list
  // iterate the website map
  data.website.forEach((key, value) => print("$key=$value")); 
}
