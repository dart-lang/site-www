import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as p;

class BlogDataLoader implements DataLoader {
  @override
  Future<void> loadData(Page page) async {
    if (!page.path.startsWith('blog/')) return;

    // Set the layout to 'blog'.
    page.apply(
      data: {
        'page': {'layout': 'blog'},
      },
    );

    // Set the image path relative to the content directory.
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

    final content = page.content;
    final wordCount = RegExp(r'\w+').allMatches(content).length;
    final readingTime = (wordCount / 250).ceil();
    page.apply(
      data: {
        'page': {'readingTime': '$readingTime min read'},
      },
    );
  }
}
