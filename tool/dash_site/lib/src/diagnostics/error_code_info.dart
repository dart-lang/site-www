// Copyright (c) 2021, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:yaml/yaml.dart' show loadYaml;

final class Messages {
  /// Decoded messages from the analyzer's `messages.yaml` file.
  final Map<String, Map<String, AnalyzerErrorCodeInfo>> analyzerMessages;

  /// Decoded messages from the linter's `messages.yaml` file.
  final Map<String, Map<String, AnalyzerErrorCodeInfo>> linterMessages;

  /// Decoded messages from the front end and analyzer's
  /// shared `messages.yaml` file.
  final Map<String, FrontEndErrorCodeInfo> sharedMessages;

  /// Decoded messages from the front end's `messages.yaml` file.
  final Map<String, FrontEndErrorCodeInfo> frontEndMessages;

  /// A set of tables mapping between front end and analyzer error codes.
  final CfeToAnalyzerErrorCodeTables cfeToAnalyzerErrorCodeTables;

  Messages._({
    required this.analyzerMessages,
    required this.linterMessages,
    required this.frontEndMessages,
    required this.sharedMessages,
    required this.cfeToAnalyzerErrorCodeTables,
  });

  static Future<Messages> retrieve() async {
    final rawAnalyzerYaml = await _loadSdkYaml('pkg/analyzer/messages.yaml');
    final analyzerMessages = _decodeAnalyzerMessagesYaml(rawAnalyzerYaml);
    final rawAnalysisServerYaml = await _loadSdkYaml(
      'pkg/analysis_server/messages.yaml',
    );
    final analysisServerMessages = _decodeAnalyzerMessagesYaml(
      rawAnalysisServerYaml,
    );
    final rawFrontEndYaml = await _loadSdkYaml('pkg/front_end/messages.yaml');
    final frontEndMessages = _decodeCfeMessagesYaml(rawFrontEndYaml);
    final rawSharedYaml = await _loadSdkYaml(
      'pkg/_fe_analyzer_shared/messages.yaml',
    );
    final sharedMessages = _decodeCfeMessagesYaml(rawSharedYaml);
    final rawLinterYaml = await _loadSdkYaml('pkg/linter/messages.yaml');
    final linterMessages = _decodeAnalyzerMessagesYaml(rawLinterYaml);

    return Messages._(
      analyzerMessages: {...analyzerMessages, ...analysisServerMessages},
      linterMessages: linterMessages,
      frontEndMessages: frontEndMessages,
      cfeToAnalyzerErrorCodeTables: CfeToAnalyzerErrorCodeTables._({
        ...frontEndMessages,
        ...sharedMessages,
      }),
      sharedMessages: sharedMessages,
    );
  }
}

/// Pattern used by the front end to identify placeholders in error message
/// strings.
final RegExp _placeholderPattern = RegExp(
  '#([-a-zA-Z0-9_]+)(?:%([0-9]*).([0-9]+))?',
);

/// Convert a CFE template string (which uses placeholders like `#string`) to
/// an analyzer template string (which uses placeholders like `{0}`).
String convertTemplate(Map<String, int> placeholderToIndexMap, String entry) {
  return entry.replaceAllMapped(
    _placeholderPattern,
    (match) => '{${placeholderToIndexMap[match.group(0)!]}}',
  );
}

Future<String> _fetchSdkFile(String pathInSdk) async {
  final uri = Uri.parse(
    'https://raw.githubusercontent.com/dart-lang/sdk/refs/heads/main/$pathInSdk',
  );
  final rawFile = await http.read(uri);
  return rawFile;
}

Future<Object?> _loadSdkYaml(String pathInSdk) async {
  final yamlString = await _fetchSdkFile(pathInSdk);
  return loadYaml(yamlString) as Object?;
}

