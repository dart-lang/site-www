import 'package:opal/opal.dart' show MarkupTags, Tag, Tags;
import '../token_renderer.dart';

final Map<Tag, TextStyle> dashDarkTheme = {
  // Comments - #8B95A7
  Tags.comment: TextStyle(
    foregroundColor: Color(
      red: 0x8B / 255.0,
      green: 0x95 / 255.0,
      blue: 0xA7 / 255.0,
    ),
  ),
  Tags.lineComment: TextStyle(
    foregroundColor: Color(
      red: 0x8B / 255.0,
      green: 0x95 / 255.0,
      blue: 0xA7 / 255.0,
    ),
  ),
  Tags.blockComment: TextStyle(
    foregroundColor: Color(
      red: 0x8B / 255.0,
      green: 0x95 / 255.0,
      blue: 0xA7 / 255.0,
    ),
  ),
  Tags.docComment: TextStyle(
    foregroundColor: Color(
      red: 0x8B / 255.0,
      green: 0x95 / 255.0,
      blue: 0xA7 / 255.0,
    ),
  ),

  // Keywords and Storage - #FF897E
  Tags.keyword: TextStyle(
    foregroundColor: Color(
      red: 0xFF / 255.0,
      green: 0x89 / 255.0,
      blue: 0x7E / 255.0,
    ),
  ),
  Tags.declarationKeyword: TextStyle(
    foregroundColor: Color(
      red: 0xFF / 255.0,
      green: 0x89 / 255.0,
      blue: 0x7E / 255.0,
    ),
  ),
  Tags.modifierKeyword: TextStyle(
    foregroundColor: Color(
      red: 0xFF / 255.0,
      green: 0x89 / 255.0,
      blue: 0x7E / 255.0,
    ),
  ),
  Tags.controlKeyword: TextStyle(
    foregroundColor: Color(
      red: 0xFF / 255.0,
      green: 0x89 / 255.0,
      blue: 0x7E / 255.0,
    ),
  ),

  // Operators - #E1E2EC
  Tags.operator: TextStyle(
    foregroundColor: Color(
      red: 0xE1 / 255.0,
      green: 0xE2 / 255.0,
      blue: 0xEC / 255.0,
    ),
  ),

  // Constants and Strings - #1CDAC5
  Tags.stringLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.stringContent: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.quotedString: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.singleQuoteString: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.doubleQuoteString: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.tripleQuoteString: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.characterLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),

  // Number literals - #1CDAC5 (same as constants)
  Tags.numberLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.integerLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.floatLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),

  // Boolean and null literals - #1CDAC5
  Tags.booleanLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.trueLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.falseLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  Tags.nullLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),

  // Functions and Attributes - #B581FF
  Tags.function: TextStyle(
    foregroundColor: Color(
      red: 0xB5 / 255.0,
      green: 0x81 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),
  Tags.constructor: TextStyle(
    foregroundColor: Color(
      red: 0xB5 / 255.0,
      green: 0x81 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),
  Tags.property: TextStyle(
    foregroundColor: Color(
      red: 0xB5 / 255.0,
      green: 0x81 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),

  // Classes, Types, and Tags - #6bb1ff
  Tags.type: TextStyle(
    foregroundColor: Color(
      red: 0x6B / 255.0,
      green: 0xB1 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),
  Tags.builtInType: TextStyle(
    foregroundColor: Color(
      red: 0x6B / 255.0,
      green: 0xB1 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),
  Tags.tag: TextStyle(
    foregroundColor: Color(
      red: 0x6B / 255.0,
      green: 0xB1 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),

  // Variables and Parameters - #E1E2EC
  Tags.variable: TextStyle(
    foregroundColor: Color(
      red: 0xE1 / 255.0,
      green: 0xE2 / 255.0,
      blue: 0xEC / 255.0,
    ),
  ),
  Tags.parameter: TextStyle(
    foregroundColor: Color(
      red: 0xE1 / 255.0,
      green: 0xE2 / 255.0,
      blue: 0xEC / 255.0,
    ),
  ),

  // Punctuation - #dcdcdc (default foreground)
  Tags.punctuation: TextStyle(
    foregroundColor: Color(
      red: 0xDC / 255.0,
      green: 0xDC / 255.0,
      blue: 0xDC / 255.0,
    ),
  ),
  Tags.separator: TextStyle(
    foregroundColor: Color(
      red: 0xDC / 255.0,
      green: 0xDC / 255.0,
      blue: 0xDC / 255.0,
    ),
  ),
  Tags.accessor: TextStyle(
    foregroundColor: Color(
      red: 0xDC / 255.0,
      green: 0xDC / 255.0,
      blue: 0xDC / 255.0,
    ),
  ),

  // Annotations/Metadata - #B581FF (same as functions)
  Tags.annotation: TextStyle(
    foregroundColor: Color(
      red: 0xB5 / 255.0,
      green: 0x81 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),

  // Special identifiers - #FF897E (same as keywords)
  Tags.specialIdentifier: TextStyle(
    foregroundColor: Color(
      red: 0xFF / 255.0,
      green: 0x89 / 255.0,
      blue: 0x7E / 255.0,
    ),
  ),

  // String escape sequences - brighter/highlighted version
  Tags.stringEscape: TextStyle(
    foregroundColor: Color(
      red: 0x2A / 255.0,
      green: 0xF5 / 255.0,
      blue: 0xDE / 255.0,
    ),
    fontWeight: FontWeight.w600,
  ),

  // String interpolation - #E1E2EC (operators/interpolations color)
  Tags.stringInterpolation: TextStyle(
    foregroundColor: Color(
      red: 0xE1 / 255.0,
      green: 0xE2 / 255.0,
      blue: 0xEC / 255.0,
    ),
  ),

  // Markup tags
  MarkupTags.bold: TextStyle(
    fontWeight: FontWeight.w700,
  ),
  MarkupTags.italic: TextStyle(
    fontStyle: FontStyle.italic,
  ),
  MarkupTags.underline: TextStyle(
    foregroundColor: Color(
      red: 0xDC / 255.0,
      green: 0xDC / 255.0,
      blue: 0xDC / 255.0,
    ),
  ),
  MarkupTags.strikethrough: TextStyle(
    foregroundColor: Color(
      red: 0x8B / 255.0,
      green: 0x95 / 255.0,
      blue: 0xA7 / 255.0,
    ),
  ),
  MarkupTags.heading: TextStyle(
    fontWeight: FontWeight.w700,
  ),
  MarkupTags.code: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  MarkupTags.codeBlock: TextStyle(
    foregroundColor: Color(
      red: 0xDC / 255.0,
      green: 0xDC / 255.0,
      blue: 0xDC / 255.0,
    ),
  ),
  MarkupTags.link: TextStyle(
    foregroundColor: Color(
      red: 0x6B / 255.0,
      green: 0xB1 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),
  MarkupTags.linkReference: TextStyle(
    foregroundColor: Color(
      red: 0x6B / 255.0,
      green: 0xB1 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),
  MarkupTags.linkDefinition: TextStyle(
    foregroundColor: Color(
      red: 0x6B / 255.0,
      green: 0xB1 / 255.0,
      blue: 0xFF / 255.0,
    ),
  ),

  // Diff formatting
  MarkupTags.inserted: TextStyle(
    foregroundColor: Color(
      red: 0x1C / 255.0,
      green: 0xDA / 255.0,
      blue: 0xC5 / 255.0,
    ),
  ),
  MarkupTags.removed: TextStyle(
    foregroundColor: Color(
      red: 0xFF / 255.0,
      green: 0x89 / 255.0,
      blue: 0x7E / 255.0,
    ),
  ),

  // Invalid/error content
  Tags.invalid: TextStyle(
    foregroundColor: Color(
      red: 0xFF / 255.0,
      green: 0x89 / 255.0,
      blue: 0x7E / 255.0,
    ),
    fontWeight: FontWeight.w600,
  ),
};
