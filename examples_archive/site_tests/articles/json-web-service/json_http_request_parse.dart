import "dart:convert";
import "dart:html";

void onDataLoaded(HttpRequest req) {
  Map data = JSON.decode(req.responseText); // parse response text
  print(data["language"]); // dart
  print(data["targets"][0]); // dartium
  print(data["website"]["homepage"]); // www.dartlang.org
}