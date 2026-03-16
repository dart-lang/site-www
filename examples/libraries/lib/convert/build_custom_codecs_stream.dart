// #docregion stream-transform, fuse-pipeline
import 'dart:convert';
import 'dart:io';

// #enddocregion stream-transform, fuse-pipeline

import 'build_custom_codecs.dart';

// #docregion stream-transform
void streamTransformExample() async {
  const caesar = CaesarCodec(3);

  // Encrypt a file as a stream.
  final encrypted = File('message.txt')
      .openRead() //
      .transform(utf8.decoder)
      .transform(caesar.encoder);

  await for (final chunk in encrypted) {
    stdout.write(chunk);
  }
}
// #enddocregion stream-transform

// #docregion fuse-pipeline
void fusePipelineExample() async {
  const caesar = CaesarCodec(3);

  // Create a codec that encrypts, then compresses.
  final encryptAndCompress = caesar.fuse(utf8).fuse(gzip);

  // Write encrypted, compressed data.
  final output = File('message.gz').openWrite();
  output.add(encryptAndCompress.encode('Secret message.'));
  await output.close();

  // Read and decrypt.
  final bytes = await File('message.gz').readAsBytes();
  final decrypted = encryptAndCompress.decode(bytes);
  print(decrypted); // Secret message.
}

// #enddocregion fuse-pipeline
