// Note: all commented out code fails the static type checker
import 'dart:html';
//import 'package:js/js.dart' as js;
var js;

void main() {
  js.scoped(() {
    // create a top-level JavaScript function called myJsonpCallback
    //js.context.myJsonpCallback = new js.Callback.once( (jsonData) {
    //  print(jsonData); // js.Proxy object containing the data
    //                   // see js interop docs
    //});

    // add a script tag for the api required
    ScriptElement script = new Element.tag("script");
    // add the callback function name to the URL
    script.src = "http://example.com/some/api?callback=myJsonpCallback";
    document.body.children.add(script); // add the script to the DOM
  });
}
