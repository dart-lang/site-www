Once you're ready to move beyond DartPad and develop real apps,
you need an SDK.
You can either download the Dart SDK directly
(as described below)
or [download the Flutter SDK,][]
which includes the full Dart SDK.

[download the Flutter SDK,]: {{site.flutter-docs}}/get-started/install

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">Mac</li>
</ul>

<div id="tab-sdk-install-windows" class="tabs__content current" markdown="1">
  Use [Chocolatey](https://chocolatey.org) to install a stable release of
  the Dart SDK.

{{site.alert.important}}
  These commands require administrator privileges.
  If you need help on starting an administrator-level command prompt,
  try a search like
  <em><a href="https://www.google.com/search?q=cmd+admin"
  target="blank">cmd admin</a>.</em>
{{site.alert.end}}

To install the Dart SDK:

  ```terminal
  C:\> choco install dart-sdk
  ```
</div>

<div id="tab-sdk-install-linux" class="tabs__content" markdown="1">
  You can use APT to install the Dart SDK on Linux.

  1. Perform the following one-time setup:
     ```terminal
     $ sudo apt-get update
     $ sudo apt-get install apt-transport-https
     $ wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor -o /usr/share/keyrings/dart.gpg
     $ echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' | sudo tee /etc/apt/sources.list.d/dart_stable.list
     ```

  2. Install the Dart SDK:
     ```terminal
     $ sudo apt-get update
     $ sudo apt-get install dart
     ```
</div>

<div id="tab-sdk-install-mac" class="tabs__content" markdown="1">
  With [Homebrew,](https://brew.sh/)
  installing Dart is easy.

  ```terminal
  $ brew tap dart-lang/dart
  $ brew install dart
  ```
</div>

{{site.alert.important}}
  For more information, including how to **adjust your `PATH`**, see
  [Get the Dart SDK](/get-dart).
{{site.alert.end}}
