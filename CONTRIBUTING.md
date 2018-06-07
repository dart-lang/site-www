# Contributing :heart:

Thanks for thinking about helping with [www.dartlang.org][www]!
Here are a couple of ways that you can contribute:

* [Report issues](https://github.com/dart-lang/site-www/issues/new).
* Fix issues (especially ones with the label
  **[help wanted](https://github.com/dart-lang/site-www/issues?utf8=%E2%9C%93&q=is%3Aopen%20is%3Aissue%20label%3A%22help%20wanted%22%20)**).
  * If this is your first contribution—_welcome!_—please
  [sign the CLA](https://developers.google.com/open-source/cla/individual)
  and check out issues that are
  labeled **[beginner](https://github.com/dart-lang/site-www/issues?utf8=%E2%9C%93&q=is%3Aissue%20is%3Aopen%20label%3A%22help%20wanted%22%20label%3Abeginner%20)**.
  Beginner issues may or may not be easy to fix.
  Sometimes they're issues we don't have the expertise to fix ourselves,
  and we'd love to work with a contributor who has the right skills.
  * We use the usual [GitHub pull request](https://help.github.com/articles/about-pull-requests/) process.
  * We follow the [Google Developer Documentation Style Guide](https://developers.google.com/style/).

To avoid wasting your time, talk with us before you make any nontrivial
pull request. The [issue tracker](https://github.com/dart-lang/site-www/issues)
is a good way to track your progress publicly, but we can also communicate
other ways such as email and [Gitter](https://gitter.im/dart-lang/home).

For more information on contributing to Dart, see the
[dart-lang/sdk Contributing page](https://github.com/dart-lang/sdk/wiki/Contributing).

[www]: https://www.dartlang.org


## Updating code samples

If your PR changes Dart code within a page, you'll probably need to change it in two places:

1. In a markdown file for the page.
2. In a Dart file under the `/examples` directory.

For example, say  you want to change the following code in the [language tour](https://www.dartlang.org/guides/language/language-tour):

```
<?code-excerpt "misc/lib/language_tour/variables.dart (var-decl)"?>
{% prettify dart %}
var name = 'Bob';
{% endprettify %}
```

Besides editing
[/src/_guides/language/language-tour.md](https://github.com/dart-lang/site-www/blob/master/src/_guides/language/language-tour.md)
(which you can find by clicking the GitHub icon at the top right of the page),
you'll also need to edit
[/examples/misc/lib/language_tour/variables.dart](https://github.com/dart-lang/site-www/blob/master/examples/misc/lib/language_tour/variables.dart).

If you create a PR but forget to edit the Dart file,
or if your changes don't analyze/test cleanly,
the Travis CI build will fail.
Just update the PR, and Travis will try again.
