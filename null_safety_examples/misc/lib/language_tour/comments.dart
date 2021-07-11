// ignore_for_file: unused_element

void miscDeclAnalyzedButNotTested() {
  {
    // #docregion single-line-comments
    void main() {
      // TODO: refactor into an AbstractLlamaGreetingFactory?
      print('Welcome to my Llama farm!');
    }
    // #enddocregion single-line-comments
  }

  {
    // #docregion multi-line-comments
    void main() {
      /*
       * This is a lot of work. Consider raising chickens.

      Llama larry = Llama();
      larry.feed();
      larry.exercise();
      larry.clean();
       */
    }
    // #enddocregion multi-line-comments
  }
}

class Food {}

class Activity {}

// #docregion doc-comments
/// A domesticated South American camelid (Lama glama).
///
/// Andean cultures have used llamas as meat and pack
/// animals since pre-Hispanic times.
///
/// Just like any other animal, llamas need to eat,
/// so don't forget to [feed] them some [Food].
class Llama {
  String? name;

  /// Feeds your llama [food].
  ///
  /// The typical llama eats one bale of hay per week.
  void feed(Food food) {
    // ...
  }

  /// Exercises your llama with an [activity] for
  /// [timeLimit] minutes.
  void exercise(Activity activity, int timeLimit) {
    // ...
  }
}
