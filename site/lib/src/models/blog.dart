import 'package:intl/intl.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_content/jaspr_content.dart';

extension type Post(Map<String, dynamic> data) {
  String get title => data['title'] as String;
  String get description => data['description'] as String;
  String? get image => data['image'] as String?;
  String get publishDate => data['publishDate'] as String;

  DateTime get dateObject => DateTime.parse(publishDate);
  String get formattedDate => DateFormat.yMMMd().format(dateObject);

  String? get authorId => data['author'] as String?;

  String get readingTime => data['readingTime'] as String? ?? '5 min read';
  String get category => data['category'] as String? ?? 'other';
}

extension type Author(Map<String, dynamic> data) {
  String get name => data['name'] as String;
  String? get bio => data['bio'] as String?;
  String? get image => data['image'] as String?;
  String? get twitter => data['twitter'] as String?;
  AuthorGithub? get github => data['github'] as AuthorGithub?;
}

extension type AuthorGithub(Map<String, dynamic> data) {
  String get handle => data['handle'] as String;
  String? get name => data['username'] as String?;
  String? get avatarUrl => data['avatar_url'] as String?;
}

extension GetAuthor on BuildContext {
  Author? getAuthor(String id) {
    return (page.data['authors'] as Map<String, dynamic>)[id] as Author?;
  }
}
