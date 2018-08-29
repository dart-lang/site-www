<aside class="alert alert-info" markdown="1">
  **Version note:** In Dart 1.x, async functions immediately suspended
  execution. In Dart 2, instead of immediately suspending, async functions
  execute synchronously until the first `await`. If you use `await` each time
  you call an async function, the behavior is the same in Dart 1.x and Dart 2.
</aside>
