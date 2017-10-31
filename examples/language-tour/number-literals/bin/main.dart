void main() {
  // #docregion
  const msPerSecond = 1000;
  const secondsUntilRetry = 5;
  const msUntilRetry = secondsUntilRetry * msPerSecond;
  // #enddocregion
  print('Wait $msUntilRetry milliseconds.');
}
