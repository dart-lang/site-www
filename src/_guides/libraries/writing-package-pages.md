---
title: Writing package pages
description: Learn how to write a good package page.
---

<style>
  .screenshot, .screenshot-narrow {
    border-style: solid;
    border-width: 1px;
    border-color: lightgray;
    margin: 0px 20px;
    padding: 10px;
    width: 90%;
  }

  .screenshot-narrow {
    max-width: 400px;
  }
</style>

The guidelines on this page can help you create good package pages on pub.dev.
Specifically, this page has tips for
writing a better package README,
which provides the content marked **README (this document)**
in the following screenshot:

{% asset libraries/package-page-sections.png alt="package page contains sections like package layout, flutter favorite, package scoring, verified publishers, pubspec file" class="screenshot" %}

For details about other parts of the package page,
follow these links:

1. [Package layout ](https://dart.dev/tools/pub/package-layout)
2. [Flutter Favorite](https://flutter.dev/docs/development/packages-and-plugins/favorites)
3. [Package scoring](https://pub.dev/help/scoring)
4. [Verified publishers](https://dart.dev/tools/pub/verified-publishers)
5. [Pubspec file](https://dart.dev/tools/pub/pubspec)


## Writing a good README is important

People who find your package on pub.dev are likely to
quickly scan the README when deciding whether to try your package.
A good README catches the reader's attention and
shows that your package is worth trying.

{{ site.alert.note }}
  The package README is used in multiple ways.
  For example, its content appears not only in the package page on pub.dev,
  but also in [dartdoc][]-produced API reference documentation.
{{ site.alert.end }}

Although this page features the [`in_app_purchase`][] package README,
yours might not need to be as large or detailed.
If your package is simple and has no associated UI,
its README might look more like the one for the [`yaml`][] package. 


## Seven tips for good README

Here are some suggestions for creating a README
that works well on pub.dev:

1. [Put a short description at the top](#tip1)
2. [Include visual content](#tip2)
3. [Use lists to present key information](#tip3)
4. [Include usage examples](#tip4)
5. [Use Dart code formatting](#tip5)
6. [Mention related terms](#tip6)
7. [Tell users where to go next](#tip7)


### 1. Put a short description at the top {#tip1}

According to our user research,
package users spend only a few seconds to
read the package description and decide whether to
read the rest of the README.
Thus, you should concisely describe what the package does or achieves,
at a glance.
Spend some time to craft a short and sweet description and
help the user to make decisions.

{{site.alert.tip}}
  Don't write the package name again at the top.
  It's already visible in the pub.dev UI.
{{site.alert.end}}

Here are some examples of good descriptions:

*   `A Flutter plugin for showing rainbows.`
*   `Use machine learning to categorize bird sounds.`

Important information such as project status or constraints
should also be near the top.
For example:

*   `Does not work on iOS versions below 10.3.`

Here's a screenshot of the [`in_app_purchase`][] package page,
which starts with a brief explanation of the package and a caution.

{% asset libraries/package-page-description.png alt="description of the package in_app_purchase" class="screenshot" %}

[Badges][] are often near the top of the README,
either above or under the short description. 


### 2. Include visual content {#tip2}

If your package page is a wall of text with no visual content,
users might find it intimidating and stop reading.
Images are especially important if your package supports UI,
but they're also useful for explaining important concepts.
Either way, visual content can help users
feel confident about using the package.

Place visual content such as static images, animated GIFs, and
videos (such as MOV or MP4 files)
close to the beginning of the README,
where users are likely to see them.

{{site.alert.tip}}
  Prefer animated GIFs and videos for UI-related content,
  because most UIs aren't static,
  and animation conveys more information about the UI's behavior.
{{site.alert.end}}

The screenshots below show how
adding visual content made the `in_app_purchase` package page look better.
(The _before_ picture is on the left; _after_ is on the right.)

{% asset libraries/package-page-example-iap.png alt="in_app_purchase readme without and with images" class="screenshot" %}

{{ site.alert.tip }}
  When adding visual content,
  use absolute URLs for the files,
  so that the images reliably appear, no matter where the README is published.
  One place to host your images is in the repository itself,
  like `in_app_purchase` does.
{{ site.alert.end }}


### 3. Use lists to present key information {#tip3}

Lists can draw attention to important information on your README.
You might use lists for the following:

*   Key features of the package
*   Parameters, attributes, or properties
*   Unusual requirements 
*   Functionality that's out of scope of your package
*   Summarizing the contents of a long page or a section within a page
    (like this list does)


#### List key features of the package {#tip4}

First, clearly list what your package can do.
Some users might be looking for a very specific feature.
Help those users find out whether your package supports their needs or not.
Sometimes a table can be more informative than a list.

The following screenshot shows how the `in_app_purchase` README
presents the package's features:

{% asset libraries/package-page-features-list.png alt="list of features of the package in_app_purchase" class="screenshot" %}

The following screenshot shows a table from the `just_audio` README
that lists the package's features and platform support:

{% asset libraries/package-page-features-table.png alt="list of features of the package just_audio in a table format" class="screenshot-narrow" %}


#### List parameters, attributes, or properties {#tip5}

Consider listing parameters, attributes, or properties, for quick reference.
(Remember, the content of the package README appears in the
API reference documentation, as well as in the package page.)

For example, the `url_launcher` package has a table of supported URL schemes:

{% asset libraries/package-page-list-property.png alt="list of supported schemes of the package url_launcher" class="screenshot" %}

Linking to specific functions or classes
in the API reference documentation can also be useful.
See the [async]({{site.pub-pkg}}/async) package for an example.


#### List unusual requirements 

Listing requirements that are out of the scope of ordinary instructions
is a good idea, too.

{% asset libraries/package-page-list-requirements.png alt="additional instructions to use google_maps_flutter" class="screenshot" %}



#### List functionality that's out of scope of your package

Listing things that are out of scope for your package is another good idea.
For example, if you decide that your button package is only focused on
text buttons and not on icon buttons,
make it clear in the README.
If your package only supports Android from a certain version,
make sure the readers know about it.


#### Summarize contents

Users find it easier to navigate a section
when there’s a table of contents.
If a section in your README is very long,
consider listing the subsections clearly at the beginning of the section. 

{% asset libraries/package-page-list-subsections.png alt="content of the usage section of the package in_app_purchase" class="screenshot" %}


### 4. Include usage examples {#tip4}

If your package looks promising, users might want to test your package.
Include a “Get started” or “Usage” section and
include at least one code sample that users can easily understand,
and ideally, copy and paste into their project.
It’s even better if you can provide more examples with more details
to help users to understand your package. 

Remember that not all users speak English, but they all speak Dart!
Good code samples can go a long way.
Consider adding more complete examples in example/example.dart as well. 

{% asset libraries/package-page-usage-example.png alt="sample code of the package in_app_purchase" class="screenshot" %}

### 5. Use Dart code formatting {#tip5}

When adding code examples,
use three backticks + `dart` (\`\`\`dart) instead of three backticks (\`\`\`).
This formatting tells pub.dev to use Dart syntax highlighting.

```
final like = "this";
```

```dart
final like = "this";
```


### 6. Mention related terms {#tip6}

In the recent UX study, we found that
many users use the within-page search feature (ctrl+F or cmd+F) to
search for the feature they are looking for.
Thus, be sure to mention the key terms in the README,
so that users can find them. 

For example, users might want to know whether the `in_app_purchase` package
supports in-app subscription.
A user who searches for the keyword _subscription_
might abandon the page if the page doesn't mention _subscription_.

{% asset libraries/package-page-terms.png alt="the keyword is highlighted when users search for it within the page" class="screenshot" %}

After that, be consistent when using terms.
If needed, clearly define them. In the [`in_app_purchase`][] package,
the meaning of “underlying store” is presented at the beginning, and
the term is used consistently in the page.

{% asset libraries/package-page-terms-definition.png alt="the meaning of underlying store" class="screenshot" %}

{% asset libraries/package-page-terms-consistent.png alt="The term underlying store is used consistently across the page" class="screenshot" %}


### 7. Tell users where to go next {#tip7}

[PENDING: format better]

Tell users where they can go next to seek help.
It might be an issue tracker, a chat room, or an email address.

Tell users how they can contribute code to the package.

Tell users where they can find more about the package.
You many link to your article on Medium, video on YouTube, etc.

Tell users about your roadmap, or where they can find a roadmap.
Users might want to know if the feature they need is coming soon or not.

{% asset libraries/package-page-contribute.png alt="how to contribute to in_app_purchase" class="screenshot" %}


## Learn more about good README authoring

We’ve suggested seven tips for good README in this documentation.
You can learn more about common recommendations for developer docs from the
[Google Developer Documentation Style Guide][style-guide].
Some additional tips include:  

*   Supply alt text for images.
*   Be succinct. Don't say please.
*   Keep line length &lt;= 80 chars.
*   Format code correctly (as `dartfmt` or `flutter format` would).

To learn more about good README practices,
see these resources:

[README Checklist][]
: A checklist for writing a README that
helps readers feel confident about your project.

[Awesome README][]
: A curated, annotated list of great READMEs.

[Make a README][]
: An introduction to READMEs,
with a template and suggestions for a good README.

[How to write a great README for your GitHub project][]
: Key elements of a good README, and a template.

The suggestions in this page and others might not work for all packages.
Be creative!
Put yourself into users’ shoes and
imagine what the reader might want to read and know.
You’re the only person who can provide the information that the reader needs.

[Awesome README]: https://github.com/matiassingers/awesome-readme
[Badges]: https://github.com/badges/shields#readme
[dartdoc]: /tools/dartdoc
[How to write a great README for your GitHub project]: https://dbader.org/blog/write-a-great-readme-for-your-github-project
[`in_app_purchase`]: {{site.pub-pkg}}/in_app_purchase
[in its repo]: https://github.com/flutter/plugins/tree/master/packages/in_app_purchase/in_app_purchase/doc
[Make a README]: https://www.makeareadme.com
[README Checklist]: https://github.com/ddbeck/readme-checklist/blob/main/checklist.md
[style-guide]: https://developers.google.com/style/highlights
[`yaml`]: https://pub.dev/packages/yaml 
