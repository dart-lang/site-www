// ignore_for_file: sort_constructors_first
class SortedCollection {
  Function compare;

  SortedCollection(int f(Object a, Object b)) : compare = f;
}

// Initial, broken implementation.
int sort(Object a, Object b) => 0;

void main() {
  SortedCollection coll = SortedCollection(sort);

  // All we know is that compare is a function,
  // but what type of function?
  assert(coll.compare is Function);
}
