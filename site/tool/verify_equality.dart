import 'package:dart_dev_site/src/models/changelog_model.dart';
import 'package:pub_semver/pub_semver.dart';

void main() {
  final entry1 = ChangelogEntry(
    description: 'Test',
    version: Version.parse('1.0.0'),
    area: 'Docs',
    tags: {ChangelogTag.newTag},
  );

  final entry2 = ChangelogEntry(
    description: 'Test',
    version: Version.parse('1.0.0'),
    area: 'Docs',
    tags: {ChangelogTag.newTag},
  );

  final entry3 = ChangelogEntry(
    description: 'Test',
    version: Version.parse('1.0.0'),
    area: 'Docs',
    tags: {ChangelogTag.newTag, ChangelogTag.breaking},
  );

  final entry4 = ChangelogEntry(
    description: 'Test',
    version: Version.parse('1.0.0'),
    area: 'SDK', // Different area
    tags: {ChangelogTag.newTag},
  );

  print('Checking entry1 == entry2 (expect true)... ${entry1 == entry2}');
  print('Checking entry1.hashCode == entry2.hashCode (expect true)... ${entry1.hashCode == entry2.hashCode}');

  print('Checking entry1 == entry3 (expect false)... ${entry1 == entry3}');
  print('Checking entry1 == entry4 (expect false)... ${entry1 == entry4}');
  
  // Set order check (DeepCollectionEquality with Set should be unordered if configured correctly or if SetEquality is used)
  // Wait, DeepCollectionEquality on a Map containing a Set checks SetEquality?
  // Let's verify.
  final entrySet1 = ChangelogEntry(
    description: 'SetOrder',
    version: Version.parse('1.0.0'),
    area: 'Docs',
    tags: {ChangelogTag.newTag, ChangelogTag.breaking},
  );
  
  // Create defined set with reverse insertion order if possible or just rely on Set equality
  final tags2 = <ChangelogTag>{};
  tags2.add(ChangelogTag.breaking);
  tags2.add(ChangelogTag.newTag);
  
  final entrySet2 = ChangelogEntry(
    description: 'SetOrder',
    version: Version.parse('1.0.0'),
    area: 'Docs',
    tags: tags2,
  );

  print('Checking entrySet1 == entrySet2 (expect true if unordered)... ${entrySet1 == entrySet2}');
}
