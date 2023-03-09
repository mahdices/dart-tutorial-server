import 'package:mysql1/mysql1.dart';

class User {
  User(this.id, this.username, this.password, this.token);

  factory User.fromRow(ResultRow json) {
    return User(
      json[0] as int,
      json[1] as String,
      json[2] as String,
      json[3] as String,
    );
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
        json['id'] as int,
        json['username'] as String,
        json['password'] as String,
        json['token'] as String,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'token': token,
      };

  final int id;
  final String username;
  final String? password;
  final String? token;
}
