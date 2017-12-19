// ignore_for_file: type_annotate_public_apis, unused_element
// #docplaster
import 'package:dartlang_examples_util/ellipsis.dart';

void miscDeclAnalyzedButNotTested() {
  // #docregion block-comments
  greet(name) {
    /* Assume we have a valid name. */
    print('Hi, $name!');
  }
  // #enddocregion block-comments
}

class C<ChunkBuilder, Flag, LineWriter> {
  // #docregion first-sentence-a-paragraph
  /// Starts a new block as a child of the current chunk. Nested blocks are
  /// handled using their own independent [LineWriter].
  ChunkBuilder startBlock() => ellipsis;
  // #enddocregion first-sentence-a-paragraph

  // #docregion no-annotations
  /// Defines a flag with the given name and abbreviation.
  ///
  /// @param name The name of the flag.
  /// @param abbr The abbreviation for the flag.
  /// @returns The new flag.
  /// @throws ArgumentError If there is already an option with
  ///     the given name or abbreviation.
  Flag addFlag(String name, String abbr) => ellipsis;
  // #enddocregion no-annotations

  void newMethod() {}
  // #docregion doc-before-meta
  @deprecated
  // #enddocregion doc-before-meta

  // #docregion doc-before-meta
  /// _Deprecated: Use [newMethod] instead._
  oldMethod() {/* ... */}
  // #enddocregion doc-before-meta
}
