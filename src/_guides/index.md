---
title: Dart documentation
description: Learn to use the Dart language and libraries.
toc: false
---

Welcome to the Dart documentation!
Here are some of the most visited pages:

{% comment %}
To update these cards, edit src/_data/docs_cards.yml.
{% endcomment %}

<div class="card-grid">
{% for card in site.data.docs_cards -%}
  {% capture index0Modulo3 %}{{ forloop.index0 | modulo:3 }}{% endcapture %}
  {% capture indexModulo3 %}{{ forloop.index | modulo:3 }}{% endcapture %}
  <div class="card">
    <h3><a href="{{card.url}}">{{card.name}}</a></h3>
    <p>{{card.description}}</p>
  </div>
{% endfor -%}
</div>

{% comment %}
[PENDING: Give this page content similar to
[flutter.dev/docs.](https://flutter.dev/docs)]

## What's new on the site

**May 7, 2019**

Everything. :)

For a listing of new docs, see [what's new](/docs/whats-new-archive).

## New to Dart?

Once you've gone through [Get Started](/docs/get-started/install),
including [Write Your First Flutter App,](/docs/get-started/codelab)
here are some next steps.

### Docs

[Building layouts in Flutter](/docs/development/ui/layout)
: Learn how to create layouts in Flutter, where everything is a widget.

[Adding interactivity to your Flutter app](/docs/development/ui/interactive)
: Learn how to add a stateful widget to your app.

[A tour of the Flutter widget framework](/docs/development/ui/widgets-intro)
: Learn more about Flutter's react-style framework.

[FAQ](/docs/resources/faq)
: Get the answers to frequently asked questions.

You may also find these docs useful:

* [Using packages](/docs/development/packages-and-plugins/using-packages)
* [Adding assets and images](/docs/development/ui/assets-and-images)
* [Navigation and routing](/docs/development/ui/navigation)
* [State management](/docs/development/data-and-backend/state-mgmt/intro)
* [Animations](/docs/development/ui/animations)
{% endcomment %}
