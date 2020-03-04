void breedMoreLlamas() {
  print('Breed more Llamas');
}

void cleanLlamaStalls() {
  print('clean Llama stalls');
}

void main() {
  try {
    breedMoreLlamas();
  } catch (e) {
    // … handle exception ...
  } finally {
    // Always clean up, even if an exception is thrown.
    cleanLlamaStalls();
  }
}
