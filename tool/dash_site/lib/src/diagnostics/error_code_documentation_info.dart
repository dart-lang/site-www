// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

/// Converts the given [documentation] string into a list of
/// [ErrorCodeDocumentationPart] objects.  These objects represent
/// user-publishable documentation about the given [errorCode], along with code
/// blocks illustrating when the error occurs and how to fix it.
List<ErrorCodeDocumentationPart>? parseErrorCodeDocumentation(
  String errorCode,
  String? documentation,
) {
  if (documentation == null) {
    return null;
  }
  final documentationLines = documentation.split('\n');
  if (documentationLines.isEmpty) {
    return null;
  }
  final parser = _ErrorCodeDocumentationParser(errorCode, documentationLines);
  parser.parse();
  return parser.result;
}

/// Enum representing the different documentation sections in which an
/// [ErrorCodeDocumentationBlock] might appear.
enum BlockSection {
  /// The "Examples" section, where we give examples of code that
  /// generates the error.
  examples,

  /// The "Common fixes" section, where we give examples of code that
  /// doesn't generate the error.
  commonFixes,
}

/// An [ErrorCodeDocumentationPart] containing a block of code.
class ErrorCodeDocumentationBlock extends ErrorCodeDocumentationPart {
  /// The code itself.
  final String text;

  /// The section this block is contained in.
  final BlockSection containingSection;

  /// The file type of this code block (e.g. `dart` or `yaml`).
  final String fileType;

  /// The language version that must be active for this code to behave as
  /// expected (if any).
  final String? languageVersion;

  /// If this code is an auxiliary file that supports other blocks, the URI of
  /// the file.
  final String? uri;

  ErrorCodeDocumentationBlock(
    this.text, {
    required this.containingSection,
    required this.fileType,
    this.languageVersion,
    this.uri,
  });

  @override
  String formatForDocumentation() {
    return ['```$fileType', _migrateHighlightingSpans(text), '```'].join('\n');
  }
}

/// Adjust the highlight spans in analyzer diagnostic doc code blocks
/// so that they are compatible with our static site generation.
///
/// Analyzer diagnostic docs mark spans across lines,
/// but our tooling doesn't currently support doing so.
/// So this function adds opening or closing marks as necessary.
// TODO(parlough): Migrate analyzer docs away from cross-line spans.
String _migrateHighlightingSpans(String input) {
  const openingMark = '[!';
  const closingMark = '!]';
  final lines = const LineSplitter().convert(input);
  var isOpen = false;
  final resultLines = <String>[];

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];
    final openIndex = line.indexOf(openingMark);
    final closeIndex = line.indexOf(closingMark);
    final lineNumber = i + 1;

    if (openIndex == -1 && closeIndex == -1) {
      if (isOpen) {
        final trimmedLine = line.trimLeft();
        if (trimmedLine.isNotEmpty) {
          final leadingSpaceCount = line.length - trimmedLine.length;
          resultLines.add(
            '${' ' * leadingSpaceCount}$openingMark$trimmedLine$closingMark',
          );
        } else {
          resultLines.add(line);
        }
      } else {
        resultLines.add(line);
      }
      continue;
    }

    if (openIndex == -1) {
      if (!isOpen) {
        throw StateError('Unexpected closing tag at line $lineNumber: $line');
      }
      final trimmedLine = line.trimLeft();
      final leadingSpaceCount = trimmedLine.isNotEmpty
          ? line.length - trimmedLine.length
          : 0;

      resultLines.add(
        '${' ' * leadingSpaceCount}$openingMark'
        '${line.substring(leadingSpaceCount, closeIndex)}'
        '$closingMark'
        '${line.substring(closeIndex + closingMark.length)}',
      );
      isOpen = false;
      continue;
    }

    if (closeIndex == -1) {
      if (isOpen) {
        throw StateError('Overlapping span at line $lineNumber: $line');
      }
      resultLines.add(
        '${line.substring(0, openIndex)}$openingMark'
        '${line.substring(openIndex + openingMark.length)}$closingMark',
      );
      isOpen = true;
      continue;
    }

    if (isOpen) {
      if (openIndex < closeIndex) {
        throw StateError('Overlapping span at line $lineNumber: $line');
      }
      resultLines.add(
        '$openingMark${line.substring(0, closeIndex)}$closingMark'
        '${line.substring(closeIndex + closingMark.length)}',
      );
      isOpen = false;
    } else {
      if (closeIndex < openIndex) {
        throw StateError('Unexpected closing tag at line $lineNumber: $line');
      }
      resultLines.add(line);
    }
  }

  if (isOpen) {
    resultLines.add(closingMark);
  }

  if (resultLines.lastOrNull?.trim().isEmpty ?? false) {
    resultLines.removeLast();
  }

  return resultLines.join('\n');
}

