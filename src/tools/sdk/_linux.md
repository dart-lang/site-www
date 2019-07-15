If you're using Debian/Ubuntu on AMD64 (64-bit Intel), you can choose one of the
following options, both of which can update the SDK automatically when new
versions are released.

* [Install using apt-get](#install-using-apt-get)
* [Install a Debian package](#install-a-debian-package)

#### Install using apt-get

Perform the following **one-time setup**:

{% if site.data.pkg-vers.SDK.channel == 'dev' %}
```terminal
$ sudo apt-get update
$ sudo apt-get install apt-transport-https
$ sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
$ sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list'
```
{% else %}
```terminal
$ sudo apt-get update
$ sudo apt-get install apt-transport-https
$ sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
$ sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
```
{% endif %}

Then install the
**{{site.data.pkg-vers.SDK.channel}}**
release of the Dart SDK:

```terminal
$ sudo apt-get update
$ sudo apt-get install dart
```

Or, to install the
{% if site.data.pkg-vers.SDK.channel == 'dev' -%}
**stable**
{% else -%}
**dev**
{% endif -%}
release of the Dart SDK,
run the one-time setup commands followed by:

{% if site.data.pkg-vers.SDK.channel == 'dev' %}
```terminal
$ sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
$ sudo apt-get update
$ sudo apt-get install dart
```
{% else %}
```terminal
$ sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list'
$ sudo apt-get update
$ sudo apt-get install dart
```
{% endif %}


#### Install a Debian package

Alternatively, download Dart SDK as Debian package in the `.deb` package format.

{:.downloads}
- [Stable channel](#){:.download-link #debian-link-stable
  data-bits="64" data-os="debian" data-tool="sdk"}
- [Dev channel](#){:.download-link #debian-link-dev
  data-bits="64" data-os="debian" data-tool="sdk"}


#### Modify PATH for access to all Dart binaries

After installing the SDK, **add its bin directory to your PATH**. For example,
use the following command to change PATH in your active terminal session:

```terminal
$ export PATH="$PATH:/usr/lib/dart/bin"
```

To change the PATH for future terminal sessions, use a command like this:

```terminal
$ echo 'export PATH="$PATH:/usr/lib/dart/bin"' >> ~/.profile
```
