import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:universal_web/web.dart' as web;

@client
class BlogCategories extends StatefulComponent {
  const BlogCategories({super.key});

  @override
  State<BlogCategories> createState() => _BlogCategoriesState();
}

class _BlogCategoriesState extends State<BlogCategories> {
  String selectedCategory = 'all';

  static const categories = [
    'announcements',
    'other',
    'all',
  ];

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _updateCategoryFromUrl();
    }
  }

  void _updateCategoryFromUrl() {
    final uri = Uri.parse(web.window.location.href);
    final category = uri.queryParameters['category'] ?? 'all';
    if (categories.contains(category)) {
      setState(() {
        selectedCategory = category;
      });
      _applyLayout(category);
    }
  }

  void _selectCategory(String category) {
    if (category == selectedCategory) return;

    setState(() {
      selectedCategory = category;
    });

    final uri = Uri.parse(web.window.location.href);
    final newUri = uri.replace(queryParameters: {'category': category});
    web.window.history.pushState(null, '', newUri.toString());

    _applyLayout(category);
  }

  void _applyLayout(String category) {
    final container = web.document.getElementById('blog-container');
    if (container != null) {
      container.setAttribute('data-selected', category);

      final cards = container.querySelectorAll('.blog-card');
      var visibleCount = 0;

      for (var i = 0; i < cards.length; i++) {
        final card = cards.item(i) as web.Element;
        final cardCategory = card.getAttribute('data-category');

        final isVisible = category == 'all' || cardCategory == category;

        // Remove existing layout classes
        card.classList.remove('featured');
        card.classList.remove('layout-featured');
        card.classList.remove('layout-grid');
        card.classList.remove('layout-list');

        // Ensure display is cleared/set (styles in CSS might handle this via data-selected, but ensuring reset here)
        // Actually, existing CSS handles display:none via data-selected.
        // We just need to manage layout classes for visible items.

        if (isVisible) {
          if (visibleCount == 0) {
            card.classList.add('layout-featured');
            card.classList.add('featured');
          } else if (visibleCount < 5) {
            card.classList.add('layout-grid');
          } else {
            card.classList.add('layout-list');
          }
          visibleCount++;
        }
      }
    }
  }

  @override
  Component build(BuildContext context) {
    return div(classes: 'blog-categories', [
      for (final category in categories)
        button(
          classes: [
            'blog-category-chip',
            if (category == selectedCategory) 'active',
          ].join(' '),
          onClick: () => _selectCategory(category),
          [
            .text(category[0].toUpperCase() + category.substring(1)),
          ],
        ),
    ]);
  }
}
