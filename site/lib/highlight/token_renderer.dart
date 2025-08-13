import 'package:meta/meta.dart';
import 'package:opal/opal.dart' show Tag, TaggedToken;

abstract final class TokenRenderer<T> {
  const TokenRenderer();

  @useResult
  T render(List<List<TaggedToken>> tokenLines);
}

final class ThemedTokenRenderer extends TokenRenderer<List<List<ThemedSpan>>> {
  final Map<String, Theme> themeByName;

  const ThemedTokenRenderer({required this.themeByName});

  @override
  List<List<ThemedSpan>> render(List<List<TaggedToken>> tokenLines) {
    final result = <List<ThemedSpan>>[];

    for (final line in tokenLines) {
      final currentLine = <ThemedSpan>[];
      for (final token in line) {
        final styleByTheme = <String, TextStyle>{};
        for (final entry in themeByName.entries) {
          final style = entry.value.styleForSpan(token);
          if (style != null) {
            styleByTheme[entry.key] = style;
          }
        }
        currentLine.add(
          ThemedSpan(
            content: token.content,
            styleByTheme: styleByTheme,
            tag: token.tags.join(','),
          ),
        );
      }

      result.add(currentLine);
    }

    return result;
  }
}

final class Theme {
  final Map<Tag, TextStyle> _textStyleByTag;

  Theme(Map<Tag, TextStyle> textStyleByTag)
    : _textStyleByTag = {...textStyleByTag};

  @useResult
  TextStyle? styleForSpan(TaggedToken token) => token.tags.reversed
      .expand((t) => t.expand())
      .map((t) => _textStyleByTag[t])
      .nonNulls
      .firstOrNull;
}

final class ThemedSpan {
  final String content;
  final Map<String, TextStyle> styleByTheme;
  final String tag;

  ThemedSpan({
    required this.content,
    required this.styleByTheme,
    required this.tag,
  });
}

final class TextStyle {
  static final none = TextStyle();

  final Color? foregroundColor;
  final Color? backgroundColor;
  final FontStyle? fontStyle;
  final FontWeight? fontWeight;

  TextStyle({
    this.foregroundColor,
    this.backgroundColor,
    this.fontStyle,
    this.fontWeight,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextStyle &&
          foregroundColor == other.foregroundColor &&
          backgroundColor == other.backgroundColor &&
          fontStyle == other.fontStyle &&
          fontWeight == other.fontWeight;

  @override
  int get hashCode =>
      Object.hash(foregroundColor, backgroundColor, fontStyle, fontWeight);
}

final class Color {
  final double alpha;
  final double red;
  final double green;
  final double blue;

  Color({
    this.alpha = 1,
    required this.red,
    required this.green,
    required this.blue,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Color &&
          alpha == other.alpha &&
          red == other.red &&
          green == other.green &&
          blue == other.blue;

  @override
  int get hashCode => Object.hash(alpha, red, green, blue);
}

enum FontStyle {
  normal,
  italic,
}

enum FontWeight {
  w100(100),
  w200(200),
  w300(300),
  w400(400),
  w500(500),
  w600(600),
  w700(700),
  w800(800),
  w900(900);

  final int weight;

  const FontWeight(this.weight);
}
