If you're using Debian/Ubuntu on AMD64 (64-bit Intel), you can choose one of the
following options, both of which can update the SDK automatically when new
versions are released.

* [Install using apt-get](#install-using-apt-get)
* [Install a Debian package](#install-a-debian-package)

#### Install using apt-get

Perform the following **one-time setup**:

```terminal
$ sudo apt-get update
$ sudo apt-get install apt-transport-https
$ wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
$ echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
```

Then install the Dart SDK:

```terminal
$ sudo apt-get update
$ sudo apt-get install dart
```

#### Install a Debian package

Alternatively, download Dart SDK [as a Debian package](#){:.debian-link-stable}
in the `.deb` package format.

#### Modify PATH for access to all Dart binaries

After installing the SDK, **add its `bin` directory to your `PATH`**. For example,
use the following command to change `PATH` in your active terminal session:

```terminal
$ export PATH="$PATH:/usr/lib/dart/bin"
```

To change the PATH for future terminal sessions, use a command like this:

```terminal
$ echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile
```
