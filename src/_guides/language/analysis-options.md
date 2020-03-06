---
title: Customizing static analysis
description: Use an analysis options file and code comments to customize static analysis.
---

<style>
li.L0, li.L1, li.L2, li.L3,
li.L5, li.L6, li.L7, li.L8, li.L9 {
  background: none;
  list-style-type: decimal;
}
pre.prettyprint.analyzer .highlight {
    border-bottom: 2px red dashed;
    background: inherit;
    padding-bottom: 1px;
}
</style>

Static analysis allows you to find problems before
executing a single line of code. It's a powerful tool
used to prevent bugs and ensure that code conforms to style
guidelines.

With the help of the analyzer, you can find
simple typos. For example, perhaps an accidental semicolon
made its way into an `if` statement:

<blockquote class="ml-3" markdown="1">
<?code-excerpt "analysis/lib/lint.dart (empty_statements)" replace="/(if .*?)(;)/$1[!$2!]/g"?>
{% prettify dart class="linenums:10 analyzer"%}
void increment() {
  if (count < 10) [!;!]
  count++;
}
{% endprettify %}

{:.console-output}
<?code-excerpt "analysis/analyzer-results.txt" retain="empty_statements" replace="/.( • )(lib|test)\/\w+\.dart:\d+:\d+/$1example.dart:11/g"?>
```nocode
lint • Avoid empty statements • example.dart:11 • empty_statements
```
</blockquote>

The analyzer can also help you find more subtle problems.
For example, perhaps you've forgotten to close a sink method:

<blockquote class="ml-3" markdown="1">
<?code-excerpt "analysis/lib/lint.dart (close_sinks)" replace="/(_c.*?)(;)/[!$1!]$2/g"?>
{% prettify dart class="linenums:11 analyzer"%}
var [!_controller = StreamController<String>()!];
{% endprettify %}

{:.console-output}
<?code-excerpt "analysis/analyzer-results.txt" retain="close_sinks" replace="/.( • )(lib|test)\/\w+\.dart:\d+:\d+/$1example.dart:11/g"?>
```nocode
lint • Close instances of `dart.core.Sink` • example.dart:11 • close_sinks
```
</blockquote>

In the Dart ecosystem,
the Dart Analysis Server and other tools use the
[analyzer package]({{site.pub}}/packages/analyzer)
to perform static analysis.

