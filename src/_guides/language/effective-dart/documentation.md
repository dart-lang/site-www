---
layout: guide
title: "Effective Dart: Documentation"
description: "Clear, helpful comments and documentation."

nextpage:
  url: /guides/language/effective-dart/usage
  title: "Usage"
prevpage:
  url: /guides/language/effective-dart/style
  title: "Style"
---

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

### DO format comments like sentences.

<div class="good">
{% prettify dart %}
// Not if there is nothing before it.
if (_chunks.isEmpty) return false;
{% endprettify %}
</div>

Capitalize the first word unless it's a case-sensitive identifier. End it with a
period (or "!" or "?", I suppose). This is true for all comments: doc comments,
inline stuff, even TODOs. Even if it's a sentence fragment.

### DON'T use block comments for documentation.

<div class="good">
{% prettify dart %}
greet(name) {
  // Assume we have a valid name.
  print('Hi, $name!');
}
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
greet(name) {
  /* Assume we have a valid name. */
  print('Hi, $name!');
}
{% endprettify %}
</div>

You can use a block comment (`/* ... */`) to temporarily comment out a section
of code, but all other comments should use `//`.

## Doc comments

Doc comments are especially handy because [dartdoc][] parses them and generates
[beautiful doc pages][docs] from them. A doc comment is any comment that appears
before a declaration and uses the special `///` syntax that dartdoc looks for.

[dartdoc]: https://github.com/dart-lang/dartdoc
[docs]: {{site.dart_api}}

### DO use `///` doc comments to document members and types.

Using a doc comment instead of a regular comment enables [dartdoc][] to find it
and generate documentation for it.

<div class="good">
{% prettify dart %}
/// The number of characters in this chunk when unsplit.
int get length => ...
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
// The number of characters in this chunk when unsplit.
int get length => ...
{% endprettify %}
</div>

For historical reasons, dartdoc supports two syntaxes of doc comments: `///`
("C# style") and `/** ... */` ("JavaDoc style"). We prefer `///` because it's
more compact. `/**` and `*/` add two content-free lines to a multiline doc
comment. The `///` syntax is also easier to read in some situations, such as
when a doc comment contains a bulleted list that uses `*` to mark list items.

If you stumble onto code that still uses the JavaDoc style, consider cleaning it
up.

### PREFER writing doc comments for public APIs.

You don't have to document every single top-level variable, type, and member,
but you should document most of them.

### CONSIDER writing doc comments for private APIs.

Doc comments aren't just for external consumers of your library's public API.
They can also be helpful for understanding private members that are called from
other parts of the library.

### DO make the first sentence a standalone paragraph.

The first paragraph of any doc comment is a brief, user-oriented description
ending with a period. As you can see below, it is often not a complete sentence.

<div class="good">
{% prettify dart %}
/// Defines a flag.
///
/// Throws an [ArgumentError] if there is already an option named [name] or
/// there is already an option using abbreviation [abbr]. Returns the new flag.
Flag addFlag(String name, String abbr) { ... }
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
/// Starts a new block as a child of the current chunk. Nested blocks are
/// handled using their own independent [LineWriter].
ChunkBuilder startBlock() { ... }
{% endprettify %}
</div>

The description should help the reader understand whether this API might
be useful to them, compared to similar-sounding APIs. Don't just repeat the API
name&mdash;tell the reader something they don't already know.

### PREFER starting function or method comments with third-person verbs.

The doc comment should focus on what the code *does*.

<div class="good">
{% prettify dart %}
/// Returns `true` if every element satisfies the [predicate].
bool all(bool predicate(T element)) { ... }

/// Starts the stopwatch if not already running.
void start() { ... }
{% endprettify %}
</div>

### PREFER starting variable, getter, or setter comments with noun phrases.

The doc comment should stress what the property *is*. This is true even for
getters which may do calculation or other work. What the caller cares about is
the *result* of that work, not the work itself.

<div class="good">
{% prettify dart %}
/// The current day of the week, where `0` is Sunday.
int weekday;

/// The number of checked buttons on the page.
int get checkedCount { ... }
{% endprettify %}
</div>

If there's both a setter and a getter, comment only the getter. That way,
dartdoc will treat it like a variable.

### PREFER starting library or type comments with noun phrases.

Doc comments for classes are often the most important documentation in your
program. They describe the type's invariants, establish the terminology it uses,
and provide context to the other doc comments for the class's members. A little
extra effort here can make all of the other members simpler to document.

<div class="good">
{% prettify dart %}
/// A chunk of non-breaking output text terminated by a hard or soft newline.
///
/// ...
class Chunk { ... }
{% endprettify %}
</div>

### CONSIDER including code samples in doc comments.

