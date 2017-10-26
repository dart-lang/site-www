import 'dart:io';
import 'dart:convert';
import 'dart:async';

Future main() async {
  var url = Uri.parse('http://127.0.0.1:8888/languages/dart');
  var httpClient = new HttpClient();
  var request = await httpClient.getUrl(url);
  print('have request');
  var response = await request.close();
  print('have response');
  var data = await response.transform(UTF8.decoder).toList();
  var body = data.join('');
  print(body);
  httpClient.close();
}
