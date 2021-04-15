typedef Pred0 = bool Function();
typedef Void0 = void Function();

class Candidate {
  int yearsExperience = 0;

  void interview() {}
}

void miscDeclAnalyzedButNotTested() {
  final candidates = <Candidate>[];

  {
    Pred0 isRaining = () => true;
    Pred0 isSnowing = () => true;
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

  {
    // #docregion collection
    for (var candidate in candidates) {
      candidate.interview();
    }
    // #enddocregion collection
  }

  {
    Pred0 isDone = () => true;
    Pred0 doSomething = () => true;
    // #docregion while
    while (!isDone()) {
      doSomething();
    }
    // #enddocregion while
  }

  {
    Pred0 atEndOfPage = () => true;
    Pred0 printLine = () => true;
    // #docregion do-while
    do {
      printLine();
    } while (!atEndOfPage());
    // #enddocregion do-while
  }

  {
    Pred0 shutDownRequested = () => true;
    Pred0 processIncomingRequests = () => true;
    // #docregion while-break
    while (true) {
      if (shutDownRequested()) break;
      processIncomingRequests();
    }
    // #enddocregion while-break
  }

  {
    // #docregion for-continue
    for (int i = 0; i < candidates.length; i++) {
      var candidate = candidates[i];
      if (candidate.yearsExperience < 5) {
        continue;
      }
      candidate.interview();
    }
    // #enddocregion for-continue
  }

  {
    // #docregion where
    candidates
        .where((c) => c.yearsExperience >= 5)
        .forEach((c) => c.interview());
    // #enddocregion where
  }

  Void0 executeClosed = () {},
      executePending = () {},
      executeApproved = () {},
      executeDenied = () {},
      executeOpen = () {},
      executeUnknown = () {},
      executeNowClosed = () {};

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
    var text;
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
