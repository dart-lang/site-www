class BigThing {
  LittleThing little = LittleThing();
}

class LittleThing {
  int fetchInt() => 12;
}

void main() {
  BigThing? big = BigThing();

  print('The value is:');
  print(big?.little.fetchInt());
}
