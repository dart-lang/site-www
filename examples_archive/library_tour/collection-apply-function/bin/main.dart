void main() {
  var teas = ['green', 'black', 'chamomile', 'earl grey'];

  teas.forEach((tea) => print('I drink $tea'));

  var loudTeas = teas.map((tea) => tea.toUpperCase());
  assert(loudTeas.any((tea) => tea == 'GREEN'));
  loudTeas.forEach(print);

  var loudTeaList = teas.map((tea) => tea.toUpperCase()).toList();
  loudTeaList.forEach(print);
}
