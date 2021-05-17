---
title: Linter rules
description: Details about the Dart linter and its style rules you can choose.
---

Use the Dart linter to identify possible problems in your Dart code.
You can use the linter through your IDE
or with the [`dart analyze`](/tools/dart-analyze) command.
For information on how to enable and disable linter rules, see the
[linter section](/guides/language/analysis-options#enabling-linter-rules)
of the [analyzer documentation][].

[analyzer documentation]: /guides/language/analysis-options

{{site.alert.tip}}
  Linter rules (sometimes called _lints_) can have false positives,
  and they don’t all agree with each other.
  For example, some rules are more appropriate for library packages,
  and others are designed for Flutter apps.
  **Consider starting with pre-packaged linter rules**,
  such as those in the [`effective_dart` package][].
{{site.alert.end}}

[`effective_dart` package]: {{site.pub-pkg}}/effective_dart

This page lists all the linter rules,
with details such as when you might want to use each rule,
what code patterns trigger it, and
how you might fix your code.

Each rule is in one of the following groups:

[Errors](#error-rules)
: Possible errors or mistakes in your code.

[Style](#style-rules)
: Matters of style, largely derived from the [Dart style guide][].

[Pub](#pub-rules)
: Possible issues with [pub package setup](/guides/packages).

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

### {{lint.name}}

{{lint.description}}

{% if lint.maturity != "stable" %}
_This rule is currently **{{lint.maturity}}**._
{% endif %}

#### Details

{{lint.details}}

{% endif %}

{% endfor %}

## Style rules

These rules identify opportunities for style improvements, 
largely derived from the [Dart style guide][].

{% for lint in site.data.linter_rules %}

{% if lint.group == "style" %}

### {{lint.name}}

{{lint.description}}

{% if lint.maturity != "stable" %}
_This rule is currently **{{lint.maturity}}**._
{% endif %}

#### Details

{{lint.details}}

{% endif %}

{% endfor %}

## Pub rules

These rules identify possible issues around 
[pub package](/guides/packages) setup.

{% for lint in site.data.linter_rules %}

{% if lint.group == "pub" %}

### {{lint.name}}

{{lint.description}}

{% if lint.maturity != "stable" %}
_This rule is currently **{{lint.maturity}}**._
{% endif %}

#### Details

{{lint.details}}

{% endif %}

{% endfor %}

[Enabling and disabling linter rules]: /guides/language/analysis-options#enabling-linter-rules
[Dart style guide]: /guides/language/effective-dart/style
