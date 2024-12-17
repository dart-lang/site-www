{% for lint in linter_rules %}

{% if lint.state != "internal" %}

<div class="lint-card" id="{{lint.name}}">
<h3 class="card-title">{{lint.name | underscoreBreaker}}</h3>

{{lint.description}}

<div class="card-actions">
<div class="leading">
{% if lint.state == "removed" -%}
<span class="material-symbols removed-lints" title="Lint has been removed" aria-label="Lint has been removed">error</span>
{% elsif lint.state == "deprecated" -%}
<span class="material-symbols deprecated-lints" title="Lint is deprecated" aria-label="Lint is deprecated">warning</span>
{% elsif lint.state == "experimental" -%}
<span class="material-symbols experimental-lints" title="Lint is experimental" aria-label="Lint is experimental">science</span>
{% elsif lint.sinceDartSdk contains "wip" -%}
<span class="material-symbols wip-lints" title="Lint is unreleased" aria-label="Lint is unreleased">pending</span>
{% endif -%}
{% if lint.fixStatus == "hasFix" -%}
<span class="material-symbols has-fix" title="Has a quick fix" aria-label="Has a quick fix">build</span>
{% endif -%}
{% if lint.sets contains "core" -%}
<span class="material-symbols core-lints" title="Included in the core lint set" aria-label="Included in the core lint set">circles</span>
{% endif -%}
{% if lint.sets contains "recommended" -%}
<span class="material-symbols recommended-lints" title="Included in the recommended lint set" aria-label="Included in the recommended lint set">thumb_up</span>
{% endif -%}
{% if lint.sets contains "flutter" -%}
<span class="material-symbols flutter-lints" title="Included in the Flutter lint set" aria-label="Included in the Flutter lint set">flutter</span>
{% endif -%}
</div>

<div class="trailing">
<a href="/tools/linter-rules/{{lint.name}}" title="Learn more about this lint and when to enable it.">Learn more</a>
<button title="Copy {{lint.name}} to your clipboard.">Copy</button>
</div>

</div>
</div>

{% endif %}

{% endfor %}
