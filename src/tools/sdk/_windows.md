Choose one of these options:

* [Install using Chocolatey](#install-using-chocolatey)
* [Install using a setup wizard](#install-using-a-setup-wizard)

#### Install using Chocolatey

To use [Chocolatey][] to install a **stable** release of the Dart SDK, run this
command:

```terminal
C:\> choco install dart-sdk
```

To install a **beta** release, run this command (you'll need the exact version
number):

```terminal
C:\> choco install dart-sdk --pre --version 2.8.0.20-c-011-beta
```

To install a **dev** release, run this command:

```terminal
C:\> choco install dart-sdk --pre
```

To **upgrade** the Dart SDK, run this command
(add `--pre` to upgrade the dev release):

```terminal
C:\> choco upgrade dart-sdk
```
#### Install using a setup wizard

Alternatively, use the community-supported
<a href="https://www.gekorm.com/dart-windows"
  target="_blank" rel="noopener">Dart SDK installer for Windows.</a>
You can use the wizard to install **stable** or
**dev** versions of the Dart SDK.

![Windows Dart Setup Wizard][Windows installer img]{:.text-center width="250"}


[Chocolatey]: https://chocolatey.org
[Windows installer img]: {% asset shared/dart/installer-screenshot-no.png @path %}
