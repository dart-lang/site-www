<aside class="alert alert-info" markdown="1">
  **Dart 2 note:** In Dart 2, instead of immediately suspending, async functions
  execute synchronously until the first await. In most cases, you won't notice a
  difference in behavior relative to Dart 1&mdash;as long as you await each time you
  call an async method, it won't be an issue.
</aside>
