// ignore_for_file: type_annotate_public_apis, unused_element, strict_raw_type
// ignore_for_file: no_leading_underscores_for_local_identifiers, use_function_type_syntax_for_parameters

// #docregion library-doc
/// A really great test library.
@TestOn('browser')
library;
// #enddocregion library-doc

import 'package:examples_util/ellipsis.dart';

class TestOn {
  const TestOn(String platform);
}

void miscDeclAnalyzedButNotTested() {
  (Iterable _chunks) {
    // #docregion comments-like-sentences
    // Not if anything comes before it.
    if (_chunks.isNotEmpty) return false;
    // #enddocregion comments-like-sentences
    return true;
  };

  // #docregion block-comments
  void greet(String name) {
    // Assume we have a valid name.
    print('Hi, $name!');
  }
  // #enddocregion block-comments

  <Flag>() {
    // #docregion no-annotations
    /// Defines a flag.
    ///
    /// Throws an [ArgumentError] if there is already an option named [name] or
    /// there is already an option using abbreviation [abbr]. Returns the new flag.
    Flag addFlag(String name, String abbr) => ellipsis();
    // #enddocregion no-annotations
  };

  {
    // #docregion first-sentence
    /// Deletes the file at [path] from the file system.
    void delete(String path) {
      ellipsis();
    }
    // #enddocregion first-sentence
  }

  {
    // #docregion first-sentence-a-paragraph
    /// Deletes the file at [path].
    ///
    /// Throws an [IOError] if the file could not be found. Throws a
    /// [PermissionError] if the file is present but could not be deleted.
    void delete(String path) {
      ellipsis();
    }
    // #enddocregion first-sentence-a-paragraph
  }

  <T>() {
    // #docregion third-person
    /// Returns `true` if every element satisfies the [predicate].
    bool all(bool predicate(T element)) => ellipsis();

    /// Starts the stopwatch if not already running.
    void start() {
      ellipsis();
    }
    // #enddocregion third-person
  };

  // #docregion code-sample
  /// Returns the lesser of two numbers.
  ///
  /// ```dart
  /// min(5, 3) == 3
  /// ```
  num min(num a, num b) => ellipsis();
  // #enddocregion code-sample

  () {
    void anotherMethod() {}

    // #docregion identifiers
    /// Throws a [StateError] if ...
    /// similar to [anotherMethod()], but ...
    // #enddocregion identifiers

    // #docregion member
    /// Similar to [Duration.inDays], but handles fractional days.
    // #enddocregion member
    void method1() {}

    // #docregion ctor
    /// To create a point, call [Point.new] or use [Point.polar] to ...
    // #enddocregion ctor
    void method2() {}
  };

  // #docregion markdown
  /// This is a paragraph of regular text.
  ///
  /// This sentence has *two* _emphasized_ words (italics) and **two**
  /// __strong__ ones (bold).
  ///
  /// A blank line creates a separate paragraph. It has some `inline code`
  /// delimited using backticks.
  ///
  /// * Unordered lists.
  /// * Look like ASCII bullet lists.
  /// * You can also use `-` or `+`.
  ///
  /// 1. Numbered lists.
  /// 2. Are, well, numbered.
  /// 1. But the values don't matter.
  ///
  ///     * You can nest lists too.
  ///     * They must be indented at least 4 spaces.
  ///     * (Well, 5 including the space after `///`.)
  ///
  /// Code blocks are fenced in triple backticks:
  ///
  /// ```dart
  /// this.code
  ///     .will
  ///     .retain(its, formatting);
  /// ```
  ///
  /// The code language (for syntax highlighting) defaults to Dart. You can
  /// specify it by putting the name of the language after the opening backticks:
  ///
  /// ```html
  /// <h1>HTML is magical!</h1>
  /// ```
  ///
  /// Links can be:
  ///
  /// * https://www.just-a-bare-url.com
  /// * [with the URL inline](https://google.com)
  /// * [or separated out][ref link]
  ///
  /// [ref link]: https://google.com
  ///
  /// # A Header
  ///
  /// ## A subheader
  ///
  /// ### A subsubheader
  ///
  /// #### If you need this many levels of headers, you're doing it wrong
  // #enddocregion markdown
}

class IOError {}

class PermissionError {}

class Widget {}

// #docregion redundant
class RadioButtonWidget extends Widget {
  /// Sets the tooltip to [lines], which should have been word wrapped using
  /// the current font.
  void tooltip(List<String> lines) {
    ellipsis();
  }
}
// #enddocregion redundant

//----------------------------------------------------------------------------

class Point {
  Point();
  Point.polar();
}

//----------------------------------------------------------------------------

class C0 {
  // #docregion use-doc-comments
  /// The number of characters in this chunk when unsplit.
  int get length => ellipsis();
// #enddocregion use-doc-comments
}

//----------------------------------------------------------------------------

class C1 {
  C1(this.weekday);

// #docregion noun-phrases-for-non-boolean-var-etc
  /// The current day of the week, where `0` is Sunday.
  int weekday;

  /// The number of checked buttons on the page.
  int get checkedCount => ellipsis();
// #enddocregion noun-phrases-for-non-boolean-var-etc
}

//----------------------------------------------------------------------------

class Modal {
  Modal(this.isVisible);

// #docregion noun-phrases-for-boolean-var-etc
  /// Whether the modal is currently displayed to the user.
  bool isVisible;

  /// Whether the modal should confirm the user's intent on navigation.
  bool get shouldConfirm => ellipsis();

  /// Whether resizing the current browser window will also resize the modal.
  bool get canResize => ellipsis();
// #enddocregion noun-phrases-for-boolean-var-etc
}

//----------------------------------------------------------------------------

class Pool {
// #docregion getter-and-setter
  /// The pH level of the water in the pool.
  ///
  /// Ranges from 0-14, representing acidic to basic, with 7 being neutral.
  int get phLevel => ellipsis();
  set phLevel(int level) => ellipsis();
// #enddocregion getter-and-setter
}

//----------------------------------------------------------------------------

// #docregion noun-phrases-for-type-or-lib
/// A chunk of non-breaking output text terminated by a hard or soft newline.
///
/// ...
class Chunk {/* ... */}
// #enddocregion noun-phrases-for-type-or-lib

//----------------------------------------------------------------------------

class Component {
  const Component({String selector = ''});
}

// #docregion doc-before-meta
/// A button that can be flipped on and off.
@Component(selector: 'toggle')
class ToggleComponent {}
// #enddocregion doc-before-meta

//----------------------------------------------------------------------------

// #docregion this
class Box {
  /// The value this wraps.
  Object? _value;

  /// True if this box contains a value.
  bool get hasValue => _value != null;
}
// #enddocregion this
