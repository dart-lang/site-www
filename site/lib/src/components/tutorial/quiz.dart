// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';
import 'package:yaml/yaml.dart';

import '../../markdown/markdown_parser.dart';
import '../../models/quiz_model.dart';
import 'client/quiz.dart';

class Quiz extends CustomComponent {
  const Quiz() : super.base();

  @override
  Component? create(Node node, NodesBuilder builder) {
    if (node is ElementNode && node.tag.toLowerCase() == 'quiz') {
      if (node.children?.whereType<ElementNode>().isNotEmpty ?? false) {
        throw Exception(
          'Invalid Quiz content. Remove any leading empty lines to '
          'avoid parsing as markdown.',
        );
      }

      final title = node.attributes['title'];

      final content = node.children?.map((n) => n.innerText).join('\n') ?? '';
      final data = loadYamlNode(content);
      assert(data is YamlList, 'Invalid Quiz content. Expected a YAML list.');
      final questions = (data as YamlList).nodes
          .map((n) => parseQuestion(n as YamlMap))
          .toList();
      assert(questions.isNotEmpty, 'Quiz must contain at least one question.');
      return InteractiveQuiz(title: title, questions: questions);
    }
    return null;
  }
}

Question parseQuestion(YamlMap map) {
  return Question(
    parseMarkdownToHtml(map['question'] as String, inline: true),
    (map['options'] as List<Object?>)
        .map((e) => parseAnswer(e as YamlMap))
        .toList(),
  );
}

AnswerOption parseAnswer(YamlMap map) {
  return AnswerOption(
    parseMarkdownToHtml(map['text'] as String, inline: true),
    map['correct'] as bool? ?? false,
    parseMarkdownToHtml(map['explanation'] as String),
  );
}