/// Decodes a YAML object (obtained from a `messages.yaml` file) into a
/// two-level map of [ErrorCodeInfo], indexed first by class name and then by
/// error name.
Map<String, Map<String, AnalyzerErrorCodeInfo>> _decodeAnalyzerMessagesYaml(
  Object? yaml,
) {
  Never problem(String message) {
    throw Exception('Problem in analyzer/messages.yaml: $message');
  }

  final result = <String, Map<String, AnalyzerErrorCodeInfo>>{};
  if (yaml is! Map<Object?, Object?>) {
    problem('root node is not a map');
  }
  for (final classEntry in yaml.entries) {
    final className = classEntry.key;
    if (className is! String) {
      problem('non-string class key ${json.encode(className)}');
    }
    final classValue = classEntry.value;
    if (classValue is! Map<Object?, Object?>) {
      problem('value associated with class key $className is not a map');
    }
    for (final errorEntry in classValue.entries) {
      final errorName = errorEntry.key;
      if (errorName is! String) {
        problem(
          'in class $className, non-string error key '
          '${json.encode(errorName)}',
        );
      }
      final errorValue = errorEntry.value;
      if (errorValue is! Map<Object?, Object?>) {
        problem(
          'value associated with error $className.$errorName is not a '
          'map',
        );
      }

      AnalyzerErrorCodeInfo errorCodeInfo;
      try {
        errorCodeInfo = (result[className] ??= {})[errorName] =
            AnalyzerErrorCodeInfo.fromYaml(errorValue);
      } catch (e, st) {
        Error.throwWithStackTrace(
          'while processing $className.$errorName, $e',
          st,
        );
      }

      if (errorCodeInfo case AliasErrorCodeInfo(:final aliasFor)) {
        final aliasForPath = aliasFor.split('.');
        if (aliasForPath.isEmpty) {
          problem("The 'aliasFor' value at '$className.$errorName is empty");
        }
        var node = yaml;
        for (final key in aliasForPath) {
          final value = node[key];
          if (value is! Map<Object?, Object?>) {
            problem(
              'No Map value at "$aliasFor", aliased from '
              '$className.$errorName',
            );
          }
          node = value;
        }
      }
    }
  }
  return result;
}

/// Decodes a YAML object (obtained from `pkg/front_end/messages.yaml`) into a
/// map from error name to [ErrorCodeInfo].
Map<String, FrontEndErrorCodeInfo> _decodeCfeMessagesYaml(Object? yaml) {
  Never problem(String message) {
    throw Exception('Problem in pkg/front_end/messages.yaml: $message');
  }

  final result = <String, FrontEndErrorCodeInfo>{};
  if (yaml is! Map<Object?, Object?>) {
    problem('root node is not a map');
  }
  for (final entry in yaml.entries) {
    final errorName = entry.key;
    if (errorName is! String) {
      problem('non-string error key ${json.encode(errorName)}');
    }
    final errorValue = entry.value;
    if (errorValue is! Map<Object?, Object?>) {
      problem('value associated with error $errorName is not a map');
    }
    result[errorName] = FrontEndErrorCodeInfo.fromYaml(errorValue);
  }
  return result;
}

/// An [AnalyzerErrorCodeInfo] which is an alias for another, for incremental
/// deprecation purposes.
class AliasErrorCodeInfo extends AnalyzerErrorCodeInfo {
  final String aliasFor;

  AliasErrorCodeInfo._fromYaml(super.yaml, {required this.aliasFor})
    : super._fromYaml();

  String get aliasForClass => aliasFor.split('.').first;
}

/// In-memory representation of error code information obtained from the
/// analyzer's `messages.yaml` file.
class AnalyzerErrorCodeInfo extends ErrorCodeInfo {
  AnalyzerErrorCodeInfo({
    super.correctionMessage,
    super.deprecatedMessage,
    super.documentation,
    required super.problemMessage,
    super.sharedName,
  });

  factory AnalyzerErrorCodeInfo.fromYaml(Map<Object?, Object?> yaml) {
    if (yaml['aliasFor'] case final aliasFor?) {
      return AliasErrorCodeInfo._fromYaml(yaml, aliasFor: aliasFor as String);
    } else {
      return AnalyzerErrorCodeInfo._fromYaml(yaml);
    }
  }

  AnalyzerErrorCodeInfo._fromYaml(super.yaml) : super.fromYaml();
}

/// Data tables mapping between CFE errors and their corresponding automatically
/// generated analyzer errors.
class CfeToAnalyzerErrorCodeTables {
  /// Map whose values are the CFE errors for which analyzer errors should be
  /// automatically generated, and whose keys are the corresponding analyzer
  /// error name.  (Names are simple identifiers; they are not prefixed by the
  /// class name `ParserErrorCode`)
  final Map<String, ErrorCodeInfo> analyzerCodeToInfo = {};

