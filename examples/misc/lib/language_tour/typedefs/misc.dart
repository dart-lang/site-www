// #docregion Function
typedef F = List<T> Function<T>(T);
// #enddocregion Function

// #docregion compare
typedef Compare<T> = int Function(T a, T b);

int sort(int a, int b) => a - b;

void main() {
  assert(sort is Compare<int>); // True!
}
