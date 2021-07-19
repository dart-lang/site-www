---
title: Customizing static analysis
description: Use an analysis options file and code comments to customize static analysis.
---

<?code-excerpt replace="/ *\/\/\s+ignore_for_file:[^\n]+\n//g; /. • (lib|test)\/\w+\.dart:\d+:\d+//g"?>

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
<?code-excerpt "../null_safety_examples/analysis/lib/lint.dart (empty_statements)" replace="/(if .*?)(;)/$1[!$2!]/g"?>
{% prettify dart class="linenums:8 analyzer"%}
void increment() {
  if (count < 10) [!;!]
  count++;
}
{% endprettify %}

If properly configured, the analyzer points to the semicolon and
produces the following warning:

{:.console-output}
<?code-excerpt "../null_safety_examples/analysis/analyzer-results.txt" retain="empty_statements" replace="/lib\/lint.dart/example.dart/g"?>
```nocode
info - example.dart:9:19 - Avoid empty statements. - empty_statements
```
</blockquote>

The analyzer can also help you find more subtle problems.
For example, perhaps you've forgotten to close a sink method:

<blockquote class="ml-3" markdown="1">
<?code-excerpt "../null_safety_examples/analysis/lib/lint.dart (close_sinks)" replace="/(contr.*?)(;)/[!$1!]$2/g"?>
{% prettify dart class="analyzer"%}
var [!controller = StreamController<String>()!];
{% endprettify %}

{:.console-output}
<?code-excerpt "../null_safety_examples/analysis/analyzer-results.txt" retain="close_sinks" replace="/-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
info - Close instances of `dart.core.Sink`. - close_sinks
```
</blockquote>

In the Dart ecosystem,
the Dart Analysis Server and other tools use the
[analyzer package]({{site.pub-pkg}}/analyzer)
to perform static analysis.

You can customize static analysis to look for a variety of potential
problems, including errors and warnings specified in the
[Dart language spec](/guides/language/spec).
You can also configure the linter, one of the analyzer's plugins,
to ensure that your code complies with the
[Dart Style Guide](/guides/language/effective-dart/style)
and other suggested guidelines in
[Effective Dart][]. Dart tools such as the
[Dart compiler (`dart compile`)](/tools/dart-compile),
[`dart analyze`](/tools/dart-analyze),
[`flutter analyze`]({{site.flutter}}/docs/testing/debugging#the-dart-analyzer),
and [JetBrains IDEs](/tools/jetbrains-plugin)
use the analyzer package to evaluate your code.

This document explains how to customize the behavior of the analyzer
using either an analysis options file or comments in Dart source code. If you want to
add static analysis to your tool, see the
[analyzer package]({{site.pub-pkg}}/analyzer) docs and the
[Analysis Server API Specification.](https://htmlpreview.github.io/?https://github.com/dart-lang/sdk/blob/master/pkg/analysis_server/doc/api.html)

{{site.alert.note}}
  To view various analyzer diagnostics with explanations and common fixes,
  see [Diagnostic messages][diagnostics].
{{site.alert.end}}

## The analysis options file

Place the analysis options file, `analysis_options.yaml`,
at the root of the package, in the same directory as the pubspec file.

{{site.alert.tip}}
  The older name for the analysis options file was `.analysis_options`;
  support for that filename was dropped in Dart 2.8.
  To upgrade an `.analysis_options` file,
  just change its name to `analysis_options.yaml`.
{{site.alert.end}}

Here's a sample analysis options file:

<?code-excerpt "../null_safety_examples/analysis_options.yaml" from="include" remove="implicit-dynamic" retain="/^$|\w+:|- cancel/" remove="http:"?>
```yaml
include: package:lints/recommended.yaml

