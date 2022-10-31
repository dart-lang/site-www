// #docregion int-list
typedef IntList = List<int>;
IntList il = [1, 2, 3];
// #enddocregion int-list

// #docregion list-mapper
typedef ListMapper<X> = Map<X, List<X>>;
Map<String, List<String>> m1 = {}; // Verbose.
ListMapper<String> m2 = {}; // Same thing but shorter and clearer.
// #enddocregion list-mapper

// #docregion compare
typedef Compare<T> = int Function(T a, T b);

int sort(int a, int b) => a - b;

void main() {
  // ignore: unnecessary_type_check
  assert(sort is Compare<int>); // True!
}
