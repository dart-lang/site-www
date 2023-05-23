#### Options {#prod-compile-options}

The `dart compile js` command has multiple options
to customize javascript code compilation.

* [Basic options](#basic-options)
* [Path and environment options](#path-and-environment-options)
* [Display options](#display-options)
* [Analysis options](#analysis-options)

###### Basic options

Common options include:

`-o <file>` or `--output=<file>`
: Generates the output into `<file>`. 
  If not specified, the output goes in a file named `out.js`.

`--enable-asserts`
: Enables assertion checking.

`-O{0|1|2|3|4}`
: Controls optimizations to reduce file size and
  improve code performance.
  To learn more about these optimizations, 
  run `dart compile js -hv`.

  * `-O0`: Disables many optimizations.
  * `-O1`: Enables default optimizations.
  * `-O2`: Enables `-O1` optimizations, plus additional ones
    (such as minification) that respect the language semantics and
    are safe for all programs.
    {{site.alert.note}}
      With `-O2`, string representations of types are no longer the same as
      those in the Dart VM when compiled with the development JavaScript compiler.
    {{site.alert.end}}
  * `-O3`: Enables `-O2` optimizations, plus omits implicit type checks.
    {{site.alert.warning}}
      Omitting type checks can cause your app to crash due to type errors.
      Before using `-O3`, **test using `-O2`** to ensure that your app
      **never** throws a subtype of `Error` (such as `TypeError`).
    {{site.alert.end}}
  * `-O4`: Enables more aggressive optimizations than `-O3`,
    but with the same assumptions.
    {{site.alert.warning}}
      The `-O4` optimizations are susceptible to variations in input data.
      Before relying on `-O4`, **test for edge cases in user input**.
    {{site.alert.end}}

`--no-source-maps`
: Do not generate a source map file.

`-h` or `--help`
: Displays help. To get information about all options, use `-hv`.


###### Path and environment options

Some other handy options include:

`--packages=<path>`
: Specifies the path to the package resolution configuration file.
  For more information, check out the
  [Dart package configuration file][] specification.

`-D<flag>=<value>`
: Defines an environment declaration and value pair
  which can be accessed with 
  [`String.fromEnvironment`][], [`int.fromEnvironment`][], 
  [`bool.fromEnvironment`][], or [`bool.hasEnvironment`][].
  To learn more about environment declarations,
  see [Configuring apps with compilation environment declarations][].

`--version`
: Displays version information for `dart`.

[Dart package configuration file]: https://github.com/dart-lang/language/blob/main/accepted/2.8/language-versioning/package-config-file-v2.md
[`String.fromEnvironment`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/String/String.fromEnvironment.html
[`int.fromEnvironment`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/int/int.fromEnvironment.html
[`bool.fromEnvironment`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/bool/bool.fromEnvironment.html
[`bool.hasEnvironment`]: {{site.dart-api}}/{{site.data.pkg-vers.SDK.channel}}/dart-core/bool/bool.hasEnvironment.html
[Configuring apps with compilation environment declarations]: /guides/environment-declarations

###### Display options

The following options help you control the compiler output.

`--suppress-warnings`
: Doesn't display warnings.

`--suppress-hints`
: Doesn't display hints.

`--terse`
: Emits diagnostics, 
  without suggesting how to get rid of the diagnosed problems.

`-v` or `--verbose`
: Displays lots of information.


###### Analysis options

The following options control the analysis performed on Dart code.

`--fatal-warnings`
: Treat warnings as compilation errors.

`--enable-diagnostic-colors`
: Adds colors to diagnostic messages.

`--show-package-warnings`
: Shows warnings and hints generated from packages.

`--csp`
: Disables dynamic generation of code in the generated output.
  This is necessary to satisfy CSP restrictions
  (see [W3C Content Security Policy.](https://www.w3.org/TR/CSP/))

`--dump-info`
: Generates a file (with the suffix `.info.json`)
  that contains information about the generated code.
  You can inspect the generated file with tools in
  [dart2js_info](/go/dart2js-info).