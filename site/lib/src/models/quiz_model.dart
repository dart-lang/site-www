// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:jaspr/jaspr.dart';

class Question {
  const Question(this.question, this.options);

  final String question;
  final List<AnswerOption> options;

  @decoder
  factory Question.fromMap(Map<String, Object?> json) {
    return Question(
      json['question'] as String,
      (json['options'] as List<Object?>)
          .map((e) => AnswerOption.fromJson(e as Map<String, Object?>))
          .shuffled(),
    );
  }

  @encoder
  Map<String, Object?> toJson() => {
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
  factory AnswerOption.fromJson(Map<String, Object?> json) {
    return AnswerOption(
      json['text'] as String,
      json['correct'] as bool? ?? false,
      json['explanation'] as String,
    );
  }

  @encoder
  Map<String, Object?> toJson() => {
    'text': text,
    'correct': correct,
    'explanation': explanation,
  };
}
