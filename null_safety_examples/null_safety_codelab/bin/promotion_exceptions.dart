int getLength(String? str) {
  // Try throwing an exception here if `str` is null.
  if (str == null) {
    throw Exception('String is null');
  }
  return str.length;
}

void main() {
  print(getLength(null));
}
