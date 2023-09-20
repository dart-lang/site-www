---
title: "Effective Dart: Documentation"
description: Clear, helpful comments and documentation.
nextpage:
  url: /effective-dart/usage
  title: Usage
prevpage:
  url: /effective-dart/style
  title: Style
---

<?code-excerpt path-base="misc/lib/effective_dart"?>

It's easy to think your code is obvious today without realizing how much you
rely on context already in your head. People new to your code, and
even your forgetful future self won't have that context. A concise, accurate
comment only takes a few seconds to write but can save one of those people
hours of time.

We all know code should be self-documenting and not all comments are helpful.
But the reality is that most of us don't write as many comments as we should.
It's like exercise: you technically *can* do too much, but it's a lot more
likely that you're doing too little. Try to step it up.

## Comments

The following tips apply to comments that you don't want included in the
generated documentation.

### DO format comments like sentences

{:.good}
<?code-excerpt "docs_good.dart (comments-like-sentences)"?>
```dart
// Not if anything comes before it.
if (_chunks.isNotEmpty) return false;
```

Capitalize the first word unless it's a case-sensitive identifier. End it with a
period (or "!" or "?", I suppose). This is true for all comments: doc comments,
inline stuff, even TODOs. Even if it's a sentence fragment.

### DON'T use block comments for documentation

{:.good}
<?code-excerpt "docs_good.dart (block-comments)"?>
```dart
void greet(String name) {
  // Assume we have a valid name.
  print('Hi, $name!');
}
```

{:.bad}
<?code-excerpt "docs_bad.dart (block-comments)"?>
```dart
void greet(String name) {
  /* Assume we have a valid name. */
  print('Hi, $name!');
}
```

You can use a block comment (`/* ... */`) to temporarily comment out a section
of code, but all other comments should use `//`.

## Doc comments

Doc comments are especially handy because [`dart doc`][] parses them 
and generates [beautiful doc pages][docs] from them. 
A doc comment is any comment that appears before a declaration 
and uses the special `///` syntax that `dart doc` looks for.

[`dart doc`]: /tools/dart-doc
[docs]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}

### DO use `///` doc comments to document members and types

{% include linter-rule-mention.md rule="slash_for_doc_comments" %}

Using a doc comment instead of a regular comment enables 
[`dart doc`][] to find it
and generate documentation for it.

{:.good}
<?code-excerpt "docs_good.dart (use-doc-comments)"?>
```dart
/// The number of characters in this chunk when unsplit.
int get length => ...
```

{:.bad}
<?code-excerpt "docs_good.dart (use-doc-comments)" replace="/^\///g"?>
```dart
// The number of characters in this chunk when unsplit.
int get length => ...
```

For historical reasons, `dart doc` supports two syntaxes of doc comments: `///`
("C# style") and `/** ... */` ("JavaDoc style"). We prefer `///` because it's
more compact. `/**` and `*/` add two content-free lines to a multiline doc
comment. The `///` syntax is also easier to read in some situations, such as
when a doc comment contains a bulleted list that uses `*` to mark list items.

If you stumble onto code that still uses the JavaDoc style, consider cleaning it
up.

### PREFER writing doc comments for public APIs

{% include linter-rule-mention.md rule1="package_api_docs" rule2="public_member_api_docs"%}

You don't have to document every single library, top-level variable, type, and
member, but you should document most of them.

### CONSIDER writing a library-level doc comment

Unlike languages like Java where the class is the only unit of program
organization, in Dart, a library is itself an entity that users work with
directly, import, and think about. That makes the `library` directive a great
place for documentation that introduces the reader to the main concepts and
functionality provided within. Consider including:

* A single-sentence summary of what the library is for.
* Explanations of terminology used throughout the library.
* A couple of complete code samples that walk through using the API.
* Links to the most important or most commonly used classes and functions.
* Links to external references on the domain the library is concerned with.

To document a library, place a doc comment before
the `library` directive and any annotations that might be attached
at the start of the file.

{:.good}
<?code-excerpt "docs_good.dart (library-doc)"?>
```dart
/// A really great test library.
@TestOn('browser')
library;
```

### CONSIDER writing doc comments for private APIs

Doc comments aren't just for external consumers of your library's public API.
They can also be helpful for understanding private members that are called from
other parts of the library.

