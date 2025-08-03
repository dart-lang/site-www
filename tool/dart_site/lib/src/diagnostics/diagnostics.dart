// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import '../utils.dart';
import 'error_code_documentation_info.dart';
import 'error_code_info.dart';
import 'linter.dart';

/// The path to the diagnostic index file.
String get _indexOutputPath => path.join(
  repositoryRoot,
  'src',
  'content',
  'tools',
  'diagnostics',
  'index.md',
);

/// Markdown link definitions used by various diagnostic docs.
Map<String, String> get _linkDefinitions => {
  'bottom type': '/null-safety/understanding-null-safety#top-and-bottom',
  'debugPrint': 'https://api.flutter.dev/flutter/foundation/debugPrint.html',
  'ffi': '/interop/c-interop',
  'IEEE 754': 'https://en.wikipedia.org/wiki/IEEE_754',
  'kDebugMode':
      'https://api.flutter.dev/flutter/foundation/kDebugMode-constant.html',
  'meta-awaitNotRequired':
      'https://pub.dev/documentation/meta/latest/meta/awaitNotRequired-constant.html',
  'meta-doNotStore':
      'https://pub.dev/documentation/meta/latest/meta/doNotStore-constant.html',
  'meta-doNotSubmit':
      'https://pub.dev/documentation/meta/latest/meta/doNotSubmit-constant.html',
  'meta-factory':
      'https://pub.dev/documentation/meta/latest/meta/factory-constant.html',
  'meta-immutable':
      'https://pub.dev/documentation/meta/latest/meta/immutable-constant.html',
  'meta-internal':
      'https://pub.dev/documentation/meta/latest/meta/internal-constant.html',
  'meta-literal':
      'https://pub.dev/documentation/meta/latest/meta/literal-constant.html',
  'meta-mustBeConst':
      'https://pub.dev/documentation/meta/latest/meta/mustBeConst-constant.html',
  'meta-mustCallSuper':
      'https://pub.dev/documentation/meta/latest/meta/mustCallSuper-constant.html',
  'meta-optionalTypeArgs':
      'https://pub.dev/documentation/meta/latest/meta/optionalTypeArgs-constant.html',
  'meta-sealed':
      'https://pub.dev/documentation/meta/latest/meta/sealed-constant.html',
  'meta-useResult':
      'https://pub.dev/documentation/meta/latest/meta/useResult-constant.html',
  'meta-UseResult':
      'https://pub.dev/documentation/meta/latest/meta/UseResult-class.html',
  'meta-visibleForOverriding':
      'https://pub.dev/documentation/meta/latest/meta/visibleForOverriding-constant.html',
  'meta-visibleForTesting':
      'https://pub.dev/documentation/meta/latest/meta/visibleForTesting-constant.html',
  'package-logging': 'https://pub.dev/packages/logging',
  'irrefutable pattern': '/resources/glossary#irrefutable-pattern',
  'refutable pattern': '/resources/glossary#refutable-pattern',
  'constant context': '/resources/glossary#constant-context',
  'definite assignment': '/resources/glossary#definite-assignment',
  'mixin application': '/resources/glossary#mixin-application',
  'override inference': '/resources/glossary#override-inference',
  'part file': '/resources/glossary#part-file',
  'potentially non-nullable': '/resources/glossary#potentially-non-nullable',
  'public library': '/resources/glossary#public-library',
};

