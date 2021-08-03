###How to install?

You can install the Dart SDK using [Chocolatey.][Chocolatey]

> **_NOTE:_** These commands require administrative privileges. To start command prompt as an administrator following these steps:
> 
> - Press Windows+R to open the “Run” box. 
> - Type “cmd” into the box 
> - Press Ctrl+Shift+Enter to run the command as an administrator.

####To install the Dart SDK:

```terminal
C:\> choco install dart-sdk
```

#####To upgrade the Dart SDK:

```terminal
C:\> choco upgrade dart-sdk
```

####Default installation directory:

```terminal
C:\tools\dart-sdk
```

###How to change installation directory?

This package uses the help Get-BinRoot, which means that you can set an environment variable called ChocolateyToolsLocation, which controls where this package is extracted to. For more information click <a ahref=https://docs.chocolatey.org/en-us/create/functions/get-toolslocation>here</a>.

###How to set path?

- In the Windows search bar type env, you will see "edit the system environment variables" option, open it
- Click on "Environment Variables...".
- Under user variables, select "Path" and click edit.
- Click new and add the path to your dart-sdk folder.
- Press ok and apply.

[Chocolatey]: https://chocolatey.org