// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as path;

import '../utils.dart';
import 'error_code_documentation_info.dart';
import 'error_code_info.dart';
import 'linter.dart';

/// The path to the diagnostic index data file.
String get _indexOutputPath =>
    path.join(repositoryRoot, 'src', 'data', 'diagnostics.json');

/// Markdown link definitions used by various diagnostic docs.
Map<String, String> get _linkDefinitions => {
  'IEEE 754': 'https://en.wikipedia.org/wiki/IEEE_754',
  'bottom type': '/null-safety/understanding-null-safety#top-and-bottom',
  'constant context': '/resources/glossary#constant-context',
  'context type': '/resources/glossary#context-type',
  'core-deprecated-extend':
      'https://api.dart.dev/beta/latest/dart-core/Deprecated/Deprecated.extend.html',
  'core-deprecated-implement':
      'https://api.dart.dev/beta/latest/dart-core/Deprecated/Deprecated.implement.html',
  'core-deprecated-instantiate':
      'https://api.dart.dev/beta/latest/dart-core/Deprecated/Deprecated.instantiate.html',
  'core-deprecated-mixin':
      'https://api.dart.dev/beta/latest/dart-core/Deprecated/Deprecated.mixin.html',
  'core-deprecated-new':
      'https://api.dart.dev/beta/latest/dart-core/Deprecated/Deprecated.html',
  'core-deprecated-optional':
      'https://api.dart.dev/beta/latest/dart-core/Deprecated/Deprecated.optional.html',
  'core-deprecated-subclass':
      'https://api.dart.dev/beta/latest/dart-core/Deprecated/Deprecated.subclass.html',
  'definite assignment': '/resources/glossary#definite-assignment',
  'debugPrint': 'https://api.flutter.dev/flutter/foundation/debugPrint.html',
  'ffi': '/interop/c-interop',
  'irrefutable pattern': '/resources/glossary#irrefutable-pattern',
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
  'mixin application': '/resources/glossary#mixin-application',
  'obviously typed': '/resources/glossary#obviously-typed',
  'obviously-typed': '/resources/glossary#obviously-typed',
  'override inference': '/resources/glossary#override-inference',
  'package-logging': 'https://pub.dev/packages/logging',
  'part file': '/resources/glossary#part-file',
  'potentially non-nullable': '/resources/glossary#potentially-non-nullable',
  'public library': '/resources/glossary#public-library',
  'refutable pattern': '/resources/glossary#refutable-pattern',
};

/// Generate the diagnostic index page and individual diagnostic pages.
Future<void> generate() async {
  final messages = await Messages.retrieve();
  final generator = DocumentationGenerator(
    messages,
    lintNames: (await allLintNames).map((name) => name.toLowerCase()).toSet(),
  );

  generator._writeDiagnosticDataFile();
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

  /// Returns the Markdown formatted problem messages of this diagnostic.
  String get formattedProblemMessages {
    final buffer = StringBuffer();

    for (final message in messages.sorted()) {
      final escapedMessage = _escape(message).trim();
      if (escapedMessage.isEmpty) continue;
      buffer.writeln('_${escapedMessage}_\n');
    }

    return buffer.toString();
  }

  /// Returns the Markdown formatted documentation of this diagnostic.
  String get formattedDocumentation {
    final buffer = StringBuffer();

    final diagnosticDocumentation = documentation!;

    buffer.writeln(
      diagnosticDocumentation.replaceAll('#### ', '## ').trimRight(),
    );

    var noLinkReference = true;
    for (final MapEntry(key: reference, value: url)
        in _linkDefinitions.entries) {
      final linkReference = '[$reference]';
      if (diagnosticDocumentation.contains(linkReference)) {
        if (noLinkReference) {
          buffer.writeln();
          noLinkReference = false;
        }
        buffer.writeln('$linkReference: $url');
      }
    }

    return buffer.toString();
  }

  /// Return a version of the [text] in which characters that have special
  /// meaning in markdown have been escaped.
  static String _escape(String text) {
    return text.replaceAll('_', '\\_');
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

    _extractAllDocs('FrontEnd', messages.frontEndMessages);
    _extractAllDocs('FrontEnd', messages.sharedMessages);
  }

  /// Writes the condenses data representation of
  /// all diagnostics to [_indexOutputPath] for rendering the index.
  void _writeDiagnosticDataFile() {
    final condensedDiagnostics = <Map<String, Object?>>[];

    final errorCodes = infoByName.entries.sortedBy((e) => e.key);
    for (final MapEntry(key: _, value: info) in errorCodes) {
      final condensedInfo = {
        'id': info.name,
        'description': info.formattedProblemMessages.trimRight(),
        if (info.hasDocumentation) 'documentation': info.formattedDocumentation,
        'hasDocumentation': info.hasDocumentation,
        'fromLint': info.isFromLint,
        'previousNames': info.previousNames.toList(growable: false),
      };

      condensedDiagnostics.add(condensedInfo);
    }

    final file = File(_indexOutputPath);
    const indentedJsonEncoder = JsonEncoder.withIndent('  ');
    file.writeAsStringSync(indentedJsonEncoder.convert(condensedDiagnostics));
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
      final name = _camelCaseToDiagnosticNameFormat(
        errorCodeInfo.sharedName ?? errorName,
      );
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
        info.addPreviousName(previousName.toLowerCase());
      }
      final docs = _extractDoc('$className.$errorName', errorCodeInfo);
      if (docs.isNotEmpty) {
        if (info.documentation != null) {
          // Only use the first non-empty documentation.
          continue;
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
}

final RegExp _upperCasePattern = RegExp('[A-Z]');

/// Convert a `lowerCamelCase` diagnostic [name] to
/// be formatted as `lowercase_with_underscores`.
String _camelCaseToDiagnosticNameFormat(String name) => name
    .replaceAllMapped(_upperCasePattern, (m) => '_${m[0]}')
    .toLowerCase()
    .trim();
