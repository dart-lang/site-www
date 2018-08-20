import "dart:html";

void loadData() {
  var url = "http://127.0.0.1:8080/programming-languages";

  // call the web server asynchronously
  var request = HttpRequest.getString(url).then(onDataLoaded);
}

// print the raw json response text from the server
void onDataLoaded(String responseText) {
  var jsonString = responseText;
  print(jsonString);
}

main() {
  loadData();
}