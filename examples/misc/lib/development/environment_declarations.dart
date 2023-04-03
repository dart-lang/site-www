// #docregion debug-log
void log(String message) {
  // Log the debug message if the environment declaration 'DEBUG' is `true`.
  // If there was no value specified, do not log.
  if (const bool.fromEnvironment('DEBUG', defaultValue: false)) {
    print('Debug: $message');
  }
}
// #enddocregion debug-log

void hasDebug() {
  // #docregion has-debug
  if (const bool.hasEnvironment('DEBUG')) {
    print('Debug behavior was configured!');
  }
  // #enddocregion has-debug
}
