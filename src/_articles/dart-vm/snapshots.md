---
layout: article
title: "Snapshots in Dart"
description: "Learn how snapshots can help your apps start up faster."
written: 2013-02-13
category: dart-vm
---

_Written by Siva Annamalai <br>
February 2013_

This article talks about snapshots in Dart—both
what they are and how they can make Dart apps start up faster.
If you write command-line apps,
you should be able to improve their startup time
by generating your own snapshots,
following the instructions in this article.

## What is a snapshot?

A snapshot is a sequence of bytes
that represents a serialized form
of one or more Dart objects.
This representation closely corresponds to
the way these Dart objects are represented
in an isolate’s heap in memory.

The Dart VM uses snapshots for two main reasons:

* **Speeding up initial startup time**
  for an application.
  A snapshot of the core libraries and application script
  typically contains preparsed data for
  the core libraries and the application script.
  This means it is not necessary to parse and tokenize
  the libraries and script during startup.

* **Passing objects**
  from one isolate to another isolate.

The Dart VM uses the following kinds of snapshots:

* A **full snapshot**,
  which is a complete representation of
  an isolate’s heap after it is initialized.
  This is used by the Dart VM for
  fast startup and initialization of
  the entire Dart core library and other libraries
  such as dart:convert, dart:io, dart:isolate, and so on.

* A **script snapshot**,
  which is a complete representation of
  an application script in an isolate’s heap
  after the script is loaded into the isolate,
  but before the script starts executing.
  This is used by the Dart VM for
  fast startup and initialization of applications.
  For example, the script that starts dart2js
  uses a pre-created script snapshot of the dart2js application.

* An **object snapshot**.
  Messaging from one isolate to another
  is implemented in the Dart VM by
  creating a snapshot of the Dart object
  that needs to be sent to the other isolate.


## How to generate and use script snapshots

You can generate and use script snapshots using the Dart VM (dart).

<aside class="alert alert-info" markdown="1">
**Note:**
Don't bother creating a script
snapshot for a program that you're going to run
just a few times.
A script snapshot is useful only for deployed applications
where the cost of creating the snapshot
is amortized over many launches.
</aside>

To generate a script snapshot,
use dart with the `--snapshot` option.
You can use the `--package_root` option
to specify the location of packages used in imports
(`import 'package:...'`).

{% prettify sh %}
dart [--package_root=<path>] --snapshot=<output_file> <dart_file>
{% endprettify %}

The `--snapshot` option writes
a script snapshot of _dart-script-file_ to _out-file_.
For example, the following command creates
a snapshot of the Dart script `dart2js.dart`,
putting it into a file called `dart2js.snapshot`.

{% prettify sh %}
dart --snapshot=dart2js.snapshot \
    dart-sdk/lib/dart2js/lib/_internal/compiler/implementation/dart2js.dart
{% endprettify %}

To execute a script from its snapshot,
specify the snapshot file on the command line:

{% prettify sh %}
dart <snapshot_file> <args>
{% endprettify %}

Any _args_ you specify are passed to the script.
For example, you can run dart2js like this,
passing `myscript.dart -oout.js` as command-line arguments to dart2js:

{% prettify sh %}
dart dart2js.snapshot myscript.dart -oout.js
{% endprettify %}

## How to generate full snapshots

Read this section if you’re working on
one of the rare projects that embed the Dart VM (for example, Dartium).
The gen_snapshot tool writes a full snapshot
(corelibs, dart:uri, dart:io, dart:utf, dart:json, dart:isolate, ...)
to _out-file_:

{% prettify sh %}
gen_snapshot [<options>] --snapshot=<out_file>
{% endprettify %}

You can use the following _options_:

<table class="table">
  <tr style="text-align:left">
    <th>Option</th> <th>Description</th>
  </tr>
  <tr>
    <td class="nowrap">
      --package_root=<em>path</em>
    </td>
    <td>
      Specifies the location of packages used in imports
      (<code>import 'package:...'</code>).</td>
  </tr>
  <tr>
    <td class="nowrap">
      --url_mapping=<em>mapping</em>
    </td>
    <td>
      Provides a URL mapping on the command line for URI resolution
      during library imports.</td>
  </tr>
</table>


## Summary

You can find more information about snapshots
and how they are implemented by browsing the files in the
[runtime/vm directory](https://github.com/dart-lang/sdk/tree/master/runtime/vm).
Start by looking for "Snapshot" in
[snapshot.h](https://github.com/dart-lang/sdk/blob/master/runtime/vm/snapshot.h).
Note that the code might move as the implementation changes.
