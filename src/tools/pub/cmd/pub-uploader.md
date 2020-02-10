---
title: pub uploader
description: Use pub uploader to add or remove uploaders for your Dart package on the pub.dev site.
toc: false
---

{{site.alert.tip}}
  Instead of specifying uploaders for each package you publish,
  consider using a
  [verified publisher](/tools/pub/verified-publishers).
{{site.alert.end}}

_Uploader_ is one of the commands of the [pub tool](/tools/pub/cmd).

{% prettify nocode tag=pre+code %}
$ pub uploader [options] {add/remove} <email>
{% endprettify %}

This command allows
[uploaders](/tools/pub/glossary#uploader) of a
package on the [pub.dev site]({{site.pub}}) to add or remove
other uploaders for that package. It has two sub-commands,
`add` and `remove`, that take the email address of the person to
add/remove as an uploader. For example:

```terminal
~/code/transmogrify$ pub uploader add bob@example.com
'bob@example.com' added as an uploader for package 'transmogrify'.

~/code/transmogrify$ pub uploader remove bob@example.com
'bob@example.com' is no longer an uploader for package 'transmogrify'.
```

If a package has only one uploader, that uploader can't be removed. You can
remove yourself as an uploader (as long as other uploaders are available),
but you can't re-add yourself again afterwards.

By default, the package in the current working directory will have its
uploaders modified. You can also pass the `--package` flag to choose a
package by name. For example:

```terminal
$ pub uploader --package=transmogrify add bob@example.com
'bob@example.com' added as an uploader for package 'transmogrify'.
```

Note that uploaders are identified by their Google accounts, so use a Gmail or
Google Apps email address for any new uploaders.

## Options

For options that apply to all pub commands, see
[Global options](/tools/pub/cmd#global-options).

<aside class="alert alert-info" markdown="1">
  *Problems?* See [Troubleshooting Pub](/tools/pub/troubleshoot).
</aside>
