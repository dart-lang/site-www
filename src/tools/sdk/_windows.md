#### Install using a setup wizard
{: style="margin-top: 0"}

A [Dart SDK installer for Windows][]{: target="_blank"} is available and
supported by the community. You can use the wizard to install **stable** or
**dev** versions of the Dart SDK.

![Windows Dart Setup Wizard][Windows installer img]{:.text-center width="250"}

#### Install using Chcolatey

Alternatively, you can install using [Chocolatey][].
To install a stable release, run:

```terminal
C:\> choco install dart-sdk
```

To install a **dev** release, run:

```terminal
C:\> choco install dart-sdk-dev
```

To **upgrade**, run, the following command where \<package> is either `dart-sdk` or `dart-sdk-dev`:

```terminal
C:\> choco upgrade <package>
```

[Chocolatey]: https://chocolatey.org
[Dart SDK installer for Windows]: http://www.gekorm.com/dart-windows
[Windows installer img]: {% asset_path 'installer-screenshot-no.png' %}
