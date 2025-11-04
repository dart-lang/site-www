class Logger {
  static void log(String message) {
    print(message);
  }
}

void main() {
  // ERROR: An expression statement can't begin with `.`.
  // The compiler has no type context (like a variable assignment)
  // to infer that `.log` should refer to `Logger.log`.
  // ignore: dot_shorthand_undefined_member
  .log('Hello');
}
