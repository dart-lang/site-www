void breedMoreLlamas() {
  print('Breed more Llamas');
}

void cleanLlamaStalls() {
  print('clean Llama stalls');
}

void main() {
// #docregion
  try {
    breedMoreLlamas();
  } catch (e) {
    // ... handle exception ...
  } finally {
    // Always clean up, even if an exception is thrown.
    cleanLlamaStalls();
  }
// #enddocregion
}
