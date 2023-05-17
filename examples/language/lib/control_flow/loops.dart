final class Candidate {
  String name = '';
  int yearsExperience = 0;

  void interview() {}
}

void miscDeclAnalyzedButNotTested() {
  final candidates = <Candidate>[];

  {
    // #docregion collection
    for (final candidate in candidates) {
      candidate.interview();
    }
    // #enddocregion collection
  }

  {
    // #docregion collection-for-pattern
    for (final Candidate(:name, :yearsExperience) in candidates) {
      print('$name has $yearsExperience of experience.');
    }
    // #enddocregion collection-for-pattern
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
}