/// A portion of an error code's documentation.  This could be free form
/// markdown text ([ErrorCodeDocumentationText]) or a code block
/// ([ErrorCodeDocumentationBlock]).
abstract class ErrorCodeDocumentationPart {
  /// Formats this documentation part as text suitable for inclusion in the
  /// analyzer's `diagnostics.md` file.
  String formatForDocumentation();
}

/// An [ErrorCodeDocumentationPart] containing free form markdown text.
class ErrorCodeDocumentationText extends ErrorCodeDocumentationPart {
  /// The text, in markdown format.
  final String text;

  ErrorCodeDocumentationText(this.text);

  @override
  String formatForDocumentation() => text;
}

class _ErrorCodeDocumentationParser {
  /// The prefix used on directive lines to specify the language version for
  /// the snippet.
  static const String _languagePrefix = '%language=';

  /// The prefix used on directive lines to indicate the URI of an auxiliary
  /// file that is needed for testing purposes.
  static const String _uriDirectivePrefix = '%uri="';

  final String errorCode;

  final List<String> commentLines;

  final List<ErrorCodeDocumentationPart> result = [];

  int currentLineNumber = 0;

  String? currentSection;

  _ErrorCodeDocumentationParser(this.errorCode, this.commentLines);

  bool get done => currentLineNumber >= commentLines.length;

  String get line => commentLines[currentLineNumber];

  BlockSection? computeCurrentBlockSection() {
    return switch (currentSection) {
      '#### Example' || '#### Examples' => BlockSection.examples,
      '#### Common fixes' => BlockSection.commonFixes,
      null => problem('Code block before section header'),
      _ => null,
    };
  }

  void parse() {
    var textLines = <String>[];

    void flushText() {
      if (textLines.isNotEmpty) {
        result.add(ErrorCodeDocumentationText(textLines.join('\n')));
        textLines = [];
      }
    }

    while (!done) {
      if (line.startsWith('TODO')) {
        // Everything after the "TODO" is ignored.
        break;
      } else if (line.startsWith('%')) {
        problem('% directive outside code block');
      } else if (line.startsWith('```')) {
        flushText();
        processCodeBlock();
      } else {
        if (line.startsWith('#') && !line.startsWith('#####')) {
          currentSection = line;
        }
        textLines.add(line);
        currentLineNumber++;
      }
    }
    flushText();
  }

  Never problem(String explanation) {
    throw FormatException(
      'In documentation for $errorCode, '
      'at line ${currentLineNumber + 1}, $explanation',
    );
  }

  void processCodeBlock() {
    final containingSection = computeCurrentBlockSection();
    final codeLines = <String>[];
    String? languageVersion;
    String? uri;
    assert(line.startsWith('```'));
    final fileType = line.substring(3);
    if (fileType.isEmpty && containingSection != null) {
      problem('Code blocks should have a file type, e.g. "```dart"');
    }
    ++currentLineNumber;
    while (true) {
      if (done) {
        problem('Unterminated code block');
      } else if (line.startsWith('```')) {
        if (line != '```') {
          problem('Code blocks should end with "```"');
        }
        ++currentLineNumber;
        if (containingSection != null) {
          // Ignore code blocks where they're allowed but aren't checked.
          result.add(
            ErrorCodeDocumentationBlock(
              codeLines.join('\n'),
              containingSection: containingSection,
              fileType: fileType,
              languageVersion: languageVersion,
              uri: uri,
            ),
          );
        }
        return;
      } else if (line.startsWith('%')) {
        if (line.startsWith(_languagePrefix)) {
          if (languageVersion != null) {
            problem('Multiple language version directives');
          }
          languageVersion = line.substring(_languagePrefix.length);
        } else if (line.startsWith(_uriDirectivePrefix)) {
          if (uri != null) {
            problem('Multiple URI directives');
          }
          if (!line.endsWith('"')) {
            problem('URI directive should be surrounded by double quotes');
          }
          uri = line.substring(_uriDirectivePrefix.length, line.length - 1);
        } else {
          problem('Unrecognized directive ${json.encode(line)}');
        }
      } else {
        codeLines.add(line);
      }
      ++currentLineNumber;
    }
  }
}