### DO start doc comments with a single-sentence summary

Start your doc comment with a brief, user-centric description ending with a
period. A sentence fragment is often sufficient. Provide just enough context for
the reader to orient themselves and decide if they should keep reading or look
elsewhere for the solution to their problem.

{:.good}
<?code-excerpt "docs_good.dart (first-sentence)"?>
```dart
/// Deletes the file at [path] from the file system.
void delete(String path) {
  ...
}
```

{:.bad}
<?code-excerpt "docs_bad.dart (first-sentence)"?>
```dart
/// Depending on the state of the file system and the user's permissions,
/// certain operations may or may not be possible. If there is no file at
/// [path] or it can't be accessed, this function throws either [IOError]
/// or [PermissionError], respectively. Otherwise, this deletes the file.
void delete(String path) {
  ...
}
```

### DO separate the first sentence of a doc comment into its own paragraph

Add a blank line after the first sentence to split it out into its own
paragraph. If more than a single sentence of explanation is useful, put the
rest in later paragraphs.

This helps you write a tight first sentence that summarizes the documentation.
Also, tools like `dart doc` use the first paragraph as a short summary in places
like lists of classes and members.

{:.good}
<?code-excerpt "docs_good.dart (first-sentence-a-paragraph)"?>
```dart
/// Deletes the file at [path].
///
/// Throws an [IOError] if the file could not be found. Throws a
/// [PermissionError] if the file is present but could not be deleted.
void delete(String path) {
  ...
}
```

{:.bad}
<?code-excerpt "docs_bad.dart (first-sentence-a-paragraph)"?>
```dart
/// Deletes the file at [path]. Throws an [IOError] if the file could not
/// be found. Throws a [PermissionError] if the file is present but could
/// not be deleted.
void delete(String path) {
  ...
}
```

### AVOID redundancy with the surrounding context

The reader of a class's doc comment can clearly see the name of the class, what
interfaces it implements, etc. When reading docs for a member, the signature is
right there, and the enclosing class is obvious. None of that needs to be
spelled out in the doc comment. Instead, focus on explaining what the reader
*doesn't* already know.

{:.good}
<?code-excerpt "docs_good.dart (redundant)"?>
```dart
class RadioButtonWidget extends Widget {
  /// Sets the tooltip to [lines], which should have been word wrapped using
  /// the current font.
  void tooltip(List<String> lines) {
    ...
  }
}
```

{:.bad}
<?code-excerpt "docs_bad.dart (redundant)"?>
```dart
class RadioButtonWidget extends Widget {
  /// Sets the tooltip for this radio button widget to the list of strings in
  /// [lines].
  void tooltip(List<String> lines) {
    ...
  }
}
```

If you really don't have anything interesting to say
that can't be inferred from the declaration itself,
then omit the doc comment.
It's better to say nothing
than waste a reader's time telling them something they already know.


### PREFER starting function or method comments with third-person verbs

The doc comment should focus on what the code *does*.

{:.good}
<?code-excerpt "docs_good.dart (third-person)"?>
```dart
/// Returns `true` if every element satisfies the [predicate].
bool all(bool predicate(T element)) => ...

/// Starts the stopwatch if not already running.
void start() {
  ...
}
```

### PREFER starting a non-boolean variable or property comment with a noun phrase

The doc comment should stress what the property *is*. This is true even for
getters which may do calculation or other work. What the caller cares about is
the *result* of that work, not the work itself.

{:.good}
<?code-excerpt "docs_good.dart (noun-phrases-for-non-boolean-var-etc)"?>
```dart
/// The current day of the week, where `0` is Sunday.
int weekday;

/// The number of checked buttons on the page.
int get checkedCount => ...
```

### PREFER starting a boolean variable or property comment with "Whether" followed by a noun or gerund phrase

The doc comment should clarify the states this variable represents. 
This is true even for getters which may do calculation or other work. 
What the caller cares about is the *result* of that work, not the work itself.

{:.good}
<?code-excerpt "docs_good.dart (noun-phrases-for-boolean-var-etc)"?>
```dart
/// Whether the modal is currently displayed to the user.
bool isVisible;

/// Whether the modal should confirm the user's intent on navigation.
bool get shouldConfirm => ...

/// Whether resizing the current browser window will also resize the modal.
bool get canResize => ...
```

