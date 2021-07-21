This directory holds the Dart SDK archive: https://dart.dev/tools/sdk/archive

Note: `./out/web/download_archive.dart.js` is generated from Dart source code located in `../dart_sdk_archive`.

If you modify that Dart code for this page, don't forget to regenerate
the JavaScript:

    cd src/tools/sdk/archive
    dart run build_runner build --release --output out
