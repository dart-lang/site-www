import 'package:opal/opal.dart' show MarkupTags, Tag, Tags;
import '../token_renderer.dart';

final Map<Tag, TextStyle> dashLightTheme = {
  // Comments - #59616E
  Tags.comment: TextStyle(
    foregroundColor: Color(
      red: 0x59 / 255.0,
      green: 0x61 / 255.0,
      blue: 0x6E / 255.0,
    ),
  ),
  Tags.lineComment: TextStyle(
    foregroundColor: Color(
      red: 0x59 / 255.0,
      green: 0x61 / 255.0,
      blue: 0x6E / 255.0,
    ),
  ),
  Tags.blockComment: TextStyle(
    foregroundColor: Color(
      red: 0x59 / 255.0,
      green: 0x61 / 255.0,
      blue: 0x6E / 255.0,
    ),
  ),
  Tags.docComment: TextStyle(
    foregroundColor: Color(
      red: 0x59 / 255.0,
      green: 0x61 / 255.0,
      blue: 0x6E / 255.0,
    ),
  ),

  // Keywords and Storage - #BD2314
  Tags.keyword: TextStyle(
    foregroundColor: Color(
      red: 0xBD / 255.0,
      green: 0x23 / 255.0,
      blue: 0x14 / 255.0,
    ),
  ),
  Tags.declarationKeyword: TextStyle(
    foregroundColor: Color(
      red: 0xBD / 255.0,
      green: 0x23 / 255.0,
      blue: 0x14 / 255.0,
    ),
  ),
  Tags.modifierKeyword: TextStyle(
    foregroundColor: Color(
      red: 0xBD / 255.0,
      green: 0x23 / 255.0,
      blue: 0x14 / 255.0,
    ),
  ),
  Tags.controlKeyword: TextStyle(
    foregroundColor: Color(
      red: 0xBD / 255.0,
      green: 0x23 / 255.0,
      blue: 0x14 / 255.0,
    ),
  ),

  // Operators - #191C22 (default foreground)
  Tags.operator: TextStyle(
    foregroundColor: Color(
      red: 0x19 / 255.0,
      green: 0x1C / 255.0,
      blue: 0x22 / 255.0,
    ),
  ),

  // Constants and Strings - #0C7064
  Tags.stringLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.stringContent: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.quotedString: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.singleQuoteString: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.doubleQuoteString: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.tripleQuoteString: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.characterLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),

  // Number literals - #0C7064 (same as constants)
  Tags.numberLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.integerLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.floatLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),

  // Boolean and null literals - #0C7064
  Tags.booleanLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.trueLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.falseLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  Tags.nullLiteral: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),

  // Functions and Attributes - #6200EE
  Tags.function: TextStyle(
    foregroundColor: Color(
      red: 0x62 / 255.0,
      green: 0x00 / 255.0,
      blue: 0xEE / 255.0,
    ),
  ),
  Tags.constructor: TextStyle(
    foregroundColor: Color(
      red: 0x62 / 255.0,
      green: 0x00 / 255.0,
      blue: 0xEE / 255.0,
    ),
  ),
  Tags.property: TextStyle(
    foregroundColor: Color(
      red: 0x62 / 255.0,
      green: 0x00 / 255.0,
      blue: 0xEE / 255.0,
    ),
  ),

  // Classes, Types, and Tags - #146BCD
  Tags.type: TextStyle(
    foregroundColor: Color(
      red: 0x14 / 255.0,
      green: 0x6B / 255.0,
      blue: 0xCD / 255.0,
    ),
  ),
  Tags.builtInType: TextStyle(
    foregroundColor: Color(
      red: 0x14 / 255.0,
      green: 0x6B / 255.0,
      blue: 0xCD / 255.0,
    ),
  ),
  Tags.tag: TextStyle(
    foregroundColor: Color(
      red: 0x14 / 255.0,
      green: 0x6B / 255.0,
      blue: 0xCD / 255.0,
    ),
  ),

  // Variables and Parameters - #191C22 (default foreground)
  Tags.variable: TextStyle(
    foregroundColor: Color(
      red: 0x19 / 255.0,
      green: 0x1C / 255.0,
      blue: 0x22 / 255.0,
    ),
  ),
  Tags.parameter: TextStyle(
    foregroundColor: Color(
      red: 0x19 / 255.0,
      green: 0x1C / 255.0,
      blue: 0x22 / 255.0,
    ),
  ),

  // Punctuation - #191C22 (default foreground)
  Tags.punctuation: TextStyle(
    foregroundColor: Color(
      red: 0x19 / 255.0,
      green: 0x1C / 255.0,
      blue: 0x22 / 255.0,
    ),
  ),
  Tags.separator: TextStyle(
    foregroundColor: Color(
      red: 0x19 / 255.0,
      green: 0x1C / 255.0,
      blue: 0x22 / 255.0,
    ),
  ),
  Tags.accessor: TextStyle(
    foregroundColor: Color(
      red: 0x19 / 255.0,
      green: 0x1C / 255.0,
      blue: 0x22 / 255.0,
    ),
  ),

  // Annotations/Metadata - #6200EE (same as functions)
  Tags.annotation: TextStyle(
    foregroundColor: Color(
      red: 0x62 / 255.0,
      green: 0x00 / 255.0,
      blue: 0xEE / 255.0,
    ),
  ),

  // Special identifiers - #BD2314 (same as keywords)
  Tags.specialIdentifier: TextStyle(
    foregroundColor: Color(
      red: 0xBD / 255.0,
      green: 0x23 / 255.0,
      blue: 0x14 / 255.0,
    ),
  ),

  // String escape sequences - darker/highlighted version
  Tags.stringEscape: TextStyle(
    foregroundColor: Color(
      red: 0x0A / 255.0,
      green: 0x5A / 255.0,
      blue: 0x50 / 255.0,
    ),
    fontWeight: FontWeight.w600,
  ),

  // String interpolation - function color
  Tags.stringInterpolation: TextStyle(
    foregroundColor: Color(
      red: 0x62 / 255.0,
      green: 0x00 / 255.0,
      blue: 0xEE / 255.0,
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
      red: 0x19 / 255.0,
      green: 0x1C / 255.0,
      blue: 0x22 / 255.0,
    ),
  ),
  MarkupTags.strikethrough: TextStyle(
    foregroundColor: Color(
      red: 0x59 / 255.0,
      green: 0x61 / 255.0,
      blue: 0x6E / 255.0,
    ),
  ),
  MarkupTags.heading: TextStyle(
    fontWeight: FontWeight.w700,
  ),
  MarkupTags.code: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  MarkupTags.codeBlock: TextStyle(
    foregroundColor: Color(
      red: 0x19 / 255.0,
      green: 0x1C / 255.0,
      blue: 0x22 / 255.0,
    ),
  ),
  MarkupTags.link: TextStyle(
    foregroundColor: Color(
      red: 0x14 / 255.0,
      green: 0x6B / 255.0,
      blue: 0xCD / 255.0,
    ),
  ),
  MarkupTags.linkReference: TextStyle(
    foregroundColor: Color(
      red: 0x14 / 255.0,
      green: 0x6B / 255.0,
      blue: 0xCD / 255.0,
    ),
  ),
  MarkupTags.linkDefinition: TextStyle(
    foregroundColor: Color(
      red: 0x14 / 255.0,
      green: 0x6B / 255.0,
      blue: 0xCD / 255.0,
    ),
  ),

  // Diff formatting
  MarkupTags.inserted: TextStyle(
    foregroundColor: Color(
      red: 0x0C / 255.0,
      green: 0x70 / 255.0,
      blue: 0x64 / 255.0,
    ),
  ),
  MarkupTags.removed: TextStyle(
    foregroundColor: Color(
      red: 0xBD / 255.0,
      green: 0x23 / 255.0,
      blue: 0x14 / 255.0,
    ),
  ),

  // Invalid/error content
  Tags.invalid: TextStyle(
    foregroundColor: Color(
      red: 0xBD / 255.0,
      green: 0x23 / 255.0,
      blue: 0x14 / 255.0,
    ),
    fontWeight: FontWeight.w600,
  ),
};
