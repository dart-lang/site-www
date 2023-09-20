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

<img 
  src="/assets/img/libraries/package-page-sections.png"
  alt="package page contains sections like package layout, flutter favorite, package scoring, verified publishers, pubspec file" 
  class="screenshot">

For details about other parts of the package page,
follow these links:

1. [Package layout ](https://dart.dev/tools/pub/package-layout)
2. [Flutter Favorite](https://flutter.dev/docs/development/packages-and-plugins/favorites)
3. [Package scoring]({{site.pub}}/help/scoring)
4. [Verified publishers](https://dart.dev/tools/pub/verified-publishers)
5. [Pubspec file](https://dart.dev/tools/pub/pubspec)


## Writing a good README is important

People who find your package on pub.dev are likely to
quickly scan the README when deciding whether to try your package.
A good README catches the reader's attention and
shows that your package is worth trying.

{{site.alert.note}}
  The package README is used in multiple ways.
  For example, its content appears not only in the package page on pub.dev,
  but also in [`dart doc`][]-produced API reference documentation.
{{site.alert.end}}

Although this page features the [`in_app_purchase`][] package README,
yours might not need to be as large or detailed.
If your package is simple and has no associated UI,
its README might look more like the one for the [`yaml`][] package. 


## Seven tips for good README

Here are some suggestions for creating a README
that works well on pub.dev:

1. [Put a short description at the top](#tip1)
2. [Include visual content](#tip2)
3. [Use lists to present important information](#tip3)
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
which starts with a brief explanation of the package and a caution:

<img 
  src="/assets/img/libraries/package-page-description.png"
  alt="description of the package in_app_purchase" 
  class="screenshot">

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
adding visual content made the `in_app_purchase` package page look informative at first glance.
(The _before_ picture is on the left; _after_ is on the right.)

<img 
  src="/assets/img/libraries/package-page-example-iap.png"
  alt="in_app_purchase readme without and with images" 
  class="screenshot">

{{site.alert.tip}}
  When adding visual content,
  use absolute URLs for the files
  to make the images reliably appear,
  no matter where the README is published.
  One place to host your images is in the repository itself,
  like `in_app_purchase` does.
{{site.alert.end}}


### 3. Use lists to present important information {#tip3}

Lists can draw attention to important information on your README.
You might use lists for the following:

*   [Key features of the package](#list1)
*   [Parameters, attributes, or properties](#list2)
*   [Unusual requirements](#list3)
*   [Functionality that's out of scope of your package](#list4)
*   [A summary of the contents of a page or a section within a page
    (like this list)](#list5)

Usually, lists are bulleted, like the list above.
Another option is using a table,
like the table of platform support in the next section.


#### Key features of the package {#list1}

First, clearly list what your package can do.
Some users might be looking for a very specific feature.
Help those users find out whether your package supports their needs.

The following screenshot shows how the `in_app_purchase` README
presents the package's features:

<img 
  src="/assets/img/libraries/package-page-features-list.png"
  alt="list of features of the package in_app_purchase" 
  class="screenshot">

The next screenshot shows a table from the `just_audio` README
that lists the package's features and platform support:

<img 
  src="/assets/img/libraries/package-page-features-table.png"
  alt="list of features of the package just_audio in a table format" 
  class="screenshot-narrow">


#### Parameters, attributes, or properties {#list2}

Consider listing parameters, attributes, or properties for quick reference.
(Remember, the content of the package README appears in the
API reference documentation, as well as in the package page.)

For example, the `url_launcher` package has a table of supported URL schemes:

<img 
  src="/assets/img/libraries/package-page-list-property.png"
  alt="list of supported schemes of the package url_launcher" 
  class="screenshot">

Linking to specific functions or classes
in the API reference documentation can also be useful.
See the [async]({{site.pub-pkg}}/async) package for an example.


#### Unusual requirements {#list3}

If your package needs a specific setup, beyond what all packages require,
list setup instructions in the README.

For example, the following screenshot for the `google_maps_flutter` package
shows instructions on getting started with Google Maps Platform:

<img 
  src="/assets/img/libraries/package-page-list-requirements.png" 
  alt="additional instructions to use google_maps_flutter" 
  class="screenshot">


#### Functionality that's out of scope of your package {#list4}

To help users know whether your package can help them,
list the features that users might expect,
but that your package _doesn't_ support.

Here are some examples of when
you might want to list out-of-scope functionality:

* If your button package is focused only on text buttons
  and not on icon buttons,
  make that clear in the README.
* If your package supports only certain versions of Android,
  say that in the README.


#### Contents {#list5}

Users find it easier to navigate a page or section
when it has a table of contents.
If a section in your README is very long,
consider listing the subsections clearly at the beginning of the section. 

For example, the "Usage" section of the `in_app_purchase` README
has a lot of examples.
The following table of contents helps users understand which examples exist,
and go to the code that interests them:

<img 
  src="/assets/img/libraries/package-page-list-subsections.png" 
  alt="content of the usage section of the package in_app_purchase" 
  class="screenshot">


### 4. Include usage examples {#tip4}

If your package looks promising, users might want to test your package.
Include a "Get started" or "Usage" section that has
at least one code sample that users can easily understand—and, 
ideally, that they can copy and paste into their project.
It's even better if you can provide more examples with more details
to help users to understand your package. 

Remember that not all users speak English, but they all speak Dart!
Good code samples can go a long way.
Consider adding more complete examples
under your package's `example` directory,
which pub.dev can use to populate an **Examples** tab.
For details, see [Examples][] in
the [package layout conventions][].

[Examples]: /tools/pub/package-layout#examples
[package layout conventions]: /tools/pub/package-layout

The following screenshot shows one of several examples in the README for
the `in_app_purchase` package:

<img 
  src="/assets/img/libraries/package-page-usage-example.png"
  alt="sample code of the package in_app_purchase" 
  class="screenshot">

### 5. Use Dart code formatting {#tip5}

When adding code examples,
use three backticks plus `dart` (<code>```dart</code>) instead of
three backticks (<code>```</code>).
As the following examples show,
adding `dart` tells pub.dev to use Dart syntax highlighting:

<table width="100%">
<tr>
<th> <b>Formatted with just <code>```</code></b> </th>
<th> <b>Formatted with <code>```dart</code></b> </th>
</tr>
<tr markdown="1">
<td markdown="1">
```
final like = 'this';
```
</td>
<td markdown="1">
```dart
final like = 'this';
```
</td>
</tr>
</table>


### 6. Mention related terms {#tip6}

A recent UX study found that
many users use the within-page search feature
(`Control+F` or `Command+F`)
to search for the feature they are looking for.
Thus, be sure to mention important terms in the README,
so that users can find them. 

For example, users might want to know whether the `in_app_purchase` package
supports in-app subscription.
A user who searches for the keyword _subscription_
might abandon the page if the page doesn't use that term.

<img 
  src="/assets/img/libraries/package-page-terms.png"
  alt="the keyword is highlighted when users search for it within the page" 
  class="screenshot">

After mentioning all the terms that people might search for,
be consistent about the terms you use.
If needed, clearly define the terms.

For example, the [`in_app_purchase`][] package defines
_underlying store_ at the beginning:

<img 
  src="/assets/img/libraries/package-page-terms-definition.png"
  alt="the meaning of underlying store" 
  class="screenshot">

The rest of the page consistently uses that term:

<img 
  src="/assets/img/libraries/package-page-terms-consistent.png"
  alt="The term underlying store is used consistently across the page" 
  class="screenshot">


### 7. Tell users where to go next {#tip7}

Help your users find out more about the package.
Here are some suggestions for what to tell potential users:

* Where to learn more about the package.
  You might link to an article on Medium, or to a video on YouTube.
* Where to get help on using the package.
  Possibilities include an issue tracker, a chat room, or an email address.
* What you're planning to do with the package.
  A roadmap—either in the README or in an external page—can 
  help users know whether the feature they need is coming soon.
* How to contribute code to the package.

The following screenshot shows the part of the `in_app_purchase` README
that has information for potential contributors:

<img 
  src="/assets/img/libraries/package-page-contribute.png"
  alt="how to contribute to in_app_purchase" 
  class="screenshot">


## Learn more about good README authoring

We've suggested seven tips for good README in this documentation.
You can learn more about common recommendations for developer documentation
from the [Google Developer Documentation Style Guide][style-guide].
Some additional tips include:  

*   Supply alt text for images.
*   Be succinct. Don't say please.
*   Keep the line length &lt;= 80 chars.
*   Format code correctly (as `dart format` would).

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
Put yourself into users' shoes and
imagine what the reader might want to read and know.
You're the only person who can provide the information that the reader needs.

[Awesome README]: https://github.com/matiassingers/awesome-readme
[Badges]: https://github.com/badges/shields#readme
[`dart doc`]: /tools/dart-doc
[How to write a great README for your GitHub project]: https://dbader.org/blog/write-a-great-readme-for-your-github-project
[`in_app_purchase`]: {{site.pub-pkg}}/in_app_purchase
[in its repo]: https://github.com/flutter/plugins/tree/master/packages/in_app_purchase/in_app_purchase/doc
[Make a README]: https://www.makeareadme.com
[README Checklist]: https://github.com/ddbeck/readme-checklist/blob/main/checklist.md
[style-guide]: https://developers.google.com/style/highlights
[`yaml`]: {{site.pub-pkg}}/yaml 
