class OutOfLlamasException extends Error {}

void breedMoreLlamas() {}
void buyMoreLlamas() {
  print('bought more llamas');
}

void cleanLlamaStalls() {}

void breedYetMoreLlamas() {
  throw new OutOfLlamasException();
//  throw new Exception('No more llamas!');
//  throw 'Not even an exception';
}

class Point {}

void main() {
  var numberOfLlamas = 1;
  if (numberOfLlamas <= 0) {
    throw new StateError('Value must be greater than zero');
  }
  if (numberOfLlamas <= 0) {
    // #docregion out-of-llamas
    throw 'Out of llamas!';
    // #enddocregion out-of-llamas
  }

  // #docregion throw-is-an-expression
  void distanceTo(Point other) =>
      throw new UnimplementedError();
  // #enddocregion throw-is-an-expression

  // #docregion try
  try {
    breedMoreLlamas();
  } on OutOfLlamasException {
    buyMoreLlamas();
  }
  // #enddocregion try

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

  // #docregion finally
  try {
    breedMoreLlamas();
  } finally {
    // Always clean up, even if an exception is thrown.
    cleanLlamaStalls();
  }
  // #enddocregion finally

  // #docregion try-catch-finally
  try {
    breedMoreLlamas();
  } catch (e) {
    print('Error: $e'); // Handle the exception first.
  } finally {
    cleanLlamaStalls(); // Then clean up.
  }
  // #enddocregion try-catch-finally

  try {
    // #docregion
    throw new FormatException('Expected at least 1 section');
    // #enddocregion
  } on FormatException catch (e) {
    print(e);
  }

  // #docregion try-catch-2
  try {
    // #enddocregion try-catch-2
    print('About to breed too many llamas.');
    breedYetMoreLlamas();
  } on OutOfLlamasException {
    buyMoreLlamas();
    // #docregion try-catch-2
  } on Exception catch (e) {
    print('Exception details:\n $e');
  } catch (e, s) {
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
  // #enddocregion try-catch-2
}
