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
$ dart run --enable-experiment=super-mixins,no-slow-checks bin/main.dart
```


## Using experiment flags with the Dart analyzer (command-line and IDE)

To enable experiments affecting analysis,
use the `enable-experiment` key in the [analysis options file][].
Here's an example of enabling the experiments
`super-mixins` and `no-slow-checks` in `analysis_options.yaml`:

[analysis options file]: /tools/analysis#the-analysis-options-file

```yaml
analyzer:
  enable-experiment:
    - super-mixins
    - no-slow-checks
```


## Using experiment flags with IDEs

To enable experiments related to running or debugging apps in IDEs,
edit the launch configuration.

### Visual Studio Code

In `launch.json` under `configurations`,
add a new `toolArgs` key containing the desired flags.
Example:

```json
 "configurations": [
        {
            "name": "Dart",
            "program": "bin/main.dart",
            "request": "launch",
            "type": "dart",
            "toolArgs": [
                "--enable-experiment=super-mixins,no-slow-checks",
            ],
        }
    ]
```

For more information, consult the documentation for
[VS Code launch configurations.][VSC instructions]

[VSC instructions]: https://code.visualstudio.com/docs/editor/debugging#_launch-configurations


### Android Studio

Under `VMOptions` add the desired flags.
Example:

```xml
<component name="ProjectRunConfigurationManager">
  <configuration default="false" name="Run main" type="DartCommandLineRunConfigurationType" factoryName="Dart Command Line Application">
    <option name="VMOptions" value="--enable-experiment=non-nullable" />
    <option name="filePath" value="$PROJECT_DIR$/bin/main.dart" />
    <method v="2" />
  </configuration>
</component>
```

For more information, consult the instructions for
[Android Studio run/debug configurations.][AS instructions]

[AS instructions]: https://developer.android.com/studio/run/rundebugconfig


## More information

* For a complete list of experiments,
  see the Dart SDK file [`experimental_features.yaml`.][]
* For information on procedures and expectations for experiment flags,
  see the documentation of the
  [process for changes that are behind experimental flags.][flags]

[`experimental_features.yaml`.]: https://github.com/dart-lang/sdk/blob/main/tools/experimental_features.yaml
[flags]: https://github.com/dart-lang/sdk/blob/main/docs/process/experimental-flags.md

