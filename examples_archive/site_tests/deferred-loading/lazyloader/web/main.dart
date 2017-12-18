import 'dart:html';

import "package:lazyloader/breakfast.dart" deferred as breakfast;
import "package:lazyloader/lunch.dart"     deferred as lunch;
import "package:lazyloader/dinner.dart"    deferred as dinner;

main() {
  querySelector('#show-breakfast').onClick.listen((_) {
    breakfast.loadLibrary().then(onBreakfastLoaded);
  });
  querySelector('#show-lunch').onClick.listen((_) {
    lunch.loadLibrary().then(onLunchLoaded);
  });
  querySelector('#show-dinner').onClick.listen((_) {
    dinner.loadLibrary().then(onDinnerLoaded);
  });
}

void onBreakfastLoaded(e) {
  print('breakfast loaded');
  changeMenu(breakfast.menu);
}

void onLunchLoaded(e) {
  print('lunch loaded');
  changeMenu(lunch.menu);
}

void onDinnerLoaded(e) {
  print('dinner loaded');
  changeMenu(dinner.menu);
}

void changeMenu(String menu) {
  var el = querySelector("#text_id");
  el.text = menu;
}
