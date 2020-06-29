// ignore_for_file: type_annotate_public_apis, unused_element
// #docregion main-async, main-future-api
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.
// #enddocregion main-async, main-future-api

// The three versions of "print daily news" are next.
//
// - sync
// - async
// - async using Futures API

// #docregion sync
// Synchronous code
void _printDailyNewsDigestSync() {
  var newsDigest = _gatherNewsReportsSync(); // Can take a while.
  print(newsDigest);
}
// #enddocregion sync

// #docregion main-async
Future<void> _printDailyNewsDigestAsync() async {
  var newsDigest = await _gatherNewsReportsAsync();
  print(newsDigest);
}
// #enddocregion main-async

// #docregion main-future-api
Future<void> _printDailyNewsDigestAsyncUsingFutureAPI() {
  final future = _gatherNewsReportsAsync();
  return future.then(print);
  // You don't *have* to return the future here.
  // But if you don't, callers can't await it.
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
Duration oneSecond = Duration(seconds: 1);

// #enddocregion main-async, main-future-api
String _gatherNewsReportsSync() => news;

// #docregion main-async, main-future-api
// Imagine that this function is more complex and slow. :)
Future<String> _gatherNewsReportsAsync() =>
    Future.delayed(oneSecond, () => news);

// Alternatively, you can get news from a server using features
// from either dart:io or dart:html. For example:
//
// import 'dart:html';
//
// Future<String> _gatherNewsReportsFromServer() => HttpRequest.getString(
//      'https://dart.dev/f/dailyNewsDigest.txt',
//    );
// #enddocregion main-async, main-future-api

//----------------------------------------------------------------------------
// Extra function variants below here

// #docregion try-catch
Future<void> _printDailyNewsDigestAsyncWithTryCatch() async {
  try {
    var newsDigest = await _gatherNewsReportsAsync();
    print(newsDigest);
  } catch (e) {
    // Handle error...
  }
}
// #enddocregion try-catch

Future<void> _printDailyNewsDigestAsyncUsingFutureApiPassPrint() {
  final future = _gatherNewsReportsAsync();
  // #docregion main-future-api-dont-pass-print
  future.then((newsDigest) => print(newsDigest))
      // #enddocregion main-future-api-dont-pass-print
      ;
  return future;
}

// #docregion main-future-api-using-braces
Future<void> _printDailyNewsDigestAsyncUsingFutureApiAndBraces() {
  final future = _gatherNewsReportsAsync();
  return future.then((newsDigest) {
    print(newsDigest);
    // Do something else...
  });
}
// #enddocregion main-future-api-using-braces

_noArgFuture() {
  // #docregion main-future-api-then-no-arg
  final future = _printDailyNewsDigestAsync();
  return future.then((_) {
    // Code that doesn't use the `_` parameter...
    print('All reports printed.');
  });
  // #enddocregion main-future-api-then-no-arg
}

handleError(_) {}

// #docregion future-api-try-catch
Future<void> _printDailyNewsDigestAsyncFutureApiWithTryCatch() => //!<br>
    _gatherNewsReportsAsync().then(print).catchError(handleError);
// #enddocregion future-api-try-catch
