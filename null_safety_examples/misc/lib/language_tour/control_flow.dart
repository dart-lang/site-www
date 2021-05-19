class Candidate {
  int yearsExperience = 0;

  void interview() {}
}

void miscDeclAnalyzedButNotTested() {
  final candidates = <Candidate>[];

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

  {
    // #docregion collection
    for (var candidate in candidates) {
      candidate.interview();
    }
    // #enddocregion collection
  }

  {
    bool isDone() => true;
    bool doSomething() => true;
    // #docregion while
    while (!isDone()) {
      doSomething();
    }
    // #enddocregion while
  }

  {
    bool atEndOfPage() => true;
    bool printLine() => true;
    // #docregion do-while
    do {
      printLine();
    } while (!atEndOfPage());
    // #enddocregion do-while
  }

  {
    bool shutDownRequested() => true;
    bool processIncomingRequests() => true;
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
    String? text;
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
