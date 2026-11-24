// Re-export site_shared SiteSwitcher with isFlutter: false for Dart site.
import 'package:jaspr/jaspr.dart';
import 'package:site_shared/components/layout/site_switcher.dart' as shared;

export 'package:site_shared/components/layout/site_switcher.dart'
    hide SiteSwitcher;

@client
final class SiteSwitcher extends StatelessComponent {
  const SiteSwitcher({super.key});

  @override
  Component build(BuildContext context) =>
      const shared.SiteSwitcher(isFlutter: false);
}
