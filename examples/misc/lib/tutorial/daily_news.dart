// ignore_for_file: type_annotate_public_apis, unused_element
// #docregion main-async, main-future-api
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';

// #enddocregion main-async, main-future-api

// The three versions of "print daily news" are next.
//
// - sync
// - async
// - async using Futures API

// #docregion sync
// Synchronous code
_printDailyNewsDigestSync() {
  String news = _gatherNewsReportsSync(); // Can take a while.
  print(news);
}
// #enddocregion sync

// #docregion main-async
Future _printDailyNewsDigestAsync() async {
  String news = await _gatherNewsReportsAsync();
  print(news);
}
// #enddocregion main-async

// #docregion main-future-api
_printDailyNewsDigestAsyncUsingFutureAPI() {
  final future = _gatherNewsReportsAsync();
  future.then((news) => print(news));
}
// #enddocregion main-future-api

// We have two versions of main: sync and async.

// #docregion sync, main-async, main-future-api

main() {
  // #enddocregion main-async, main-future-api, sync
  mainAsync();
}

mainSync() => printNewsAndMore(_printDailyNewsDigestSync);

Future mainAsync() {
  // Return the daily news future so that the
  // test harness has something to wait on.
  final future = _printDailyNewsDigestAsync();
  printNewsAndMore(() => future);
  return future;
}

printNewsAndMore(Function _printDailyNewsDigest) {
  // #docregion main-async, main-future-api, sync
  _printDailyNewsDigest();
  _printWinningLotteryNumbers();
  _printWeatherForecast();
  _printBaseballScore();
}
// #enddocregion sync

_printWinningLotteryNumbers() {
  print('Winning lotto numbers: [23, 63, 87, 26, 2]');
}

_printWeatherForecast() {
  print("Tomorrow's forecast: 70F, sunny.");
}

_printBaseballScore() {
  print('Baseball score: Red Sox 10, Yankees 0');
}

const news = '<gathered news goes here>';
Duration oneSecond = const Duration(seconds: 1);

// #enddocregion main-async, main-future-api
String _gatherNewsReportsSync() => news;

// #docregion main-async, main-future-api
final newsStream = Stream<String>.periodic(oneSecond, (_) => news);

// Imagine that this function is more complex and slow. :)
Future<String> _gatherNewsReportsAsync() => newsStream.first;

// Alternatively, you can get news from a server using features
// from either dart:io or dart:html. For example:
//
// import 'dart:html';
//
// Future _gatherNewsReportsFromServer() => HttpRequest.getString(
//      'https://www.dartlang.org/f/dailyNewsDigest.txt',
//    );
// #enddocregion main-async, main-future-api

//----------------------------------------------------------------------------
// Extra function variants below here

// #docregion try-catch
_printDailyNewsDigestAsyncWithTryCatch() async {
  try {
    String news = await _gatherNewsReportsAsync();
    print(news);
  } catch (e) {
    // Handle error...
  }
}
// #enddocregion try-catch

// #docregion main-future-api-using-braces
_printDailyNewsDigestAsyncUsingFutureApiAndBraces() {
  final future = _gatherNewsReportsAsync();
  future.then((news) {
    print(news);
    // Do something else...
  });
}
// #enddocregion main-future-api-using-braces

// #docregion main-future-api-pass-print
_printDailyNewsDigestAsyncUsingFutureApiPassPrint() =>
    _gatherNewsReportsAsync().then(print);
// #enddocregion main-future-api-pass-print

handleError(_) {}

// #docregion future-api-try-catch
_printDailyNewsDigestAsyncFutureApiWithTryCatch() => //!<br>
    _gatherNewsReportsAsync()
        .then((news) => print(news))
        .catchError((e) => handleError(e));
// #enddocregion future-api-try-catch
