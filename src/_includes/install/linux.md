
### Install using a Linux package manager {:.no_toc}

You have two options to install the Dart SDK on Ubuntu or Debian:

* Use the [apt-get](#install-using-the-apt-get-package-manager) command.
* Download a [`.deb`](#install-as-a-debian-package) package
  and run the `dpkg` command.

### Install using the `apt-get` package manager {:.no_toc}

To install Dart with `apt-get`, perform the following steps.
You need steps 1 to 3 only for the first install.

1. Update the package index files and install the secure HTTP package.

   ```console
   $ sudo apt-get update && sudo apt-get install apt-transport-https
   ```

1. Download and add the Google Linux GPG public key.

   ```console
   $ wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub \
     | sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg
   ```

1. Add the Dart package repository to your Linux system.

   ```console
   $ echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' \
     | sudo tee /etc/apt/sources.list.d/dart_stable.list
   ```

1. Use the following `sudo apt-get` commands.

   ```console
   $ sudo apt-get update && sudo apt-get install dart
   ```

### Install as a Debian package {:.no_toc}

To install the Dart SDK as a Debian package (`*.deb`),
perform the following steps.

1. Download the Dart SDK [Debian package](#){:.debian-link-stable}.

1. Use the `sudo dpkg` command to install the `*.deb` package.

   ```console
   $ sudo dpkg -i dart_3.4.0-1_amd64.deb
   ```

   Substitute `dart_3.4.0-1_amd64.deb` with the current filename.

## Upgrade the Dart SDK {:.no_toc}

Use the same command that you used to install the SDK.

### Upgrade using `apt-get` {:.no_toc}

If you installed the Dart SDK with `apt-get`,
use the following `sudo apt-get` commands.

```console
$ sudo apt-get update && sudo apt-get install dart
```

### Upgrade using `dpkg` {:.no_toc}

If you installed the Dart SDK with `dpkg`,
use the `sudo dpkg` command.

```console
$ sudo dpkg -i dart_3.2.6-1_amd64.deb
```

Substitute `dart_3.4.0-1_amd64.deb` with the new upgrade's filename.

## Uninstall the Dart SDK {:.no_toc}

### Uninstall using `apt-get` {:.no_toc}

If you installed the Dart SDK with `apt-get`,
use the `sudo apt-get remove` command.

1. Use the `sudo apt-get remove` command.

   ```console
   $ sudo apt-get remove -y dart
   ```

1. Remove the Dart configuration files from your home directory.

   ```console
   $ rm -rf  ~/.dart*
   ```

### Uninstall using `dpkg` {:.no_toc}

If you installed the Dart SDK with `dpkg`,
use the `sudo dpkg --purge` command.

1. Use the `sudo dpkg --purge` command.

   ```console
   $ sudo dpkg --purge dart
   ```

   This removes the configuration files at the same time.

1. Verify the SDK has been removed.

   ```console
   $ dpkg -l | grep dart
   ```

[sudo]: https://www.sudo.ws/