<div class="good">
{% prettify dart %}
/// Returns the lesser of two numbers.
///
///     min(5, 3); // 3.
num min(num a, num b) { ... }
{% endprettify %}
</div>

Humans are great at generalizing from examples, so even a single code sample
makes an API easier to learn.

### DO use square brackets in doc comments to refer to in-scope identifiers.

If you surround things like variable, method, or type names in square brackets,
then dartdoc will look up the name and link to its docs.

<div class="good">
{% prettify none %}
Throws a [StateError] if ...

similar to [anotherMethod], but ...
{% endprettify %}
</div>

You can also link to constructors using `new` followed by the constructor:

<div class="good">
{% prettify none %}
To create a point, call [new Point] or use [new Point.polar] to ...
{% endprettify %}
</div>

### DO use prose to explain parameters, return values, and exceptions.

Other languages use verbose tags and sections to describe what the parameters
and returns of a method are.

<div class="bad">
{% prettify dart %}
/// Defines a flag with the given name and abbreviation.
///
/// @param name The name of the flag.
/// @param abbr The abbreviation for the flag.
/// @returns The new flag.
/// @throws ArgumentError If there is already an option with
///     the given name or abbreviation.
Flag addFlag(String name, String abbr) { ... }
{% endprettify %}
</div>

The convention in Dart is to integrate that into the description of the method
and highlight parameters using square brackets.

<div class="good">
{% prettify dart %}
/// Defines a flag.
///
/// Throws an [ArgumentError] if there is already an option named [name] or
/// there is already an option using abbreviation [abbr]. Returns the new flag.
Flag addFlag(String name, String abbr) { ... }
{% endprettify %}
</div>

### AVOID redundantly mentioning types in doc comments.

Users reading your doc comments can also see the type, return type, parameter
types, etc. of the construct you're documenting. Dartdoc already provides links
to them. There's no need to also state the type in the prose.

Tell the reader something they *don't* already know.

### DO put doc comments before metadata annotations.

<div class="good">
{% prettify dart %}
/// _Deprecated: Use [newMethod] instead._
@deprecated
oldMethod();
{% endprettify %}
</div>

<div class="bad">
{% prettify dart %}
@deprecated
/// _Deprecated: Use [newMethod] instead._
oldMethod();
{% endprettify %}
</div>


## Markdown

You are allowed to use most [markdown][] formatting in your doc comments and
dartdoc will process it accordingly using the [markdown package][].

[markdown]: https://daringfireball.net/projects/markdown/
[markdown package]: https://pub.dartlang.org/packages/markdown

There are tons of guides out there already to introduce you to Markdown. Its
universal popularity is why we chose it. Here's just a quick example to give you
a flavor of what's supported:

{% prettify dart %}
/// This is a paragraph of regular text.
///
/// This sentence has *two* _emphasized_ words (i.e. italics) and **two**
/// __strong__ ones (bold).
///
/// A blank line creates another separate paragraph. It has some `inline code`
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
/// Code blocks are indented the same way:
///
///     this.code
///         .will
///         .retain(its, formatting);
///
/// Links can be:
///
/// * http://www.just-a-bare-url.com
/// * [with the URL inline](http://google.com)
/// * [or separated out][ref link]
///
/// [ref link]: http://google.com
///
/// # A Header
///
/// ## A subheader
///
/// ### A subsubheader
///
/// #### If you need this many levels of headers, you're doing it wrong
{% endprettify %}

### AVOID using markdown excessively.

When in doubt, format less. Formatting exists to illuminate your content, not
replace it. Words are what matters.

### AVOID using HTML for formatting.

It *may* be useful to use it in rare cases for things like tables, but in almost
all cases, if it's too complex too express in Markdown, you're better off not
expressing it.

## Writing

We think of ourselves as programmers, but most of the characters in a source
file are intended primarily for humans to read. English is the language we code
in to modify the brains of our coworkers. As for any programming language, it's
worth putting effort into improving your proficiency.

This section lists a few guidelines for our docs. You can learn more about
best practices for technical writing, in general, from articles such as
[Technical writing style](https://en.wikiversity.org/wiki/Technical_writing_style).

### PREFER brevity.

Be clear and precise, but also terse.

### AVOID abbreviations and acronyms unless they are obvious.

Many people don't know what "i.e.", "e.g." and "et. al." mean. That acronym
that you're sure everyone in your field knows may not be as widely known as you
think.

### PREFER using "this" instead of "the" to refer to a member's instance.

When documenting a member for a class, you often need to refer back to the
object the member is being called on. Using "the" can be ambiguous.

<div class="good">
{% prettify dart %}
class Box {
  /// The value this wraps.
  var _value;

  /// True if this box contains a value.
  bool get hasValue => _value != null;
}
{% endprettify %}
</div>

