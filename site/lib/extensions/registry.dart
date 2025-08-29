import 'package:jaspr_content/jaspr_content.dart';

import 'attribute_processor.dart';
import 'code_block_processor.dart';
import 'header_processor.dart';
import 'table_processor.dart';

const List<PageExtension> allNodeProcessingExtensions = [
  AttributeProcessor(),
  TableOfContentsExtension(maxHeaderDepth: 3),
  HeaderWrapperExtension(),
  TableWrapperExtension(),
  CodeBlockProcessor(),
];
