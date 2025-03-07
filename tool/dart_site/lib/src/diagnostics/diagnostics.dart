// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;

import '../utils.dart';
import 'error_code_documentation_info.dart';
import 'error_code_info.dart';
import 'linter.dart';

/// Generate the file `diagnostics.md` based on the documentation associated
/// with the declarations of the error codes.
Future<void> generate() async {
  final sink = File(_outputPath).openWrite();
  final messages = await Messages.retrieve();
  final generator = DocumentationGenerator(
    messages,
    lintNames: await allLintNames,
  );
  generator.writeDocumentation(sink);
  await sink.flush();
  await sink.close();
}

/// Compute the path to the file into which documentation is being generated.
String get _outputPath => path.join(
  repositoryRoot,
  'src',
  'content',
  'tools',
  'diagnostic-messages.md',
);

/// An information holder containing information about a diagnostic that was
/// extracted from the instance creation expression.
class DiagnosticInformation {
  /// The name of the diagnostic.
  final String name;

  /// The messages associated with the diagnostic.
  final List<String> messages;

  /// The previous names by which this diagnostic has been known.
  final List<String> previousNames = [];

  /// Whether this diagnostic is from a lint rule.
  final bool isFromLint;

  /// The documentation text associated with the diagnostic.
  String? documentation;

  /// Initialize a newly created information holder with the given [name] and
  /// [message].
  DiagnosticInformation(this.name, String message, {this.isFromLint = false})
    : messages = [message];

  /// Return `true` if this diagnostic has documentation.
  bool get hasDocumentation => documentation != null;

  /// Add the [message] to the list of messages associated with the diagnostic.
  void addMessage(String message) {
    if (!messages.contains(message)) {
      messages.add(message);
    }
  }

  void addPreviousName(String previousName) {
    if (!previousNames.contains(previousName)) {
      previousNames.add(previousName);
    }
  }

  /// Return the full documentation for this diagnostic.
  void writeOn(StringSink sink) {
    messages.sort();
    sink.writeln('### ${name.toLowerCase()}');
    for (final previousName in previousNames) {
      sink.writeln();
      final previousInLowerCase = previousName.toLowerCase();
      sink.writeln(
        '<a id="$previousInLowerCase" aria-hidden="true"></a>'
        '_(Previously known as `$previousInLowerCase`)_',
      );
    }
    if (isFromLint) {
      sink.writeln();
      sink.writeln('''
<div class="tags">
  <a class="tag-label"
      href="/tools/linter-rules/$name"
      title="Learn about the lint rule that enables this diagnostic."
      aria-label="Learn about the lint rule that enables this diagnostic."
      target="_blank">
    <span class="material-symbols" aria-hidden="true">toggle_on</span>
    <span>Lint rule</span>
  </a>
</div>''');
    }
    for (final message in messages) {
      sink.writeln();
      for (final line in _split('_${_escape(message)}_')) {
        sink.writeln(line);
      }
    }
    sink.writeln();
    sink.writeln(documentation!);
  }

  /// Return a version of the [text] in which characters that have special
  /// meaning in markdown have been escaped.
  String _escape(String text) {
    return text.replaceAll('_', '\\_');
  }

  /// Split the [message] into multiple lines, each of which is less than 80
  /// characters long.
  List<String> _split(String message) {
    // This uses a brute force approach because we don't expect to have messages
    // that need to be split more than once.
    final length = message.length;
    if (length <= 80) {
      return [message];
    }
    final endIndex = message.lastIndexOf(' ', 80);
    if (endIndex < 0) {
      return [message];
    }
    return [message.substring(0, endIndex), message.substring(endIndex + 1)];
  }
}

/// A class used to generate diagnostic documentation.
class DocumentationGenerator {
  /// A map from the name of a diagnostic to the information about that
  /// diagnostic.
  final Map<String, DiagnosticInformation> infoByName = {};

  /// A collection of all lint names.
  final Set<String> lintNames;

  /// Initialize a newly created documentation generator.
  DocumentationGenerator(Messages messages, {this.lintNames = const {}}) {
    for (final classEntry in messages.analyzerMessages.entries) {
      _extractAllDocs(classEntry.key, classEntry.value);
    }
    for (final classEntry in messages.linterMessages.entries) {
      _extractAllDocs(classEntry.key, classEntry.value);
    }

    _extractAllDocs(
      'ParserErrorCode',
      messages.cfeToAnalyzerErrorCodeTables.analyzerCodeToInfo,
    );
  }

  /// Writes the documentation to [sink].
  void writeDocumentation(StringSink sink) {
    _writeHeader(sink);
    _writeGlossary(sink);
    _writeDiagnostics(sink);
  }

