// ignore_for_file: prefer_final_fields, unused_field, unused_field_from_primary_constructor

// #docregion private-named-old
// Variant not using a private named parameter.
class UserOld({required String name}) {
  String _name = name;
}
// #enddocregion private-named-old

// #docregion private-named-new
// Variant using a private named parameter.
class UserNew({required var String _name});
// #enddocregion private-named-new
