/// A multi-platform Hello World library.
library hw_mp;

// #docregion export
export 'src/hw_none.dart' // Stub implementation
    if (dart.library.io) 'src/hw_io.dart' // dart:io implementation
    if (dart.library.js_interop) 'src/hw_web.dart'; // package:web implementation
// #enddocregion export
