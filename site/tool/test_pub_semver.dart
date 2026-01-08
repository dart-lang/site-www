import 'package:pub_semver/pub_semver.dart';

void main() {
  final versions = ['3.0', '3.0.0', '3.1', '3.0.0-dev', 'Next', 'WIP'];
  
  print('Testing pub_semver parsing:');
  for (final v in versions) {
    try {
      final parsed = Version.parse(v);
      print("'$v' -> Parsed: $parsed");
    } catch (e) {
      print("'$v' -> Failed: $e");
    }
  }

  // Test comparison if possible
  try {
    final v1 = Version.parse('3.0.0');
    final v2 = Version.parse('3.0.0-dev');
    print('${v1} vs ${v2}: ${v1.compareTo(v2)}'); // Expect 1 (release > pre-release)
  } catch (e) {
    print('Comparison failed: $e');
  }
}
