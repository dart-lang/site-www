// ignore_for_file: unused_field, unused_element

// #docregion unnamed-before
class _PageState extends State<Page> {
  late final AnimationController _animationController = AnimationController(
    vsync: this,
  );
  final ScrollController _scrollController = ScrollController();

  final GlobalKey<ScaffoldMessengerState> scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  Map<String, Map<String, bool>> properties = <String, Map<String, bool>>{};
  // ...
}
// #enddocregion unnamed-before

// #docregion unnamed-after
class _PageStateAfter extends State<Page> {
  late final AnimationController _animationController = .new(vsync: this);
  final ScrollController _scrollController = .new();
  final GlobalKey<ScaffoldMessengerState> scaffoldKey = .new();
  Map<String, Map<String, bool>> properties = .new();
  // ...
}
// #enddocregion unnamed-after

// Supporting classes for example.

class State<T> {}

class ScaffoldMessengerState {}

class GlobalKey<T> {}

class ScrollController {}

class AnimationController {
  AnimationController({State<Object>? vsync});
}

class Page {}
