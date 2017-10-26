import 'dart:async';

// I deleted types from functions so that runBroken would run.

//Future<String> findEntrypoint() async => 'entrypoint';
findEntrypoint() async => 'entrypoint';

//Future<int> runExecutable(String entrypoint, List<String> args) async {
Future<int> runExecutable(entrypoint, args) async {
  print('runExecutable($entrypoint, $args)');
  return 0;
}

//Future<int> flushThenExit(exitCode) async {
flushThenExit(exitCode) async {
  print('flushing then exiting: $exitCode');
  return 0;
}

// This function has bad code! It doesn't wait for the Futures
// returned by findEntrypoint(), runExecutable(), and flushThenExit()
// to complete.
runBroken() {
  var args = ['runBroken'];

  // Here's where the trouble starts.
  var entrypoint = findEntrypoint();

  // entrypoint is a Future, not the real entrypoint.
  var exitCode = runExecutable(entrypoint, args);

  // exitCode is a Future, not the real exit code.
  flushThenExit(exitCode);
}

//Future runUsingAsyncAwait() async { // return type of async is Future
runUsingAsyncAwait() async {
  var args = ['runUsingAsyncAwait'];

  var entrypoint = await findEntrypoint();
  var exitCode = await runExecutable(entrypoint, args);
  await flushThenExit(exitCode);
}

//void runUsingFuture() {
runUsingFuture() {
  var args = ['runUsingFuture'];

  findEntrypoint().then((entrypoint) {
    return runExecutable(entrypoint, args);
  }).then(flushThenExit);
}

void main() {
  runBroken();
  runUsingFuture();
  runUsingAsyncAwait();
}
