The index file in this directory is automatically generated
from the dart-samples repo on GitHub. (Specifically, from the
https://github.com/dart-lang/dart-samples/tree/master/dart_io_mini_samples
directory.)

To regenereate index.markdown:

Clone the repo:

```
git clone https://github.com/dart-lang/dart-samples.git
```

Change directory to dart_io_mini_samples and run "pub get":

```
cd dart-samples/dart_io_mini_samples
pub get
```

Run the script:

```
dart generate_md_for_dartlang.dart > output
```

Replace the `/dart-by-example/index.markdown` file with the `output` file.
