import 'dart:convert';

main() {
  var outSink = new ChunkedConversionSink.withCallback((chunks) {
    print(chunks.single); // 𝅘𝅥𝅯
  });

  var inSink = UTF8.decoder.startChunkedConversion(outSink);
  var list = [0xF0, 0x9D];
  inSink.addSlice(list, 0, 2, false);
  // Since we used `addSlice` we are allowed to reuse the list.
  list[0] = 0x85;
  list[1] = 0xA1;
  inSink.addSlice(list, 0, 2, true);
}
