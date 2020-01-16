Choose one of these options:

* [Install using Chocolatey](#install-using-chocolatey)
* [Install using a setup wizard](#install-using-a-setup-wizard)

#### Install using Chocolatey

{% if site.data.pkg-vers.SDK.channel == 'dev' %}
To use [Chocolatey][] to install a **dev** release of the Dart SDK, run this
command:

```terminal
C:\> choco install dart-sdk --pre
```

To install a **stable** release, run this command:

```terminal
C:\> choco install dart-sdk
```

To **upgrade** the dev release of the Dart SDK, run this command:
(remove the `--pre` to upgrade the stable release):

```terminal
C:\> choco upgrade dart-sdk --pre
```
{% else %}
To use [Chocolatey][] to install a **stable** release of the Dart SDK, run this
command:

```terminal
C:\> choco install dart-sdk
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
{% endif %}

#### Install using a setup wizard

Alternatively, use the community-supported
[Dart SDK installer for Windows.][Dart SDK installer for Windows]{: target="_blank"}
You can use the wizard to install **stable** or
**dev** versions of the Dart SDK.

![Windows Dart Setup Wizard][Windows installer img]{:.text-center width="250"}


[Chocolatey]: https://chocolatey.org
[Dart SDK installer for Windows]: https://www.gekorm.com/dart-windows
[Windows installer img]: {% asset shared/dart/installer-screenshot-no.png @path %}
