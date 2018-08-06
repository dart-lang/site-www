---
title: Customize Static Analysis
description: Customize static analysis using an analysis options file.
---

Static analysis allows you to find problems before
executing a single line of code. It's a powerful tool
used to prevent bugs and ensure that code conforms to style
guidelines. With the help of the analyzer, you can find
simple typos. For example, perhaps an accidental semicolon
made its way into an `if` statement:

{% img 'guides/avoid-empty-statements.png' %}

The analyzer can also help you find more subtle problems.
For example, perhaps you've forgotten to close a sink method:

{% img 'guides/close-sinks.png' %}

In the Dart ecosystem,
the Dart Analysis Server and other tools use the
[analyzer package](https://pub.dartlang.org/packages/analyzer)
to perform static analysis.

You can customize static analysis to look for a variety of potential
problems, including errors and warnings specified in the
[Dart language spec](/guides/language/spec).
You can also configure the linter, one of the analyzer's plugins,
to ensure that your code complies with the
[Dart Style Guide](/guides/language/effective-dart/style)
and other suggested guidelines in
[Effective Dart](/guides/language/effective-dart). Dart tools such as the
[Dart dev compiler (dartdevc),]({{site.webdev}}/tools/dartdevc)
[`dartanalyzer`,](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer)
[`flutter analyze`,](https://flutter.io/debugging/#the-dart-analyzer)
and [JetBrains IDEs](/tools/jetbrains-plugin)
use the analyzer package to evaluate your code.

This document explains how to customize the behavior of the analyzer
using an analysis options file. If you want to
add static analysis to your tool, see the
[analyzer package](https://pub.dartlang.org/packages/analyzer) docs and the
[Analysis Server API Specification.](https://htmlpreview.github.io/?https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/doc/api.html)

<aside class="alert alert-info" markdown="1">
**Note:**
The analyzer error codes are listed in the [Dart SDK
repo.](https://github.com/dart-lang/sdk/blob/master/pkg/analyzer/lib/error/error.dart)
</aside>

## The analysis options file

Place the analysis options file, `analysis_options.yaml`,
at the root of the package, in the same directory as the pubspec file.

<aside class="alert alert-warning" markdown="1">
  **Breaking change:** The conventional name for the analysis options file
  used to be `.analysis_options` (note the leading dot and missing `.yaml` suffix).
  We expect support for the `.analysis_options` name to go away in a future
  release, so we recommend that you **rename your `.analysis_options` files to
  `analysis_options.yaml`.**
  {% comment %}
  Tracking issue: https://github.com/dart-lang/sdk/issues/28385
  {% endcomment %}
</aside>

Here's a sample analysis options file:

{% prettify yaml %}
analyzer:
  strong-mode:
    implicit-casts: false
  errors:
    todo: ignore
  exclude:
    - flutter/**
    - lib/api/*.dart

linter:
  rules:
    - avoid_empty_else
    - cancel_subscriptions
    - close_sinks
    - unnecessary_const
    - unnecessary_new
{% endprettify %}

YAML is sensitive to whitespace&mdash;don't use tabs in a YAML file,
and use 2 spaces to denote each level of indentation.

<aside class="alert alert-info" markdown="1">
**Note**: You might come across a `language:` tag in an analysis options file.
This tag is used for testing experimental features. You can ignore it.
</aside>

If the analyzer can't find an analysis options file at the package root,
it walks up the directory tree, looking for one.
If no file is available, the analyzer defaults to standard checks.

Consider the following directory structure for a large project:

{% img 'guides/analysis-options-directory-structure.png' %}

The analyzer will use file #1 to analyze the code in `my_other_package`
and `my_other_other_package`, and file #2 to analyze the code in
`my_package`.


## Enabling additional type checks

If you want stricter static checks than
the [Dart type system][sound-dart] requires,
consider using the `implicit-casts` and `implicit-dynamic` flags:

{% prettify yaml %}
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
{% endprettify %}

You can use the flags together or separately;
both default to `true`.
The presence of either flag, regardless of value, enables
the Dart 2 type system.

{% comment %}
**PENDING:
Will these flags still appear under strong-mode in Dart 2.0?
Should we mention related command-line flags
(--no-implicit-casts, --no-implicit-dynamic)?**
{% endcomment %}

`implicit-casts: <bool>`
: A value of `false` ensures that the type inference engine never
  implicitly casts to a more specific type.
  The following valid Dart code
  includes an implicit downcast that would be caught by this flag:

{% prettify dart %}
Object o = ...;
String s = o;  // Implicit downcast
String s2 = s.substring(1);
{% endprettify %}

`implicit-dynamic: <bool>`
: A value of `false` ensures that the type inference engine never chooses
  the `dynamic` type when it can't determine a static type.

{% comment %}
TODO: Clarify that description, and insert an example here.
{% endcomment %}


## Enabling linter rules

The analyzer package also provides a code linter. A wide variety of
[linter rules](http://dart-lang.github.io/linter/lints/)
are available. Linters tend to be
nondenominational&mdash;rules don't have to agree with each other.
For example, some rules are more appropriate for library packages
and others are designed for Flutter apps.
Note that linter rules can have false positives, unlike static analysis.

To enable a linter rule, add `linter:` to the analysis options file,
followed by `rules:`.
On subsequent lines, specify the rules that you want to apply,
prefixed with dashes. For example:

{% prettify yaml %}
linter:
  rules:
    - always_declare_return_types
    - camel_case_types
    - empty_constructor_bodies
    - annotate_overrides
    - avoid_init_to_null
    - constant_identifier_names
    - one_member_abstracts
    - slash_for_doc_comments
    - sort_constructors_first
    - unnecessary_brace_in_string_interps
{% endprettify %}

{% comment %}
Brian expressed concern about including this:
In future, related lint rules may be coalesced into meta rules. See
[Issue 99: Meta linter rules](https://github.com/dart-lang/linter/issues/288)
for more information.
{% endcomment %}

## Excluding files

Perhaps you rely on code generated from a package that
you don't own&mdash;the generated code works,
but produces errors during static analysis.
You can exclude files from static analysis using the `exclude:` field.

{% prettify yaml %}
analyzer:
  exclude:
    - lib/client/piratesapi.dart
{% endprettify %}

You can specify a group of files using
[glob](https://pub.dartlang.org/packages/glob) syntax:

{% prettify yaml %}
analyzer:
  exclude:
    - src/test/_data/**
    - test/*_example.dart
{% endprettify %}

## Excluding lines within a file

Perhaps one of the linter rules causes a false positive and you
want to suppress that warning.
To suppress a specific rule on a specific line of code,
preceed that line with a comment using the following format:

{% prettify dart %}
// ignore: <linter rule>
{% endprettify %}

For example:

{% prettify dart %}
// ignore: invalid_assignment
int x = '';
{% endprettify %}

If you want to suppress more than one rule, supply a comma-separated list.
For example:

{% prettify dart %}
// ignore: invalid_assignment, const_initialized_with_non_constant_value
const x = y;
{% endprettify %}

## Ignoring specific analysis rules

Sometimes your code doesn't fit perfectly within the standard
analysis guidelines, or violates a rule here or there, for
reasons you'd rather not get into. You can ignore specific
rules during analysis using the `errors:` field. List the
rule, followed by `: ignore`. For example:

{% prettify yaml %}
analyzer:
  errors:
    todo: ignore
{% endprettify %}

This analysis options file instructs the analysis tools to ignore
the TODO rule.

Alternatively, as of Dart 1.24 you can ignore a specific rule for a
specific file using an `ignore_for_file` comment:

{% prettify dart %}
// ignore_for_file: unused_import
{% endprettify %}

This acts for the whole file, before or after the comment, and is
particularly useful for generated code. A comma-separated list may be
used to suppress more than one rule:

{% prettify dart %}
// ignore_for_file: unused_import, invalid_assignment
{% endprettify %}

## Changing the severity of analysis rules

Using the same mechanism, you can also globally change the severity
of a particular rule using one of the following values: `warning`,
`error`, or `info`. This works for regular analysis issues as well as
for lints. For example:

{% prettify yaml %}
analyzer:
  errors:
    invalid_assignment: warning
    missing_return: error
    dead_code: info
{% endprettify %}

This analysis options file instructs the analysis tools to
ignore unused local variables, treat invalid assignments as warnings and
missing returns as errors, and only provide information about dead code.

## Resources

{% comment %}
Join the discussion list for linter enthusiasts:

* [linter-discuss (TBD)](xxx)  Doesn't exist yet...
{% endcomment %}

Use the following resources to learn more about static analysis in Dart:

* [Dart's Type System][sound-dart]
* [Dart linter](https://github.com/dart-lang/linter#linter-for-dart)
* [Dart linter rules](http://dart-lang.github.io/linter/lints/)
* [dartanalyzer](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer)
* [dartdevc]({{site.webdev}}/tools/dartdevc)
* [analyzer package](https://pub.dartlang.org/packages/analyzer)

[sound-dart]: /guides/language/sound-dart
