typedef int Compare(Object a, Object b);

int sort(int a, int b) => a - b;

void main() {
  assert(sort is Compare); // True!
}
