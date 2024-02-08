
### Install using package manager {:.no_toc}

Choose to install either using [apt-get](#install-using-apt-get)
or downloading a [`.deb`](#install-a-debian-package) package.

Both methods trigger an SDK update whenever Dart releases a new version.

#### Install using `apt-get` {:.no_toc}

Perform the following steps for the first install only.

1. Update the package index files and install the secure HTTP package.

   ```console
   $ sudo apt-get update && sudo apt-get install apt-transport-https
   ```

1. Download and add the Google Linux GPG public key.

   ```console
   $ wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg  --dearmor -o /usr/share/keyrings/dart.gpg
   ```

1. Add the Dart package repository to your Linux system.

   ```console
   $ echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
   ```

Install the Dart SDK using [`sudo`][sudo].

```console
$ sudo apt-get update && sudo apt-get install dart
```

#### Install a Debian package

To install the Dart SDK as a Debian package (`*.deb`).

1. Download the Dart SDK as a [Debian package](#){:.debian-link-stable}.

1. Install the `*.deb` package using one of two methods:

   * From a GUI, double-click the `.deb` file.

   * From a terminal, run the following command:

     ```console
     $ sudo dpkg -i dart_3.2.6-1_amd64.deb
     ```

[sudo]: https://www.sudo.ws/
