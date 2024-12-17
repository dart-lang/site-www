---
title: Linter rules
description: Details about the Dart linter and its style rules you can choose.
show_breadcrumbs: true
body_class: linter-rules
# js: [{url: '/assets/js/linter-rules.js', defer: true}]
---

Use the Dart linter to identify possible problems in your Dart code.
You can use the linter through your IDE
or with the [`dart analyze`](/tools/dart-analyze) command.
For information on how to enable and disable individual linter rules, see
[individual rules sections][] of the [analyzer documentation][].

[individual rules sections]: /tools/analysis#individual-rules
[analyzer documentation]: /tools/analysis

This page lists all the linter rules,
with details such as when you might want to use each rule,
what code patterns trigger it, and
how you might fix your code.

:::tip
Linter rules (sometimes called _lints_) can have false positives,
and they don't all agree with each other.
For example, some rules are more appropriate for regular Dart packages,
and others are designed for Flutter apps.
:::

<a id="predefined-rule-sets"></a>
## Sets

To avoid the need to individually select compatible linter rules,
consider starting with a linter rule set,
which the following packages provide:

<a id="lints"></a>

[lints][]
: Contains two rule sets curated by the Dart team. 
  We recommend using at least the `core` rule set, 
  which is used when [scoring]({{site.pub}}/help/scoring) 
  packages uploaded to [pub.dev]({{site.pub}}). 
  Or, better yet, use the `recommended` rule set, 
  a superset of `core` that identifies additional issues
  and enforces style and format. 
  If you're writing Flutter code, 
  use the rule set in the [`flutter_lints`](#flutter_lints) package,
  which builds on `lints`.

<a id="flutter_lints"></a>

[flutter_lints][]
: Contains the `flutter` rule set,
  which the Flutter team encourages you to use
  in Flutter apps, packages, and plugins.
  This rule set is a superset of the [`recommended`](#lints) set,
  which is itself a superset of the [`core`](#lints) set that
  partially determines the [score]({{site.pub}}/help/scoring) of
  packages uploaded to [pub.dev]({{site.pub}}).

[lints]: {{site.pub-pkg}}/lints
[flutter_lints]: {{site.pub-pkg}}/flutter_lints

To learn how to use a specific rule set,
visit the documentation for [enabling and disabling linter rules][].

To find more predefined rule sets,
check out the [`#lints` topic]({{site.pub-pkg}}?q=topic:lints) on pub.dev.

[enabling and disabling linter rules]: /tools/analysis#enabling-linter-rules

<a id="maturity-levels"></a>
## Status

Each rule has a status or maturity level:

**Stable**
: These rules are safe to use and are verified as functional
  with the latest versions of the Dart language.
  All rules are considered stable unless
  they're marked as experimental, deprecated, or removed.

**Experimental**
: These rules are still under evaluation and might never be stabilized.
  Use these with caution and report any issues you come across.

**Deprecated**
: These rules are no longer suggested for use
  and might be removed in a future Dart release.

**Removed**
: These rules have been already been removed in the
  latest stable Dart release.

## Quick fixes

Some rules can be fixed automatically using quick fixes.
A quick fix is an automated edit 
targeted at fixing the issue
reported by the linter rule.

If the rule has a quick fix,
it can be applied using [`dart fix`](/tools/dart-fix)
or using your [editor with Dart support](/tools#editors).
To learn more, see [Quick fixes for analysis issues][].

[Quick fixes for analysis issues]: https://medium.com/dartlang/quick-fixes-for-analysis-issues-c10df084971a

## Rules

The following is an index of all linter rules and 
a short description of their functionality.
To learn more about a specific rule, 
click the **Learn more** button on its card.

For an auto-generated list containing all linter rules
in Dart `{{site.sdkVersion}}`,
check out [All linter rules](/tools/linter-rules/all).

---

<section class="filter-and-search">
  <div id="linter-search">
    <search>
      <span class="material-symbols leading-icon" aria-hidden="true">search</span>
      <input type="search" placeholder="Search rules..." aria-label="Search linter rules">
    </search>
    <button class="empty-button" id="sort">
      <span class="material-symbols">sort</span>
    </button>
  </div>

  <div class="chip-set">
    <button class="chip select-chip">
      <span class="label">Category</span>
      <svg class="chip-icon trailing-icon" width="24" height="24" viewBox="0 0 24 24">
        <path d="M7 10l5 5 5-5H7z"></path>
      </svg>
    </button>
    <button class="chip select-chip">
      <span class="label">Rule set</span>
      <svg class="chip-icon trailing-icon" width="24" height="24" viewBox="0 0 24 24">
        <path d="M7 10l5 5 5-5H7z"></path>
      </svg>
    </button>
    <button class="chip filter-chip">
      <svg class="chip-icon leading-icon" viewBox="0 0 18 18" aria-hidden="true">
        <path d="M6.75012 12.1274L3.62262 8.99988L2.55762 10.0574L6.75012 14.2499L15.7501 5.24988L14.6926 4.19238L6.75012 12.1274Z"></path>
      </svg>
      <span class="label">Fix available</span>
    </button>
    <button class="empty-button" id="reset-filters">Clear filters</button>
  </div>
</section>

<section class="results">
  <div class="card-container" id="card-container">
    {% render 'linter-rule-cards.md', linter_rules:linter_rules %}
  </div>
</section>

[Dart style guide]: /effective-dart/style
