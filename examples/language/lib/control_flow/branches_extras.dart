// ignore_for_file: unused_local_variable

sealed class Question {}

class TextQuestion extends Question {
  final String body;
  final String category;
  final String id;
  final Answer answer;

  TextQuestion({
    required this.body,
    required this.category,
    required this.id,
    required this.answer,
  });
}

class ImageQuestion extends Question {
  final String imagePath;
  final Answer answer;

  ImageQuestion({required this.imagePath, required this.answer});
}

abstract class Answer {}

class MultipleChoiceAnswer extends Answer {}

class BooleanAnswer extends Answer {}

abstract class QuestionWidget {}

class TextQuestionWidget extends QuestionWidget {
  TextQuestionWidget(Question question);
}

class MultipleChoiceWidget extends AnswerWidget {
  MultipleChoiceWidget(MultipleChoiceAnswer answer);
}

class ImageQuestionWidget extends QuestionWidget {
  ImageQuestionWidget(Question question);
}

class BooleanAnswerWidget extends AnswerWidget {
  BooleanAnswerWidget(BooleanAnswer answer);
}

abstract class AnswerWidget {}

class DefaultAnswerWidget extends AnswerWidget {}

// #docregion json-validation-before
// Imperative, verbose JSON validation
Question fromJson(Map<String, dynamic> json) {
  if (json.containsKey('type') && json['type'] == 'textQuestion') {
    if (json.containsKey('questionBody') && json['questionBody'] is String) {
      // ... more validation ...
      return TextQuestion(
        body: json['questionBody'] as String,
        category: '',
        id: '',
        answer: MultipleChoiceAnswer(),
      );
    }
  }
  throw FormatException('Invalid JSON');
}
// #enddocregion json-validation-before

// #docregion json-validation-after
// Dart 3: Switch expression with Map Patterns
Question fromJsonWithSwitch(Map<String, dynamic> json) {
  return switch (json) {
    {
      'type': 'textQuestion',
      'questionBody': String body,
      'category': String cat,
      'id': String id,
    } =>
      TextQuestion(
        body: body,
        category: cat,
        id: id,
        answer: MultipleChoiceAnswer(),
      ),
    {
      'type': 'imageQuestion',
      'imagePath': String path,
      // ...
    } =>
      ImageQuestion(imagePath: path, answer: BooleanAnswer()),
    _ => throw FormatException('JSON did not match expected patterns'),
  };
}
// #enddocregion json-validation-after

// #docregion object-patterns
// Returning specific Widgets based on subclass types and their properties
(QuestionWidget, AnswerWidget) getWidgets(Question question) {
  return switch (question) {
    TextQuestion(answer: MultipleChoiceAnswer answer) => (
      TextQuestionWidget(question),
      MultipleChoiceWidget(answer),
    ),
    TextQuestion() => (TextQuestionWidget(question), DefaultAnswerWidget()),
    ImageQuestion(answer: BooleanAnswer answer) => (
      ImageQuestionWidget(question),
      BooleanAnswerWidget(answer),
    ),
    ImageQuestion() => (ImageQuestionWidget(question), DefaultAnswerWidget()),
  };
}
// #enddocregion object-patterns

Color getButtonColor(
  bool isActive,
  bool isPressed,
  bool isHovered,
  bool isSelected,
  bool isCorrect,
) {
  const pressedColor = Color();
  const hoveredColor = Color();
  const initialColor = Color();
  const incorrectAnswerColor = Color();
  const correctAnswerColor = Color();
  const inactiveColor = Color();

  // #docregion exhaustiveness-ui-state
  // Create a Record of current UI states
  final state = (isActive, isPressed, isHovered, isSelected, isCorrect);

  return switch (state) {
    (true, true, _, _, _) => pressedColor,
    (true, false, true, _, _) => hoveredColor,
    (true, false, false, _, _) => initialColor,
    (false, _, _, true, false) => incorrectAnswerColor,
    (false, _, _, true, true) => correctAnswerColor,
    (false, _, _, false, _) => inactiveColor,
  };
  // #enddocregion exhaustiveness-ui-state
}

class Color {
  const Color();
}
