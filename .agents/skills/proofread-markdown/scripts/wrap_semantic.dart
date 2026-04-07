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

    // Don't wrap empty lines or headings (heuristic)
    if (line.trim().isEmpty ||
        line.trim().startsWith('#')) {
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
  // Extract leading whitespace
  final match = RegExp(r'^(\s*)').firstMatch(line);
  final leadingWhitespace = match?.group(1) ?? '';
  
  // Check for list bullet
  final contentAfterWs = line.substring(leadingWhitespace.length);
  final listMatch = RegExp(r'^([-*]|\d+\.)\s+').firstMatch(contentAfterWs);
  
  String firstLinePrefix;
  String subsequentLinePrefix;
  String contentToWrap;
  
  if (listMatch != null) {
    // It's a list item
    final prefixLength = leadingWhitespace.length + listMatch.end;
    firstLinePrefix = line.substring(0, prefixLength);
    subsequentLinePrefix = ' ' * prefixLength;
    contentToWrap = line.substring(prefixLength);
  } else {
    // Normal indented text
    firstLinePrefix = leadingWhitespace;
    subsequentLinePrefix = leadingWhitespace;
    contentToWrap = contentAfterWs;
  }
  
  // Wrap the content with available width
  final availableWidth = 80 - firstLinePrefix.length;
  final wrappedChunks = _wrapText(contentToWrap, availableWidth);
  
  final result = <String>[];
  if (wrappedChunks.isEmpty) {
    result.add(firstLinePrefix);
  } else {
    result.add(firstLinePrefix + wrappedChunks[0]);
    for (var i = 1; i < wrappedChunks.length; i++) {
      result.add(subsequentLinePrefix + wrappedChunks[i]);
    }
  }
  return result;
}

List<String> _wrapText(String text, int width) {
  final result = <String>[];
  var currentText = text.trim();
  
  while (currentText.length > width) {
    var splitIndex = -1;
    
    // 1. Try sentence break
    for (var i = width; i > 0; i--) {
      if (i < currentText.length &&
          (currentText[i] == '.' || currentText[i] == '!' || currentText[i] == '?') &&
          (i + 1 == currentText.length || currentText[i + 1] == ' ')) {
        splitIndex = i + 1;
        break;
      }
    }
    
    // 2. Try clause break
    if (splitIndex == -1) {
      for (var i = width; i > 0; i--) {
        if (i < currentText.length &&
            (currentText[i] == ',' || currentText[i] == ';') &&
            (i + 1 == currentText.length || currentText[i + 1] == ' ')) {
          splitIndex = i + 1;
          break;
        }
      }
    }
    
    // 3. Fall back to space
    if (splitIndex == -1) {
      splitIndex = currentText.lastIndexOf(' ', width);
    }
    
    // 4. Force break
    if (splitIndex == -1) {
      splitIndex = width;
    }
    
    result.add(currentText.substring(0, splitIndex).trimRight());
    currentText = currentText.substring(splitIndex).trimLeft();
  }
  
  if (currentText.isNotEmpty) {
    result.add(currentText);
  }
  return result;
}
