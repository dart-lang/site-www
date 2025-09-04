This directory contains the [Dart][], [Jaspr][], and [Jaspr Content][] based
implementation of the dart.dev website.

[Dart]: https://dart.dev
[Jaspr]: https://docs.jaspr.site
[Jaspr Content]: https://docs.jaspr.site/content

## Usage

The site should be run with the `./dash_site` tool
from the root of the repository.
Some relevant commands include:

- **Serve:** `./dash_site serve`
- **Build:** `./dash_site build`
- **Clean:** `./dash_site clean`

Run `./dash_site --help` to learn what other commands are available.

## Structure

> [!NOTE]  
> Most of the site content, excluding unprocessed assets,
> is instead located in the root `src/` directory.

The implementation is roughly structured as follows in the `site` directory:

-  `lib/`

   The source code for the Jaspr Content site.

   - `_sass/`

     The [Sass][] style files for the rendered site in the [`.scss` format][].
   - `archive/`

     The code for building the SDK archive tables for each SDK channel.
   - `components/`

     The custom Jaspr components used across the site,
     both statically and dynamically rendered ones.
   - `extensions/`

     Custom Jaspr Content [page extensions][].
   - `highlight/`

     Syntax highlighting implementation and themes.
   - `layouts/`

     Custom Jaspr Content [page layouts][] for wrapping
     content in shared layouts.
   - `loaders/`

     Custom Jaspr Content [data loaders][] for loading data
     from custom sources or manually adding it to pages.
   - `markdown/`

     Custom `package:markdown` extensions and syntaxes used by the site.
   - `models/`

     Data classes used to generate pages or render components,
     such as details about a lint rule.
   - `pages/`

     Custom [memory pages][] loaded with code rather than content
     as well as [secondary outputs][], such as `robots.txt`.
   - `main.dart`

     The primary entry point and configuration for Jaspr and Jaspr Content.
   - `util.dart`

     Utility functions used across the site implementation.

-  `web/`

   Static assets that do not need to be processed by Jaspr Content,
   such as images, PDFs, and JavaScript.

-  `pubspec.yaml`

   The pubspec and dependency configuration for the Jaspr Content site.

[Sass]: https://sass-lang.com/
[`.scss` format]: https://sass-lang.com/documentation/syntax/#scss
[page extensions]: https://docs.jaspr.site/content/concepts/page_extensions
[page layouts]: https://docs.jaspr.site/content/concepts/page_layouts
[data loaders]: https://docs.jaspr.site/content/concepts/data_loading
[memory pages]: https://docs.jaspr.site/content/concepts/route_loading#memoryloader
[secondary outputs]: https://docs.jaspr.site/content/concepts/secondary_outputs