You can customize static analysis to look for a variety of potential
problems, including errors and warnings specified in the
[Dart language spec](/guides/language/spec).
You can also configure the linter, one of the analyzer's plugins,
to ensure that your code complies with the
[Dart Style Guide](/guides/language/effective-dart/style)
and other suggested guidelines in
[Effective Dart][]. Dart tools such as the
[Dart dev compiler (dartdevc),](/tools/dartdevc)
[`dartanalyzer`,](/tools/dartanalyzer)
[`flutter analyze`,]({{site.flutter}}/docs/testing/debugging#the-dart-analyzer)
and [JetBrains IDEs](/tools/jetbrains-plugin)
use the analyzer package to evaluate your code.

This document explains how to customize the behavior of the analyzer
using either an analysis options file or comments in Dart source code. If you want to
add static analysis to your tool, see the
[analyzer package]({{site.pub}}/packages/analyzer) docs and the
[Analysis Server API Specification.](https://htmlpreview.github.io/?https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/doc/api.html)

{{site.alert.note}}
  The analyzer error codes are listed in the [Dart SDK
  repo.][analyzer error codes]
{{site.alert.end}}

## The analysis options file

Place the analysis options file, `analysis_options.yaml`,
at the root of the package, in the same directory as the pubspec file.

{{site.alert.warn}}
  **Breaking change:** The conventional name for the analysis options file
  used to be `.analysis_options` (note the leading dot and missing `.yaml` suffix).
  We expect support for the `.analysis_options` name to go away in a future
  release, so we recommend that you **rename your `.analysis_options` files to
  `analysis_options.yaml`.**
  {% comment %}
  Tracking issue: https://github.com/dart-lang/sdk/issues/28385
  {% endcomment %}
{{site.alert.end}}

Here's a sample analysis options file:

<?code-excerpt "analysis_options.yaml" from="include" remove="implicit-dynamic" retain="/^$|\w+:|- camel/" remove="http:"?>
```yaml
include: package:pedantic/analysis_options.1.8.0.yaml

analyzer:
  exclude: [build/**]
  strong-mode:
    implicit-casts: false

linter:
  rules:
    - camel_case_types
```

The sample illustrates the most common top-level entries:

- Use <code>include: <em>url</em></code> to
  bring in options from the specified URL — in this case,
  from a file in the `pedantic` package.
- Use the `analyzer:` entry to customize static analysis —
  [enabling stricter type checks](#enabling-additional-type-checks),
  [excluding files](#excluding-files),
  [ignoring specific rules](#ignoring-rules), or
  [changing the severity of rules](#changing-the-severity-of-rules).
- Use the `linter:` entry to configure [linter rules](#enabling-linter-rules).

Another tag you might see is `language:`,
which is used for experimental language features.

{{site.alert.warn}}
  **YAML is sensitive to whitespace.** Don't use tabs in a YAML file,
  and use 2 spaces to denote each level of indentation.
{{site.alert.end}}

If the analyzer can't find an analysis options file at the package root,
it walks up the directory tree, looking for one.
If no file is available, the analyzer defaults to standard checks.

Consider the following directory structure for a large project:

{% asset guides/analysis-options-directory-structure.png alt="project root contains analysis_options.yaml (#1) and 3 packages, one of which (my_package) contains an analysis_options.yaml file (#2)." %}

The analyzer uses file #1 to analyze the code in `my_other_package`
and `my_other_other_package`, and file #2 to analyze the code in
`my_package`.


## Enabling stricter type checks {#enabling-additional-type-checks}

If you want stricter static checks than
the [Dart type system][sound-dart] requires,
consider using the `implicit-casts` and `implicit-dynamic` flags:

<?code-excerpt "analysis/analysis_options.yaml" from="analyzer" to="implicit-dynamic" remove="exclude"?>
```yaml
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
```

You can use the flags together or separately; both default to `true`.

`implicit-casts: <bool>`
: A value of `false` ensures that the type inference engine never
  implicitly casts to a more specific type.
  The following valid Dart code
  includes an implicit downcast that would be caught by this flag:

{:.fails-sa}
<?code-excerpt "analysis/lib/assignment.dart (implicit-downcast)" replace="/(s = )(o)/$1[!$2!]/g"?>
{% prettify dart class="analyzer" %}
Object o = ...
String s = [!o!]; // Implicit downcast
String s2 = s.substring(1);
{% endprettify %}

{:.console-output}
<?code-excerpt "analysis/analyzer-results.txt" retain="lib/assignment.dart" replace="/. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>
```nocode
error • A value of type 'Object' can't be assigned to a variable of type 'String' • invalid_assignment
```

`implicit-dynamic: <bool>`
: A value of `false` ensures that the type inference engine never chooses
  the `dynamic` type when it can't determine a static type.

{% comment %}
TODO: Clarify that description, and insert an example here.
{% endcomment %}


## Enabling and disabling linter rules {#enabling-linter-rules}

The analyzer package also provides a code linter. A wide variety of
[linter rules][] are available. Linters tend to be
nondenominational&mdash;rules don't have to agree with each other.
For example, some rules are more appropriate for library packages
and others are designed for Flutter apps.
Note that linter rules can have false positives, unlike static analysis.

### Enabling default Google rules: pedantic {#default-google-rules-pedantic}

To enable the list of linter rules that Google uses in its own Dart code,
depend on the [pedantic package]({{site.pub-pkg}}/pedantic)
and include its `analysis_options.yaml` file.
Unless you need to use the `pedantic` API, declare a dev dependency on `pedantic`
in your `pubspec.yaml` file:

<?code-excerpt "analysis/pubspec.yaml" retain="/dev_dep|pedantic/"?>
```yaml
dev_dependencies:
  pedantic: ^1.0.0
```

Run `pub get`, and then
add the following line to your `analysis_options.yaml` file:

<?code-excerpt "analysis/analysis_options.yaml" from="include" retain="include:" replace="/1\.8\.0\.//g"?>
```yaml
include: package:pedantic/analysis_options.yaml
```

{{site.alert.important}}
  When a **new version of `pedantic`** is published,
  code that previously passed analysis might **start failing analysis.**
  We recommend updating your code to work with the new rules.
  Other options are to
  include a specific version of the pedantic analysis options file
  (as described [in the pedantic package page][]),
  explicitly enable individual linter rules,
  or [disable individual rules][].
{{site.alert.end}}

### Enabling Effective Dart rules: effective_dart {#effective-dart-rules}

To enable linter rules corresponding to the guidelines in [Effective Dart][],
add a dev dependency on the [effective_dart package:][effective_dart]

<?code-excerpt "analysis_effective_dart/pubspec.yaml" retain="/dev_dep|effective_dart/"?>
```yaml
dev_dependencies:
  effective_dart: ^1.0.0
```

Run `pub get`, and then
add the following line to your `analysis_options.yaml` file:

<?code-excerpt "analysis_effective_dart/analysis_options.yaml" from="include" retain="include:"?>
```yaml
include: package:effective_dart/analysis_options.yaml
```

{{site.alert.important}}
  When a **new version of `effective_dart`** is published,
  code that previously passed analysis might **start failing analysis.**
  We recommend updating your code to work with the new rules.
  Other options are to
  include a specific version of the effective_dart analysis options file
  (as described [in the effective_dart package page][]),
  explicitly enable individual linter rules,
  or [disable individual rules][].
{{site.alert.end}}

### Enabling individual rules {#individual-rules}

To enable a single linter rule, add `linter:` to the analysis options file,
followed by `rules:`.
On subsequent lines, specify the rules that you want to apply,
prefixed with dashes. For example:

<?code-excerpt "analysis/analysis_options.yaml" from="linter:" take="12" remove="http:"?>
```yaml
linter:
  rules:
    - annotate_overrides
    - await_only_futures
    - camel_case_types
    - cancel_subscriptions
    - close_sinks
    - comment_references
    - constant_identifier_names
    - control_flow_in_finally
    - empty_statements
```

{% comment %}
Brian expressed concern about including this:
In future, related lint rules may be coalesced into meta rules. See
[Issue 99: Meta linter rules](https://github.com/dart-lang/linter/issues/288)
for more information.
{% endcomment %}


### Disabling individual rules

If you include an analysis options file such as the one in `pedantic`,
you might want to disable some of the included rules.
Disabling individual rules is similar to enabling them,
but with two differences:

* Omit the dash (`-`) before the rule name.
* Add `: false` _after_ the rule name.

Here's an example of an analysis options file
that uses all pedantic rules except `avoid_shadowing_type_parameters`.
It also enables the lint `await_only_futures`:

<?code-excerpt "analysis_alt/analysis_options_linter.yaml"?>
```yaml
include: package:pedantic/analysis_options.yaml

linter:
  rules:
    avoid_shadowing_type_parameters: false
    await_only_futures: true
```

{{site.alert.note}}
  Due to YAML restrictions, **you can't mix list and key-value syntax in the same `rules` entry.**
  You can, however, use the other syntax for rules in an included file.
{{site.alert.end}}

## Excluding code from analysis

Sometimes it's OK for some code to fail analysis.
For example, you might rely on code generated by a package that
you don't own&mdash;the generated code works,
but produces errors during static analysis.
Or a linter rule might cause a false positive
that you want to suppress.

You have several ways to exclude code from analysis:

* Exclude entire files from analysis.
* Stop specific rules from being applied to individual files.
* Stop specific rules from being applied to individual lines of code.
* Ignore specific rules or errors.

You can also [change the severity of rules][].

### Excluding files

To exclude files from static analysis, use the `exclude:` analyzer option. You
can list individual files, or use [glob]({{site.pub}}/packages/glob) syntax:

<?code-excerpt "analysis_alt/analysis_options.yaml (exclude)" plaster="none"?>
```yaml
analyzer:
  exclude:
    - lib/client.dart
    - lib/server/*.g.dart
    - test/_data/**
```


### Suppressing rules for a file

To ignore a specific rule for a specific file,
add an `ignore_for_file` comment to the file:

<?code-excerpt "analysis/lib/assignment.dart (ignore_for_file)" replace="/, \w+//g"?>
```dart
// ignore_for_file: unused_import
```

This acts for the whole file, before or after the comment, and is
particularly useful for generated code.

To suppress more than one rule, use a comma-separated list:

<?code-excerpt "analysis/lib/assignment.dart (ignore_for_file)"?>
```dart
// ignore_for_file: unused_import, unused_local_variable, omit_local_variable_types
```


### Suppressing rules for a line of code

To suppress a specific rule on a specific line of code, put an `ignore` comment
above the line of code. Here's an example of ignoring code that causes a runtime
error, as you might do in a language test:

<?code-excerpt "analysis/lib/assignment.dart (invalid_assignment)"?>
```dart
// ignore: invalid_assignment
int x = '';
```

To suppress more than one rule, supply a comma-separated list:

<?code-excerpt "analysis/lib/assignment.dart (ignore more)"?>
```dart
// ignore: invalid_assignment, const_initialized_with_non_constant_value
const x = y;
```

Alternatively, append the ignore rule to the line that it applies to:

<?code-excerpt "analysis/lib/assignment.dart (single-line)"?>
```dart
int x = ''; // ignore: invalid_assignment
```

## Customizing analysis rules

Each [analyzer error code][analyzer error codes] and
[linter rule][linter rules] has a default severity.
You can use the analysis options file to change
the severity of individual rules, or to always ignore some rules.

The analyzer supports three severity levels:

`info`
: An informational message that doesn't cause analysis to fail.
  Example: [`todo`][todo]

`warning`
: A warning that doesn't cause analysis to fail unless
  the analyzer is configured to treat warnings as errors.
  Example: [`analysis_option_deprecated`][analysis_option_deprecated]

`error`
: An error that causes analysis to fail.
  Example: [`invalid_assignment`][invalid_assignment]


### Ignoring rules

You can ignore specific [analyzer error codes][] and [linter rules][]
by using the `errors:` field.
List the rule, followed by <code>:&nbsp;ignore</code>. For example, the following
analysis options file instructs the analysis tools to ignore the TODO rule:

<?code-excerpt "analysis_alt/analysis_options.yaml (errors)" to="ignore"?>
```yaml
analyzer:
  errors:
    todo: ignore
```


### Changing the severity of rules

You can globally change the severity of a particular rule.
This technique works for regular analysis issues as well as for lints.
For example, the following analysis options file instructs the analysis tools to
treat invalid assignments as warnings and missing returns as errors,
and to provide information (but not a warning or error) about dead code:

<?code-excerpt "analysis_alt/analysis_options.yaml (errors)" remove="ignore"?>
```yaml
analyzer:
  errors:
    invalid_assignment: warning
    missing_return: error
    dead_code: info
```


## Resources

Use the following resources to learn more about static analysis in Dart:

* [Dart's type system][sound-dart]
* [Dart linter](https://github.com/dart-lang/linter#linter-for-dart)
* [Dart linter rules][linter rules]
* [dartanalyzer](/tools/dartanalyzer)
* [dartdevc](/tools/dartdevc)
* [analyzer package]({{site.pub}}/packages/analyzer)

[analysis_option_deprecated]: {{site.pub-api}}/analyzer/latest/analyzer/AnalysisOptionsWarningCode/ANALYSIS_OPTION_DEPRECATED-constant.html
[analyzer error codes]: https://github.com/dart-lang/sdk/blob/master/pkg/analyzer/lib/error/error.dart
[change the severity of rules]: #changing-the-severity-of-rules
[invalid_assignment]: {{site.pub-api}}/analyzer/latest/analyzer/StaticTypeWarningCode/INVALID_ASSIGNMENT-constant.html
[linter rules]: https://dart-lang.github.io/linter/lints/
[sound-dart]: /guides/language/sound-dart
[todo]: {{site.pub-api}}/analyzer/latest/analyzer/TodoCode/TODO-constant.html
[in the pedantic package page]: {{site.pub-pkg}}/pedantic#using-the-lints
[disable individual rules]: #disabling-individual-rules
[in the effective_dart package page]: {{site.pub-pkg}}/effective_dart#using-the-lints
[effective_dart]: {{site.pub-pkg}}/effective_dart
[Effective Dart]: /guides/language/effective-dart
