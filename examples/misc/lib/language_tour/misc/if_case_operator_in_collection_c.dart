void main() {
  // #docregion code_sample
  var a = 'apple';
  var b = 'orange';
  var c = 'mango';
  var items = [
    0,
    if (a case 'apple') 1 else if (a case 'mango') 10,
    if (b case 'pear') 2 else if (b case 'mango') 20,
    if (c case 'apple') 3 else if (c case 'mango') 30,
    4,
  ]; // [0, 1, 30, 4]
  // #enddocregion code_sample

  print(items);
}
