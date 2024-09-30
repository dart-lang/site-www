// ignore_for_file: type_annotate_public_apis, unused_element
import 'package:examples_util/ellipsis.dart';

void miscDeclAnalyzedButNotTested() {
  // #docregion block-comments
  void greet(String name) {
    /* Assume we have a valid name. */
    print('Hi, $name!');
  }
  // #enddocregion block-comments

  {
    // #docregion first-sentence
    /// Depending on the state of the file system and the user's permissions,
    /// certain operations may or may not be possible. If there is no file at
    /// [path] or it can't be accessed, this function throws either [IOError]
    /// or [PermissionError], respectively. Otherwise, this deletes the file.
    void delete(String path) {
      ellipsis();
    }
    // #enddocregion first-sentence
  }

  {
    // #docregion first-sentence-a-paragraph
    /// Deletes the file at [path]. Throws an [IOError] if the file could not
    /// be found. Throws a [PermissionError] if the file is present but could
    /// not be deleted.
    void delete(String path) {
      ellipsis();
    }
    // #enddocregion first-sentence-a-paragraph
  }
}

class IOError {}

class PermissionError {}

//----------------------------------------------------------------------------

class Widget {}

// #docregion redundant
class RadioButtonWidget extends Widget {
  /// Sets the tooltip for this radio button widget to the list of strings in
  /// [lines].
  void tooltip(List<String> lines) {
    ellipsis();
  }
}
// #enddocregion redundant

//----------------------------------------------------------------------------

class C<ChunkBuilder, Flag, LineWriter> {
  // #docregion no-annotations
  /// Defines a flag with the given name and abbreviation.
  ///
  /// @param name The name of the flag.
  /// @param abbr The abbreviation for the flag.
  /// @returns The new flag.
  /// @throws ArgumentError If there is already an option with
  ///     the given name or abbreviation.
  Flag addFlag(String name, String abbr) => ellipsis();
  // #enddocregion no-annotations
}

//----------------------------------------------------------------------------

class Pool {
// #docregion getter-and-setter
  /// The depth of the water in the pool, in meters.
  int get waterDepth => ellipsis();

  /// Updates the water depth to a total of [meters] in height.
  set waterDepth(int meters) => ellipsis();
// #enddocregion getter-and-setter
}

//----------------------------------------------------------------------------

class Component {
  const Component({String selector = ''});
}

// #docregion doc-before-meta
@Component(selector: 'toggle')

/// A button that can be flipped on and off.
class ToggleComponent {}
// #enddocregion doc-before-meta
