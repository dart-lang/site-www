import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as p;

/// A [FilesystemLoader] that filters files by extension.
class FilteredFilesystemLoader extends FilesystemLoader {
  final Set<String> extensions;

  FilteredFilesystemLoader(super.directory, {required this.extensions});

  @override
  Future<List<PageSource>> loadPageSources() async {
    final sources = await super.loadPageSources();
    return sources.where((source) {
      return extensions.contains(p.extension(source.path));
    }).toList();
  }

  @override
  void addFile(String path) {
    if (extensions.contains(p.extension(path))) {
      super.addFile(path);
    }
  }
}
