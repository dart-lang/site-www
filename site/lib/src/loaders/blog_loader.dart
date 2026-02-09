import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as p;

class BlogDataLoader implements DataLoader {
  @override
  Future<void> loadData(Page page) async {
    if (!page.path.startsWith('blog/')) return;

    page.apply(
      data: {
        'page': {'layout': 'blog'},
      },
    );

    final handle =
        page.data.page['author']
            as String?; // The 'author' field in frontmatter is the username/handle

    // Check for author data from YAML (loaded into page.data['authors'])
    final authors = page.data['authors'] as Map<String, dynamic>?;

    if (handle != null && authors != null && authors.containsKey(handle)) {
      final authorData = authors[handle] as Map<String, dynamic>;

      // Pass this data to the page for the layout to use
      page.apply(data: {'author_data': authorData});
    } else if (handle != null) {
      // Fallback or explicit github handle handling if needed,
      // but for now we assume the author field maps to a yaml entry.
      // The previous logic used 'github_handle' but get-post.js sets 'author' to the username/handle.
    }

    final image = page.data.page['image'] as String?;
    if (image != null && !image.startsWith('http') && !image.startsWith('/')) {
      page.apply(
        data: {
          'page': {
            'image': p.normalize(
              p.join('/images/content', p.dirname(page.path), image),
            ),
          },
        },
      );
    }
  }
}