  /// Extract documentation from all of the files containing the definitions of
  /// diagnostics.
  void _extractAllDocs(String className, Map<String, ErrorCodeInfo> messages) {
    for (final errorEntry in messages.entries) {
      final errorName = errorEntry.key;
      final errorCodeInfo = errorEntry.value;
      if (errorCodeInfo is AliasErrorCodeInfo) {
        continue;
      }
      final name = errorCodeInfo.sharedName ?? errorName;
      var info = infoByName[name];
      final message = convertTemplate(
        errorCodeInfo.computePlaceholderToIndexMap(),
        errorCodeInfo.problemMessage,
      );
      if (info == null) {
        info = DiagnosticInformation(
          name,
          message,
          isFromLint: lintNames.contains(name),
        );
        infoByName[name] = info;
      } else {
        info.addMessage(message);
      }
      final previousName = errorCodeInfo.previousName;
      if (previousName != null) {
        info.addPreviousName(previousName);
      }
      final docs = _extractDoc('$className.$errorName', errorCodeInfo);
      if (docs.isNotEmpty) {
        if (info.documentation != null) {
          throw StateError(
            'Documentation defined multiple times for ${info.name}',
          );
        }
        info.documentation = docs;
      }
    }
  }

  /// Extract documentation from the given [errorCodeInfo].
  String _extractDoc(String errorCode, ErrorCodeInfo errorCodeInfo) {
    final parsedComment = parseErrorCodeDocumentation(
      errorCode,
      errorCodeInfo.documentation,
    );
    if (parsedComment == null) {
      return '';
    }
    return [
      for (final documentationPart in parsedComment)
        documentationPart.formatForDocumentation(),
    ].join('\n');
  }

  /// Write the documentation for all of the diagnostics.
  void _writeDiagnostics(StringSink sink) {
    sink.write('''

## Diagnostics

The analyzer produces the following diagnostics for code that
doesn't conform to the language specification or
that might work in unexpected ways.

[bottom type]: https://dart.dev/null-safety/understanding-null-safety#top-and-bottom
[debugPrint]: https://api.flutter.dev/flutter/foundation/debugPrint.html
[ffi]: https://dart.dev/interop/c-interop
[IEEE 754]: https://en.wikipedia.org/wiki/IEEE_754
[irrefutable pattern]: https://dart.dev/resources/glossary#irrefutable-pattern
[kDebugMode]: https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html
[meta-doNotStore]: https://pub.dev/documentation/meta/latest/meta/doNotStore-constant.html
[meta-doNotSubmit]: https://pub.dev/documentation/meta/latest/meta/doNotSubmit-constant.html
[meta-factory]: https://pub.dev/documentation/meta/latest/meta/factory-constant.html
[meta-immutable]: https://pub.dev/documentation/meta/latest/meta/immutable-constant.html
[meta-internal]: https://pub.dev/documentation/meta/latest/meta/internal-constant.html
[meta-literal]: https://pub.dev/documentation/meta/latest/meta/literal-constant.html
[meta-mustBeConst]: https://pub.dev/documentation/meta/latest/meta/mustBeConst-constant.html
[meta-mustCallSuper]: https://pub.dev/documentation/meta/latest/meta/mustCallSuper-constant.html
[meta-optionalTypeArgs]: https://pub.dev/documentation/meta/latest/meta/optionalTypeArgs-constant.html
[meta-sealed]: https://pub.dev/documentation/meta/latest/meta/sealed-constant.html
[meta-useResult]: https://pub.dev/documentation/meta/latest/meta/useResult-constant.html
[meta-UseResult]: https://pub.dev/documentation/meta/latest/meta/UseResult-class.html
[meta-visibleForOverriding]: https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html
[meta-visibleForTesting]: https://pub.dev/documentation/meta/latest/meta/visibleForTesting-constant.html
[package-logging]: https://pub.dev/packages/logging
[refutable pattern]: https://dart.dev/resources/glossary#refutable-pattern
''');
    final errorCodes = infoByName.keys.toList();
    errorCodes.sort();
    for (final errorCode in errorCodes) {
      final info = infoByName[errorCode]!;
      if (info.hasDocumentation) {
        sink.writeln();
        info.writeOn(sink);
      }
    }
  }

  /// Link to the glossary.
  void _writeGlossary(StringSink sink) {
    sink.write(r'''

[constant context]: /resources/glossary#constant-context
[definite assignment]: /resources/glossary#definite-assignment
[mixin application]: /resources/glossary#mixin-application
[override inference]: /resources/glossary#override-inference
[part file]: /resources/glossary#part-file
[potentially non-nullable]: /resources/glossary#potentially-non-nullable
[public library]: /resources/glossary#public-library
''');
  }

  /// Write the header of the file.
  void _writeHeader(StringSink sink) {
    sink.write('''
---
title: Diagnostic messages
description: Details for diagnostics produced by the Dart analyzer.
body_class: highlight-diagnostics
skipFreshness: true
---

{%- comment %}
WARNING: Do NOT EDIT this file directly. It is autogenerated by the script in
`pkg/analyzer/tool/diagnostics/generate.dart` in the sdk repository.
Update instructions: https://github.com/dart-lang/site-www/issues/1949
{% endcomment -%}

This page lists diagnostic messages produced by the Dart analyzer,
with details about what those messages mean and how you can fix your code.
For more information about the analyzer, see
[Customizing static analysis](/tools/analysis).
''');
  }
}
