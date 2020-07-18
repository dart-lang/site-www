---
title: Experiment flags
description: Using experiment flags with Dart tools.
---

The Dart SDK often contains experimental features,
which you can try by passing flags to Dart tools.

{{site.alert.warning}}
  Don't use experiments for production code.
  Experiments might have breaking changes or be removed
  without notice.
{{site.alert.end}}


## Using experiment flags with command-line tools

To use an experiment with Dart SDK [command line tools](/tools/sdk),
pass the corresponding flag to the tool.
For example, to enable the experiments
`super-mixins` and `no-slow-checks`,
add those flags to the `dart` command:

```terminal
$ dart --enable-experiment=super-mixins,no-slow-checks
```


## Using experiment flags with IDEs

To enable experiments related to running or debugging apps in IDEs,
edit the launch configuration:

* [Instructions for Visual Studio Code](https://code.visualstudio.com/docs/editor/debugging#_launch-configurations)
* [Instructions for Android Studio](https://developer.android.com/studio/run/rundebugconfig)


## Using experiment flags with the Dart analyzer (command-line and IDE)

To enable experiments affecting analysis,
use the `enable-experiment` key in the [analysis options file][].
Here's an example of enabling the experiments
`super-mixins` and `no-slow-checks` in `analysis_options.yaml`:

[analysis options file]: /guides/language/analysis-options#the-analysis-options-file

```yaml
analyzer:
  enable-experiment:
    - super-mixins
    - no-slow-checks
```


## More information

* For a complete list of experiments,
  see the Dart SDK file [`experimental_features.yaml`.][]
* For information on procedures and expectations for experiment flags,
  see the documentation of the
  [process for changes that are behind experimental flags.][flags]

[`experimental_features.yaml`.]: https://github.com/dart-lang/sdk/blob/master/tools/experimental_features.yaml
[flags]: https://github.com/dart-lang/sdk/blob/master/docs/process/experimental-flags.md

