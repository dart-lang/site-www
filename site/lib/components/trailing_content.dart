import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

class TrailingContent extends StatelessComponent {
  const TrailingContent({super.key, this.repo, this.sdkVersion});

  final String? repo;
  final String? sdkVersion;

  @override
  Iterable<Component> build(BuildContext context) sync* {
    final page = context.page;
    final pageUrl = page.url;
    final pageData = page.data.page;
    final siteData = page.data.site;
    final branch = siteData['branch'] as String? ?? 'main';
    final repoLinks = siteData['repo'] as Map<String, Object?>? ?? {};
    final repoUrl =
        repo ??
        repoLinks['this'] as String? ??
        'https://github.com/dart-lang/site-www';
    final inputPath = pageData['inputPath'] as String?;
    final pageDate = pageData['date'] as String?;

    final currentSdkVersion =
        sdkVersion ?? siteData['sdkVersion'] as String? ?? '';
    final siteUrl = siteData['url'] as String? ?? 'https://dart.dev';

    final fullPageUrl = '$siteUrl$pageUrl';
    final String issueUrl;
    final String? pageSource;

    if (inputPath != null) {
      pageSource = '$repoUrl/blob/$branch/${inputPath.replaceAll('./', '')}';
      issueUrl =
          '$repoUrl/issues/new?template=1_page_issue.yml&page-url=$fullPageUrl&page-source=$pageSource';
    } else {
      pageSource = null;
      issueUrl =
          '$repoUrl/issues/new?template=1_page_issue.yml&page-url=$fullPageUrl';
    }

    yield div(
      id: 'trailing-content',
      attributes: {'data-nosnippet': 'true'},
      [
        div(id: 'page-feedback', [
          div(classes: 'feedback initial-feedback', [
            div([text('Was this page\'s content helpful?')]),
            div(classes: 'feedback-buttons', [
              button(
                id: 'feedback-up-button',
                classes: 'icon-button',
                attributes: {
                  'aria-label': 'Yes, this page was helpful',
                  'title': 'Helpful',
                },
                [
                  span(
                    classes: 'material-symbols',
                    attributes: {'aria-hidden': 'true'},
                    [text('thumb_up')],
                  ),
                ],
              ),
              button(
                id: 'feedback-down-button',
                classes: 'icon-button',
                attributes: {
                  'aria-label': 'No, this page was not helpful or had an issue',
                  'title': 'Not helpful or had issue',
                },
                [
                  span(
                    classes: 'material-symbols',
                    attributes: {'aria-hidden': 'true'},
                    [text('thumb_down')],
                  ),
                ],
              ),
            ]),
          ]),

          div(classes: 'feedback good-feedback', [
            div([text('Thank you for your feedback!')]),
            a(
              href: issueUrl,
              classes: 'text-button',
              attributes: {
                'aria-label': 'Provide feedback',
                'target': '_blank',
                'rel': 'noopener',
              },
              [
                span(
                  classes: 'material-symbols',
                  attributes: {'aria-hidden': 'true'},
                  [text('feedback')],
                ),
                span([text('Provide details')]),
              ],
            ),
          ]),

          div(classes: 'feedback bad-feedback', [
            div([
              text(
                'Thank you for your feedback!'
                'Please let us know what we can do to improve.',
              ),
            ]),
            a(
              href: issueUrl,
              classes: 'text-button',
              attributes: {
                'aria-label': 'Provide feedback or report an issue',
                'target': '_blank',
                'rel': 'noopener',
              },
              [
                span(
                  classes: 'material-symbols',
                  attributes: {'aria-hidden': 'true'},
                  [text('bug_report')],
                ),
                span([text('Provide details')]),
              ],
            ),
          ]),
        ]),

        p(id: 'page-github-links', [
          span([
            text(
              'Unless stated otherwise, the documentation on '
              'this site reflects Dart $currentSdkVersion. ',
            ),
            if (pageDate != null)
              text(
                'Page last updated on $pageDate. ',
              ),
          ]),
          if (pageSource != null) ...[
            a(
              href: pageSource,
              attributes: {'target': '_blank', 'rel': 'noopener'},
              [text('View source')],
            ),
            span([text(' or ')]),
          ],
          a(
            href: issueUrl,
            attributes: {
              'title': 'Report an issue with this page',
              'target': '_blank',
              'rel': 'noopener',
            },
            [text(pageSource == null ? 'Report an issue' : 'report an issue')],
          ),
          text('.'),
        ]),
      ],
    );
  }
}
