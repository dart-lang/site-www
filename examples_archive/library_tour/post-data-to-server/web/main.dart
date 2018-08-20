// XXX: Now that it's converted to async-await, we really should run this.

import 'dart:async';
import 'dart:html';

String encodeMap(Map data) {
  return data.keys.map((k) {
    return '${Uri.encodeComponent(k)}=' + '${Uri.encodeComponent(data[k])}';
  }).join('&');
}

void loadEnd(HttpRequest request) {
  if (request.status != 200) {
    print('Uh oh, error: ${request.status}');
    return;
  } else {
    print('Data has been posted');
  }
}

Future main() async {
  var dataUrl = '/registrations/create';
  var data = {'dart': 'fun', 'editor': 'productive'};
  var encodedData = encodeMap(data);

  var httpRequest = new HttpRequest();
  httpRequest.open('POST', dataUrl);
  httpRequest.setRequestHeader(
      'Content-type', 'application/x-www-form-urlencoded');
  httpRequest.send(encodedData);
  await httpRequest.onLoadEnd.first;
  loadEnd(httpRequest);
}
