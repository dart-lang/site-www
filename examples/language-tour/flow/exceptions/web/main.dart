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
    throw new StateError('Out of llamas!');
  }

  void distanceTo(Point other) => throw new UnimplementedError();

  try {
    breedMoreLlamas();
  } on OutOfLlamasException {
    buyMoreLlamas();
  }

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

  try {
    breedMoreLlamas();
  } finally {
    // Always clean up, even if an exception is thrown.
    cleanLlamaStalls();
  }

  try {
    breedMoreLlamas();
  } catch (e) {
    print('Error: $e'); // Handle the exception first.
  } finally {
    cleanLlamaStalls(); // Then clean up.
  }

  try {
    throw new FormatException('Expected at least 1 section');
  } on FormatException catch (e) {
    print(e);
  }

  try {
    print('About to breed too many llamas.');
    breedYetMoreLlamas();
  } on OutOfLlamasException {
    buyMoreLlamas();
  } on Exception catch (e) {
    print('Exception details:\n $e');
  } catch (e, s) {
    print('Exception details:\n $e');
    print('Stack trace:\n $s');
  }
}
