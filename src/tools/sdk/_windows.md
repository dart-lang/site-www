You can install the Dart SDK using [Chocolatey.][Chocolatey]

{% if site.data.pkg-vers.SDK.channel == 'dev' %}
To install a **dev** release of the Dart SDK, run this command:

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
To install a **stable** release of the Dart SDK, run this command:

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


[Chocolatey]: https://chocolatey.org
