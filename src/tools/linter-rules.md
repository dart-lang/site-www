---
title: Linter rules
description: Details about the Dart linter and its style rules you can choose.
---

Use the Dart linter to identify possible problems in your Dart code.
You can use the linter through your IDE
or with the [`dart analyze`](/tools/dart-analyze) command.
For information on how to enable and disable individual linter rules, see
[individual rules sections][] of the [analyzer documentation][].

[individual rules sections]: /guides/language/analysis-options#individual-rules
[analyzer documentation]: /guides/language/analysis-options

This page lists all the linter rules,
with details such as when you might want to use each rule,
what code patterns trigger it, and
how you might fix your code.

{{site.alert.tip}}
Linter rules (sometimes called _lints_) can have false positives,
and they don’t all agree with each other.
For example, some rules are more appropriate for library packages,
and others are designed for Flutter apps.
{{site.alert.end}}

## Predefined rule sets

To avoid the need to individually select compatible linter rules,
consider starting with a linter rule set,
which the following packages provide:

[lints][]
: The rule sets that the Dart team encourages using.
  If you're writing Flutter code,
  use the `flutter_lints` rule set,
  which builds on `lints`.
  Dart and Flutter packages uploaded to [pub.dev]({{site.pub}}) 
  are [scored]({{site.pub}}/help/scoring) 
  with the `core` set of these rules.

[flutter_lints][]
: The set of rules that the Flutter team encourages you to use
  in Flutter apps, packages, and plugins.
  This rule set is a superset of the `recommended`
  set from the [lints package]({{site.pub-pkg}}/lints),
  which is itself a superset of the `core` set that
  partially determines the [score]({{site.pub}}/help/scoring) of
  packages uploaded to [pub.dev]({{site.pub}}).

[effective_dart][] (_deprecated_)
: The deprecated set of rules previously used to
  conform to the guidelines in [Effective Dart][].
  Consider migrating to one of the rule sets in
  the [lints][] or [flutter_lints][] packages.

[pedantic][] (_deprecated_)
: The deprecated set of rules previously used to match
  the rules used for all Google-internal Dart code.
  Consider migrating to one of the rule sets in
  the [lints][] or [flutter_lints][] packages.
  See [Migrating from pedantic][] for more information on switching.
   
[Migrating from pedantic]: https://github.com/dart-lang/lints#migrating-from-packagepedantic
[lints]: {{site.pub-pkg}}/lints
[flutter_lints]: {{site.pub-pkg}}/flutter_lints
[effective_dart]: {{site.pub-pkg}}/effective_dart
[pedantic]: {{site.pub-pkg}}/pedantic

To learn how to use a specific rule set,
see the documentation for [enabling and disabling linter rules][].

[enabling and disabling linter rules]: /guides/language/analysis-options#enabling-linter-rules
[Effective Dart]: /guides/language/effective-dart

## Rule types

Each rule is in one of the following groups:

[Errors](#error-rules)
: Possible errors or mistakes in your code.

[Style](#style-rules)
: Matters of style, largely derived from the [Dart style guide][].

[Pub](#pub-rules)
: Possible issues with [pub package setup](/guides/packages).

## Maturity levels

Each rule also has a maturity level:

Stable
: These rules are safe to use and are verified as functional
  with the latest versions of the Dart language.
  All rules are considered stable
  unless they're marked as experimental or deprecated.

Experimental
: These rules are still under evaluation and might never be stabilized.
  Use these with caution and report any issues you come across.

Deprecated
: These rules are no longer suggested for use
  and might be removed in a future linter release.

## Error rules

These rules identify possible errors and other mistakes in your code.

{% for lint in site.data.linter_rules %}

{% if lint.group == "errors" %}

{% include linter-rule.md lint=lint %}

{% endif %}

{% endfor %}

## Style rules

These rules identify opportunities for style improvements, 
largely derived from the [Dart style guide][].

{% for lint in site.data.linter_rules %}

{% if lint.group == "style" %}

{% include linter-rule.md lint=lint %}

{% endif %}

{% endfor %}

## Pub rules

These rules identify possible issues around 
[pub package](/guides/packages) setup.

{% for lint in site.data.linter_rules %}

{% if lint.group == "pub" %}

{% include linter-rule.md lint=lint %}

{% endif %}

{% endfor %}

[Enabling and disabling linter rules]: /guides/language/analysis-options#enabling-linter-rules
[Dart style guide]: /guides/language/effective-dart/style
