void doSomething() {}
void printLine() => print('Hi');
bool isDone() => true;
bool atEndOfPage() => true;

void main() {
  while (!isDone()) {
    doSomething();
  }

  do {
    printLine();
  } while (!atEndOfPage());
}
