---
layout: guide
title: "Customize the Static Analysis Server"
description: "Customize the static analysis server using the analysis_options file."
---

Static analysis allows you to find problems before
executing a single line of code. It's a powerful tool
used to prevent bugs and ensure that code conforms to style
guidelines. In the Dart ecosystem, the
Dart Analysis Server performs static analysis.

You can customize the server to look for a variety of potential
problems, including errors and warnings specified in the
[Dart language spec](/guides/language/spec).
You can also configure the linter, one of the analysis server's plugins,
to ensure that your code complies with the
[Dart Style Guide](/guides/language/effective-dart/style)
and other suggested guidelines
in [Effective Dart](/guides/language/effective-dart).
Dart tools, such as the
[Dart Dev Compiler (DDC)](https://github.com/dart-lang/dev_compiler),
[`dartanalyzer`](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer),
[`flutter analyze`](https://flutter.io/debugging/#the-dart-analyzer),
and the [IntelliJ IDEs](https://www.dartlang.org/tools/jetbrains-plugin),
all use the analysis server to evaluate your code.

This document explains how to customize the behavior of the
analysis server using an `.analysis_options` file. If you want to use
the analysis server API to add static analysis to your tool, see the
[Analysis Server API Specification](https://htmlpreview.github.io/?https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/doc/api.html)


## The analysis options file

The `.analysis_options` (or `.analysis_options.yaml`) file,
written in the YAML language, is typically placed in the same
directory as the pubspec file at the top of the package.
If no file is present, the server walks up the directory
tree, looking for one.

Here's a sample YAML analysis_options file:

{% prettify yaml %}
analyzer:
  language:
    enableStrictCallChecks: true
    enableSuperMixins: true
  strong-mode:
    - no-implicit-downcasts: true
    - no-implicit-dynamic: true
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

## Specifying strong mode

The Dart language spec supports dynamic typing, allowing you to
write code that has no type annotations at all.
Strong mode is a way to apply more restrictive rules to
the type system, resulting in finding more errors during
static analysis and runtime. Another benefit of strong mode
is faster compilation.
Some tools, such as DDC, require strong mode compliance.

The simplest way to enable strong mode is to specify
`strong-mode: true` in the analysis-options file:

{% prettify yaml %}
analyzer:
  strong-mode: true
{% endprettify %}

This flag defaults to false. Instead of specifying `true`
you can use the following flags to look for specific types
of implicit casting, on top of the standard strong mode checks.
The presence of either flag, regardless of value, enables strong mode.

`no-implicit-downcasts: <bool>`
: A value of `false` ensures that the type inference engine never
  implicitly casts to a more specific type. The following valid Dart code
  includes an implicit downcast that would be caught by this flag:

{% prettify dart %}
Object o = ...;
String s = o;  // Implicit downcast
String s2 = s.substring(1);
{% endprettify %}

  This flag defaults to `true`.

`no-implicit-dynamic: <bool>`
: A value of `false` ensures that the type inference engine never chooses
  the `dynamic` type when it can't determine a static type.
  This flag defaults to `true`.

To enable both flags:

{% prettify yaml %}
analyzer:
  strong-mode:
    - no-implicit-downcasts: false
    - no-implicit-dynamic: false
{% endprettify %}

## Enabling linter rules

One of the plugins to the analysis server is a code linter.
A [wide variety](http://dart-lang.github.io/linter/lints/)
of linter rules are available. Linters tend to be
non-denominational&mdash;rules don't have to agree with each other.
For example, some rules are more appropriate for library packages
and other rules are designed for Flutter apps.
Note that some of the linter rules don't play well with strong mode.
Linter rules can have a false positive, unlike a static analyzer.

To enable a linter rule, add `linter:` to the analysis options file,
followed by `rule:`.
On subsequent lines, specify the rules that you want to apply,
prefixed with a dash. For example:

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

In future, related lint rules may be coalesced into meta rules. See
[Issue 99: Meta linter rules](https://github.com/dart-lang/linter/issues/288)
for more information.

## Excluding files

Perhaps you have some code that generates errors but is not
part of your production code.
Or perhaps you rely on code generated from a package that
you don't own&mdash;it runs, but generates errors during static analysis.
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

## TBD: Something about the language options...

xxx: Are the `language:` options used to make 1.0 work more like 2.0?

## Resources

Join the discussion list for linter enthusiasts:

* [linter-discuss (TBD)](xxx) mailing list

Use the following resources to learn more about static analysis in Dart:

* [Strong Mode](https://github.com/dart-lang/dev_compiler/blob/master/STRONG_MODE.md#strong-mode)

* [Dart Linter](https://github.com/dart-lang/linter#linter-for-dart)

* [Linter Rules](http://dart-lang.github.io/linter/lints/)

* [dartanalyzer](https://github.com/dart-lang/sdk/tree/master/pkg/analyzer_cli#dartanalyzer)

* [DDC](https://github.com/dart-lang/dev_compiler#dev_compiler)


{% comment %}
Questions:

- I see these phrases:  type inference engine, linter, dart analysis
  server. Are these used interchangeably?
- What are the "language" options for? I need a section on this.
{% endcomment %}
