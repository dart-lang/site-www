void doSomething() {}
void printLine() => print('Hi');
bool isDone() => true;
bool atEndOfPage() => true;

void main() {
  // #docregion
  while (!isDone()) {
    doSomething();
  }
  // #enddocregion

  // #docregion do-while
  do {
    printLine();
  } while (!atEndOfPage());
  // #enddocregion do-while
}
