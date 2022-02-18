// ignore_for_file: unused_element, unused_local_variable
import 'dart:convert';
import 'dart:io';

void miscDeclAnalyzedButNotTested() {
  const recursive = 0, followLinks = 1;
  final searchPath = '.', searchTerms = [''];
  Map<dynamic, bool> argResults = {};
  void searchFile(FileSystemEntity e, List<String> terms) {}

  {
    // #docregion listen
    void main(List<String> arguments) {
      // ...
      FileSystemEntity.isDirectory(searchPath).then((isDir) {
        if (isDir) {
          final startingDir = Directory(searchPath);
          startingDir.list().listen((entity) {
            if (entity is File) {
              searchFile(entity, searchTerms);
            }
          });
        } else {
          searchFile(File(searchPath), searchTerms);
        }
      });
    }
    // #enddocregion listen
  }

  {
    // #docregion await-for
    void main(List<String> arguments) async {
      // ...
      if (await FileSystemEntity.isDirectory(searchPath)) {
        final startingDir = Directory(searchPath);
        await for (final entity in startingDir.list()) {
          if (entity is File) {
            searchFile(entity, searchTerms);
          }
        }
      } else {
        searchFile(File(searchPath), searchTerms);
      }
    }
    // #enddocregion await-for
  }

  {
    // #docregion readFileAwaitFor
    Future<void> readFileAwaitFor() async {
      var config = File('config.txt');
      Stream<List<int>> inputStream = config.openRead();

      // #docregion transform
      var lines =
          inputStream.transform(utf8.decoder).transform(const LineSplitter());
      // #enddocregion transform
      try {
        await for (final line in lines) {
          print('Got ${line.length} characters from stream');
        }
        print('file is now closed');
      } catch (e) {
        print(e);
      }
    }
    // #enddocregion readFileAwaitFor
  }

  {
    // #docregion onDone
    var config = File('config.txt');
    Stream<List<int>> inputStream = config.openRead();

    inputStream.transform(utf8.decoder).transform(const LineSplitter()).listen(
        (String line) {
      print('Got ${line.length} characters from stream');
    }, onDone: () {
      print('file is now closed');
    }, onError: (e) {
      print(e);
    });
    // #enddocregion onDone
  }
}
