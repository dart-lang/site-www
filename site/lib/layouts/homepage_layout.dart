import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

import 'dash_layout.dart';

class HomepageLayout extends DashLayout {
  const HomepageLayout();

  @override
  String get name => 'homepage';

  @override
  Component buildBody(Page page, Component child) {
    return Fragment(children: [super.buildBody(page, child)]);
  }
}
