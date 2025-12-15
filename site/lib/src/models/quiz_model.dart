// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:jaspr/jaspr.dart';

import '../markdown/markdown_parser.dart' show parseMarkdownToHtml;

class Question {
  const Question(this.question, this.options);

  final String question;
  final List<AnswerOption> options;

  @decoder
  factory Question.fromMap(Map<Object?, Object?> json) {
    return Question(
      parseMarkdownToHtml(json['question'] as String, inline: true),
      (json['options'] as List<Object?>)
          .map((e) => AnswerOption.fromJson(e as Map<Object?, Object?>))
          .shuffled(),
    );
  }

  @encoder
  Map<Object?, Object?> toJson() => {
    'question': question,
    'options': options.map((e) => e.toJson()).toList(),
  };
}

class AnswerOption {
  const AnswerOption(this.text, this.correct, this.explanation);

  /// The option text formatted as raw HTML.
  final String text;

  /// Whether this answer is correct.
  final bool correct;

  /// The correct/incorrect explanation formatted as raw HTML.
  final String explanation;

  @decoder
  factory AnswerOption.fromJson(Map<Object?, Object?> json) {
    return AnswerOption(
      parseMarkdownToHtml(json['text'] as String, inline: true),
      json['correct'] as bool? ?? false,
      parseMarkdownToHtml(json['explanation'] as String),
    );
  }

  @encoder
  Map<Object?, Object?> toJson() => {
    'text': text,
    'correct': correct,
    'explanation': explanation,
  };
}
