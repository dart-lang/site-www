/// The `print()` method from dart:io can't be mocked.
/// This library defines an overwritable [$print()] method,
/// which is initially set to the dart:io print. In this way,
/// code examples using $print can be executed from the command line
/// and will behave as expected. In a test context, $print can be
/// overwritten.

typedef void Print(Object o);

/// The `print()` method from dart:io
final Print ioPrint = print; // save default print function

/// An overwritable global print function
Print $print = ioPrint;
