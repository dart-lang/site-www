// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../../markdown/markdown_parser.dart';
import '../../models/quiz_model.dart';
import 'client/quiz.dart';

class Quiz extends CustomComponent {
  const Quiz() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node is! ElementNode || node.tag.toLowerCase() != 'quiz') {
      return null;
    }

    final quizId = node.attributes['id'];
    if (quizId == null || quizId.isEmpty) return null;
    final quizTitle = node.attributes['title'];

    return Builder(
      builder: (context) {
        final quizzes = context.page.data['quiz'] as Map<String, Object?>?;
        if (quizzes?[quizId] case final List<Object?> quizData) {
          return InteractiveQuiz(
            title: quizTitle,
            questions: quizData
                .map((q) => _parseQuestion(q as Map<String, Object?>))
                .toList(growable: false),
          );
        }

        throw ArgumentError('Failed to parse quiz with ID: $quizId');
      },
    );
  }
}

Question _parseQuestion(Map<Object?, Object?> map) => Question(
  parseMarkdownToHtml(map['question'] as String, inline: true),
  (map['options'] as List<Object?>)
      .map((e) => _parseAnswer(e as Map<Object?, Object?>))
      .toList(),
);

AnswerOption _parseAnswer(Map<Object?, Object?> map) => AnswerOption(
  parseMarkdownToHtml(map['text'] as String, inline: true),
  map['correct'] as bool? ?? false,
  parseMarkdownToHtml(map['explanation'] as String),
);
