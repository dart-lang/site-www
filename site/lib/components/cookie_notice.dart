import 'package:jaspr/jaspr.dart';

class DashCookieNotice extends StatelessComponent {
  const DashCookieNotice({super.key});

  @override
  Component build(BuildContext context) {
    return section(
      id: 'cookie-notice',
      attributes: {'data-nosnippet': 'true'},
      [
        div(classes: 'container', [
          p([
            text(
              'dart.dev uses cookies from Google to deliver and '
              'enhance the quality of its services and to analyze traffic.',
            ),
          ]),
          div(classes: 'button-group', [
            a(
              href: 'https://policies.google.com/technologies/cookies',
              target: Target.blank,
              classes: 'text-button',
              attributes: {'rel': 'noopener'},
              [text('Learn more')],
            ),
            button(id: 'cookie-consent', classes: 'filled-button', [
              text('OK, got it'),
            ]),
          ]),
        ]),
      ],
    );
  }
}
