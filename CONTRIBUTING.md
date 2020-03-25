# Contributing :heart:

Thanks for thinking about helping with [dart.dev][www]!
You can contribute in a few ways.

* **Fix typos.** The GitHub UI makes it easy to contribute small fixes, and
  you'll get credit for your contribution! To start, click the **page icon**
  at the upper right of the page. Then click the **pencil icon** to start
  editing the file. Once you've fixed the typo, commit your changes to a new
  branch and create a **pull request.**
  
  Once we've reviewed and approved your change, we'll merge it. Normally, we'll
  review your fix within one working day, and your fix will appear online less
  than an hour after we merge your PR.
  
  **Note:** If this is your first contribution to a Google project — _welcome!_
  — you'll need to [sign the CLA][].
  
* **[Report issues][].**

* **Fix known issues** (especially ones with the label **[help wanted][]** or
  **[beginner][]**). These issues may or may not be easy to fix. Sometimes
  they're issues that we don't have the expertise to fix, and we'd love to
  work with a contributor who has the right skills.
  
More info:

* To avoid wasting your time, talk with us before you make any nontrivial
  pull request. The [issue tracker][] is a good way to track your progress
  publicly, but we can also communicate other ways such as email and
  [Gitter][].
* We use the usual [GitHub pull request][] process.
* We follow the [Google Developer Documentation Style Guide][].
* For more ways to contribute to Dart, see the
  [dart-lang/sdk Contributing page][].

[beginner]: https://github.com/dart-lang/site-www/issues?utf8=%E2%9C%93&q=is%3Aissue%20is%3Aopen%20label%3A%22help%20wanted%22%20label%3Abeginner%20
[dart-lang/sdk Contributing page]: https://github.com/dart-lang/sdk/wiki/Contributing
[GitHub pull request]: https://help.github.com/articles/about-pull-requests/
[Gitter]: https://gitter.im/dart-lang/home
[Google Developer Documentation Style Guide]: https://developers.google.com/style/
[help wanted]: https://github.com/dart-lang/site-www/issues?utf8=%E2%9C%93&q=is%3Aopen%20is%3Aissue%20label%3A%22help%20wanted%22%20
[issue tracker]: https://github.com/dart-lang/site-www/issues
[Report issues]: https://github.com/dart-lang/site-www/issues/new
[sign the CLA]: https://developers.google.com/open-source/cla/individual
[www]: https://dart.dev

## Updating code samples

If your PR changes Dart code within a page, you'll probably need to change the code in two places:

1. In a `.md` file for the page.
2. In a `.dart` file under the `/examples` directory.

For example, say  you want to change the following code in the [language tour](https://dart.dev/guides/language/language-tour):

```
<?code-excerpt "misc/lib/language_tour/variables.dart (var-decl)"?>
{% prettify dart tag=pre+code %}
var name = 'Bob';
{% endprettify %}
```

Besides editing
[/src/_guides/language/language-tour.md](https://github.com/dart-lang/site-www/blob/master/src/_guides/language/language-tour.md)
(which you can find by clicking the GitHub icon at the top right of the page),
you'll also need to edit the `var-decl` region of
[/examples/misc/lib/language_tour/variables.dart](https://github.com/dart-lang/site-www/blob/master/examples/misc/lib/language_tour/variables.dart).

If you create a PR but forget to edit the Dart file,
or if your changes don't analyze/test cleanly,
the Travis CI build will fail.
Just update the PR, and Travis will try again.


## A word about conduct 

We pledge to maintain an open and welcoming environment.
For details, see our [code of conduct](https://dart.dev/code-of-conduct).
