---
title: "Dart string manipulation done right 👉"
description: "Does your app use emojis or support multiple languages? Dart just introduced a new way to safely handle them in string manipulation."
publishDate: 2020-06-30
author: "taodong"
image: images/1H_-SP7V6x1cQpGM_6DUReg.png
category: other
tags:
  - dart
  - flutter
  - programming-languages
  - string-manipulation
  - developer-experience
---


Like many other programming languages designed before emojis started to dominate our daily communications and the rise of multilingual support in commercial apps, Dart represents a string as [a sequence of UTF-16 code units](https://api.dart.dev/stable/2.8.4/dart-core/String-class.html). The encoding worked fine in most cases, until increased internationalization and the introduction of emojis that go with any language made the encoding’s inherent problems become everybody’s problems.

Consider this example:

<DashImage src="images/1H_-SP7V6x1cQpGM_6DUReg.png" />


In the string “Hello👋”, each user-perceivable character is mapped to a single code unit except the waving hand emoji 👋. An immediate consequence of this mapping is confusion over the length of this string. Will the output of the following line of code be 6 or 7?

```
print('Hello👋'.length);
```


To the user, there are clearly 6 characters in this string unless you get philosophical. But the Dart `String` API will tell you that the [`length`](https://api.dart.dev/stable/dart-core/String/length.html) is 7, or to be precise, 7 UTF-16 code units. This difference has all kinds of ramifications, because so many text manipulation tasks involve using character indexes with the `String` API. For example, `"Hello👋"[5]` won’t return the 👋 emoji. Instead it will return a malformed character representing the first code unit of the emoji.

The good news is that Dart has a new package called [*characters*](https://pub.dev/packages/characters) that operates on user-perceivable characters instead of UTF-16 code units. However, you, as a Dart programmer, need to know when to use the `characters` package. Our research indicates that even experienced Dart programmers can easily miss such problems when reading text manipulation code. In this article, I go over some common scenarios where you need to pay extra attention and consider using the `characters` package instead of Dart `String`.

## Scenarios to watch out for

In this section, I’ll go over a few common text manipulation scenarios, explain why using Dart’s `String` API could cause problems in these scenarios, and show how to use the `characters` package for more reliable results. The use cases below generally assume that we’re dealing with strings entered by human users, which could include emojis or characters in a language the app developer doesn’t expect.

### Scenario 1: Counting characters in a string

Suppose you’re writing a function that checks if the text entered by the user has exceeded a specific number of characters. The function returns a positive number of remaining characters if the limit hasn’t been reached, or a negative number of extra characters if the limit has been exceeded.

This is pretty straightforward to do using the `String` API:

```dart
// Implementation using the String API, 
// which counts the number of UTF-16 code units
// instead of user-perceivable characters.
int remainingCapacity(String input, int limit) {
  var length = input.length;
  return limit - length;
}

```

However, the following test reveals the problem with this code:

```dart
test('remainingCapacity', (){
  var limit = 140;
  input = 'Laughter 😀 is the sensation of feeling good all over and showing it principally in one place.';
  expect(remainingCapacity(input, limit), equals(47));
});
```

Here are the testing results:

```
Expected: <47>
  Actual: <46>
```


We can rewrite this function using the `characters` package, which provides a convenient extension method on `String`, to produce the correct number of characters as follows:

```dart
int checkMaxLength(String input, int limit) {
  var length = input.characters.length;
  return limit - length;
}
```

### Scenario 2: Extracting a substring

In this scenario, we want to implement a function that deletes the last character from a string and returns the result as a new string. Let’s assume this string comes from user input.

This function is easy to implement using the `substring` method on `String` as follows:

```dart
String skipLastChar(String text) {
  return text.substring(0, max(0, text.length - 1));
}
```

However, a good emoji test can quickly break the code:

```dart
test('skipLastChar(text)', () {
  var string = 'Hi 🇩🇰';
  expect(skipLastChar(string), equals('Hi '));
});
```

Here are the testing results:

```
Expected: ‘Hi ’
  Actual: ‘Hi 🇩???’
    Which: is different. Both strings start the same, but the actual value also has the following trailing characters: 🇩???
```


The `characters` package can handle this case with ease, as it provides high-level methods such as [`skipLast(int count)`](https://pub.dev/documentation/characters/latest/characters/Characters/skipLast.html)*.* We can rewrite this snippet into the following code:

```dart
String skipLastChar(String text) {
  return text.characters.skipLast(1).toString();
}
```

### Scenario 3: Splitting a string on an emoji

In the third scenario, we want to split a string on a given emoji. Here is a function doing that using the split method on `String`:

```dart
List splitEmojiSeparatedWords(String text, String separator) {
  return text.split(separator);
}
```

Would it work? It probably will work just fine 99% of the time, but the test below illustrates an example where the above code produces rather surprising results.

```dart
test('splitEmojiSeparatedWords(String text, String separator)', () {
   var text = 'abc👨‍👩‍👧‍👦👧abc👧abc👧abc';
   var separator = '👧';
   List<String> expected = ['abc👨‍👩‍👧‍👦', 'abc', 'abc', 'abc'];
   expect(td.splitEmojiSeparatedWords(text, separator), equals(expected));
});
```

Here are the testing results:

```
Expected: ['abc👨‍👩‍👧‍👦', 'abc', 'abc', 'abc']
  Actual: ['abc👨‍👩‍','‍👦', 'abc', 'abc', 'abc']
    Which: was 'abc👨‍👩‍' instead of 'abc👨‍👩‍👧‍👦' at location [0]
```


So, why did 👨‍👩‍👧‍👦 become two emojis 👨‍👩 when the string was split? It’s because 👨‍👩‍👧‍👦 is actually made of four different emojis: 👨👩👧👦. When the string was split on 👧, “abc👨‍👩‍👧‍👦” got separated into two parts: “abc👨‍👩” and “‍👦”.

You can avoid this issue by using the [`split`](https://pub.dev/documentation/characters/latest/characters/Characters/split.html) method on the `Characters` class, as the following code shows:

```dart
List<String> splitEmojiSeparatedWords(String text, String separator) {
  // Split returns an iterable, which we need to convert to a list.
  return [...text.characters.split(separator.characters)]; 
}
```

### Scenario 4: Accessing a specific character by its index

In text manipulation, it’s common to access a specific character by its index (i.e., position) in the string. For example, the snippet shows a function that returns initials from the first name and the last name entered by the user in two separate text fields:

```dart
String createInitials(String firstName, String lastName) {
    return firstName[0].toUpperCase() + lastName[0].toUpperCase();
}
```

But as we have demonstrated in the beginning of the article, using the index in a UTF-16-based string could be risky. Let’s verify the correctness of the above code with the test case below:

```dart
test("createInitials(firstName, lastname)", () {
    var firstName = 'étienne';
    var lastname = 'bézout';
    expect(td.createInitials(firstName, lastname), equals('ÉB'));
});
```

Here are the test results:

```
Expected: ‘ÉB’
  Actual: ‘EB’
    Which: is different.
```


Why did the test fail? It’s because the letter “É” could be a combination of “E” and the accent mark. You can use the `characters` package to easily avoid this problem:

```dart
String createInitials(String firstName, String lastName) {
  return '${firstName.characters.first}${lastName.characters.first}';
}
```

## Exercise: Omitting text overflow

Now, here’s a challenge for you. In this scenario, the app needs to display a list of messages, one per line. You’re asked to review code that implements a function that displays text overflow as an ellipsis when the message’s length exceeds the given character limit.

```dart
String textOverflowEllipsis(String text, int limit) {
  if (text.length > limit) {
    return text.substring(0, limit - 3) + '…';
  } else {
    return text;
  }
}
```

Can you come up with a test to reveal a potential issue with this code snippet? How would you rewrite it using the `characters` package? The answer is at the end of this article.

## Mitigations and possible long-term solution

It’s unreasonable to expect Dart users to stay on high alert for the kinds of pitfalls described above. For example, in an experiment we conducted, 53.7% of Dart users were unable to detect the problem illustrated in the first scenario (counting characters), even though they received two pages of information about the `characters` package and the problem the package was designed to address just a few minutes before. Therefore, we are taking a two-staged approach to helping developers choose the most appropriate API for their text manipulation needs.

In the short term, we are introducing a set of mitigations in the Flutter framework and the Dart analyzer to make the `characters` package easier to discover and invoke in Dart UI programming. This involves a few steps:

1. Use the `characters` package in the internal implementation of the `TextField` widget. See [this PR](https://github.com/flutter/flutter/pull/53381) and [this design doc](https://docs.google.com/document/d/1OOFW0PEZf0orBl445YXJ3nfjyKOqZdmeQ6KU3glUh7s/edit) for more details.

1. Expose the API of the `characters` package through the Flutter framework. Once this is done, Flutter users will have a higher chance of discovering the API through the extension method [`String.characters`](https://pub.dev/documentation/characters/latest/characters/StringCharacters.html), which will show up when doing an autocomplete on `String`. The status of this work is tracked in this issue: [https://github.com/flutter/flutter/issues/55593](https://github.com/flutter/flutter/issues/55593).

1. Update the Flutter framework’s API documentation and sample code to suggest using the [`Characters`](https://pub.dev/documentation/characters/latest/characters/Characters-class.html) class when applicable, such as in the callback for [`TextField.onChanged`](https://api.flutter.dev/flutter/material/TextField/onChanged.html). This work is tracked in [https://github.com/flutter/flutter/issues/55598](https://github.com/flutter/flutter/issues/55598) with relevant details in [this doc](https://docs.google.com/document/d/18SxWeHpds4modnvo997vIOiq01EspeFgsNvPa5ey88w/edit#heading=h.1isiu2jji0ae).

1. Have the Dart analyzer suggest converting a `String` object to a `Characters` object when autocompleting a callback template for handling user-entered text. For example, the IDE could fill out everything in the snippet below after the user autocompletes on `onChanged`. This work is tracked in [https://github.com/dart-lang/sdk/issues/41677](https://github.com/dart-lang/sdk/issues/41677).

```dart
TextField(
  onChanged: (String value) {
  // Converting String to Characters to handle emojis 
  // and non-English characters more robustly.
  var myText = value.characters;      
  }
)
```

Those mitigations can help, but they are limited to string manipulations performed in the context of a Flutter project. We need to carefully measure their effectiveness after they become available. A more complete solution at the Dart language level will likely require migration of at least some existing code, although a few options (for example, [static extension types](https://github.com/dart-lang/language/issues/42)) *might* make breaking changes manageable. More technical investigation is needed to fully understand the trade-offs.

## How you can help

Please help us raise awareness of how to fix string issues using the `characters` package:

* Look for instances of using `String.length` or `String.substring` in your own code. If the string might have originated from user input, try to rewrite the code using the `characters` package.

* Share this post with others in the Dart community.

* Try to update [existing answers about Dart text manipulation](https://stackoverflow.com/search?q=%5Bdart%5D+or+%5BFlutter%5D+String) on StackOverflow. If the accepted answers missed this limitation of the `String` API, remind people of the risk.

* Comment on the GitHub issues listed above to let us know your thoughts and opinions.

Now, happy coding 😉!

## Acknowledgments

Thanks to [Kathy Walrath](https://medium.com/@kathyw_39223), [Lasse Nielsen](https://medium.com/@lrhn), and [Michael Thomson](https://medium.com/@mit.mit) for reviewing this article. I would also like to thank developers who participated in our user research. Their participation helped the Dart and Flutter teams better understand the challenge of dealing with this limitation of the Dart `String` API.

— — —

PS: Here is the solution for the exercise:

```dart
// Prerequisite: add the characters package as a dependency in your pubspec.yaml.
import 'package:characters/characters.dart';

void main(List<String> arguments) {
  print(textOverflowEllipsis('😸cats', 10));
  print(textOverflowEllipsis('🦏rhinoceroses', 10));
}

// This function converts text overflow to an ellipsis
// when the text's length exceeds the given character limit.
String textOverflowEllipsis(String text, int limit) {
  var myChars = text.characters;
  if (myChars.length > limit) {
    return '${myChars.take(limit - 1)}…';
  } else {
    return text;
  }
}
```