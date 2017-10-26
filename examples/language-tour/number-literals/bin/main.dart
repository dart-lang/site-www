void main() {
  // BEGIN(number_literals)
  const msPerSecond = 1000;
  const secondsUntilRetry = 5;
  const msUntilRetry = secondsUntilRetry * msPerSecond;
  // END(number_literals)
  print('Wait $msUntilRetry milliseconds.');
}