/// Generate the diagnostic index page and individual diagnostic pages.
Future<void> generate() async {
  final messages = await Messages.retrieve();
  final generator = DocumentationGenerator(
    messages,
    lintNames: await allLintNames,
  );

  await generator.writeDiagnosticIndexPage();
  generator._writeIndividualFiles();
}

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

  /// Initialize a newly created information holder with
  /// the given [name] and [message].
  DiagnosticInformation(this.name, String message, {this.isFromLint = false})
    : messages = [message];

  /// If this diagnostic has documentation associated with it.
  bool get hasDocumentation => documentation != null;

  /// Add the [message] to the list of messages associated with the diagnostic.
  void addMessage(String message) {
    if (!messages.contains(message)) {
      messages.add(message);
    }
  }

  /// Add [previousName] to the list of previous names for this diagnostic.
  void addPreviousName(String previousName) {
    if (!previousNames.contains(previousName)) {
      previousNames.add(previousName);
    }
  }

  /// Write the problem messages of this diagnostic to the given [sink].
  void writeMessages(StringSink sink) {
    if (messages.isEmpty) return;

    for (final message in messages.sorted()) {
      final escapedMessage = _escape(message).trim();
      if (escapedMessage.isEmpty) continue;
      sink.writeln();
      for (final line in _split('_${escapedMessage}_')) {
        sink.writeln(line);
      }
    }
  }

  /// Write the content of this diagnostic's documentation to the given [sink].
  void writeOn(StringSink sink) {
    for (final previousName in previousNames) {
      sink.writeln();
      final previousInLowerCase = previousName.toLowerCase();
      sink.writeln('_(Previously known as `$previousInLowerCase`)_');
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
    writeMessages(sink);
    sink.writeln();
    final diagnosticDocumentation = documentation!;

    sink.writeln(
      diagnosticDocumentation.replaceAll('#### ', '## ').trimRight(),
    );

    var noLinkReference = true;
    for (final MapEntry(key: reference, value: url)
        in _linkDefinitions.entries) {
      final linkReference = '[$reference]';
      if (diagnosticDocumentation.contains(linkReference)) {
        if (noLinkReference) {
          sink.writeln();
          noLinkReference = false;
        }
        sink.writeln('$linkReference: $url');
      }
    }
  }

  /// Return a version of the [text] in which characters that have special
  /// meaning in markdown have been escaped.
  static String _escape(String text) {
    return text.replaceAll('_', '\\_');
  }

  /// Split the [message] into multiple lines, each of which is less than 80
  /// characters long.
  static List<String> _split(String message) {
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

/// Documentation generator for analyzer diagnostics.
final class DocumentationGenerator {
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

  /// Writes the index of diagnostics to [_indexOutputPath].
  Future<void> writeDiagnosticIndexPage() async {
    final sink = File(_indexOutputPath).openWrite();
    _writeHeader(sink);
    _writeIndex(sink);
    await sink.flush();
    await sink.close();
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

  /// Write the header of the file.
  void _writeHeader(StringSink sink) {
    sink.write('''
---
title: Diagnostic messages
short-title: Diagnostics
description: >-
  An index of the diagnostics produced by the Dart analyzer.
skipFreshness: true
body_class: diagnostics
---

{%- comment %}
WARNING: Do NOT EDIT this file directly.
It is autogenerated with `./dash_site generate-diagnostics`.
{% endcomment -%}

This page lists diagnostic messages produced by the Dart analyzer,
with details about what those messages mean and how you can fix your code.
For more information about the analyzer, see
[Customizing static analysis](/tools/analysis).
''');
  }

  /// Write the documentation for all of the diagnostics.
  void _writeIndex(StringSink sink) {
    sink.write('''

<a id="diagnostics" aria-hidden="true"></a>

## Diagnostic index

The analyzer produces the following diagnostics for code that
doesn't conform to the language specification or
that might work in unexpected ways.

If a diagnostic has extra documentation and guidance,
click **Learn more** to view it.

<div class="card-list">
''');
    final errorCodes = infoByName.keys.toList();
    errorCodes.sort();
    for (final errorCode in errorCodes) {
      final info = infoByName[errorCode]!;
      final formattedDiagnostic = info.name.toLowerCase().trim();
      sink.writeln(
        '<div class="card outlined-card" id="$formattedDiagnostic">',
      );

      for (final previousName in info.previousNames) {
        final formattedName = previousName.toLowerCase().trim();
        sink.writeln('<a id="$formattedName" aria-hidden="true"></a>');
      }

      sink.writeln('''
<div class="card-header">
<header class="card-title" id="$formattedDiagnostic">{{"$formattedDiagnostic" | underscoreBreaker}}</header>
</div>''');

      sink.writeln('<div class="card-content">');

      info.writeMessages(sink);

      sink.writeln('\n</div>');

      sink.writeln('''
<div class="card-actions">
<div class="leading">''');

      if (info.isFromLint) {
        sink.writeln(
          '<span class="material-symbols" title="Diagnostic is from lint rule" '
          'aria-label="Diagnostic is from lint rule">toggle_on</span>',
        );
      }

      sink.writeln('</div>');

      sink.writeln('<div class="trailing">');

      if (info.hasDocumentation) {
        sink.writeln(
          '  <a class="outlined-button" '
          'href="/tools/diagnostics/$formattedDiagnostic" '
          'title="Learn more about this diagnostic and how to resolve it.">'
          'Learn more</a>',
        );
      }

      sink.writeln('''
  <button class="copy-button filled-button hidden" data-copy="$formattedDiagnostic" title="Copy $formattedDiagnostic to your clipboard.">Copy name</button>
</div>
</div>
</div>''');
    }

    // Close the card grid.
    sink.writeln('</div>');
  }

  void _writeIndividualFiles() {
    final diagnosticDirectory = path.join(
      repositoryRoot,
      'src',
      'content',
      'tools',
      'diagnostics',
    );

    for (final diagnostic in infoByName.values) {
      if (!diagnostic.hasDocumentation) continue;
      final diagnosticName = diagnostic.name.toLowerCase().trim();
      final diagnosticPath = path.join(
        diagnosticDirectory,
        '$diagnosticName.md',
      );

      final buffer = StringBuffer('''
---
title: $diagnosticName
description: >-
  Details about the $diagnosticName
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
body_class: highlight-diagnostics
---
''');

      diagnostic.writeOn(buffer);

      File(diagnosticPath).writeAsStringSync(buffer.toString());

      // Create hidden pages for removed diagnostics that
      // redirect to the page for the current name.
      for (final previousName in diagnostic.previousNames) {
        final previousDiagnosticName = previousName.toLowerCase().trim();
        final previousDiagnosticPath = path.join(
          diagnosticDirectory,
          '$previousDiagnosticName.md',
        );

        final buffer = StringBuffer('''
---
title: $diagnosticName
description: >-
  Details about the $diagnosticName
  diagnostic produced by the Dart analyzer.
underscore_breaker_titles: true
canonical: https://dart.dev/tools/diagnostics/$diagnosticName
redirectTo: /tools/diagnostics/$diagnosticName
sitemap: false
noindex: true
body_class: highlight-diagnostics
---
''');
        diagnostic.writeOn(buffer);

        File(previousDiagnosticPath).writeAsStringSync(buffer.toString());
      }
    }
  }
}
