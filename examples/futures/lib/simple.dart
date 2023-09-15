// ignore_for_file: dead_code, invalid_return_type_for_catch_error, one_member_abstracts

import 'dart:async';

import 'package:examples_util/ellipsis.dart';
import 'package:futures_examples/util.dart';

void simpleCallbacks() {
  {
    // #docregion then-catch
    myFunc().then(processValue).catchError(handleError);
    // #enddocregion then-catch
  }

  {
    // #docregion comprehensive-errors
    myFunc().then((value) {
      doSomethingWith(value);
      ellipsis();
      throw Exception('Some arbitrary error');
    }).catchError(handleError);
    // #enddocregion comprehensive-errors
  }

  {
    // #docregion throws-then-catch
    asyncErrorFunction().then(successCallback, onError: (e) {
      handleError(e); // Original error.
      anotherAsyncErrorFunction(); // Oops, new error.
    }).catchError(handleError); // Error from within then() handled.
    // #enddocregion throws-then-catch
  }

  {
    dynamic connectToServer() {}

    const myUrl = 'https://dart.dev';

    // #docregion connect-server
    final server = connectToServer();
    server
        .post(myUrl, fields: const {'name': 'Dash', 'profession': 'mascot'})
        .then(handleResponse)
        .catchError(handleError)
        .whenComplete(server.close);
    // #enddocregion connect-server
  }
}

abstract class FakeFuture<T> {
  // #docregion future-then
  Future<R> then<R>(FutureOr<R> Function(T value) onValue, {Function? onError});
  // #enddocregion future-then

  // #docregion future-catch-error
  Future<T> catchError(Function onError, {bool Function(Object error)? test});
  // #enddocregion future-catch-error
}

// #docregion auth-response
void main() {
  handleAuthResponse(const {'username': 'dash', 'age': 3})
      .then((_) => ellipsis())
      .catchError(handleFormatException, test: (e) => e is FormatException)
      .catchError(handleAuthorizationException,
          test: (e) => e is AuthorizationException);
}
// #enddocregion auth-response

String doSomethingWith(dynamic value) {
  return 'value';
}

Future<Object> anotherAsyncErrorFunction() {
  throw Exception('Also threw an exception');
}

Future<Object> handleResponse() => Future.value('Response');

Object successCallback(dynamic value) async {
  return '';
}

Future<Object> myFunc() => Future.value('42');

Future<Object> handleAuthResponse(Map<String, dynamic> data) {
  return Future.value('Response');
}

void handleFormatException(Object exception) {}

void handleAuthorizationException(Object exception) {}

class AuthorizationException implements Exception {}