{{site.alert.note}}
  This guideline intentionally doesn't include using "Whether or not". In many
  cases, usage of "or not" with "whether" is superfluous and can be omitted,
  especially when used in this context.
{{site.alert.end}}

### DON'T write documentation for both the getter and setter of a property

If a property has both a getter and a setter, then create a doc comment for
only one of them. `dart doc` treats the getter and setter like a single field,
and if both the getter and the setter have doc comments, then
`dart doc` discards the setter's doc comment.

{:.good}
<?code-excerpt "docs_good.dart (getter-and-setter)"?>
```dart
/// The pH level of the water in the pool.
///
/// Ranges from 0-14, representing acidic to basic, with 7 being neutral.
int get phLevel => ...
set phLevel(int level) => ...
```

{:.bad}
<?code-excerpt "docs_bad.dart (getter-and-setter)"?>
```dart
/// The depth of the water in the pool, in meters.
int get waterDepth => ...

/// Updates the water depth to a total of [meters] in height.
set waterDepth(int meters) => ...
```

### PREFER starting library or type comments with noun phrases

Doc comments for classes are often the most important documentation in your
program. They describe the type's invariants, establish the terminology it uses,
and provide context to the other doc comments for the class's members. A little
extra effort here can make all of the other members simpler to document.

{:.good}
<?code-excerpt "docs_good.dart (noun-phrases-for-type-or-lib)"?>
```dart
/// A chunk of non-breaking output text terminated by a hard or soft newline.
///
/// ...
class Chunk { ... }
```

### CONSIDER including code samples in doc comments

{:.good}
<?code-excerpt "docs_good.dart (code-sample)"?>
{% prettify dart tag=pre+code %}
/// Returns the lesser of two numbers.
///
/// ```dart
/// min(5, 3) == 3
/// ```
num min(num a, num b) => ...
{% endprettify %}

Humans are great at generalizing from examples, so even a single code sample
makes an API easier to learn.

### DO use square brackets in doc comments to refer to in-scope identifiers

{% include linter-rule-mention.md rule="comment_references" %}

If you surround things like variable, method, or type names in square brackets,
then `dart doc` looks up the name and links to the relevant API docs.
Parentheses are optional, 
but can make it clearer when you're referring to a method or constructor.

{:.good}
<?code-excerpt "docs_good.dart (identifiers)"?>
```dart
/// Throws a [StateError] if ...
/// similar to [anotherMethod()], but ...
```

To link to a member of a specific class, use the class name and member name,
separated by a dot:

{:.good}
<?code-excerpt "docs_good.dart (member)"?>
```dart
/// Similar to [Duration.inDays], but handles fractional days.
```

The dot syntax can also be used to refer to named constructors. For the unnamed
constructor, use `.new` after the class name:

{:.good}
<?code-excerpt "docs_good.dart (ctor)"?>
```dart
/// To create a point, call [Point.new] or use [Point.polar] to ...
```

### DO use prose to explain parameters, return values, and exceptions

Other languages use verbose tags and sections to describe what the parameters
and returns of a method are.

{:.bad}
<?code-excerpt "docs_bad.dart (no-annotations)"?>
```dart
/// Defines a flag with the given name and abbreviation.
///
/// @param name The name of the flag.
/// @param abbr The abbreviation for the flag.
/// @returns The new flag.
/// @throws ArgumentError If there is already an option with
///     the given name or abbreviation.
Flag addFlag(String name, String abbr) => ...
```

The convention in Dart is to integrate that into the description of the method
and highlight parameters using square brackets.

{:.good}
<?code-excerpt "docs_good.dart (no-annotations)"?>
```dart
/// Defines a flag.
///
/// Throws an [ArgumentError] if there is already an option named [name] or
/// there is already an option using abbreviation [abbr]. Returns the new flag.
Flag addFlag(String name, String abbr) => ...
```

### DO put doc comments before metadata annotations

{:.good}
<?code-excerpt "docs_good.dart (doc-before-meta)"?>
```dart
/// A button that can be flipped on and off.
@Component(selector: 'toggle')
class ToggleComponent {}
```

