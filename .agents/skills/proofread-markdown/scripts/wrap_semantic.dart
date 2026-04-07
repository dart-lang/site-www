import 'dart:io';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart wrap_semantic.dart <file_path>');
    exit(1);
  }

  final filePath = args[0];
  final file = File(filePath);

  if (!file.existsSync()) {
    print('Error: File not found: $filePath');
    exit(1);
  }

  final content = file.readAsStringSync();
  final wrappedContent = wrapContent(content);

  file.writeAsStringSync(wrappedContent);
  print('Successfully wrapped $filePath');
}

String wrapContent(String content) {
  final lines = content.split('\n');
  final result = <String>[];
  var inCodeBlock = false;

  for (var i = 0; i < lines.length; i++) {
    final line = lines[i];

    // Toggle code block state
    if (line.trim().startsWith('```')) {
      inCodeBlock = !inCodeBlock;
      result.add(line);
      continue;
    }

    if (inCodeBlock) {
      result.add(line);
      continue;
    }

    // Don't wrap empty lines, headings, or lists (heuristic)
    if (line.trim().isEmpty ||
        line.trim().startsWith('#') ||
        line.trim().startsWith('-') ||
        line.trim().startsWith('*') ||
        RegExp(r'^\d+\.').hasMatch(line.trim())) {
      result.add(line);
      continue;
    }

    // Wrap the line if it exceeds 80 characters
    if (line.length <= 80) {
      result.add(line);
    } else {
      result.addAll(wrapLine(line));
    }
  }

  return result.join('\n');
}

List<String> wrapLine(String line) {
  final result = <String>[];
  var currentLine = line;

  while (currentLine.length > 80) {
    var splitIndex = -1;

    // 1. Try to find a sentence break (. ! ?) within the first 80 chars.
    for (var i = 80; i > 0; i--) {
      if (i < currentLine.length &&
          (currentLine[i] == '.' || currentLine[i] == '!' || currentLine[i] == '?') &&
          (i + 1 == currentLine.length || currentLine[i + 1] == ' ')) {
        splitIndex = i + 1;
        break;
      }
    }

    // 2. Try to find a clause break (, ;) within the first 80 chars.
    if (splitIndex == -1) {
      for (var i = 80; i > 0; i--) {
        if (i < currentLine.length &&
            (currentLine[i] == ',' || currentLine[i] == ';') &&
            (i + 1 == currentLine.length || currentLine[i + 1] == ' ')) {
          splitIndex = i + 1;
          break;
        }
      }
    }

    // 3. Fall back to space.
    if (splitIndex == -1) {
      splitIndex = currentLine.lastIndexOf(' ', 80);
    }

    // 4. Force break if no space found (very long word).
    if (splitIndex == -1) {
      splitIndex = 80;
    }

    result.add(currentLine.substring(0, splitIndex).trimRight());
    currentLine = currentLine.substring(splitIndex).trimLeft();
  }

  if (currentLine.isNotEmpty) {
    result.add(currentLine);
  }

  return result;
}
