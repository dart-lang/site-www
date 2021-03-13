---
title: Linter rules
description: Details about the Dart Linter and the lint rules it provides.
---

The Dart linter uses the analyzer to identify and report
on "lints" found within Dart code. This page outlines
all currently existing rules, their use cases, and possible fixes.

For more information about using the linter and configure default
sets of rules, see [Enabling and disabling linter rules][].

## Error rules

These rules identify possible errors and other problems in your code.

{% for lint in site.data.linter_rules %}

{% if lint.group == "error" %}

### {{ lint.name }}

{{ lint.description }}

_This rule is currently **{{ lint.maturity }}**._

#### Details

{{ lint.details }}

{% endif %}

{% endfor %}

## Style rules

These rules identify opportunities for style improvements, 
largely derived from the 
official [Dart style guide](/guides/language/effective-dart/style).

{% for lint in site.data.linter_rules %}

{% if lint.group == "style" %}

### {{ lint.name }}

{{ lint.description }}

_This rule is currently **{{ lint.maturity }}**._

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

_This rule is currently **{{ lint.maturity }}**._

#### Details

{{ lint.details }}

{% endif %}

{% endfor %}

[Enabling and disabling linter rules]: (/guides/language/analysis-options#enabling-linter-rules)
