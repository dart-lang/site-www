import 'dart:async';

import 'package:build/build.dart';

import 'src/builders/styles_hash_builder.dart';

Builder stylesHashBuilder(BuilderOptions options) => StylesHashBuilder(options);
Builder contentAssetsBuilder(BuilderOptions options) => ContentAssetsBuilder();

class ContentAssetsBuilder implements Builder {
  @override
  final buildExtensions = const {
    'src/content/{{}}.png': ['web/images/content/{{}}.png'],
    'src/content/{{}}.jpg': ['web/images/content/{{}}.jpg'],
    'src/content/{{}}.jpeg': ['web/images/content/{{}}.jpeg'],
    'src/content/{{}}.gif': ['web/images/content/{{}}.gif'],
    'src/content/{{}}.svg': ['web/images/content/{{}}.svg'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final inputId = buildStep.inputId;
    // extension is not needed as we just read/write bytes

    // Calculate output path: src/content/foo/bar.png -> web/images/content/foo/bar.png
    // The {{}} captured part is "foo/bar"

    // We can rely on allowedOutputs if we match the input
    final allowedOutputs = buildStep.allowedOutputs;
    if (allowedOutputs.isEmpty) return;

    final outputId = allowedOutputs.first;
    await buildStep.writeAsBytes(
      outputId,
      await buildStep.readAsBytes(inputId),
    );
  }
}
