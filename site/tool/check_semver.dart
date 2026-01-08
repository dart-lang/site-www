import "package:pub_semver/pub_semver.dart";

void main() {
  check("2.19");
  check("3.0");
  check("3.0.0");
  check("3.0.0-wip");
}

void check(String version) {
  try {
    final v = Version.parse(version);
    print("Parsed '$version': $v (major=${v.major}, minor=${v.minor}, patch=${v.patch})");
  } catch (e) {
    print("Failed '$version': $e");
  }
}