analyzer:
  exclude: [build/**]
  language:
    strict-raw-types: true
  strong-mode:
    implicit-casts: false

linter:
  rules:
    - cancel_subscriptions
```

The sample illustrates the most common top-level entries:

- Use <code>include: <em>url</em></code> to
  bring in options from the specified URL — in this case,
  from a file in the `lints` package.
- Use the `analyzer:` entry to customize static analysis —
  [enabling stricter type checks](#enabling-additional-type-checks),
  [excluding files](#excluding-files),
  [ignoring specific rules](#ignoring-rules),
  [changing the severity of rules](#changing-the-severity-of-rules), or
  [enabling experiments](/tools/experiment-flags#using-experiment-flags-with-the-dart-analyzer-command-line-and-ide).
- Use the `linter:` entry to configure [linter rules](#enabling-linter-rules).

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
the [Dart type system][type-system] requires,
consider using the `implicit-casts` and `implicit-dynamic` flags:

<?code-excerpt "../null_safety_examples/analysis/analysis_options.yaml" from="analyzer" to="implicit-dynamic" remove="exclude"?>
```yaml
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
```

You can use the flags together or separately; both default to `true`.

`implicit-casts: <bool>`
: A value of `false` ensures that the type inference engine never
  implicitly casts from `dynamic` to a more specific type.
  The following valid Dart code
  includes an implicit downcast that would be caught by this flag:

{:.fails-sa}
<?code-excerpt "../null_safety_examples/analysis/lib/assignment.dart (implicit-downcast)" replace="/(s = )(o)/$1[!$2!]/g"?>
{% prettify dart class="analyzer" %}
dynamic o = ...
String s = [!o!]; // Implicit downcast
String s2 = s.substring(1);
{% endprettify %}

{:.console-output}
<?code-excerpt "../null_safety_examples/analysis/analyzer-results.txt" retain="/'dynamic' can't be assigned to a variable of type 'String'/"  replace="/. Try.*'String'. / /g; /-(.*?):(.*?):(.*?)-/-/g"?>
```nocode
error - A value of type 'dynamic' can't be assigned to a variable of type 'String' - invalid_assignment
```

{{site.alert.version-note}}
  In packages that use a [language version][] before 2.12
  (when support for [null safety](/null-safety) was introduced),
  code can implicitly downcast from non-`dynamic` types such as `Object`.
  The `implicit-casts` flag can catch those non-`dynamic` downcasts,
  even if you're using a more recent Dart SDK.
{{site.alert.end}}

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

### Enabling Dart team recommended linter rules {#lints}

The Dart team provides two sets of recommended linter rules
in the [lints package][]:

Core rules
: Help identify critical issues that are likely to lead to problems
  when running or consuming Dart code.
  All code should pass these linter rules.
  Packages that are uploaded to [pub.dev]({{site.pub}})
  have a [package score]({{site.pub}}/help/scoring)
  that's based in part on passing these rules.

Recommended rules
: Help identify additional issues
  that may lead to problems when running or consuming Dart code,
  and enforce a single, idiomatic style and format.
  We recommend that all Dart code use these rules,
  which are a superset of the core rules.

{{site.alert.tip}}
  If you're working on Flutter code, then instead of using the `lints` package, 
  use [`flutter_lints`]({{site.pub-pkg}}/flutter_lints),
  which provides a superset of the recommended rules.
{{site.alert.end}}

To enable either set of lints,
add the [lints package][] as a dev dependency:

```terminal
$ dart pub add --dev lints
```

Then edit your `analysis_options.yaml` file to include
your preferred rule set:

```yaml
include: package:lints/<RULE_SET>.yaml
```

For example, you can include the recommended rule set like this:

```yaml
include: package:lints/recommended.yaml
```

{{site.alert.important}}
When a **new version of `lints`** is published,
code that previously passed analysis might **start failing analysis.**
We recommend updating your code to work with the new rules.
Other options are to explicitly enable individual linter rules 
or [disable individual rules][].
{{site.alert.end}}

[lints package]: {{site.pub-pkg}}/lints

### Enabling individual rules {#individual-rules}

To enable a single linter rule, add `linter:` to the analysis options file
as a top-level key,
followed by `rules:` as a second-level key.
On subsequent lines, specify the rules that you want to apply,
prefixed with dashes (the syntax for a YAML list).
For example:

<?code-excerpt "../null_safety_examples/analysis_options.yaml" from="linter:" take="12" remove="http:"?>
```yaml
linter:
  rules:
    - always_declare_return_types
    - cancel_subscriptions
    - close_sinks
    - comment_references
    - one_member_abstracts
    - only_throw_errors
    - package_api_docs
    - prefer_single_quotes
    - sort_child_properties_last
```


### Disabling individual rules

If you include an analysis options file such as the one in `lints`,
you might want to disable some of the included rules.
Disabling individual rules is similar to enabling them,
but requires the use of a map rather than a list
as the value for the `rules:` entry,
so each line should contain the name of a rule followed by
either `: false` or `: true`.

Here's an example of an analysis options file
that uses all the recommended rules from `lints`
except `avoid_shadowing_type_parameters`.
It also enables the lint `await_only_futures`:

<?code-excerpt "../null_safety_examples/analysis_alt/analysis_options_linter.yaml"?>
```yaml
include: package:lints/recommended.yaml

linter:
  rules:
    avoid_shadowing_type_parameters: false
    await_only_futures: true
```

{{site.alert.note}}
  Due to YAML restrictions, 
  **you can't mix list and key-value syntax in the same `rules` entry.**
  You can, however, use the other syntax for rules in an included file.
{{site.alert.end}}

## Excluding code from analysis

Sometimes it's OK for some code to fail analysis.
For example, you might rely on code generated by a package that
you don't own&mdash;the generated code works,
but produces warnings during static analysis.
Or a linter rule might cause a false positive
that you want to suppress.

You have a few ways to exclude code from analysis:

* Exclude entire files from analysis.
* Stop specific non-error rules from being applied to individual files.
* Stop specific non-error rules from being applied to individual lines of code.

You can also [disable specific rules][disable individual rules]
for all files or
[change the severity of rules][].

{{site.alert.version-note}}
  As of Dart 2.8, you can't stop error rules from being applied to
  individual files or lines of code.
{{site.alert.end}}


### Excluding files

To exclude files from static analysis, use the `exclude:` analyzer option. You
can list individual files, or use [glob]({{site.pub-pkg}}/glob) syntax:

<?code-excerpt "../null_safety_examples/analysis_alt/analysis_options.yaml (exclude)" plaster="none"?>
```yaml
analyzer:
  exclude:
    - lib/client.dart
    - lib/server/*.g.dart
    - test/_data/**
```


### Suppressing rules for a file

To ignore a specific non-error rule for a specific file,
add an `ignore_for_file` comment to the file:

<?code-excerpt "../null_safety_examples/analysis/lib/assignment.dart (ignore_for_file)" replace="/, \w+//g"?>
```dart
// ignore_for_file: unused_local_variable
```

This acts for the whole file, before or after the comment, and is
particularly useful for generated code.

To suppress more than one rule, use a comma-separated list:

<?code-excerpt "../null_safety_examples/analysis/lib/assignment.dart (ignore_for_file)"?>
```dart
// ignore_for_file: unused_local_variable, duplicate_ignore, dead_code
```


### Suppressing rules for a line of code

To suppress a specific non-error rule on a specific line of code,
put an `ignore` comment
above the line of code. Here's an example of ignoring code that causes a runtime
error, as you might do in a language test:

<?code-excerpt "../null_safety_examples/analysis/lib/assignment.dart (invalid_assignment)"?>
```dart
// ignore: invalid_assignment
int x = '';
```

To suppress more than one rule, supply a comma-separated list:

<?code-excerpt "../null_safety_examples/analysis/lib/assignment.dart (ignore more)"?>
```dart
// ignore: invalid_assignment, const_initialized_with_non_constant_value
const x = y;
```

Alternatively, append the ignore rule to the line that it applies to:

<?code-excerpt "../null_safety_examples/analysis/lib/assignment.dart (single-line)"?>
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
  Example: [`dead_code`][dead_code]

`warning`
: A warning that doesn't cause analysis to fail unless
  the analyzer is configured to treat warnings as errors.
  Example: [`invalid_null_aware_operator`][invalid_null_aware_operator]

`error`
: An error that causes analysis to fail.
  Example: [`invalid_assignment`][invalid_assignment]


### Ignoring rules

You can ignore specific [analyzer error codes][] and [linter rules][]
by using the `errors:` field.
List the rule, followed by <code>:&nbsp;ignore</code>. For example, the following
analysis options file instructs the analysis tools to ignore the TODO rule:

<?code-excerpt "../null_safety_examples/analysis_alt/analysis_options.yaml (errors)" to="ignore"?>
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

<?code-excerpt "../null_safety_examples/analysis_alt/analysis_options.yaml (errors)" remove="ignore"?>
```yaml
analyzer:
  errors:
    invalid_assignment: warning
    missing_return: error
    dead_code: info
```


## Resources

Use the following resources to learn more about static analysis in Dart:

* [Dart's type system][type-system]
* [Dart linter](https://github.com/dart-lang/linter#linter-for-dart)
* [Dart linter rules][linter rules]
* [analyzer package]({{site.pub-pkg}}/analyzer)

[invalid_null_aware_operator]: /tools/diagnostic-messages#invalid_null_aware_operator
[analyzer error codes]: https://github.com/dart-lang/sdk/blob/master/pkg/analyzer/lib/error/error.dart
[change the severity of rules]: #changing-the-severity-of-rules
[diagnostics]: /tools/diagnostic-messages
[invalid_assignment]: /tools/diagnostic-messages#invalid_assignment
[language version]: /guides/language/evolution#language-versioning
[linter rules]: https://dart-lang.github.io/linter/lints/
[type-system]: /guides/language/type-system
[dead_code]: /tools/diagnostic-messages#dead_code
[disable individual rules]: #disabling-individual-rules
[Effective Dart]: /guides/language/effective-dart
