int getLength(String? str) {
  // Try throwing exception here if `str` is null.
  if (str == null) {
  	return Exception("String is null");
  }
  return str.length;  
}

void main() {
  print(getLength(null));
}
