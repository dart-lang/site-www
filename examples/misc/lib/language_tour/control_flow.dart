import 'package:examples_util/nullable.dart';

void miscDeclAnalyzedButNotTested() {
  {
    bool isRaining() => true;
    bool isSnowing() => true;
    dynamic car, you;
    // #docregion if-else
    if (isRaining()) {
      you.bringRainCoat();
    } else if (isSnowing()) {
      you.wearJacket();
    } else {
      car.putTopDown();
    }
    // #enddocregion if-else
  }

  void executeClosed() {}
  void executePending() {}
  void executeApproved() {}
  void executeDenied() {}
  void executeOpen() {}
  void executeUnknown() {}
  void executeNowClosed() {}

  {
    // #docregion switch
    var command = 'OPEN';
    switch (command) {
      case 'CLOSED':
        executeClosed();
        break;
      case 'PENDING':
        executePending();
        break;
      case 'APPROVED':
        executeApproved();
        break;
      case 'DENIED':
        executeDenied();
        break;
      case 'OPEN':
        executeOpen();
        break;
      default:
        executeUnknown();
    }
    // #enddocregion switch
  }

  {
    // #docregion switch-break-omitted
    var command = 'OPEN';
    switch (command) {
      case 'OPEN':
        executeOpen();
        // ERROR: Missing break
        // #enddocregion switch-break-omitted
        break;
      // #docregion switch-break-omitted

      case 'CLOSED':
        executeClosed();
        break;
    }
    // #enddocregion switch-break-omitted
  }

  {
    // #docregion switch-empty-case
    var command = 'CLOSED';
    switch (command) {
      case 'CLOSED': // Empty case falls through.
      case 'NOW_CLOSED':
        // Runs for both CLOSED and NOW_CLOSED.
        executeNowClosed();
        break;
    }
    // #enddocregion switch-empty-case
  }

  {
    // #docregion switch-continue
    var command = 'CLOSED';
    switch (command) {
      case 'CLOSED':
        executeClosed();
        continue nowClosed;
      // Continues executing at the nowClosed label.

      nowClosed:
      case 'NOW_CLOSED':
        // Runs for both CLOSED and NOW_CLOSED.
        executeNowClosed();
        break;
    }
    // #enddocregion switch-continue
  }

  {
    int number = 0;
    String urlString = '';
    String? text = nullableValue<String>();
    // #docregion assert
    // Make sure the variable has a non-null value.
    assert(text != null);

    // Make sure the value is less than 100.
    assert(number < 100);

    // Make sure this is an https URL.
    assert(urlString.startsWith('https'));
    // #enddocregion assert
  }
}
