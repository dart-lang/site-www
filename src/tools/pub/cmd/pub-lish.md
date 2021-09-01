---
title: dart pub publish
description: Use dart pub publish to publish your Dart package to the pub.dev site.
---

_Publish_ is one of the commands of the [pub tool](/tools/pub/cmd).

```nocode
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

{{site.alert.info}}
  *Problems?*
  See [Troubleshooting Pub](/tools/pub/troubleshoot).
{{site.alert.end}}

