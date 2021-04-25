---
title: Linter rules
description: Details about the Dart Linter and the lint rules it provides.
---

The Dart Linter uses the analyzer to identify and report
on "lints" found within Dart code. Linting is performed
by the Dart analysis server through your IDE
or with the `dart analyze` command.

This page outlines all currently existing rules, 
their use cases, as well as possible fixes.

The rules are organized into familiar rule groups:

* [Errors](#error-rules)
  - Possible errors or mistakes in your code.
* [Style](#style-rules)
  - Matters of style, largely derived from the [Dart style guide][].
* [Pub](#pub-rules)
  - Possible issues with [Pub](/guides/packages) setup.

Rules are also assigned a maturity level. Rules without one specified
are considered stable, while other maturity levels are marked with the rule.

* Stable
  - These rules are safe to use and are verified as functional
  with the latest versions of the Dart language.
* Experimental
  - The rules are still under evaluation and may never be stabilized.
  Use these with caution and report any issues you come across.
* Deprecated
  - These rules are no longer suggested for use
  and are subject for removal in future Linter releases.

For more information about using the linter and configure default
sets of rules, see [Enabling and disabling linter rules][].

## Error rules

These rules identify possible errors and other mistakes in your code.

{% for lint in site.data.linter_rules %}

{% if lint.group == "errors" %}

### {{ lint.name }}

{{ lint.description }}

{% if lint.maturity != "stable" %}
_This rule is currently **{{ lint.maturity }}**._
{% endif %}

#### Details

{{ lint.details }}

{% endif %}

{% endfor %}

## Style rules

These rules identify opportunities for style improvements, 
largely derived from the official [Dart style guide][].

{% for lint in site.data.linter_rules %}

{% if lint.group == "style" %}

### {{ lint.name }}

{{ lint.description }}

{% if lint.maturity != "stable" %}
_This rule is currently **{{ lint.maturity }}**._
{% endif %}

#### Details

{{ lint.details }}

{% endif %}

{% endfor %}

## Pub rules

These rules identify possible issues around 
[pub](/guides/packages) package setup and declarations.

{% for lint in site.data.linter_rules %}

{% if lint.group == "pub" %}

### {{ lint.name }}

{{ lint.description }}

{% if lint.maturity != "stable" %}
_This rule is currently **{{ lint.maturity }}**._
{% endif %}

#### Details

{{ lint.details }}

{% endif %}

{% endfor %}

[Enabling and disabling linter rules]: /guides/language/analysis-options#enabling-linter-rules
[Dart style guide]: /guides/language/effective-dart/style
