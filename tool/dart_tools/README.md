# dart_tools

dart tools for site-www.

## Usage - update_analyzer_txt.dart

Make sure the Dart SDK in your PATH is the channel you want to use.
This script will update files matching analyzer-results-CHANNEL.txt
in the examples/ directories

```
cd tool/dart_tools
dart pub get
dart run bin/update_analyzer_txt.dart
```

