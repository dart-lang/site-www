int getLength(String? str) {
  // Add null check here
  if (str == null) {
    return 0;
  }
  return str.length;
}

void main() {
  print(getLength('This is a string!'));
}
