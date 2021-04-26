class Meal {
  late String _description;

  void set description(String str) {
    _description = str;
  }

  String get description => _description;
}

void main() {
  final myMeal = Meal();
  myMeal.description = 'Feijoada!';
  print(myMeal.description);
}
