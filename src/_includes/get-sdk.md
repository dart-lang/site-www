Once you’re ready to move beyond DartPad and develop real apps,
you need the Dart SDK.

As you install, **note the path to the SDK.**
You'll need it in the next step.

<ul class="tabs__top-bar">
  <li class="tab-link current" data-tab="tab-sdk-install-windows">Windows</li>
  <li class="tab-link" data-tab="tab-sdk-install-linux">Linux</li>
  <li class="tab-link" data-tab="tab-sdk-install-mac">Mac</li>
</ul>

<div id="tab-sdk-install-windows" class="tabs__content current" markdown="1">
  Use [Chocolatey](https://chocolatey.org) to install a stable release of
  the Dart SDK:
  ```terminal
  C:\> choco install dart-sdk
  ```
</div>

<div id="tab-sdk-install-linux" class="tabs__content" markdown="1">
  You can use Aptitude to install the Dart SDK on Linux.

   1. Perform the following one-time setup:
      ```terminal
      > sudo apt-get update
      > sudo apt-get install apt-transport-https
      > sudo sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
      > sudo sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
      ```
   2. Install the Dart SDK:
      ```terminal
      > sudo apt-get update
      > sudo apt-get install dart
      ```
</div>

<div id="tab-sdk-install-mac" class="tabs__content" markdown="1">
  With [Homebrew,](http://brew.sh/)
  installing Dart is easy.

  ```terminal
  > brew tap dart-lang/dart
  > brew install dart
  ```
</div>

More information: [Get the Dart SDK](/get-dart)
