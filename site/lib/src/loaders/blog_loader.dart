import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:jaspr_content/jaspr_content.dart';
import 'package:path/path.dart' as p;

class BlogDataLoader implements DataLoader {
  // Simple memory cache for GitHub users to avoid hitting rate limits.
  final githubCache = <String, Map<String, String>>{};

  @override
  Future<void> loadData(Page page) async {
    if (!page.path.startsWith('blog/')) return;

    page.apply(
      data: {
        'page': {'layout': 'blog'},
      },
    );

    var authorName = page.data.page['author'] as String? ?? 'Dart Team';
    // String? avatarUrl;
    // String? profileUrl;
    final handle = page.data.page['github_handle'] as String?;

    if (handle != null) {
      // profileUrl = 'https://github.com/$handle';
      // avatarUrl = 'https://github.com/$handle.png';

      // Try to fetch real name if not in cache
      if (githubCache.containsKey(handle)) {
        authorName = githubCache[handle]!['name']!;
      } else {
        try {
          // Note: In a real CI/CD environment, you'd want a GITHUB_TOKEN here.
          // For local dev/static sites, unauthenticated requests usually suffice
          // for small volume.
          final url = Uri.parse('https://api.github.com/users/$handle');
          final response = await http.get(
            url,
            headers: {
              // User-Agent is required by GitHub API
              'User-Agent': 'Dart-Blog-Loader',
              'Accept': 'application/vnd.github.v3+json',
            },
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body) as Map<String, dynamic>;
            if (data['name'] != null) {
              authorName = data['name'] as String;
            }
          }
          // Cache the result (even if failed, to avoid retrying)
          githubCache[handle] = {'name': authorName};
        } catch (e) {
          print('Failed to fetch GitHub data for $handle: $e');
          // Fallback is already set to default or whatever we have
        }
      }
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
