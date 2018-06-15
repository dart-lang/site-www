// ignore_for_file: only_throw_errors, unused_element

class OutOfLlamasException /*extends Exception*/ {}

class Point {}

void breedMoreLlamas() {}
void buyMoreLlamas() {}
void cleanLlamaStalls() {}

void miscDeclAnalyzedButNotTested(bool c) {
  if (c) {
    // #docregion throw-FormatException
    throw FormatException('Expected at least 1 section');
    // #enddocregion throw-FormatException
  }

  if (c) {
    // #docregion out-of-llamas
    throw 'Out of llamas!';
    // #enddocregion out-of-llamas
  }

  {
    // #docregion throw-is-an-expression
    void distanceTo(Point other) => throw UnimplementedError();
    // #enddocregion throw-is-an-expression
  }

  {
    // #docregion try
    try {
      breedMoreLlamas();
    } on OutOfLlamasException {
      buyMoreLlamas();
    }
    // #enddocregion try
  }

  {
    // #docregion try-catch
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
    // #enddocregion try-catch
  }

  {
    // #docregion try-catch-2
    try {
      // #enddocregion try-catch-2
      // #docregion try-catch-2
    } on Exception catch (e) {
      print('Exception details:\n $e');
    } catch (e, s) {
      print('Exception details:\n $e');
      print('Stack trace:\n $s');
    }
    // #enddocregion try-catch-2
  }

  {
    // #docregion finally
    try {
      breedMoreLlamas();
    } finally {
      // Always clean up, even if an exception is thrown.
      cleanLlamaStalls();
    }
    // #enddocregion finally
  }

  {
    // #docregion try-catch-finally
    try {
      breedMoreLlamas();
    } catch (e) {
      print('Error: $e'); // Handle the exception first.
    } finally {
      cleanLlamaStalls(); // Then clean up.
    }
    // #enddocregion try-catch-finally
  }
}
