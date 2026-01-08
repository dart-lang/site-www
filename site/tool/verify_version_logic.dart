import 'package:dart_dev_site/src/models/changelog_model.dart';
import 'package:pub_semver/pub_semver.dart';

int compareVersions(String v1, String v2) {
  Version? tryParse(String v) {
    try {
      return Version.parse(v);
    } on FormatException {
      // Try normalizing "3.0" -> "3.0.0"
      try {
        if (RegExp(r'^\d+\.\d+$').hasMatch(v)) {
          return Version.parse('$v.0');
        }
      } catch (_) {}
      return null;
    }
  }

  final ver1 = tryParse(v1);
  final ver2 = tryParse(v2);

  if (ver1 != null && ver2 != null) {
    return ver1.compareTo(ver2);
  }
  // Fallback logic
  if (ver1 != null) return 1;
  if (ver2 != null) return -1;

  return v1.compareTo(v2);
}

void main() {
  print('Testing valid versions...');
  print('3.0 vs 3.1: ${compareVersions('3.0', '3.1')} (expect < 0)');
  print(
    '3.0.0 vs 3.0.0-dev: ${compareVersions('3.0.0', '3.0.0-dev')} (expect > 0)',
  );
  print('3.12 vs 3.2: ${compareVersions('3.12', '3.2')} (expect > 0)');

  print('\nTesting non-semver versions...');
  print(
    'Next vs 3.0: ${compareVersions('Next', '3.0')} (expect < 0 because 3.0 is valid)',
  );
  print(
    'Next vs WIP: ${compareVersions('Next', 'WIP')} (expect regular string comparison)',
  );

  // Verify equality checks
  print('\nTesting equality...');
  print('3.0 vs 3.0.0: ${compareVersions('3.0', '3.0.0')} (expect 0)');

  print('\nTesting shortVersion...');
  print('3.0.0 -> ${Version.parse('3.0.0').shortVersion} (expect 3.0)');
  print(
    '3.0.0-dev -> ${Version.parse('3.0.0-dev').shortVersion} (expect 3.0)',
  );
  print('3.12.5 -> ${Version.parse('3.12.5').shortVersion} (expect 3.12)');
  print('3.1.0 -> ${Version.parse('3.1.0').shortVersion} (expect 3.1)');
  // 'Next' is no longer a valid version in the strict model, so we can't test it for shortVersion on Version type directly
  // unless we parse it specially or it throws.
  try {
    Version.parse('Next');
  } catch (e) {
    print('Next -> Throws format exception (expected)');
  }
}

// Mock of getShortVersion for testing (duplicate logic or import?)
// Since I can't easily import the model here without depending on it, I'll copy the logic OR import the file.
// Importing the file might drag in web dependencies which might fail in pure dart CLI if universal_web doesn't handle it gracefully?
// universal_web usually works in VM (shims).
// Let's try importing the file.
