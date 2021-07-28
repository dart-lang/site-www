// ignore_for_file: dead_code, only_throw_errors

void main() {
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

  // #docregion try-catch
  try {
    breedMoreLlamas();
  } catch (e) {
    print('I was just trying to breed llamas!');
    rethrow;
  }
  // #enddocregion try-catch

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
}

void cleanLlamaStalls() {}

void breedMoreLlamas() {}

void buyMoreLlamas() {}

class OutOfLlamasException implements Exception {}

void throwErrors() {
  // #docregion simple-throws
  throw Exception('Something bad happened.');
  throw 'Waaaaaaah!';
  // #enddocregion simple-throws
}
