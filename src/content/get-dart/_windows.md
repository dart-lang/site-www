
### Install using Chocolatey {:.no_toc}

To install the Dart SDK, use [Chocolatey][Chocolatey].
Chocolatey requires [elevated permissions].

Install Chocolatey, then run a [command prompt] with elevated permissions.

```ps
C:\> choco install dart-sdk
```

### Change default install path {:.no_toc}

By default, Chocolatey installs the SDK at `C:\tools\dart-sdk`.
To change that location, set the [`ChocolateyToolsLocation`][]
environment variable to your desired installation directory.

### Verify your PATH includes Dart {:.no_toc}

Verify you can run Dart.

```ps
C:\> dart --version
Dart SDK version: 3.2.4 (stable) (Thu Dec 21 19:13:53 2023 +0000) on "win_x64"
```

If your development machine doesn't return a Dart version,
add the SDK location to your PATH:

1. In the Windows search box, type `env`.
2. Click **Edit the system environment variables**.
3. Click **Environment Variables...**.
4. In the user variable section, select **Path** and click **Edit...**.
5. Click **New**, and enter the path to the `dart-sdk` directory.
6. In each window that you just opened,
   click **Apply** or **OK** to dismiss it and apply the path change.

### Upgrade using Chocolatey {:.no_toc}

To upgrade the Dart SDK:

```ps
C:\> choco upgrade dart-sdk
```

[elevated permissions]: https://www.thewindowsclub.com/elevated-privileges-windows
[command prompt]: https://www.thewindowsclub.com/how-to-run-command-prompt-as-an-administrator
[Chocolatey]: https://chocolatey.org
[`ChocolateyToolsLocation`]: https://stackoverflow.com/questions/19752533/how-do-i-set-chocolatey-to-install-applications-onto-another-drive/68314437#68314437
