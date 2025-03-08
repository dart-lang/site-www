// ignore_for_file: unused_local_variable, unnecessary_type_check

void main() {
  // #docregion json-1
  var data = {
    'user': ['Lily', 13],
  };
  var {'user': [name, age]} = data;
  // #enddocregion json-1

  {
    // #docregion json-2
    if (data is Map<String, Object?> &&
        data.length == 1 &&
        data.containsKey('user')) {
      var user = data['user'];
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
    if (data case {'user': [String name, int age]}) {
      print('User $name is $age years old.');
    }
    // #enddocregion json-3
  }
}
