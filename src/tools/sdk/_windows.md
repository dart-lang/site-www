You can install the Dart SDK using [Chocolatey.][Chocolatey]

{{site.alert.important}}
  These commands require administrator rights.
  Here's one way to open a Command Prompt window
  that has admin rights:

  1. Press <kbd>Windows+R</kbd> to open the **Run** window.
  2. Type `cmd` into the box.
  3. Press <kbd>Ctrl+Shift+Enter</kbd>.
{{site.alert.end}}

To install the Dart SDK:

```terminal
C:\> choco install dart-sdk
```

To upgrade the Dart SDK:

```terminal
C:\> choco upgrade dart-sdk
```

By default, the SDK is installed at `C:\tools\dart-sdk`.
You can change that location by setting
the [`ChocolateyToolsLocation`][] environment variable
to your chosen installation directory.

If you can't use the Dart SDK executables,
add the SDK location to your PATH:

1. In the Windows search box, type `env`.
2. Click **Edit the system environment variables**.
3. Click **Environment Variables...**.
4. In the user variable section, select **Path** and click **Edit...**.
5. Click **New**, and enter the path to the `dart-sdk` directory.
6. In each window that you just opened,
   click **Apply** or **OK** to dismiss it and apply the path change.

[Chocolatey]: https://chocolatey.org
[`ChocolateyToolsLocation`]: https://stackoverflow.com/questions/19752533/how-do-i-set-chocolatey-to-install-applications-onto-another-drive/68314437#68314437
