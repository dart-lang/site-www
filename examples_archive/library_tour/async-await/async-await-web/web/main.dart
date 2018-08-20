import 'dart:async';
import 'dart:html';

String url = 'humans.txt';

void main() {
  printRobots();
  printRobotsAndHandleErrors();
  querySelector("#button1").onClick.listen(handleClick);
}

void handleClick(MouseEvent event) {
  print('click!');
}

Future printRobots() async {
  var result = await HttpRequest.getString(url);
  print(result);
  // Should handle errors here.
}

Future printRobotsAndHandleErrors() async {
  try {
    var result = await HttpRequest.getString(url);
    print(result);
  } catch (e) {
    // Handle or ignore the error.
    print('Oops, couldn\'t get $url: $e');
  }
}
