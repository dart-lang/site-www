{% if site.url == site.www -%}
  {% include banner.html -%}
{% else -%}
<div class="banner" markdown="1">
  {:.banner__text}
  [**Announcing Dart 2**:][Announcing Dart 2]{:.no-automatic-external target="_blank"}
  Optimized for client-side development.
  [Learn more](/dart-2).

  [Announcing Dart 2]: https://medium.com/dartlang/announcing-dart-2-80ba01f43b6
</div>
{% endif %}
