import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as p;

class ImagePathProcessor implements PageExtension {
  const ImagePathProcessor();

  static final imageAttributes = {
    'img': 'src',
    'dashimage': 'src',
    'githubembed': 'image',
  };

  @override
  Future<List<Node>> apply(Page page, List<Node> nodes) async {
    if (page.path.startsWith('blog/')) {
      return _processNodes(nodes, page);
    }
    return nodes;
  }

  List<Node> _processNodes(List<Node> nodes, Page page) {
    return nodes.map((node) {
      if (node is ElementNode &&
          imageAttributes.containsKey(node.tag.toLowerCase())) {
        final src = node.attributes[imageAttributes[node.tag.toLowerCase()]!];
        if (src != null && !src.startsWith('http') && !src.startsWith('/')) {
          // It's a relative path. Rewrite it.
          // page.path is likely "blog/test-folder-post/test-folder-post.md" or similar.
          // We want: /images/content/blog/test-folder-post/dash.png

          final contentDir = p.dirname(page.path);
          // If page.path is "blog/test-folder-post", dirname is "blog", which might be wrong for index.md?
          // But if page.path comes from FilesystemLoader, it usually includes extension or is the ID.

          // Let's assume contentAssetsBuilder mirrors the src/content structure to web/images/content
          final newSrc = p.join('/images/content', contentDir, src);

          return ElementNode(
            node.tag,
            {
              ...node.attributes,
              imageAttributes[node.tag.toLowerCase()]!: newSrc,
            },
            node.children,
          );
        }
      }
      if (node is ElementNode && node.children != null) {
        return ElementNode(
          node.tag,
          node.attributes,
          _processNodes(node.children!, page),
        );
      }
      return node;
    }).toList();
  }
}
