---
layout: guide
title: "Customize Static Analysis"
description: "Customize static analysis using the analysis_options file."
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
and other suggested guidelines
in [Effective Dart](/guides/language/effective-dart).
Dart tools such as the
[Dart Dev Compiler (DDC)](https://github.com/dart-lang/dev_compiler),
[`dartanalyzer`](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer),
[`flutter analyze`](https://flutter.io/debugging/#the-dart-analyzer),
and [JetBrains IDEs](https://www.dartlang.org/tools/jetbrains-plugin)
use the analyzer package to evaluate your code.

This document explains how to customize the behavior of the analyzer
using an analysis options file. If you want to
add static analysis to your tool, see the
[analyzer package](https://pub.dartlang.org/packages/analyzer) docs and the
[Analysis Server API Specification](https://htmlpreview.github.io/?https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/doc/api.html).


## The analysis options file

Place the analysis options file at the root of the package,
in the same directory as the pubspec file.
By convention, the file is called `.analysis_options`, but it
can also be named `analysis_options.yaml` (without the leading dot).

Here's a sample analysis options file:

{% prettify yaml %}
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
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

## Specifying strong mode

The Dart language spec supports dynamic typing, allowing you to
write code that has no type annotations at all.
Strong mode applies more restrictive rules to the type system and,
as a result, finds more errors during static analysis and at runtime.
Another benefit of strong mode is faster compilation.
Some tools, such as DDC, require strong mode compliance.

The simplest way to enable strong mode is to specify
`strong-mode: true` in the analysis-options file:

{% prettify yaml %}
analyzer:
  strong-mode: true
{% endprettify %}

Strong mode is disabled by default. Instead of specifying `true`
you can use the following flags to look for specific types
of implicit casting, on top of the standard strong mode checks.
The presence of either flag, regardless of value, enables strong mode.

`implicit-downcasts: <bool>`
: A value of `false` ensures that the type inference engine never
  implicitly casts to a more specific type. The following valid Dart code
  includes an implicit downcast that would be caught by this flag:

{% prettify dart %}
Object o = ...;
String s = o;  // Implicit downcast
String s2 = s.substring(1);
{% endprettify %}

  This flag defaults to `true`.

`implicit-dynamic: <bool>`
: A value of `false` ensures that the type inference engine never chooses
  the `dynamic` type when it can't determine a static type.
  This flag defaults to `true`.

To disallow both implicit downcasts and implicit dynamic types in the
analysis options file:

{% prettify yaml %}
analyzer:
  strong-mode:
    - implicit-downcasts: false
    - implicit-dynamic: false
{% endprettify %}

## Enabling linter rules

The analyzer package also provides a code linter. A wide variety of
[linter rules](http://dart-lang.github.io/linter/lints/)
are available. Linters tend to be
non denominational&mdash;rules don't have to agree with each other.
For example, some rules are more appropriate for library packages
and others are designed for Flutter apps.
Note that some of the linter rules don't play well with strong mode,
and linter rules can have false positives, unlike static analysis.

To enable a linter rule, add `linter:` to the analysis options file,
followed by `rules:`.
On subsequent lines, specify the rules that you want to apply,
prefixed with dashes. For example:

{% prettify yaml %}
analyzer:
  strong-mode: true

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
    - unnecessary_brace_in_string_interp
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
  strong-mode: true
  exclude:
    - lib/client/piratesapi.dart
{% endprettify %}

You can specify a group of files using
[glob](https://pub.dartlang.org/packages/glob) syntax:

{% prettify yaml %}
analyzer:
  strong-mode: true
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

## Configuring specific rules for analysis

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

You can also globally change the severity of a particular rule
using one of the following values: `warning`, `error`, or `info`.
For example:

{% prettify yaml %}
analyzer:
  errors:
    unused_local_variable: ignore
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

* [Strong mode](https://github.com/dart-lang/dev_compiler/blob/master/STRONG_MODE.md#strong-mode)
* [Dart linter](https://github.com/dart-lang/linter#linter-for-dart)
* [Dart linter Rules](http://dart-lang.github.io/linter/lints/)
* [dartanalyzer](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer)
* [DDC](https://github.com/dart-lang/dev_compiler#dev_compiler)
* [analyzer package](https://pub.dartlang.org/packages/analyzer)
