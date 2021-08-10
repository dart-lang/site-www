// ignore_for_file: dead_code, only_throw_errors

import 'package:test/test.dart';

void main() {
  test('try_on_catch', () {
    expect(() {
      // #docregion try-on-catch
      try {
        breedMoreLlamas();
      } on OutOfLlamasException {
        // A specific exception
        buyMoreLlamas();
      } on Exception catch (e) {
        // Anything else that is an exception
        print('Unknown exception: $e');
      } catch (e) {
        // No specified type, handles all
        print('Something really unknown: $e');
      }
      // #enddocregion try-on-catch
    }, prints('Bought more llamas.\n'));
  });

  test('simple_throws', () {
    void throwErrors() {
      // #docregion simple-throws
      throw Exception('Something bad happened.');
      throw 'Waaaaaaah!';
      // #enddocregion simple-throws
    }

    expect(throwErrors, throwsException);
  });

  test('try_catch', () {
    expect(() {
      expect(() {
        // #docregion try-catch
        try {
          breedMoreLlamas();
        } catch (e) {
          print('I was just trying to breed llamas!');
          rethrow;
        }
        // #enddocregion try-catch
      }, throwsA(isA<OutOfLlamasException>()));
    }, prints('I was just trying to breed llamas!\n'));
  });

  test('try_catch_finally', () {
    expect(() {
      // #docregion try-catch-finally
      try {
        breedMoreLlamas();
      } catch (e) {
        // ... handle exception ...
      } finally {
        // Always clean up, even if an exception is thrown.
        cleanLlamaStalls();
      }
      // #enddocregion try-catch-finally
    }, prints('Cleaned llama stalls.\n'));
  });
}

void cleanLlamaStalls() {
  print('Cleaned llama stalls.');
}

void breedMoreLlamas() {
  throw OutOfLlamasException();
}

void buyMoreLlamas() {
  print('Bought more llamas.');
}

class OutOfLlamasException implements Exception {}