  CfeToAnalyzerErrorCodeTables._(Map<String, FrontEndErrorCodeInfo> messages) {
    for (final entry in messages.entries) {
      final errorCodeInfo = entry.value;
      if (errorCodeInfo.analyzerCode.length != 1) {
        continue;
      }
      final frontEndCode = entry.key;
      final analyzerCodeLong = errorCodeInfo.analyzerCode.single;
      final String analyzerCode;
      if (analyzerCodeLong.startsWith('ParserErrorCode.')) {
        analyzerCode = analyzerCodeLong.substring('ParserErrorCode.'.length);
      } else if (analyzerCodeLong.startsWith('CompileTimeErrorCode.')) {
        analyzerCode = analyzerCodeLong.substring(
          'CompileTimeErrorCode.'.length,
        );
      } else {
        // Ignore error codes that start with other types.
        continue;
      }
      final previousEntryForAnalyzerCode = analyzerCodeToInfo[analyzerCode];
      if (previousEntryForAnalyzerCode != null) {
        throw Exception(
          'Analyzer code $analyzerCode used by both '
          '$previousEntryForAnalyzerCode and '
          '$frontEndCode',
        );
      }
      analyzerCodeToInfo[analyzerCode] = errorCodeInfo;
    }
  }
}

/// In-memory representation of error code information obtained from either the
/// analyzer or the front end's `messages.yaml` file.  This class contains the
/// common functionality supported by both formats.
abstract class ErrorCodeInfo {
  /// If the error code has an associated correctionMessage, the template for
  /// it.
  final String? correctionMessage;

  /// If non-null, the deprecation message for this error code.
  final String? deprecatedMessage;

  /// If present, user-facing documentation for the error.
  final String? documentation;

  /// The problemMessage for the error code.
  final String problemMessage;

  /// If present, indicates that this error code has a special name for
  /// presentation to the user, that is potentially shared with other error
  /// codes.
  final String? sharedName;

  /// If present, indicates that this error code has been renamed from
  /// [previousName] to its current name (or [sharedName]).
  final String? previousName;

  ErrorCodeInfo({
    this.documentation,
    this.sharedName,
    required this.problemMessage,
    this.correctionMessage,
    this.deprecatedMessage,
    this.previousName,
  });

  /// Decodes an [ErrorCodeInfo] object from its YAML representation.
  ErrorCodeInfo.fromYaml(Map<Object?, Object?> yaml)
    : this(
        correctionMessage: yaml['correctionMessage'] as String?,
        deprecatedMessage: yaml['deprecatedMessage'] as String?,
        documentation: yaml['documentation'] as String?,
        problemMessage: yaml['problemMessage'] as String? ?? '',
        sharedName: yaml['sharedName'] as String?,
        previousName: yaml['previousName'] as String?,
      );

  /// Given a messages.yaml entry, come up with a mapping from placeholder
  /// patterns in its message strings to their corresponding indices.
  Map<String, int> computePlaceholderToIndexMap() {
    final mapping = <String, int>{};
    for (final value in [problemMessage, correctionMessage]) {
      if (value is! String) continue;
      for (final Match match in _placeholderPattern.allMatches(value)) {
        // CFE supports a bunch of formatting options that analyzer doesn't;
        // make sure none of those are used.
        if (match.group(0) != '#${match.group(1)}') {
          throw Exception(
            'Template string ${json.encode(value)} contains unsupported '
            'placeholder pattern ${json.encode(match.group(0))}',
          );
        }

        mapping[match.group(0)!] ??= mapping.length;
      }
    }
    return mapping;
  }
}

/// In-memory representation of error code information obtained from the front
/// end's `messages.yaml` file.
class FrontEndErrorCodeInfo extends ErrorCodeInfo {
  /// The set of analyzer error codes that corresponds to this error code, if
  /// any.
  final List<String> analyzerCode;

  FrontEndErrorCodeInfo.fromYaml(super.yaml)
    : analyzerCode = _decodeAnalyzerCode(yaml['analyzerCode']),
      super.fromYaml();

  static List<String> _decodeAnalyzerCode(Object? value) {
    return switch (value) {
      null => const [],
      String() => [value],
      List() => [for (final s in value) s as String],
      _ => throw Exception('Unrecognized analyzer code: $value'),
    };
  }
}