{:.bad}
<?code-excerpt "docs_bad.dart (doc-before-meta)" replace="/\n\n/\n/g"?>
```dart
@Component(selector: 'toggle')
/// A button that can be flipped on and off.
class ToggleComponent {}
```


## Markdown

You are allowed to use most [markdown][] formatting in your doc comments and
`dart doc` will process it accordingly using the [markdown package.][]

[markdown]: https://daringfireball.net/projects/markdown/
[markdown package.]: {{site.pub-pkg}}/markdown

There are tons of guides out there already to introduce you to Markdown. Its
universal popularity is why we chose it. Here's just a quick example to give you
a flavor of what's supported:

<?code-excerpt "docs_good.dart (markdown)"?>
{% prettify dart tag=pre+code %}
/// This is a paragraph of regular text.
///
/// This sentence has *two* _emphasized_ words (italics) and **two**
/// __strong__ ones (bold).
///
/// A blank line creates a separate paragraph. It has some `inline code`
/// delimited using backticks.
///
/// * Unordered lists.
/// * Look like ASCII bullet lists.
/// * You can also use `-` or `+`.
///
/// 1. Numbered lists.
/// 2. Are, well, numbered.
/// 1. But the values don't matter.
///
///     * You can nest lists too.
///     * They must be indented at least 4 spaces.
///     * (Well, 5 including the space after `///`.)
///
/// Code blocks are fenced in triple backticks:
///
/// ```dart
/// this.code
///     .will
///     .retain(its, formatting);
/// ```
///
/// The code language (for syntax highlighting) defaults to Dart. You can
/// specify it by putting the name of the language after the opening backticks:
///
/// ```html
/// <h1>HTML is magical!</h1>
/// ```
///
/// Links can be:
///
/// * https://www.just-a-bare-url.com
/// * [with the URL inline](https://google.com)
/// * [or separated out][ref link]
///
/// [ref link]: https://google.com
///
/// # A Header
///
/// ## A subheader
///
/// ### A subsubheader
///
/// #### If you need this many levels of headers, you're doing it wrong
{% endprettify %}

### AVOID using markdown excessively

When in doubt, format less. Formatting exists to illuminate your content, not
replace it. Words are what matter.

### AVOID using HTML for formatting

It *may* be useful to use it in rare cases for things like tables, but in almost
all cases, if it's too complex to express in Markdown, you're better off not
expressing it.

### PREFER backtick fences for code blocks

Markdown has two ways to indicate a block of code: indenting the code four
spaces on each line, or surrounding it in a pair of triple-backtick "fence"
lines. The former syntax is brittle when used inside things like Markdown lists
where indentation is already meaningful or when the code block itself contains
indented code.

The backtick syntax avoids those indentation woes, lets you indicate the code's
language, and is consistent with using backticks for inline code.

{:.good}
```dart
/// You can use [CodeBlockExample] like this:
///
/// ```dart
/// var example = CodeBlockExample();
/// print(example.isItGreat); // "Yes."
/// ```
```

{:.bad}
```dart
/// You can use [CodeBlockExample] like this:
///
///     var example = CodeBlockExample();
///     print(example.isItGreat); // "Yes."
```

## Writing

We think of ourselves as programmers, but most of the characters in a source
file are intended primarily for humans to read. English is the language we code
in to modify the brains of our coworkers. As for any programming language, it's
worth putting effort into improving your proficiency.

This section lists a few guidelines for our docs. You can learn more about
best practices for technical writing, in general, from articles such as
[Technical writing style](https://en.wikiversity.org/wiki/Technical_writing_style).

### PREFER brevity

Be clear and precise, but also terse.

### AVOID abbreviations and acronyms unless they are obvious

Many people don't know what "i.e.", "e.g." and "et al." mean. That acronym
that you're sure everyone in your field knows may not be as widely known as you
think.

### PREFER using "this" instead of "the" to refer to a member's instance

When documenting a member for a class, you often need to refer back to the
object the member is being called on. Using "the" can be ambiguous.

{:.good}
<?code-excerpt "docs_good.dart (this)"?>
```dart
class Box {
  /// The value this wraps.
  Object? _value;

  /// True if this box contains a value.
  bool get hasValue => _value != null;
}
```
