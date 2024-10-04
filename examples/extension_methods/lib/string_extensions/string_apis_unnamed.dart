// #docregion unnamed
extension on String {
  bool get isBlank => trim().isEmpty;
}
// #enddocregion unnamed

bool isBlank(String string) => string.isBlank;
