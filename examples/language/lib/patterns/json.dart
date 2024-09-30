// ignore_for_file: unused_local_variable, unnecessary_type_check

void main() {
  // #docregion json-1
  var json = {
    'user': ['Lily', 13]
  };
  var {'user': [name, age]} = json;
  // #enddocregion json-1

  {
    // #docregion json-2
    if (json is Map<String, Object?> &&
        json.length == 1 &&
        json.containsKey('user')) {
      var user = json['user'];
      if (user is List<Object> &&
          user.length == 2 &&
          user[0] is String &&
          user[1] is int) {
        var name = user[0] as String;
        var age = user[1] as int;
        print('User $name is $age years old.');
      }
    }
    // #enddocregion json-2
  }
  {
    // #docregion json-3
    if (json case {'user': [String name, int age]}) {
      print('User $name is $age years old.');
    }
    // #enddocregion json-3
  }
}
