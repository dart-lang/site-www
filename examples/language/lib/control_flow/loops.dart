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

  {
    // #docregion label-for-loop-break
    outerLoop:
    for (var i = 1; i <= 3; i++) {
      for (var j = 1; j <= 3; j++) {
        print('i = $i, j = $j');
        if (i == 2 && j == 2) {
          break outerLoop;
        }
      }
    }
    print('outerLoop exited');
    // #enddocregion label-for-loop-break
  }

  {
    // #docregion label-for-loop-continue
    outerLoop:
    for (var i = 1; i <= 3; i++) {
      for (var j = 1; j <= 3; j++) {
        if (i == 2 && j == 2) {
          continue outerLoop;
        }
        print('i = $i, j = $j');
      }
    }
    // #enddocregion label-for-loop-continue
  }

  {
    // #docregion label-while-loop-break
    var i = 1;

    outerLoop:
    while (i <= 3) {
      var j = 1;
      while (j <= 3) {
        print('i = $i, j = $j');
        if (i == 2 && j == 2) {
          break outerLoop;
        }
        j++;
      }
      i++;
    }
    print('outerLoop exited');
    // #enddocregion label-while-loop-break
  }

  {
    // #docregion label-while-loop-continue
    var i = 1;

    outerLoop:
    while (i <= 3) {
      var j = 1;
      while (j <= 3) {
        if (i == 2 && j == 2) {
          i++;
          continue outerLoop;
        }
        print('i = $i, j = $j');
        j++;
      }
      i++;
    }
    // #enddocregion label-while-loop-continue
  }

  {
    // #docregion label-do-while-loop-break
    var i = 1;

    outerLoop:
    do {
      var j = 1;
      do {
        print('i = $i, j = $j');
        if (i == 2 && j == 2) {
          break outerLoop;
        }
        j++;
      } while (j <= 3);
      i++;
    } while (i <= 3);

    print('outerLoop exited');
    // #enddocregion label-do-while-loop-break
  }

  {
    // #docregion label-do-while-loop-continue
    var i = 1;

    outerLoop:
    do {
      var j = 1;
      do {
        if (i == 2 && j == 2) {
          i++;
          continue outerLoop;
        }
        print('i = $i, j = $j');
        j++;
      } while (j <= 3);
      i++;
    } while (i <= 3);
    // #enddocregion label-do-while-loop-continue
  }
}
