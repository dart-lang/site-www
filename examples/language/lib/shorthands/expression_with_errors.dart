class Logger {
  static void log(String message) {
    print(message);
  }
}

void main() {
  // ERROR: An expression statement cannot begin with  `.`
  // The compiler has no type context (like a variable assignment)
  // to infer that `.log` should refer to `Logger.log`.
  .log('Hello');
}