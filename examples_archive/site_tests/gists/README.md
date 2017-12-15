This directory contains source code for some examples published
using [DartPad](https://github.com/dart-lang/dart-pad).
To generate gists suitable for DartPad, we use
[kasperpeulen's gist-generator](https://github.com/kasperpeulen/gist-generator).
See Kasper's project for the latest instructions on using the tool,
but here's what we do, for now.

To get the tool:

```
pub global activate --source git https://github.com/kasperpeulen/gist-generator
```

To test whether all the examples follow DartPad's format,
without actually generating any gists:

```
<from a directory containing one or more packages>
gist generate -n
```

To generate a trial version of the gists, without changing any
gists that are already published:

```
gist generate -t
```

To generate or update all gists for packages under the current directory:

```
gist generate
```

For that last command to work, you'll need the gist token for whichever
user all the gists are under. (Contact the user.) If that is impractical,
an alternative is to edit each pubspec.yaml, removing the `gist:` and
`dartpad:` entries at the end. Then run `gist generate` and update all
references to point to the new locations.
