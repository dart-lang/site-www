---
title: dart pub publish
description: Use dart pub publish to publish your Dart package to the pub.dev site.
---

_Publish_ is one of the commands of the [pub tool](/tools/pub/cmd).

```plaintext
$ dart pub publish [options]
```

This command publishes your package on the
[pub.dev site]({{site.pub}}) for anyone to download and depend
on. For information on how to prepare your package for publishing,
and what files you should include or exclude,
see [Publishing packages](/tools/pub/publishing).

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

### `--dry-run` or `-n`

With this, pub goes through the validation process but does not actually upload
the package. This is useful if you want to see if your package meets all of the
publishing requirements before you're ready to actually go public.

### `--force` or `-f`

With this, pub does not ask for confirmation before publishing. Normally, it
shows you the package contents and asks for you to confirm the upload.

If your package has errors, pub doesn't upload it and exits with an error.
In the event of warnings, your package *is* uploaded.
To ensure that your package has no warnings before uploading,
either don't use `--force`, or use `--dry-run` first.

### `--skip-validation`

Publishes without going through the client-side validation process or resolving dependencies.
This is useful for advanced users who knows why the validation fails and wishes to side step a particularly issues.

**Example:** When publishing to pub.dev it may take a few minutes for a newly published package to become available.
Hence, if you are publishing two dependent packages, where the second depends on the first.
You can either wait a few minutes in between publishing the first and the second, or use `--skip-validation`
to publish the second package immediately, by side-stepping client-side valiation.

{% render 'pub-problems.md' %}
