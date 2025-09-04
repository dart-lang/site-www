// Copyright (c) 2025, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:jaspr_content/jaspr_content.dart';

import 'attribute_processor.dart';
import 'code_block_processor.dart';
import 'header_processor.dart';
import 'table_processor.dart';

/// A list of all node-processing, page extensions to applied to
/// content loaded with Jaspr Content.
const List<PageExtension> allNodeProcessingExtensions = [
  AttributeProcessor(),
  TableOfContentsExtension(maxHeaderDepth: 3),
  HeaderWrapperExtension(),
  TableWrapperExtension(),
  CodeBlockProcessor(),
];
