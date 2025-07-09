import 'package:jaspr/server.dart';
import 'package:jaspr_content/jaspr_content.dart';

import '../util.dart';

final class RobotsTxtOutput extends SecondaryOutput {
  @override
  final Pattern pattern = RegExp(r'/?index\..*');

  @override
  String createRoute(String _) => '/robots.txt';

  @override
  Component build(Page _) {
    return Builder(
      builder: (context) sync* {
        context.setHeader('Content-Type', 'text/plain; charset=utf-8');
        final String textContent;
        if (productionBuild) {
          textContent = '''
User-agent: *
Disallow:

Sitemap: https://dart.dev/sitemap.xml
''';
        } else {
          textContent = '''
User-agent: linkcheck
Disallow:

User-agent: *
Disallow: /
''';
        }
        context.setStatusCode(200, responseBody: textContent);
      },
    );
  }
}
