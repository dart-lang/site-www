How to install?

You can install the Dart SDK using [Chocolatey.][Chocolatey]

{{site.alert.important}} 
  These commands require administrative privileges. 

  For example, to start command prompt as an administrator,
  follow these steps:
  
  1. Press <kbd>Windows+R</kbd> to open the **Run** window. 
  
  2. Type `cmd` into the box. 
  
  3. Press <kbd>Ctrl+Shift+Enter</kbd> to run the command as an administrator.
  
{{site.alert.end}}

To install the Dart SDK:

```terminal
C:\> choco install dart-sdk
```

To upgrade the Dart SDK:

```terminal
C:\> choco upgrade dart-sdk
```

Default installation directory:

```terminal
C:\tools\dart-sdk
```

How to change installation directory?

This package uses the help Get-BinRoot, which means that 
you can set an environment variable called ChocolateyToolsLocation, which 
controls where this package is extracted to. 
For more information check out [get-toolslocation].

How to set path?

1. In the Windows search bar type "env". 
2. Click on **edit the system environment variables**.
3. Click on **Environment Variables...**.
4. Under user variables, select **Path** and click edit.
5. Click **New..** and add the path to your dart-sdk folder.
6. Press **OK** and **Apply**.

[Chocolatey]: https://chocolatey.org
[get-toolslocation]: https://docs.chocolatey.org/en-us/create/functions/get-toolslocation
